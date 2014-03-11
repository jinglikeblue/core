package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.interfaces.IListItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DataTileList extends DataList
	{
		public function DataTileList(itemClass:Class, itemGuiName:String, listGUI:DisplayObject=null)
		{
			super(itemClass, itemGuiName, listGUI);
		}
		
		private var _tileWidth:int = 0;
		
		public function set tileWidth(width:int):void
		{
			_tileWidth = width;
		}
		
		override public function draw():void
		{
			var length:int = _items.length;
			var listRealH:int = 0;
			var item:IListItem;
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
		}
	}
}