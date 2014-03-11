package jing.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import jing.loader.events.LoaderErrorEvent;
	import jing.loader.interfaces.ILoader;
	
	/**
	 * 加载队列，队列中的加载器会按照先后顺序依次加载<b />
	 * 【不建议重复使用该类】 
	 * @author Jing
	 * 
	 */	
	public class LoaderList extends EventDispatcher
	{
		/**
		 * 队列 
		 */		
		private var _loaders:Vector.<ILoader>;
		
		/**
		 * 正在执行的加载器 
		 */		
		private var _nowLoader:ILoader;
		
		/**
		 * 当前加载器已加载的数据 
		 */		
		private var _nowLoaderBytesLoaded:int;
		
		/**
		 * 当前加载器需要加载的字节的总数 
		 */		
		private var _nowLoaderBytesTotal:int;
		
		/**
		 * 每个加载器对应的模拟值的字典 
		 */		
		private var _imitateValueDic:Dictionary;
		
		/**
		 * 计算出的模拟加载的总值 
		 */		
		private var _totalImitateValue:int;
		
		/**
		 * 目前为止计算出的已加载总模拟值 
		 */		
		private var _loadedImitateValue:int;
		
		/**
		 * 已加载的字节总数(不包括正在加载的,正在加载的为_nowLoaderBytesLoaded) 
		 */		
		private var _bytesLoaded:int;

		/**
		 * 已加载的字节总数 
		 */
		public function getBytesLoaded():int
		{
			return _bytesLoaded + _nowLoaderBytesLoaded;
		}
		
		/**
		 * 要执行的加载器的索引 
		 */		
		private var _index:int;
		
		/**
		 * 队列的长度 
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return _loaders.length;
		}
		
		/**
		 * 已执行完的加载器数量
		 * @return 
		 * 
		 */		
		public function get loadedCount():int
		{
			return _index;
		}

		
		public function LoaderList()
		{
			_loaders = new Vector.<ILoader>();
			_imitateValueDic = new Dictionary();
		}
		
		/**
		 *  
		 * @param loader
		 * @param imitateValue 模拟文件的大小，用于计算进度
		 * 
		 */		
		public function add(loader:ILoader, imitateValue:int):void
		{
			_loaders.push(loader);
			_imitateValueDic[loader] = imitateValue;
			_totalImitateValue += imitateValue;
		}
		
		/**
		 * 开始执行队列的加载 
		 * 
		 */		
		public function start():void
		{
			loadNext();
		}
		
		/**
		 * 加载下一个 
		 * 
		 */		
		private function loadNext():void
		{
			if(_index >= _loaders.length)
			{
				_nowLoader = null;
				//加载已经完成
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			_nowLoader = _loaders[_index++];
			_nowLoader.addEventListener(ProgressEvent.PROGRESS, _nowLoader_progressHandler);
			_nowLoader.addEventListener(Event.COMPLETE, _nowLoader_completeHandler);
			_nowLoader.addEventListener(LoaderErrorEvent.Error, _nowLoader_errorHandler);
			_nowLoader.load();
		}
		
		private function _nowLoader_progressHandler(e:ProgressEvent):void
		{
			_nowLoaderBytesLoaded = e.bytesLoaded;
			_nowLoaderBytesTotal = e.bytesTotal;
			var per:Number = _nowLoaderBytesLoaded / _nowLoaderBytesTotal;
			var imitateValue:int = _imitateValueDic[e.currentTarget];
			var loadedImitateValue:int = imitateValue * per + _loadedImitateValue;
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,loadedImitateValue,_totalImitateValue));
		}
		
		private function _nowLoader_completeHandler(e:Event):void
		{
			_loadedImitateValue +=	_imitateValueDic[e.currentTarget];
			_bytesLoaded += _nowLoaderBytesTotal;
			_nowLoaderBytesLoaded = 0;
			_nowLoaderBytesTotal = 0;
			
			loadNext();
		}
		
		private function _nowLoader_errorHandler(e:LoaderErrorEvent):void
		{
			_loadedImitateValue +=	_imitateValueDic[e.currentTarget];
			
			loadNext();
		}
		
		/**
		 * 清理当前的加载器 
		 * 
		 */		
		private function clearNowLoader():void
		{
			if(_nowLoader)
			{
				_nowLoader.removeEventListener(ProgressEvent.PROGRESS, _nowLoader_progressHandler);
				_nowLoader.removeEventListener(Event.COMPLETE, _nowLoader_completeHandler);
				_nowLoader.removeEventListener(LoaderErrorEvent.Error, _nowLoader_errorHandler);
				_nowLoader = null;
			}
		}
		
		/**
		 * 关闭队列的加载 
		 * 
		 */		
		public function close():void
		{
			clearNowLoader();
		}
		
		/**
		 * 销毁队列 
		 * 
		 */		
		public function dispose():void
		{
			close();
			for each(var loader:ILoader in _loaders)
			{
				loader.dispose();
			}
			_loaders.length = 0;
			_nowLoaderBytesLoaded = 0;
			_nowLoaderBytesTotal = 0;
			_imitateValueDic = new Dictionary();
			_totalImitateValue = 0;
			_loadedImitateValue = 0;
			_bytesLoaded = 0;
			_index = 0;
		}
	}
}