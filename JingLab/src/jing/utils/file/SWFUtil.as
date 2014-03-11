package jing.utils.file
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SWFUtil
	{
		static private const COMPRESSED:String = "CWS"; 
		
		/**
		 * 获取SWF文件中的一些信息 
		 * @param ba
		 * @return 
		 * 
		 */		
		static public function getSWFInfo(ba:ByteArray):Object
		{   
			//是否压缩  
			var compressed:String = ba.readUTFBytes(3);
			
			//swf版本
			var version:int = ba.readByte();
			
			var length:uint = ba.readUnsignedInt();   
			
			ba.position = 8;
			
			var swfBytes:ByteArray = new ByteArray();
			ba.readBytes(swfBytes); 
			
			
			if(compressed == COMPRESSED)
			{
				swfBytes.uncompress(); 
			}  
			swfBytes.endian = Endian.LITTLE_ENDIAN;
			
			// 解析 swf 宽度 高度 数据 rect 数据
			var swfSize:int = swfBytes.readUnsignedByte()>>3;
			
			// 计算 rect 结束位置
			swfBytes.position = Math.ceil((swfSize*4)/8+5);
			//trace(_swfByteArray.position); 
			
			//读取帧频 因为低8位是小数，所以需要除以2的8次方
			var frameRate:int = swfBytes.readShort()/256;
			
			//读取 总帧数
			var frameTotal:int = swfBytes.readShort();
			
			while(swfBytes.bytesAvailable)
			{
				var tagHead:int = swfBytes.readShort();
				var tagType:int = tagHead>>6;
				
				
				//0x3F  00111111
				var tagLength:int = tagHead & 0x3F;   
				if(tagLength == 63) //如果tag 是长类型
				{
					tagLength = swfBytes.readUnsignedInt();
				}
				// 解析 symbolClass tag
				if(tagType == 76) 
				{   
					var classList:Array = [];
					var classNum:int = swfBytes.readShort();
					while(classNum --)
					{   
						var classId:int = swfBytes.readUnsignedShort();
						// trace("classId之后的位置是"+_swfByteArray.position);
						var char:int = swfBytes.readByte(); 
						var name:String = "";
						while(char)
							
						{    
							name += String.fromCharCode(char);    
							char = swfBytes.readByte(); 
						}
						trace("导出类名为"+name);
						classList.push(name);
					} 
				}
				else
				{
					swfBytes.position += tagLength;
				}
			}
			
			var infoObj:Object = {};
			//压缩码
			infoObj.compressed = compressed;
			//版本
			infoObj.version = version;
			//帧率
			infoObj.frameRate = frameRate;
			//总帧数
			infoObj.frameTotal = frameTotal;
			//类名列表
			infoObj.classList = classList;
			return infoObj;
		}

	}
}