package jing.loader.events
{
	import flash.events.Event;
	
	/**
	 * 加载事件 
	 * @author Jing
	 * 
	 */	
	public class LoaderEvent extends Event
	{
		private var _status:int;
		
		/**
		 * 状态 
		 * @return 
		 * 
		 */		
		public function get status():int
		{
			return _status;
		}
		
		public function LoaderEvent(type:String, status:int)
		{
			_status = status;
			super(type);
		}
		
		/**
		 * 加载状态 
		 */		
		static public const HTTP_STATUS:String = "HttpStatus";
	}
}