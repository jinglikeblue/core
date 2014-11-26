package jing.net.http
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	/**
	 * http请求代理 
	 * @author Jing
	 * 
	 */	
	public class HttpProxy extends EventDispatcher
	{
		private var _loader:URLLoader;
		private var _request:URLRequest;
		
		private var _data:*;

		/**
		 * 存储的数据 
		 */
		public function get data():*
		{
			return _data;
		}

		
		private var _args:Object;

		/**
		 * 请求的参数 
		 */
		public function get requestArgs():Object
		{
			return _args;
		}

		
		private var _url:String;

		/**
		 * 请求的地址 
		 */
		public function get url():String
		{
			return _url;
		}

		
		private var _responseData:ByteArray;

		/**
		 * 请求返回的数据 
		 */
		public function get responseData():ByteArray
		{
			return _responseData;
		}

		
		private var _isLoading:Boolean = false;
		
		public function HttpProxy(url:String, requestArgs:Object = null, data:* = null)
		{
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_request = new URLRequest(url);
			_request.data = parseRequestArgs(requestArgs);
			
			_args = requestArgs;
			_data = data;
			_url = url;
			
			addListeners();
		}
		
		private function parseRequestArgs(obj:Object):Object
		{
			if(null == obj || obj is String)
			{
				return obj;
			}
			
			var v:URLVariables = new URLVariables();
			for(var k:String in obj)
			{
				v[k] = obj[k];
			}
			return v;
		}
		
		private function addListeners():void
		{
			_loader.addEventListener(Event.COMPLETE, _loader_completeHandler);		
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _loader_ioErrorHandler);
		}
		
		private function removeListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, _loader_completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, _loader_ioErrorHandler);
		}
		
		protected function _loader_completeHandler(event:Event):void
		{
			_isLoading = false;
			_responseData = _loader.data as ByteArray;	
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function _loader_ioErrorHandler(event:IOErrorEvent):void
		{
			trace(event.text);
		}
		
		/**
		 * 用GET方式发送请求 
		 * 
		 */		
		public function get():void
		{
			_request.method = URLRequestMethod.GET;
			load();
		}
		
		/**
		 * 用POST方式发送请求 
		 * 
		 */		
		public function post():void
		{
			_request.method = URLRequestMethod.POST;	
			load();
		}
		
		private function load():void
		{
			_isLoading = true;
			_loader.load(_request);
		}
		
		/**
		 * 取消执行中的请求 
		 * 
		 */		
		public function cancel():void
		{
			if(false == _isLoading)
			{
				return;
			}
			
			try
			{
				_loader.close();
			}
			catch(e:Error)
			{
				
			}
		}
		
		/**
		 * 销毁对象 
		 * 
		 */		
		public function dispose():void
		{
			cancel();
			removeListeners();
			_loader = null;
			_request = null;
			_data = null;
			_args = null;
			_url = null;
			_responseData = null;
		}
	}
}