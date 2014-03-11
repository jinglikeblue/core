package jing.multiThread
{
	import flash.events.Event;
	
	/**
	 * 线程错误事件 
	 * @author Jing
	 * 
	 */	
	public class ThreadErrorEvent extends Event
	{
		private var _errorInfo:String;
		
		/**
		 * 线程错误信息 
		 * @return 
		 * 
		 */		
		public function get errorInfo():String
		{
			return _errorInfo;
		}
		
		public function ThreadErrorEvent(type:String, errorInfo:String)
		{
			_errorInfo = errorInfo;
			super(type);
		}
		
		static public const ERROR:String = "Error";



	}
}