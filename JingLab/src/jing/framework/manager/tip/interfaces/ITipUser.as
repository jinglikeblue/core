package jing.framework.manager.tip.interfaces
{
	import jing.framework.core.view.interfaces.IView;
	
	import flash.display.DisplayObject;
	
	import jing.framework.manager.tip.vo.TipVO;

	/**
	 * 实现该接口的显示对象可以呈现Tip内容 
	 * @author Jing
	 * 
	 */	
	public interface ITipUser extends IView
	{
		/**
		 * 得到对象响应鼠标悬浮的显示对象 
		 * @return 
		 * 
		 */		
		function get tipDisplayObject():DisplayObject;		
		
		/**
		 * 得到对象的tip数据 
		 * @return 
		 * 
		 */		
		function get tipVO():TipVO;
	}
}