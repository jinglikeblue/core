package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.interfaces.IDataListItem;
	import jing.utils.img.ColorMatrixFilterUtil;

	/**
	 * 持有数据的列表项
	 * 根据bgGUIName找出可能存在的背景gui，通过该gui实现列表项的默认、移过、选中的视觉效果。
	 * 监听MouseOver，MouseOut，Click三个事件，含有这三个事件的方法，子类可以重载使用，务必记得super。
	 * 在刷新DataList的dataProvider时会清除列表项中的数据，方法为clearData()，可以重载并super来实现显示操作。
	 * @author GoSoon
	 *
	 */
	public class DataListItem extends CompmentView implements IDataListItem
	{
		// Vars -----------------------------------------------------------------------------------

		/** 数据 */
		protected var _data:Object;
		/** 在列表中的下标 */
		protected var _index:int;
		/** 所在列表 */
		protected var _list:DataList;
		/** 是否选中 */
		protected var _selected:Boolean;
		/** 是否可用 */
		protected var _enable:Boolean=true;

		private var _bgGUI:MovieClip;
		/** 背景gui帧数 */
		private var _bgGUIFrames:int;

		// System --------------------------------------------------------------------------------

		public function DataListItem(gui:DisplayObject, bgGUIName:String="bg")
		{
			super(gui);
			_selected=false;
			this.bgGUI=this.getChildByName(bgGUIName) as MovieClip;
		}

		/**
		 * 子类注意一定要重载
		 *
		 */
		public override function addListeners():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		/**
		 * 子类注意一定要重载
		 *
		 */
		public override function removeListeners():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		// 事件 ------------------------------------------------------------------------------------------------------

		/**
		 * 鼠标滑过，子类实现
		 * @param event
		 *
		 */
		protected function rollOverHandler(event:MouseEvent):void
		{
			if (!_enable)
			{
				return;
			}
			if (!_selected)
			{
				showOver();
			}
		}

		/**
		 * 鼠标滑出，子类实现
		 * @param event
		 *
		 */
		protected function rollOutHandler(event:MouseEvent):void
		{
			if (!_enable)
			{
				return;
			}
			if (!_selected)
			{
				showNormal();
			}
		}

		/**
		 * 鼠标单击，会设置所在列表的选中项为此项，重载务必super
		 * @param event
		 *
		 */
		protected function mouseClickHandler(event:MouseEvent):void
		{
			if (!_enable)
			{
				return;
			}
			_list.setSelectedItem(this);
		}

		/**
		 * list机制方法：设置下标
		 * @param index
		 *
		 */
		internal function setIndex(index:int):void
		{
			_index=index;
		}

		// 私有 ------------------------------------------------------------------------------------------------------

		private function showNormal():void
		{
			if (!_bgGUI)
				return;
			_bgGUI.gotoAndStop(1);
			_bgGUI.filters=null;
		}

		private function showOver():void
		{
			if (!_bgGUI)
				return;
			if (_bgGUIFrames > 1)
				_bgGUI.gotoAndStop(2);
			else
				_bgGUI.filters=[ColorMatrixFilterUtil.getHighlightFilter()];
		}

		private function showSelected():void
		{
			if (!_bgGUI)
				return;
			if (_bgGUIFrames > 2)
				_bgGUI.gotoAndStop(_bgGUIFrames);
			else if (_bgGUIFrames > 1)
				_bgGUI.gotoAndStop(2);
			else
				_bgGUI.filters=[ColorMatrixFilterUtil.getHighlightFilter()];
		}

		// 功能 ------------------------------------------------------------------------------------------------------

		public function setList(list:List):void
		{
			_list=list as DataList;
		}

		public function setSelected(b:Boolean):void
		{
			_selected=b;
			if (_selected)
				showSelected();
			else
				showNormal();
		}

		public function set index(index:int):void
		{
			_index=index;
		}

		public function get index():int
		{
			return _index;
		}

		public function set data(data:Object):void
		{
			_data=data;
			if (!_data)
				this.visible=false;
			else
				this.visible=true;
		}

		public function get data():Object
		{
			return _data;
		}

		public function get list():DataList
		{
			return _list;
		}

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable=value;
		}

		/**
		 * 设置可能存在的列表项背景gui（通常应该有默认、移过、选中的视觉效果）
		 * @param value
		 *
		 */
		public function set bgGUI(value:MovieClip):void
		{
			_bgGUI=value;
			if (_bgGUI)
			{
				_bgGUI.mouseChildren=false;
				_bgGUI.mouseEnabled=false;
				_bgGUI.gotoAndStop(1);
				_bgGUIFrames=_bgGUI.totalFrames;
			}
		}

	}
}
