package jing.loader.events
{
	import flash.events.Event;
	
	/**
	 * 加载中发生的错误 
	 * @author Jing
	 * 
	 */	
	public class LoaderErrorEvent extends Event
	{
		private var _reason:String;
		
		/**
		 * 错误原因 
		 * @return 
		 * 
		 */		
		public function get reason():String
		{
			return _reason;
		}
		
		private var _msg:String;

		/**
		 * 错误信息 
		 * @return 
		 * 
		 */		
		public function get msg():String
		{
			return _msg;
		}

		/**
		 * 
		 * @param type 事件类型
		 * @param reason 错误原因,参考ErrorReason
		 * @param msg 错误信息
		 * 
		 */		
		public function LoaderErrorEvent(type:String,reason:String, msg:String = "")
		{
			_reason = reason;
			_msg = msg;
			super(type);
		}
		
		/**
		 * 加载错误 
		 */		
		static public const Error:String = "Error"

	}
}