package jing.framework.manager.loader.events
{
	import flash.events.Event;
	
	/**
	 * 加载事件 
	 * @author jing
	 * 
	 */	
	public class LoaderEvent extends Event
	{
		public function LoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		static public const LOADER_ERROR:String = "LoaderError";
	}
}