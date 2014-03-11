package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.interfaces.IListItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * 平铺的列表， 
	 * @author jing
	 * 
	 */	
	public class TileList extends List
	{		
		private var _tileWidth:int = 0;
		
		public function TileList(listGUI:DisplayObject = null)
		{
			super(listGUI);
		}
		
		override public function draw():void
		{
			var length:int = _items.length;
			var listRealH:int = 0;
			var item:IListItem = null;
			var container:DisplayObjectContainer = _gui as DisplayObjectContainer;
			var posX:int = 0;
			for(var i:int = 0; i < length; i++)
			{
				item = _items[i];
				if(posX != 0 && posX + item.width > _tileWidth)
				{					
					listRealH += item.height;
					posX = 0;						
				}
				
				item.show(container,posX,listRealH);
				posX += item.width;
				
			}
			
//			if(null != _vs)
//			{
//				_vs.setViewRealH(listRealH + item.height);
//			}
		}

//		override public function set width(w:Number):void
//		{
//			if(null == _vs)
//			{
//				_tileWidth = w;
//			}
//			else
//			{
//				super.width = w;
//				_tileWidth = super.width;
//			}
//		}
	}
}