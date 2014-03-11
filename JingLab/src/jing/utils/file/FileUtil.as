package jing.utils.file
{
	/**
	 * 文件工具 
	 * @author Jing
	 * 
	 */	
	public class FileUtil
	{
		/**
		 * 得到不带后缀的文件名 
		 * @param name
		 * @return 
		 * 
		 */		
		static public function getFileNameWithouExtension(name:String):String
		{
			var index:int = name.lastIndexOf(".");
			if(index == -1)
			{
				return name;
			}
			
			return name.slice(0,index);
		}
	}
}