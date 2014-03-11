package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.ui.yrtlib.compment.base.CompmentView;
	
	public class TileBox extends CompmentView
	{
		/**
		 * X轴上的间隔 
		 */		
		private var _gapX:int = 0;
		
		/**
		 * Y轴上的间隔 
		 */		
		private var _gapY:int = 0;
		
		/**
		 * 盒子里的排列项 
		 */		
		private var _items:Vector.<ViewBase> = null;
		/**
		 * 
		 * @param gui
		 * @param gapX
		 * @param gapY
		 * 
		 */		
		public function TileBox(gui:DisplayObject,gapX:int = 0, gapY:int = 0)
		{
			_items = new Vector.<ViewBase>();
			_gapX = gapX;
			_gapY = gapY;
			super(gui);
		}
		
		public function append(view:ViewBase):void
		{
			
		}
	}
}