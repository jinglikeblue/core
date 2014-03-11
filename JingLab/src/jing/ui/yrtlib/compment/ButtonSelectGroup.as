package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * 单选按钮组,用来管理单选按钮
	 * @author Owen
	 */	
	public class ButtonSelectGroup
	{
		/** 保存每组选择按钮 */
		private var _buttonSelectArr:Vector.<ButtonSelect> = new Vector.<ButtonSelect>();
		/** 已选中的按钮索引 */
		private var _selectedIndex:int = -1;
		
		public function ButtonSelectGroup()
		{
		}
		/**
		 * 添加按钮到组中
		 * @param btn
		 */		
		public function joinGroup(btn:ButtonSelect):void
		{
			joinGroupAt(btn);
		}
		/**
		 * 添加按钮到组中的索引位置
		 * @param btn
		 * @param index
		 */		
		public function joinGroupAt(btn:ButtonSelect, index:int = -1):void
		{
			if(_buttonSelectArr.indexOf(btn) != -1)//已经有同样的项则不再添加
			{
				return;
			}
			if(_buttonSelectArr.length < index || index == -1)//索引位置不合理则默认到最后一位
			{
				index = _buttonSelectArr.length;
			}
			_buttonSelectArr.splice(index, 0, btn);
			btn.addEventListener(MouseEvent.CLICK, btnGui_clickHandler);
		}
		/**
		 * 获取单项
		 * @param index
		 * @return 
		 */		
		public function getItem(index:int):ButtonSelect
		{
			if(index >= _buttonSelectArr.length)
			{
				return null;
			}
			return _buttonSelectArr[index];
		}
		/**
		 * 获取索引位置
		 * @param bs
		 * @return 
		 */
		public function getItemIndex(bs:ButtonSelect):int
		{
			var index:int = _buttonSelectArr.indexOf(bs);
			return index;
		}
		/**
		 * 返回单项个数
		 * @return
		 */		
		public function itemCount():int
		{
			return _buttonSelectArr.length;
		}
		/**
		 * 将已添加的按钮移出组
		 * @param btn
		 */
		public function removeItemGroup(btn:ButtonSelect):void
		{
			if(_buttonSelectArr == null || _buttonSelectArr.length == 0)
			{
				return;
			}
			var index:int = _buttonSelectArr.indexOf(btn);
			if(index == -1)
			{
				return;
			}
			btn.removeEventListener(MouseEvent.CLICK, btnGui_clickHandler);
			_buttonSelectArr.splice(index, 1);
		}
		/**
		 * 清除所有组成员
		 */
		public function clearGroup():void
		{
			for(var i:int = _buttonSelectArr.length - 1; i >= 0; i--)
			{
				_buttonSelectArr[i].removeEventListener(MouseEvent.CLICK, btnGui_clickHandler);
				_buttonSelectArr.splice(i, 1);
			}
		}
		/**
		 * 点击按钮
		 * @param event
		 */		
		private function btnGui_clickHandler(event:MouseEvent):void
		{
			var tempBtn:ButtonSelect = event.target as ButtonSelect;
			var tempIndex:int = _buttonSelectArr.indexOf(tempBtn);
			if(tempBtn.selected)
			{
				if(_selectedIndex != -1)
				{
					_buttonSelectArr[_selectedIndex].cancelSelect();
				}
				_selectedIndex = tempIndex;
			}
			else
			{
				tempBtn.setSelect();
			}
		}
		/**
		 * 设置选中项
		 * @param index
		 */
		public function set selectedIndex(index:int):void
		{
			if(index <= -1 || index >= _buttonSelectArr.length)
			{
				return;
			}
			if(_selectedIndex == index)
			{
				 _buttonSelectArr[_selectedIndex].selected = true;
				return;
			}
			if(_selectedIndex != -1)
			{
				_buttonSelectArr[_selectedIndex].cancelSelect();
				_selectedIndex = index;
				if(index != -1)
				{
					_buttonSelectArr[index].setSelect();
				}
				return;
			}
			_buttonSelectArr[index].setSelect();
			_selectedIndex = index;
		}
		/**
		 * 获取当前选中索引
		 * @return
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		/**
		 * 清楚信息
		 */		
		public function clearInfo():void
		{
			if(_selectedIndex != -1)
			{
				_buttonSelectArr[_selectedIndex].cancelSelect();
				_selectedIndex = -1;
			}
		}
	}
}