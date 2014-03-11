package jing.utils.cache
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;

	/**
	 * sharedObject工具类
	 * @author Owen
	 * 
	 */
	public class SharedObjectUtil
	{
		public static var so:SharedObject = SharedObject.getLocal("yrt_liuyun");
		
		public static var isAskFlush:Boolean = false;
		public function SharedObjectUtil()
		{
		}
		/**
		 * 存入信息到sharedObject
		 * 传入的特性可以是任何 ActionScript 或 JavaScript 类型的对象（数组、数字、布尔值、字节数组、XML，等等）
		 * @param key
		 * @param value
		 */		
		public static function saveSO(key:String, value:*):void
		{
			so.data[key] = value;
			
			if(false == isAskFlush)
			{
				isAskFlush = true;
				so.addEventListener(NetStatusEvent.NET_STATUS, so_netStatusHandler);
				so.flush(50000000);
				
			}
			
//			var flushStr:String = so.flush(50000000);
//			trace("保存完毕:" + flushStr);
		}
		
		public static function so_netStatusHandler(e:NetStatusEvent):void
		{
			e.currentTarget.removeEventListener(NetStatusEvent.NET_STATUS, so_netStatusHandler);
//			e.
//			trace(e.info);
//			(e.currentTarget as SharedObject).
		}
		
		/**
		 * 获取当前输入key的值
		 * @param key
		 * @return 
		 */		
		public static function getValue(key:String):*
		{
			var temp:* = so.data[key];
			return temp;
		}
		/**
		 * 删除
		 * @param key
		 */		
		public static function deleteValue(key:String):void
		{
			delete so.data[key];
			trace("删除成功");
		}
		/**
		 * 清除
		 */		
		public static function clearSO():void
		{
			so.clear();
			trace("清除完毕");
		}
	}
}