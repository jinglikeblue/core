package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.events.ButtonBarEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import jing.framework.manager.notice.NoticeManager;
	import jing.framework.manager.stage.StageManager;

	/**
	 * 通过控件定义一组具有普通外观和导航的且在逻辑上相关的水平按钮
	 * @author Owen
	 */
	public class ButtonBar extends CompmentView
	{
		/** 信息数组 */
		private var _dataProvider:Array;
		/** 按钮组 */
		private var _buttonGroup:ButtonSelectGroup;
		/** 皮肤 */
		private var _skin:Class;
		/** 保存按钮 */
		private var _buttonDic:Dictionary;
		/** 当前选择索引 */
		private var _selectedIndex:int;
		
		/**
		 * 传入皮肤，数据源，容器，初始化界面
		 * @param skin
		 * @param dataProvider:数据中的元素项应为object，有label属性用于显示和data属性用于在点击时判断执行内容
		 * @param container
		 */
		public function ButtonBar(skin:Class, dataProvider:Array, container:DisplayObjectContainer = null)
		{
			if(container == null)
			{
				container = new Sprite();
			}
			super(container);
			_skin = skin;
			_dataProvider = dataProvider;
			
			_buttonDic = new Dictionary();
			_buttonGroup = new ButtonSelectGroup();
			createButtonBar();
		}
		
		/**
		 * 更新数据
		 * 更新buttonBar显示
		 * @param dataProvider
		 */
		public function updateButtonBar(dataProvider:Array):void
		{
			removeAllButton();
			_dataProvider = dataProvider;
			createButtonBar();
		}
		/**
		 * 创建按钮组
		 */
		private function createButtonBar():void
		{
			if(_skin == null || _dataProvider == null || _dataProvider.length <= 0)
			{//皮肤或数据源不完整，无法进行显示
				return;
			}
			for(var i:int = 0; i < _dataProvider.length; i++)
			{
				createButton(_dataProvider[i]);
			}
			_buttonGroup.selectedIndex = 0;
		}
		/**
		 * 添加一个按钮
		 * @param obj
		 */
		public function addButton(obj:Object):void
		{
			addButtonAt(obj);
		}
		/**
		 * 添加一个按钮到索引位置
		 * @param obj
		 * @param index
		 */
		public function addButtonAt(obj:Object, index:int = -1):void
		{
			if(obj == null)
			{
				return;
			}
			if(index == -1)
			{
				index = _dataProvider.length;
			}
			_dataProvider.splice(index, 0, obj);
			createButton(obj, index);
		}
		/**
		 * 创建按钮
		 * @param obj
		 * @param index
		 */
		private function createButton(obj:Object, index:int = -1):void
		{
			var buttonItem:ButtonSelectLabel;
			if(_buttonDic[obj["label"]] == null)
			{
				buttonItem = new ButtonSelectLabel(new _skin(), obj["label"]);
				_buttonDic[obj["label"]] = buttonItem;
			}
			else
			{
				buttonItem = _buttonDic[obj["label"]];
			}
			_buttonGroup.joinGroupAt(buttonItem, index);
			buttonItem.addEventListener(MouseEvent.CLICK, buttonItem_clickHandler);
			callDraw();
		}
		/**
		 * 清空所有数据 以及按钮
		 */
		public function removeAllButton():void
		{
			if(_dataProvider == null || _dataProvider.length <= 0)
			{
				return;
			}
			var length:int = _dataProvider.length;
			while(--length > -1)
			{
				removeButton(length);
			}
		}
		/**
		 * 删除单个按钮
		 * @param index
		 */
		public function removeButton(index:int):void
		{
//			trace("删除按钮：" + index);
			if(index >= _dataProvider.length || index < 0)
			{
				trace("删除索引无效");
				return;
			}
//			trace("删除按钮：" + index);
			_dataProvider.splice(index, 1);//从数据数组中删除
			var buttonItem:ButtonSelect = _buttonGroup.getItem(index);
			_buttonGroup.removeItemGroup(buttonItem);//从按钮组中删除
			buttonItem.removeEventListener(MouseEvent.CLICK, buttonItem_clickHandler);
			buttonItem.close();
			callDraw();
		}
		/**
		 * 重写方法，下一帧执行刷新
		 */
		override public function draw():void
		{
			var length:int = _buttonGroup.itemCount();
			var buttonBarW:int = 0;
			var itemButton:ButtonSelect = null;
			var container:DisplayObjectContainer = _gui as DisplayObjectContainer;
			
			for(var i:int = 0; i < length; i++)
			{
				itemButton = _buttonGroup.getItem(i);
				itemButton.show(container,buttonBarW,0);
				buttonBarW += itemButton.width;
			}
		}
		/**
		 * 获取当前索引
		 * @return
		 */
		public function getSelectedIndex():int
		{
			return _buttonGroup.selectedIndex;
		}
		/**
		 * 设置当前索引
		 * @param index
		 */
		public function setSelectedIndex(index:int):void
		{
			_buttonGroup.selectedIndex = index;
		}
		/**
		 * 单项个数
		 * @return
		 */		
		public function itemCount():int
		{
			return _buttonGroup.itemCount();
		}
		/**
		 * 点击按钮项
		 * @param event
		 */
		private function buttonItem_clickHandler(event:MouseEvent):void
		{
			var buttonNum:int = _buttonGroup.selectedIndex;
			this.dispatchEvent(new ButtonBarEvent(ButtonBarEvent.CHANGE_SELECT, _buttonGroup.selectedIndex));
		}
		/**
		 * 添加事件侦听
		 */		
		override public function addListeners():void
		{
			var buttonItem:ButtonSelectLabel;
			for(var i:int = 0; i < _buttonGroup.itemCount(); i++)
			{
				buttonItem = _buttonGroup.getItem(i) as ButtonSelectLabel;
				if(buttonItem == null)
				{
					continue;
				}
				buttonItem.addEventListener(MouseEvent.CLICK, buttonItem_clickHandler);
			}
		}
		/**
		 * 删除事件侦听
		 */
		override public function removeListeners():void
		{
			var buttonItem:ButtonSelectLabel;
			for(var i:int = 0; i < _buttonGroup.itemCount(); i++)
			{
				buttonItem = _buttonGroup.getItem(i) as ButtonSelectLabel;
				if(buttonItem == null)
				{
					continue;
				}
				buttonItem.removeEventListener(MouseEvent.CLICK, buttonItem_clickHandler);
			}
		}
	}
}