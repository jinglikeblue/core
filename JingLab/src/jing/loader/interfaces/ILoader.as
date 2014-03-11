package jing.loader.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * 加载类的接口 
	 * @author Jing
	 * 
	 */	
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "HttpStatus", type = "jing.loader.events.LoaderEvent")]
	[Event(name = "Error", type = "jing.loader.events.LoaderErrorEvent")]
	public interface ILoader extends IEventDispatcher
	{
		/**
		 * 加载 
		 * @param request
		 * 
		 */		
		function load(request:URLRequest = null):void;
		
		/**
		 * 销毁对象 
		 * 
		 */		
		function dispose():void;
	}
}