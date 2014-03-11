package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.events.ListEvent;
	import jing.ui.yrtlib.compment.interfaces.IListItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * 简单的列表组件
	 * @author jing
	 *
	 */
	[Event(name="SELECT_ITEM", type="jing.ui.yrtlib.compment.events.ListEvent")]
	public class List extends CompmentView
	{
		private var _realHight:Number;
		
		public function get realHight():Number
		{
			return _realHight;
		}
		
		/** 垂直间隔 */
		protected var _verticalGap:Number;

		//列表项
		protected var _items:Vector.<IListItem>=new Vector.<IListItem>();

		protected var _selectedItem:IListItem=null;

		/**
		 * 选中项
		 */
		public function get selectedItem():IListItem
		{
			return _selectedItem;
		}

		/**
		 * 得到列表项的长度
		 * @return
		 *
		 */
		public function get itemsCount():int
		{
			return _items.length;
		}

		protected var _scrollPos:int=0;

		public function List(listGUI:DisplayObject=null)
		{
			if (null == listGUI)
			{
				listGUI=new Sprite();
			}
			super(listGUI);
			init();
		}

		protected function init():void
		{
			_verticalGap=0;
		}

		public override function destroy():void
		{
			removeAll();
			super.destroy();
		}

		/**
		 * 垂直间隔
		 * @return
		 *
		 */
		public function get verticalGap():Number
		{
			return _verticalGap;
		}

		/**
		 * @private
		 */
		public function set verticalGap(value:Number):void
		{
			if (_verticalGap == value)
				return;
			_verticalGap=value;
			callDraw();
		}

		/**
		 * 设置选中的索引项
		 * @param index
		 *
		 */
		public function setSelectedIndex(index:int):void
		{
			if (index > -1 && index < _items.length && _items.length > 0)
			{
				setSelectedItem(_items[index]);
			}
		}

		/**
		 * 设置选中的列表项
		 * @param item
		 *
		 */
		public function setSelectedItem(item:IListItem):void
		{
			if (null != item)
			{
				if (null != _selectedItem)
				{
					_selectedItem.setSelected(false);
				}
				item.setSelected(true);
				_selectedItem=item;
				dispatchEvent(new ListEvent(ListEvent.SELECT_ITEM));
			}
		}

		/**
		 * 滚动到索引所在位置
		 * @param index
		 *
		 */
//		public function scrollToIndex(index:int):void
//		{
//			var item:IListItem=_items[index];
//			scrollToItem(item);
//		}

		/**
		 * 滚动到列表项
		 * @param item
		 *
		 */
//		public function scrollToItem(item:IListItem):void
//		{
//			if (null == item || null == _vs)
//			{
//				return;
//			}
//			_vs.scrollViewToPos(item.y - (this.height >> 1));
//		}

		/**
		 * 添加列表项
		 * @param item
		 *
		 */
		public function addItem(item:IListItem):void
		{
			addItemAt(item, _items.length);
		}

		/**
		 * 在指定位置添加列表项
		 * @param item
		 *
		 */
		public function addItemAt(item:IListItem, index:int):void
		{
			if (index > _items.length)
			{
				index=_items.length;
			}

			_items.splice(index, 0, item);
			item.setList(this);
			callDraw();
		}

		public function updateUI():void
		{
			callDraw();
		}

		override public function draw():void
		{
			var length:int=_items.length;
			var listRealH:int=0;
			var item:IListItem=null;
			var container:DisplayObjectContainer=_gui as DisplayObjectContainer;

			for (var i:int=0; i < length; i++)
			{
				item=_items[i];
				item.show(container, 0, listRealH);
				listRealH+=item.height + _verticalGap;
			}
			
			_realHight = listRealH;

//			if (null != _vs)
//			{
//				_vs.setViewRealH(listRealH);
//			}

//			_vs.scrollViewToPos(_scrollPos);
		}


		/**
		 * 移除列表项
		 * @param item
		 *
		 */
		public function removeItem(item:IListItem):void
		{
			var index:int=_items.indexOf(item);
			if (index > -1)
			{
				removeItemAt(index);
			}
		}

		/**
		 * 移除指定位置列表项
		 * @param index
		 *
		 */
		public function removeItemAt(index:int):void
		{
			_items[index].destroy();
			_items.splice(index, 1);

			callDraw();
		}

		/**
		 * 添加列表项集合
		 * @param items
		 *
		 */
		public function addItems(items:Array):void
		{
			var length:int=items.length;
			for (var i:int=0; i < length; i++)
			{
				addItem(items[i] as IListItem);
			}
		}

		/**
		 * 通过索引获取列表项
		 * @param index
		 * @return
		 *
		 */
		public function getItemAt(index:int):IListItem
		{
			return _items[index];
		}

		/**
		 * 删除所有列表项
		 *
		 */
		public function removeAll():void
		{
			var length:int=_items.length;
			while (--length > -1)
			{
				removeItemAt(length);
			}
		}



	}
}
