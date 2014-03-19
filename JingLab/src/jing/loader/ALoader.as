package jing.loader
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    
    import jing.loader.consts.ErrorReason;
    import jing.loader.events.LoaderErrorEvent;
    import jing.loader.events.LoaderEvent;
    import jing.loader.interfaces.ILoader;

    /**
     * 加载类的抽象基类
     * @author Jing
     *
     */
    [Event(name = "progress", type = "flash.events.ProgressEvent")]
    [Event(name = "complete", type = "flash.events.Event")]
    [Event(name = "HttpStatus", type = "jing.loader.events.LoaderEvent")]
    [Event(name = "Error", type = "jing.loader.events.LoaderErrorEvent")]
    internal class ALoader extends EventDispatcher implements ILoader
    {
        /**
         * 加载数据的流
         */
        protected var _urlStream:URLStream;

        protected var _urlRequest:URLRequest;
		
		/**
		 * 尝试次数 
		 */		
		protected var _tryTime:int;
		
		private var _param:*;

		/**
		 * 携带的参数 
		 */
		public function get param():*
		{
			return _param;
		}

		/**
		 * @private
		 */
		public function set param(value:*):void
		{
			_param = value;
		}

        /**
         * HTTP请求中所包含的信息
         * @return
         *
         */
        public function get urlRequest():URLRequest
        {
            return _urlRequest;
        }


        public function get isLoading():Boolean
        {
            if (_urlStream && _urlStream.connected)
            {
                return true;
            }
            return false;
        }

		/**
		 *  
		 * @param urlRequest HTTP请求信息
		 * @param tryTime 失败后的重复尝试次数
		 * 
		 */		
        public function ALoader(urlRequest:URLRequest = null, tryTime:int = 0)
        {
			_tryTime = tryTime;
            _urlRequest = urlRequest;
        }

        /**
         * 获得字节数组
         * @return
         *
         */
        protected function getByteArray():ByteArray
        {
            var ba:ByteArray;

            if (_urlStream)
            {
                ba = new ByteArray();
                _urlStream.readBytes(ba, 0, _urlStream.bytesAvailable);
            }
            return ba;
        }

        /**
         * 开始加载
         * @param request 如果这里不传入URLRequest数据，请确定在初始化对象时已传入
         *
         */
        public function load(request:URLRequest = null):void
        {
			if(null == request)
			{
				request = _urlRequest;
			}
			//这里在清理的时候会清除_urlRequst的数据
			
            dispose();

			_urlRequest = request;

            if (null == request)
            {
                this.dispatchEvent(new LoaderErrorEvent(LoaderErrorEvent.Error, ErrorReason.NONE_URLREQUEST));
                return;
            }

            _urlStream = new URLStream();
            _urlStream.addEventListener(ProgressEvent.PROGRESS, _urlStream_progressHandler);
            _urlStream.addEventListener(Event.COMPLETE, _urlStream_completeHandler);
            _urlStream.addEventListener(IOErrorEvent.IO_ERROR, _urlStream_ioErrorHandler);
            _urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _urlStream_securityErrorHandler);
            _urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, _urlStream_heepStatusHandler);
            _urlStream.load(request);
        }

        protected function _urlStream_heepStatusHandler(event:HTTPStatusEvent):void
        {
            this.dispatchEvent(new LoaderEvent(LoaderEvent.HTTP_STATUS, event.status));
        }

        protected function _urlStream_securityErrorHandler(event:SecurityErrorEvent):void
        {
            this.dispatchEvent(new LoaderErrorEvent(LoaderErrorEvent.Error, ErrorReason.SECURITY_ERROR));
        }

        protected function _urlStream_ioErrorHandler(event:IOErrorEvent):void
        {
			removeStremListeners();
			if(_tryTime > 0)
			{
				_tryTime--;
				//重试加载
				load();
				return;
			}
            this.dispatchEvent(new LoaderErrorEvent(LoaderErrorEvent.Error, ErrorReason.IO_ERROR, event.text));
        }

        protected function _urlStream_completeHandler(event:Event):void
        {
			removeStremListeners();
            this.dispatchEvent(new Event(Event.COMPLETE));
        }

        protected function _urlStream_progressHandler(event:ProgressEvent):void
        {
            this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, event.bytesLoaded, event.bytesTotal));
        }

		/**
		 * 移除加载流的事件 
		 * 
		 */		
		private function removeStremListeners():void
		{
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, _urlStream_progressHandler);
			_urlStream.removeEventListener(Event.COMPLETE, _urlStream_completeHandler);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, _urlStream_ioErrorHandler);
			_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _urlStream_securityErrorHandler);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _urlStream_heepStatusHandler);
		}
		
        /**
         * 销毁所有加载的数据
         *
         */
        public function dispose():void
        {
            if (_urlStream)
            {
				removeStremListeners();
                _urlStream.close();
                _urlStream = null;
            }
            _urlRequest = null;
        }


    }
}
