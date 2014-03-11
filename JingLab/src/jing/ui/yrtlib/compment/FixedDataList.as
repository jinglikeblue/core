package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.interfaces.IDataListItem;

	import flash.display.DisplayObject;

	/**
	 * 固定长度以及外观的数据列表
	 * 要使用该列表，ListGUI中必须有序列化的项申明，如 item0 item1 item2...
	 * 没有滚动条。根据传入的列表gui生成列表
	 * @author GoSoon
	 *
	 */
	public class FixedDataList extends DataList
	{
		/** 列表项序列化申明 */
		private var _itemDefined:String;

		/**
		 * 固定长度以及外观的数据列表造函数
		 * @param itemCount 固定的列表长度
		 * @param itemClass 列表项类
		 * @param listGUI 列表GUI
		 * @param itemDefined 列表项序列化申明，比如GUI中 item0 item1 item2... 默认itemDefined='item'
		 *
		 */
		public function FixedDataList(itemCount:int, itemClass:Class, listGUI:DisplayObject, itemDefined:String="item")
		{
			super(itemClass, "", listGUI);
			_itemDefined=itemDefined;
			var item:DataListItem;
			for (var i:int=0; i < itemCount; i++)
			{
				item=new _itemClass(_gui[_itemDefined + i]);
				item.addListeners();
				addItem(item);
			}
			dataProvider=null;
		}

		/**
		 * 设置数组数据，父类方法失效
		 * @param data
		 *
		 */
		protected override function setArrayData(data:Array):void
		{
			//父类方法失效
			_dataProvider=data;
			var listItem:IDataListItem;
			for (var i:int=0; i < _items.length; i++)
			{
				listItem=_items[i] as IDataListItem;
				listItem.data=_dataProvider[i];
			}
		}

		public override function draw():void
		{
			//该方法失效，因为这是固定的列表
		}
	}
}
