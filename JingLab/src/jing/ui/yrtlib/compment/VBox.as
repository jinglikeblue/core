package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.interfaces.IListItem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 放置在VBOX里面的元件会按照顺序从上往下排列
	 * @author jing
	 * 
	 */	
	public class VBox extends CompmentView
	{
		private var _items:Vector
		
		public function VBox()
		{
			super(new Sprite());
		}
	}
}