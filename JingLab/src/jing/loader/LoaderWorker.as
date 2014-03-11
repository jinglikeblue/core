package jing.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import jing.loader.events.LoaderErrorEvent;
	import jing.loader.interfaces.ILoader;
	
	/**
	 * 加载流水线 
	 * @author Jing
	 * 
	 */	
	public class LoaderWorker extends EventDispatcher
	{
		/**
		 * 加载器的队列 
		 */		
		private var _loaders:Vector.<ILoader> = new Vector.<ILoader>();
		
		/**
		 * 当前加载器 
		 */		
		private var _nowLoader:ILoader;
		
		/**
		 * 获取待加载的Loader数量(不包括正在加载的) 
		 * @return 
		 * 
		 */		
		public function getLoaderCount():int
		{
			return _loaders.length;
		}
		
		public function LoaderWorker()
		{
			super();
		}
		
		public function add(loader:ILoader):void
		{
			_loaders.push(loader);
			doNext();
		}
		
		/**
		 * 执行下一个加载 
		 * 
		 */		
		private function doNext():void
		{
			if(null != _nowLoader || 0 == _loaders.length)
			{
				return;
			}
			
			_nowLoader = _loaders.shift();
			_nowLoader.addEventListener(Event.COMPLETE, _nowLoader_completeHandler);
			_nowLoader.addEventListener(LoaderErrorEvent.Error, _nowLoader_errorHandler);
			_nowLoader.load();
		}
		
		private function _nowLoader_errorHandler(e:LoaderErrorEvent):void
		{
			// TODO Auto Generated method stub
			clearNowLoader();
			doNext();
		}
		
		private function _nowLoader_completeHandler(e:Event):void
		{
			// TODO Auto Generated method stub
			clearNowLoader();
			doNext();
		}
		
		/**
		 * 清理当前正在加载的 
		 * 
		 */		
		private function clearNowLoader():void
		{
			if(_nowLoader)
			{
				_nowLoader.removeEventListener(Event.COMPLETE, _nowLoader_completeHandler);
				_nowLoader.removeEventListener(LoaderErrorEvent.Error, _nowLoader_errorHandler);
				_nowLoader = null;
			}
		}
	}
}