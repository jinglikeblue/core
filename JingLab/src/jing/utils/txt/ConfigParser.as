package jing.utils.txt
{
	import jing.utils.data.StringUtil;

	/**
	 * 配置解析器，针对TXT文件格式的配置进行解析
	 * 配置的格式如下：
	 * 
	 * ---------------------------------------------------
	   关卡ID	关卡名称	资源名称	下一关卡ID
		1	第一关	assets/1	
		2	第二关	assets/2	3
		3	第三关	assets/3	2
     * -------------------------------------------------- 
	 * @author Jing
	 * 
	 */	
	public class ConfigParser
	{
		public function ConfigParser()
		{
		}
		
		/**
		 * 解析配置 
		 * @param content
		 * @return 
		 * 
		 */		
		static public function parse(content:String):Object
		{
			var conf:Object;
			
			try
			{
				conf = new Object();
				var rows:Array = content.split("\r\n");
				var keyNames:Array = getColumns(rows[0]);
				var keys:Array = getColumns(rows[1]);
				
				for(var i:int = 2; i < rows.length; i++)
				{
					if("" == StringUtil.trim(rows[i]))
					{
						continue;
					}
					
					var rowObject:Object = {};					
					var columns:Array = getColumns(rows[i]);
					for(var j:int = 0; j < columns.length; j++)
					{
						rowObject[keys[j]] = columns[j];
					}
					conf[rowObject[keys[0]]] = rowObject;
				}
			}
			catch(e:Error)
			{
				trace("ConfigParser::parse config parse error")
			}
			
			return conf;
		}
		
		static private function getColumns(row:String):Array
		{
			var columns:Array = row.split("\t");
			return columns;
		}
	}
}