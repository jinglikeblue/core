package jing.framework.manager.loader
{
	public class LoaderQueueInfo
	{
		public function LoaderQueueInfo():void
		{
			
		}
		
		/**
		 * 已完成的loader数量
		 */		
		public var loadedCount:int = 0;
		
		/**
		 * 总共的loader数量
		 */		
		public var totalCount:int = 0;
		
		/**
		 * 已加载的资源总大小
		 */		
		public var allBytesLoaded:int = 0;
		
		/**
		 * 总共要加载的资源大小 
		 */		
		public var allBytesTotal:int = 0;
		
		/**
		 * 当前队列值 
		 */		
		public var currentListValue:int = 0;
		
		/**
		 * 
		 * 整个队列中所有loader的listValue集合 
		 */		
		public var totalListValue:int = 0;
		
		/**
		 * 当前加载的资源已加载的大小 
		 */		
		public var currentModuleBytesLoaded:int = 0;
		
		/**
		 * 当前加载的资源总大小 
		 */		
		public var currentModuleBytesTotal:int = 0;
		
		/**
		 * 是否所有loader执行完毕
		 */		
		public var isAllComplete:Boolean = false;
		
		/**
		 * 正在加载的资源 
		 */		
		public var loadingURL:String = null;
	}
}