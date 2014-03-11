package jing.framework.manager.loader
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import jing.framework.manager.loader.events.LoaderEvent;
	import jing.framework.manager.loader.interfaces.ILoader;

	/**
	 * loader队列，管理loader,按照添加的先后顺序依次执行loader进行加载
	 * @author jing
	 *
	 */
	public class LoaderQueue
	{
		/**
		 * 加载的列表
		 */
		private var _list:Vector.<ILoader>=null;

		public function get list():Vector.<ILoader>
		{
			return _list;
		}

		private var _info:LoaderQueueInfo=null;

		private var _progressFun:Function=null;

		private var _completeFun:Function=null;

		private var _allBytesLoaded:int=0;
		private var _allBytesTotal:int=0;
		private var _currentListValue:int=0;

		private var _listValueDic:Dictionary=null;

		public function LoaderQueue(progressFun:Function=null, completeFun:Function=null)
		{
			_list=new Vector.<ILoader>();

			_info=new LoaderQueueInfo();

			_listValueDic=new Dictionary();

			_progressFun=progressFun;
			_completeFun=completeFun;
		}

		/**
		 * 添加一个loader
		 * @param loader
		 * @param listValue 在队列中改对象加载完所达到的值
		 *
		 */
		public function addLoader(loader:ILoader, listValue:int=0):void
		{
			if (_list.indexOf(loader) != -1)
			{
				return;
			}
			
			
			loader.addEventListener(ProgressEvent.PROGRESS, iLoader_progressHandler);
			loader.addEventListener(LoaderEvent.LOADER_ERROR, iLoader_errorHandler);
			loader.addEventListener(Event.COMPLETE, iLoader_completeHandler);
			_list.push(loader);
			_info.totalListValue+=listValue;
			_listValueDic[loader]=listValue;
		}

		public function startLoad():void
		{
			if (0 == _list.length)
			{
				return;
			}
			_info.totalCount=_list.length;
			loadNext();
		}

		protected function loadNext():void
		{

			var iLoader:ILoader=_list[_info.loadedCount];
			if(iLoader.getUrl().indexOf("Pack.swf") > -1)
			{
				trace(123);
			}
			_info.loadingURL=iLoader.getUrl();
			if (iLoader is DisplayLoader)
			{
				(iLoader as DisplayLoader).load(new URLRequest(iLoader.getUrl()));
			}
			else if (iLoader is BytesLoader)
			{
				(iLoader as BytesLoader).load(new URLRequest(iLoader.getUrl()));
			}
		}


		protected function iLoader_progressHandler(e:ProgressEvent):void
		{
			_info.currentModuleBytesLoaded=e.bytesLoaded;
			_info.currentModuleBytesTotal=e.bytesTotal;
			_info.allBytesLoaded=_allBytesLoaded + e.bytesLoaded;
			_info.allBytesTotal=_allBytesTotal + e.bytesTotal;
			_info.currentListValue=_currentListValue + int(_listValueDic[e.currentTarget] * (e.bytesLoaded / e.bytesTotal));
			if (null != _progressFun)
			{
				_progressFun(_info);
			}
		}

		protected function iLoader_errorHandler(e:Event):void
		{
			_info.loadedCount++;
			if (_info.loadedCount == _info.totalCount)
			{
				_info.isAllComplete=true;
				if (null != _completeFun)
				{
					_completeFun(_info);
				}
				destory();
			}
			else
			{
				loadNext();
			}
		}

		protected function iLoader_completeHandler(e:Event):void
		{
			_allBytesLoaded=_info.allBytesLoaded;
			_allBytesTotal=_info.allBytesTotal;
			_currentListValue=_info.currentListValue;

			_info.loadedCount++;
			if (_info.loadedCount == _info.totalCount)
			{
				_info.isAllComplete=true;
				if (null != _completeFun)
				{
					_completeFun(_info);
				}
				destory();
			}
			else
			{
				loadNext();
			}


		}

		public function destory(isUnload:Boolean=false):void
		{
			for (var i:int=0; i < _list.length; i++)
			{
				_list[i].removeEventListener(ProgressEvent.PROGRESS, iLoader_progressHandler);
				_list[i].removeEventListener(Event.COMPLETE, iLoader_completeHandler);
				if (true == isUnload && _list[i] is DisplayLoader)
				{
					(_list[i] as DisplayLoader).unloadAndStop();
				}
			}
			_list.length=0;

			_progressFun=null;
			_completeFun=null;
		}

		/**
		 * 加载队列信息
		 * @return
		 *
		 */
		public function get info():LoaderQueueInfo
		{
			return _info;
		}
	}
}
