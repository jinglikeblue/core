package jing.utils.xml
{
	import flash.utils.ByteArray;

	/**
	 * XML操作辅助工具 
	 * @author Jing
	 * 
	 */	
	public class XMLUtil
	{
		/**
		 * 将XML文件转换为XML对象 
		 * @param ba XML的文件数据
		 * @param charSet 文件使用的字符集，默认是UTF8
		 * @return 
		 * 
		 */		
		static public function readByteArray2XML(ba:ByteArray, charSet:String = "utf-8"):XML
		{
			var xmlStr:String = ba.readMultiByte(ba.bytesAvailable,"utf-8");
			var xml:XML = XML(xmlStr);
			return xml;
		}
		
		/**
		 * 将XML写入字节数组，UTF8格式 
		 * @param xml
		 * @param ba
		 * @return 
		 * 
		 */		
		static public function writeXML2ByteArray(xml:XML, ba:ByteArray = null):ByteArray
		{
			if(null == ba)
			{
				ba = new ByteArray();
			}
			
			ba.writeUTFBytes(xml.toXMLString());
			
			return ba;
		}
	}
}