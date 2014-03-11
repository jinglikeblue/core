package jing.framework.manager.loader.interfaces
{
	import flash.events.IEventDispatcher;

	/**
	 * 加载类的接口 
	 * @author Jing
	 * 
	 */	
	public interface ILoader extends IEventDispatcher
	{
		/**
		 * 加载地址中的内容，加载的地址会排在LoaderManager的加载队列中 
		 * @param url
		 * 
		 */	
		function loadAtList(url:String):void;
		
		/**
		 * 设置loader要加载的url地址 
		 * @param url
		 * 
		 */		
		function setUrl(url:String):void;
		
		/**
		 * 得到加载的URL地址 
		 * @return 
		 * 
		 */		
		function getUrl():String;
		
		/**
		 * 是否正在加载中 
		 * @return 
		 * 
		 */		
		function get isLoading():Boolean;
	}
}