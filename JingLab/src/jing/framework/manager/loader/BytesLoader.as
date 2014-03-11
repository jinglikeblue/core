package jing.framework.manager.loader
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    import jing.framework.manager.loader.events.LoaderEvent;
    import jing.framework.manager.loader.interfaces.ILoader;
    import jing.utils.cache.CacheLevel;
    import jing.utils.cache.CacheUtils;
    import jing.utils.debug.DebugUtil;

    /**
     * 继承自URLLoader的字节数据加载类
     * @author Jing
     *
     */
    public class BytesLoader extends URLLoader implements ILoader
    {

        //是否已经在加载了
        private var _isLoading:Boolean = false;

        /**
         * 得到是否正在加载
         * @return
         *
         */
        public function get isLoading():Boolean
        {
            return _isLoading;
        }

        //加载的地址
        private var _urlRequest:URLRequest = null;

        //回调函数
        private var _callBackFunc:Function = null;

        //加载尝试的次数
        private var _tryTime:int = int.MAX_VALUE;

        //缓存等级
        private var _cacheLevel:int = int.MAX_VALUE;

        /**
         * 缓存的版本
         */
        private var _cacheVer:String = null;


        /**
         *
         * @param callBackFunc 回调函数(需要给回调函数指明一个参数，参数类型为[Object])Object类型和dataFormat参数相关
         * @param cacheLevel 缓存等级
         *
         */
        public function BytesLoader(callBackFunc:Function = null, cacheLevel:int = CacheLevel.MEM, cacheVer:String = null)
        {
            super();
            this._callBackFunc = callBackFunc;
            _cacheLevel = cacheLevel;
            _cacheVer = cacheVer;
            this.dataFormat = URLLoaderDataFormat.BINARY;
        }

        override public function load(request:URLRequest):void
        {
            _urlRequest = request;

            var data:Object = CacheUtils.loadCacheFile(_urlRequest.url, _cacheLevel, _cacheVer);

            if (null != data)
            {
                loadOver(data);
            }
            else
            {
				if(CacheLevel.NEWEST == _cacheLevel)
				{
					_urlRequest.url = _urlRequest.url + "?Ver=" + new Date().getTime();
				}
				else if(CacheLevel.NONE != _cacheLevel && null != _cacheVer)
				{
					_urlRequest.url = _urlRequest.url + "?Ver=" + _cacheVer;
				}
				
                this.addEventListener(Event.COMPLETE, completeHandler);
                this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
                super.load(_urlRequest);
            }
        }


        /**
         * 加载地址中的内容，加载的地址会排在LoaderManager的加载队列中
         * @param url
         *
         */
        public function loadAtList(url:String):void
        {
            _urlRequest = new URLRequest(url);

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

        private function completeHandler(e:Event):void
        {
            trace("加载完成: ", _urlRequest.url);
            trace("加载内容大小： ", this.bytesTotal >> 10, "KB");

            DebugUtil.addNetStream(this.bytesTotal >> 10);
            //缓存加载的对象
            CacheUtils.saveCacheFile(_urlRequest.url, this.data, _cacheLevel, _cacheVer);

            loadOver(this.data);
        }

        /**
         * 加载完毕执行方法将数据返回，从加载队列移除
         * @param data
         *
         */
        private function loadOver(data:Object):void
        {
            if (null != _callBackFunc)
            {
                _callBackFunc(data);
            }
            LoaderManager.endLoad(this);
            clearListeners();
        }

        private function ioErrorHandler(e:IOErrorEvent):void
        {
            onLoadError(e);
        }

        private function securityError(e:SecurityErrorEvent):void
        {
            onLoadError(e);
        }

        private function onLoadError(e:Event):void
        {
            trace("加载失败：", _urlRequest.url);
            trace(e.toString());
            clearListeners();
            LoaderManager.endLoad(this);
			this.dispatchEvent(new LoaderEvent(LoaderEvent.LOADER_ERROR));
        }

        //清理事件监听
        private function clearListeners():void
        {
            this.removeEventListener(Event.COMPLETE, completeHandler);
            this.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
        }

        public function setUrl(url:String):void
        {
            _urlRequest = new URLRequest(url);
        }

        public function getUrl():String
        {
            return _urlRequest.url;
        }
    }
}