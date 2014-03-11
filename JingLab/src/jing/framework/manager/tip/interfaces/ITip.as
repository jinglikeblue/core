package jing.framework.manager.tip.interfaces
{
	import jing.framework.core.view.interfaces.IView;

	/**
	 * Tip对象实现该接口 
	 * @author Jing
	 * 
	 */	
	public interface ITip extends IView
	{
		/**
		 * 设置Tip对象的数据 
		 * @param obj
		 * 
		 */		
		function setData(obj:Object):void;
		
		/**
		 * 设置是否是附加Tip 
		 * @param b
		 * 
		 */		
		function setIsAppend(b:Boolean):void;
	}
}