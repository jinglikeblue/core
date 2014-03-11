package jing.air.utils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	public class IOUtil
	{			
		/**
		 * 检查路径，如果路径不是以斜杠结尾，则添加 
		 * @param path
		 * @return 
		 * 
		 */		
		static private function checkPath(path:String):String
		{
			if(Capabilities.os.indexOf("Windows") > -1)
			{
				if(path.charAt(path.length - 1) != "\\" && path.charAt(path.length - 1) != "/")
				{
					path += "/";
				}
			}
			else
			{
				if(path.charAt(path.length - 1) != "/")
				{
					path += "/";
				}
			}
			return path;
		}
		
		/**
		 * 已经注册为AMF序列化的类的字典 
		 */		
		static private var _registedClassAlias:Dictionary;
		
		/**
		 * 注册对象为AMF序列化对象 
		 * 只能注册数据对象(不继承自DisplayObject的对象)
		 * @param obj
		 * 
		 */		
		static public function registClassAlias(obj:Object):void
		{
			if(null == _registedClassAlias)
			{
				_registedClassAlias = new Dictionary();
			}
			
			var aliasName:String = getQualifiedClassName(obj);
			
			if(null == _registedClassAlias[aliasName])
			{
				var classObject:Class = getDefinitionByName(aliasName) as Class;				
				_registedClassAlias[aliasName] = classObject;
				registerClassAlias(aliasName,classObject);
				
				
				var describeXML:XML = describeType(classObject);
				var variableXMLList:XMLList = describeXML.factory.variable.(@type != "String" && @type != "int" && @type != "Number");
				var nodeXML:XML;
				var type:String;
				for each(nodeXML in variableXMLList)
				{
					type = nodeXML.@type.toString();
					registClassAlias(getDefinitionByName(type));
				}
				
//				var accessorXMLList:XMLList = describeXML.factory.accessor.(@type != "String" && @type != "int" && @type != "Number");
//				for each(nodeXML in accessorXMLList)
//				{
//					type = nodeXML.@type.toString();
//					registClassAlias(getDefinitionByName(type));
//				}
				
				trace(describeType(classObject));
			}			
		}
		
		
		
		/**
		 * 将一个以AMF序列化方式对象写入文件 
		 * @param fileName
		 * @param path
		 * @param obj
		 * @return 
		 * 
		 */		
		static public function writeObjectToFile(fileName:String, path:String, obj:Object):int
		{
			registClassAlias(obj);
			var ba:ByteArray = new ByteArray();
			ba.writeObject(obj);
			return writeFile(fileName,path,ba);
		}
		
		/**
		 * 以AMF序列化方式从文件获取对象 
		 * @param fileName
		 * @param path
		 * @param classObject
		 * @return 
		 * 
		 */		
		static public function readObjectFromFile(fileName:String, path:String, classObject:Class):Object
		{
			registClassAlias(classObject);
			var ba:ByteArray = readFile(fileName,path);
			var obj:Object = ba.readObject();
			return obj;
		}
		
		/**
		 * 向文件路径创建文件 
		 * @param filePath
		 * @param ba
		 * @return 
		 * 
		 */		
		static public function writeFileDirect(filePath:String, ba:ByteArray):int
		{
			var result:int = 1;
			try
			{
				var file:File =  new File(filePath);
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
			}
			catch(e:Error)
			{
				trace(e);
				result = 0;
			}
			return result;
		}
		
		/**
		 * 将数据写入文件 
		 * @param fileName
		 * @param path
		 * @param ba
		 * @return 
		 * 
		 */		
		static public function writeFile(fileName:String, path:String, ba:ByteArray):int
		{
			path = checkPath(path);
			return writeFileDirect(path + fileName, ba);
		}
		
		/**
		 * 将绝对路径指向的文件读出 
		 * @param filePath
		 * @return 
		 * 
		 */		
		static public function readFileDirect(filePath:String):ByteArray
		{
			return getFile(new File(filePath));
		}
		
		/**
		 * 从文件读取数据 
		 * @param fileName
		 * @param path
		 * @return 
		 * 
		 */		
		static public function readFile(fileName:String, path:String):ByteArray
		{
			return getFile(new File(path).resolvePath(fileName));
		}
		
		/**
		 * 读取一个XML文件(不可使用相对路径) 
		 * @param fileName
		 * @param path
		 * @return 
		 * 
		 */		
		static public function readXMLFile(fileName:String, path:String):XML
		{
			return getXMLFile(new File(path).resolvePath(fileName));
		}
		
		/**
		 * 通过完整路径读取一个XML文件(不可使用相对路径) 
		 * @param fileName
		 * @param path
		 * @return 
		 * 
		 */	
		static public function readXMLFileDirect(filePath:String):XML
		{
			return getXMLFile(new File(filePath));
		}
		
		/**
		 * 得到文件 
		 * @param file
		 * @return 
		 * 
		 */		
		static public function getFile(file:File):ByteArray
		{
			var ba:ByteArray;
			if(file.exists && false == file.isDirectory)
			{				
				try
				{							
					var fs:FileStream = new FileStream();
					fs.open(file,FileMode.READ);
					ba = new ByteArray();
					fs.readBytes(ba);
					fs.close();
				}
				catch(e:Error)
				{
					trace(e);
				}				
			}
			return ba;
		}
		
		/**
		 * 设置文件 
		 * @param file
		 * @return 
		 * 
		 */		
		static public function setFile(file:File, ba:ByteArray):Boolean
		{
			var success:Boolean = true;
			try
			{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
			}
			catch(e:Error)
			{
				trace(e);
				success = true;
			}
			return success
		}
		
		/**
		 * 得到XML文件 
		 * @param file
		 * @return 
		 * 
		 */		
		static public function getXMLFile(file:File):XML
		{
			var ba:ByteArray = getFile(file);
			var xml:XML;
			if(ba)
			{
				var xmlStr:String = ba.readUTFBytes(ba.bytesAvailable);
				xml = new XML(xmlStr);
			}
			return xml;
		}
		
		/**
		 * 通过完整路径读取一个XML文件(不可使用相对路径) 
		 * @param fileName
		 * @param path
		 * @return 
		 * 
		 */	
		static public function readXMLFileDirect(filePath:String):XML
		{
			var xmlBA:ByteArray = readFileDirect(filePath);
			var xmlStr:String = xmlBA.readUTFBytes(xmlBA.bytesAvailable);
			var xml:XML = new XML(xmlStr);
			return xml;
		}
		
		
		/*
		********************************************************
		* 文件选择部分
		************************************************************
		*/
		
		static private var _selectFileCallBack:Function;
		
		
		/**
		 * 选择多个文件 
		 * @param callBack 回调函数,包含一个[Array]类型的参数
		 * @param title
		 * @param typeFilter
		 * 
		 */		
		static public function selectMultiFile(callBack:Function, title:String, typeFilter:FileFilter):void
		{
			_selectFileCallBack = callBack;
			var file:File = File.desktopDirectory;
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, file_selectMultipleHandler);
			file.browseForOpenMultiple(title,[typeFilter]);
		}
		
		static private function file_selectMultipleHandler(e:FileListEvent):void
		{
			var file:File = e.currentTarget as File;
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, file_selectMultipleHandler);			
			_selectFileCallBack(e.files);
		}
		
		
		//-------------选择一个文件-------------		
		
		/**
		 * 选择一个系统中的文件 
		 * @param callBack 回调函数,包含一个[FILE]类型的参数
		 * @param title
		 * @param typeFilter
		 * 
		 */		
		static public function selectFile(callBack:Function,title:String,typeFilter:FileFilter):void
		{
			_selectFileCallBack = callBack;
			var file:File = File.desktopDirectory;
			file.addEventListener(Event.SELECT, file_selectHandler);
			file.browseForOpen(title,[typeFilter]);
		}
		
		/**
		 * 选择一个系统中的文件夹
		 * @param callBack 回调函数,包含一个[FILE]类型的参数
		 * @param title
		 * 
		 */		
		static public function selectDirectory(callBack:Function,title:String):void
		{
			_selectFileCallBack = callBack;
			var file:File = File.desktopDirectory;
			file.addEventListener(Event.SELECT, file_selectHandler);
			file.browseForDirectory(title);			
		}
		
		static private function file_selectHandler(e:Event):void
		{
			var file:File = e.currentTarget as File;
			file.removeEventListener(Event.SELECT, file_selectHandler);
			_selectFileCallBack(file);
		}
		
		//******************************************************
		
		//--------------移动一个文件到指定位置-------------
		
		/**
		 * 移动一个文件到指定位置 
		 * @param sourcePath 源路径
		 * @param targetPath 目标路径
		 * @param isDeleteSource 是否删除源路径
		 * 
		 */		
		static public function moveFileToPath(sourcePath:String,targetPath:String,isDeleteSource:Boolean = false):Boolean
		{
			var isSuccess:Boolean = true;
			
			var sourceFile:File = new File(sourcePath);
			var targetFile:File = new File(targetPath);

			try
			{
				sourceFile.copyTo(targetFile,true);
				if(true == isDeleteSource)
				{
					sourceFile = new File(sourceFile.nativePath);
					sourceFile.deleteDirectory(true);	
				}
			}
			catch(error:Error)
			{
				isSuccess = false;
			}
			
			return isSuccess;
		}
		
		/**
		 * 删除文件 
		 * @param path 文件路径
		 * @return 
		 * 
		 */		
		static public function deleteFile(path:String):Boolean
		{
			var isSuccess:Boolean = true;
			
			var file:File = new File(path);
			try
			{
				file.moveToTrash();
			}
			catch(erroe:Error)
			{
				isSuccess = false;
			}
			
			return isSuccess;
		}		
	}
}