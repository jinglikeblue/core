package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	
	import jing.framework.manager.module.ModuleManager;
	import jing.ui.yrtlib.compment.interfaces.IDataList;
	import jing.ui.yrtlib.compment.interfaces.IDataListItem;
	import jing.ui.yrtlib.compment.interfaces.IListItem;

	/**
	 * 数据列表
	 * 持有数据的列表
	 * @author GoSoon
	 *
	 */
	public class DataList extends List implements IDataList
	{
		// Vars -------------------------------------------------------------------------------------

		/** 数据提供者 */
		protected var _dataProvider:Object;
		/** 列表项类型 */
		protected var _itemClass:Class;
		/** 列表项类GUI */
		protected var _itemGuiName:String;

		// System ----------------------------------------------------------------------------------

		public function DataList(itemClass:Class, itemGuiName:String, listGUI:DisplayObject=null)
		{
			super(listGUI);
			_itemClass=itemClass;
			_itemGuiName=itemGuiName;
		}

		// 功能 --------------------------------------------------------------------------------------------------

		/**
		 * 列表长度
		 * @return
		 *
		 */
		public function get length():int
		{
			return _items.length;
		}

		/**
		 * 列表项集合
		 * @return
		 *
		 */
		public function get items():Vector.<IListItem>
		{
			return _items;
		}

		/**
		 * 获得选中的数据列表项
		 * @return
		 *
		 */
		public function get selectedDataListItem():IDataListItem
		{
			return _selectedItem as IDataListItem;
		}

		public override function addItemAt(item:IListItem, index:int):void
		{
			super.addItemAt(item, index);
			(item as IDataListItem).index=index;
		}

		public override function removeItemAt(index:int):void
		{
			(_items[index] as IDataListItem).data=null;
			_items[index].destroy();
			_items.splice(index, 1);

			callDraw();
		}

		/**
		 * 根据数据自动调整列表项
		 * @param len
		 *
		 */
		protected function autoAdjustItems(len:int):void
		{
			var itemGui:DisplayObject;
			var item:IDataListItem;
			var itemLen:int=_items.length;
			//如果数据源比之前少了项，删除多余的
			if (len < itemLen)
			{
				var delCount:int=itemLen - len;
				for (delCount; delCount > 0; delCount--)
				{
					removeItem(_items[_items.length - 1] as IDataListItem);
				}
			}
			//如果数据源比之前多了项，添加
			else if (len > itemLen)
			{
				var addCount:int=len - itemLen;
				for (addCount; addCount > 0; addCount--)
				{
					itemGui=ModuleManager.getObject(_itemGuiName) as DisplayObject;
					item=new _itemClass(itemGui);
					addItemAt(item, _items.length);
				}
			}
			//刷新数据
			var count:int=0;
			for each (item in _items)
			{
				item.data=_dataProvider[count];
				count++;
			}
		}

		/**
		 * 清理列表数据
		 *
		 */
		public function clearData():void
		{
			var listItem:IDataListItem;
			for (var i:int=0; i < _items.length; i++)
			{
				listItem=_items[i] as IDataListItem;
				listItem.data=null;
			}
			_dataProvider=null;
			if (_selectedItem)
			{
				_selectedItem.setSelected(false);
				_selectedItem=null;
			}
		}

		/**
		 * 设置Array类型数据
		 *
		 */
		protected function setArrayData(data:Array):void
		{
			_dataProvider=data;
			autoAdjustItems(data.length);
		}

		// 接口 -------------------------------------------------------------------------------------------

		public function set dataProvider(data:Object):void
		{
			clearData();
			if (!data)
			{
				return;
			}
			if (data is Array)
			{
				setArrayData(data as Array);
			}
		}

		public function get dataProvider():Object
		{
			return _dataProvider;
		}
	}
}
