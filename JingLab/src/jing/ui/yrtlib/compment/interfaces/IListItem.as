package jing.ui.yrtlib.compment.interfaces
{
	import jing.framework.core.view.interfaces.IView;
	import jing.ui.yrtlib.compment.List;
	
	/**
	 * 列表项接口 
	 * @author jing
	 * 
	 */	
	public interface IListItem extends IView
	{
		/**
		 * 通过该方法把使用列表项的列表传入 
		 * @param list
		 * 
		 */		
		function setList(list:List):void;
		
		/**
		 * 设置列表项是否选中 
		 * @param b
		 * 
		 */		
		function setSelected(b:Boolean):void;
	}
}