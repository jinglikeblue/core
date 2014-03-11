package jing.loader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import jing.loader.events.LoaderErrorEvent;
	import jing.loader.events.LoaderEvent;
	
	public class Example extends Sprite
	{
		private var l:DisplayLoader = new DisplayLoader(null,null,4);
		private var worker:LoaderWorker = new LoaderWorker();
		private var factory:LoaderFactory = new LoaderFactory();
		private var loaderList:LoaderList = new LoaderList();
		private var offX:int = 0;
		public function Example()
		{
			super();
		}
		
		/**
		 * 测试加载URL地址 
		 * @param url
		 * 
		 */		
		public function test(url:String):void
		{
			l.addEventListener(LoaderErrorEvent.Error, l_errorHandler);
			l.addEventListener(Event.COMPLETE, l_completeHandler);
			l.addEventListener(LoaderEvent.HTTP_STATUS, httpStatusHandler);
			l.addEventListener(ProgressEvent.PROGRESS, l_progressHandler);
			l.load(new URLRequest(url));	
		}
		
		/**
		 * 测试加载队列 
		 * @param urls
		 * 
		 */		
		public function testWorker(urls:Array):void
		{
			for each(var url:String in urls)
			{
				l = new DisplayLoader(new URLRequest(url));
				l.addEventListener(Event.COMPLETE,l_completeHandler);
				worker.add(l);
			}
		}
		
		/**
		 * 测试加载工厂 
		 * @param urls
		 * 
		 */		
		public function testFactory(urls:Array):void
		{
			for each(var url:String in urls)
			{
				l = new DisplayLoader(new URLRequest(url));
				l.addEventListener(Event.COMPLETE,l_completeHandler);
				factory.add(l);
			}
		}
		
		/**
		 * 测试加载队列 
		 * @param urls
		 * 
		 */		
		public function testLoaderList(urls:Array):void
		{
			for each(var url:String in urls)
			{
				l = new DisplayLoader(new URLRequest(url));
				l.addEventListener(Event.COMPLETE,l_completeHandler);
				loaderList.add(l,100);
			}
			loaderList.addEventListener(ProgressEvent.PROGRESS, loaderList_progressHandler);
			loaderList.start();
			
		}
		
		private function loaderList_progressHandler(e:ProgressEvent):void
		{
			var ll:LoaderList = e.currentTarget as LoaderList;
//			ll.dispose();
			trace("队列进度:", e.bytesLoaded + "/" + e.bytesTotal, ll.loadedCount + "/" + ll.length, ll.getBytesLoaded());
		}
		
		protected function l_progressHandler(event:ProgressEvent):void
		{
			// TODO Auto-generated method stub
			trace("加载进度:",event.bytesLoaded,"/",event.bytesTotal);
		}
		
		protected function httpStatusHandler(event:LoaderEvent):void
		{
			// TODO Auto-generated method stub
			trace("加载状态：",event.status);
		}
		
		protected function l_completeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("加载完成");
			var loader:DisplayLoader = event.currentTarget as DisplayLoader;
			loader.displayObject.x = offX;
			offX += 50;
			this.addChild(loader.displayObject);
		}
		
		protected function l_errorHandler(event:LoaderErrorEvent):void
		{
			trace("发生错误----------------------");
			trace("原因：",event.reason);
			trace("信息：",event.msg);
		}
	}
}