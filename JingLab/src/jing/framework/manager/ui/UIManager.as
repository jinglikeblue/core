package jing.framework.manager.ui
{
	import flash.utils.Dictionary;
	
	import jing.framework.core.view.base.ViewBase;

	/**
	 * UI管理器 
	 * @author jing
	 * 
	 */	
	public class UIManager
	{
		static private var _viewDic:Dictionary = new Dictionary();
		
		/**
		 * 通过视图名字得到视图 
		 * @param viewName
		 * @return 
		 * 
		 */		
		static public function getView(viewName:String):ViewBase
		{
			return _viewDic[viewName];
		}
		
		/**
		 * 缓存一个视图到管理器 
		 * @param viewName
		 * @param view
		 * 
		 */		
		static public function cacheView(viewName:String,view:ViewBase):void
		{
			var oldView:ViewBase = _viewDic[viewName];			
			if(null != oldView && view != oldView && false == oldView.isDestroyed)
			{
				
				oldView.destroy();
			}
			_viewDic[viewName] = view;
		}
		
		/**
		 * 从视图管理器释放一个缓存了的视图 
		 * @param viewName
		 * 
		 */		
		static public function releaseView(viewName:String, isDestory:Boolean = false):void
		{
			if(true == isDestory)
			{
				var view:ViewBase = _viewDic[viewName];
				if(false == view.isDestroyed)
				{
					view.destroy();
				}
			}
			delete _viewDic[viewName];
		}
	}
}