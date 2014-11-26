package jing.net.server
{
	import flash.utils.ByteArray;
	
	public class ByteBuffer extends ByteArray
	{
		public function ByteBuffer()
		{
			super();
		}
		
		/**
		 * 写入字符串
		 * 改方法将首先写入一个short类型的值记录字符串长度，再将字符串作为UTF-8编码写入
		 */
		public function writeString(str:String):void
		{
			var temp:ByteArray = new ByteArray();
			temp.writeMultiByte(str,"UTF-8");
			
			writeShort(temp.length);
			writeMultiByte(str,"UTF-8");
		}
		
		/**
		 * 读取字符串
		 * 改方法将首先读取一个short类型的值记录字符串长度，再将字符串作为UTF-8编码读出
		 */
		public function readString():String
		{
			var length:int = readShort();
			var str:String = readMultiByte(length, "UTF-8");
			return str;
		}
	}
}