package jing.loader
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import jing.loader.interfaces.ILoader;
	
	/**
	 * 二进制数据的加载器 
	 * @author Jing
	 * 
	 */	
	public class BytesLoader extends ALoader implements ILoader
	{
		private var _ba:ByteArray;
		
		/**
		 * 加载到的二进制字节数组 
		 * @return 
		 * 
		 */		
		public function get byteArray():ByteArray
		{
			return _ba;
		}
		
		public function BytesLoader(urlRequest:URLRequest = null, tryTime:int = 0)
		{
			super(urlRequest,tryTime);
		}
		
		override protected function _urlStream_completeHandler(event:Event):void
		{
			_ba = getByteArray();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function dispose():void
		{
			_ba = null;
			super.dispose();
		}
	}
}