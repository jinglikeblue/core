package jing.framework.manager.loader
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import jing.framework.manager.loader.events.LoaderEvent;
	import jing.framework.manager.loader.interfaces.ILoader;
	import jing.utils.debug.DebugUtil;
	import jing.utils.cache.CacheLevel;
	import jing.utils.cache.CacheUtils;

	/**
	 * 加载显示类对象如SWF,PNG等
	 * @author Jing
	 *
	 */
	[Event(name="LoaderError", type="jing.framework.manager.loader.events.LoaderEvent")]
	public class DisplayLoader extends Loader implements ILoader
	{
		//是否已经在加载了
		private var _isLoading:Boolean=false;

		/**
		 * 得到是否正在加载
		 * @return
		 *
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}

		//原始地址
		private var _url:String;

		//加载的地址
		private var _urlRequest:URLRequest=null;

		//加载的配置参数
		private var _context:LoaderContext=null;

		//回调函数
		private var _callBackFunc:Function=null;

		//加载尝试的次数(至少一次)
		private var _tryTime:int=int.MAX_VALUE;

		//缓存等级
		private var _cacheLevel:int=int.MAX_VALUE;

		//缓存版本
		private var _cacheVer:String=null;

		//字节流加载器
		private var _bytesLoader:URLLoader;

		//字节流加载器是否正在运行
		private var _bytesLoading:Boolean=false;

		/**
		 *
		 * @param callBackFunc 回调函数(需要给回调函数指明一个参数，参数类型为[DisplayObject])
		 * @param context
		 * @param tryTime 加载尝试的次数(至少一次)
		 * @param cacheLevel 缓存等级
		 *
		 */
		public function DisplayLoader(callBackFunc:Function=null, context:LoaderContext=null, tryTime:int=1, cacheLevel:int=CacheLevel.MEM, cacheVer:String=null)
		{
			super();
			_callBackFunc=callBackFunc;
			_context=context;
			_tryTime=tryTime;
			_cacheLevel=cacheLevel;
			_cacheVer=cacheVer;
//            init();
		}

		private function init():void
		{
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

		}

		protected function completeHandler(e:Event):void
		{
//			_isLoading = false;

			if (null != _callBackFunc)
			{
				_callBackFunc(this.content);
			}
//            LoaderManager.endLoad(this);
//            clearListeners();
			this.dispatchEvent(new Event(Event.COMPLETE));


			clear();
		}

		private function ioErrorHandler(e:IOErrorEvent):void
		{
			onLoadError(e);
		}

		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			onLoadError(e);
		}


		/**
		 * 直接加载的方式，如果要以队列的方式依次加载资源，请使用loadInList方法
		 * @param request
		 * @param context
		 *
		 */
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			init();

			_urlRequest=request;

			if (context != null)
			{
				_context=context;
			}

			var data:Object=CacheUtils.loadCacheFile(_urlRequest.url, _cacheLevel, _cacheVer);

			if (null != data)
			{
				this.loadBytes(data as ByteArray, _context);
			}
			else
			{
				if (CacheLevel.NEWEST == _cacheLevel)
				{
					_urlRequest.url=_urlRequest.url + "?Ver=" + new Date().getTime();
				}
				else if (CacheLevel.NONE != _cacheLevel && null != _cacheVer)
				{
					_urlRequest.url=_urlRequest.url + "?Ver=" + _cacheVer;
				}

				_bytesLoading=true;
				_bytesLoader=new URLLoader();
				_bytesLoader.dataFormat=URLLoaderDataFormat.BINARY;
				_bytesLoader.addEventListener(Event.COMPLETE, _bytesLoader_completeHandler);
				_bytesLoader.addEventListener(ProgressEvent.PROGRESS, _bytesLoader_progressHandler);
				_bytesLoader.addEventListener(IOErrorEvent.IO_ERROR, _bytesLoader_ioErrorHandler);
				_bytesLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _bytesLoader_securityErrorHandler);
				_bytesLoader.load(request);
			}
		}

		private function _bytesLoader_progressHandler(e:ProgressEvent):void
		{
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoader.bytesLoaded, _bytesLoader.bytesTotal));
		}


		/**
		 * 加载地址中的内容，加载的地址会排在LoaderManager的加载队列中
		 * @param url
		 *
		 */
		public function loadAtList(url:String):void
		{
			_urlRequest=new URLRequest(url);

			if (false == _isLoading)
			{
				if (true == LoaderManager.checkLoadEnable(this))
				{
					load(_urlRequest);
				}
				else
				{
					LoaderManager.addToLoadList(this);
				}
			}

		}

		public function setUrl(url:String):void
		{
			_url=url;
			_urlRequest=new URLRequest(url);
		}

		public function get url():String
		{
			return _url;
		}

		public function getUrl():String
		{
			return _urlRequest.url;
		}


		private function _bytesLoader_completeHandler(e:Event):void
		{
			_bytesLoading=false;

			trace("加载完成: ", _urlRequest.url);
			trace("加载内容大小： ", _bytesLoader.bytesTotal >> 10, "KB");
			DebugUtil.addNetStream(_bytesLoader.bytesTotal >> 10);
			//缓存加载的对象
			CacheUtils.saveCacheFile(_urlRequest.url, _bytesLoader.data, _cacheLevel, _cacheVer);
			this.loadBytes(_bytesLoader.data, _context);
		}



		private function _bytesLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			onLoadError(e);
		}

		private function _bytesLoader_securityErrorHandler(e:SecurityErrorEvent):void
		{
			onLoadError(e);
		}

		private function onLoadError(e:Event):void
		{
//			_bytesLoading = false;
//			_isLoading = false;

			trace("加载失败：", _urlRequest.url);
			//			trace(e.toString());
//            clearListeners();
//            LoaderManager.endLoad(this);

//            this.dispatchEvent(e.clone());
			this.dispatchEvent(new LoaderEvent(LoaderEvent.LOADER_ERROR));
			clear();
		}


		private function clearListeners():void
		{
			if (null != _bytesLoader)
			{
				_bytesLoader.removeEventListener(Event.COMPLETE, _bytesLoader_completeHandler);
				_bytesLoader.removeEventListener(ProgressEvent.PROGRESS, _bytesLoader_progressHandler);
				_bytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, _bytesLoader_ioErrorHandler);
				_bytesLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _bytesLoader_securityErrorHandler);
			}
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		override public function close():void
		{
			if (null != _bytesLoader)
			{
				_bytesLoader.close();
			}
			super.close();
		}

		public function clear():void
		{
			if (true == _bytesLoading)
			{
				_bytesLoader.close();
			}
			clearListeners();
			LoaderManager.endLoad(this);
			_bytesLoader=null;
			_bytesLoading=false;
			_isLoading=false;
			_callBackFunc=null;
			_urlRequest=null;
			_context=null;
			_cacheVer=null;
			this.unload();
		}

	}
}
