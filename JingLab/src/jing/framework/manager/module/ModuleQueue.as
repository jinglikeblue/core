package jing.framework.manager.module
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import jing.framework.manager.loader.DisplayLoader;
	import jing.framework.manager.loader.LoaderManager;
	import jing.framework.manager.loader.LoaderQueue;
	import jing.framework.manager.loader.interfaces.ILoader;
	import jing.utils.cache.CacheLevel;

	/**
	 * 模块队列 
	 * @author jing
	 * 
	 */	
	public class ModuleQueue
	{
		private var _loaderQueue:LoaderQueue = null;	
		
		public function ModuleQueue(progressFun:Function = null, completeFun:Function = null)
		{
			_loaderQueue = new LoaderQueue(progressFun,completeFun);
		}
		
		public function addModule(modulePath:String,lc:LoaderContext = null, cacheLevel:int = CacheLevel.NONE, moduleSize:int = 0, cacheVer:String = null):DisplayLoader
		{
			if (null == lc)
			{
				lc = new LoaderContext(false, ModuleManager.defaultDomain);
			}
			
			var dl:DisplayLoader = new DisplayLoader(null,lc,1,cacheLevel,cacheVer);
			dl.setUrl(modulePath);
			_loaderQueue.addLoader(dl,moduleSize);
			return dl;
		}
		
		internal function startLoad():void
		{
			_loaderQueue.startLoad();
		}

		
		/**
		 * 销毁加载队列 
		 * @param isUnload 是否阻止后台加载
		 * 
		 */		
		public function destory(isUnload:Boolean = false):void
		{
			_loaderQueue.destory(isUnload);
		}
	}
}