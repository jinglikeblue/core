package jing.framework.manager.loader
{
	import flash.display.Loader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import jing.framework.manager.loader.interfaces.ILoader;

	/**
	 * 加载loader的管理工具，带有队列加载功能 
	 * @author Jing
	 * 
	 */	
	public class LoaderManager
	{
		//加载列表
		static private var _list:Vector.<ILoader> = new Vector.<ILoader>();
		
		static public function get list():Vector.<ILoader>
		{
			return _list;
		}
		/**
		 * 同一时间可以执行的Loader的总数 
		 */		
		static private var _threadCount:int = 6;
		
		/**
		 * 已经被使用的loader数量 
		 */		
		static private var _threadUsedCount:int = 0;
		
		/**
		 * 加载是否允许 
		 */		
		static private var _loadEnableDic:Dictionary = new Dictionary();
		
		/**
		 * 将loader对象添加到加载队列 
		 * @param loader
		 * 
		 */		
		static internal function addToLoadList(loader:ILoader):void
		{
			//判断loader是否已在队列中，是则跳出
			if(_list.indexOf(loader) != -1)
			{
				return;
			}			
			
			_list.push(loader);
			checkNextLoad();
		}
		
		static public function init():void
		{
			
		}
		
		/**
		 * 检查下一个要加载的对象 
		 * 
		 */		
		static private function checkNextLoad():void
		{
			var iLoaderLoaing:Object = null;
			if(_list.length > 0 && _threadUsedCount < _threadCount)
			{
				var iLoader:ILoader = _list[0];
				
				for (iLoaderLoaing in _loadEnableDic)
				{					
					if((iLoaderLoaing as ILoader).getUrl() == iLoader.getUrl())
					{
						//加载的地址一样，则跳出这次加载
//						trace("存在重复的地址请求：",iLoader.getUrl());
						return;
					}
				}
				
				startLoad(_list.shift());
			}				
		}
		
		/**
		 * 开始加载 
		 * @param loader
		 * 
		 */		
		static internal function startLoad(loader:ILoader):void
		{
			_loadEnableDic[loader] = true;
			_threadUsedCount++;
//			trace("使用的网络线程数量",_threadUsedCount);
			loader.loadAtList(loader.getUrl());
		}
		
		/**
		 * 结束加载 
		 * @param loader
		 * 
		 */		
		static internal function endLoad(loader:ILoader):void
		{
			if(true == _loadEnableDic[loader])
			{
				delete _loadEnableDic[loader];
				_threadUsedCount--;
				checkNextLoad();
			}
		}
		
		/**
		 * 检查是否可以开始加载loader 
		 * @param loader
		 * @return 
		 * 
		 */		
		static internal function checkLoadEnable(loader:ILoader):Boolean
		{
			return true==_loadEnableDic[loader];
		}
			
		
		/**
		 * 加载URL地址指定内容 
		 * @param url 网络地址
		 * @param type 数据的类型，参考LoaderType类
		 * @param context 只对LoaderType.DISPLAY类型的加载有用
		 * @param cacheLevel 数据缓存等级, 参考CacheLevel类
		 * 
		 */		
		static public function load(url:String,type:int, _callBackFunc:Function = null, context:LoaderContext = null, cacheLevel:int = 0):void
		{						
			var iLoader:ILoader = null;
			switch(type)
			{
				case LoaderType.BYTES:
					iLoader = new BytesLoader(_callBackFunc,cacheLevel);
					break;
				case LoaderType.DISPLAY:
					iLoader = new DisplayLoader(_callBackFunc,context,1,cacheLevel);
					break;
				case LoaderType.TEXT:
					var bl:BytesLoader = new BytesLoader(_callBackFunc,cacheLevel);
					bl.dataFormat = URLLoaderDataFormat.TEXT;
					iLoader = bl;
					break;
			}
			iLoader.setUrl(url);
			addToLoadList(iLoader);
		}
	}
}