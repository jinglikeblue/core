package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import jing.framework.core.events.ViewBaseEvent;
	import jing.framework.core.view.base.ViewBase;
	import jing.ui.yrtlib.compment.base.CompmentView;

	/**
	 * 滚动条
	 * @author jing
	 *
	 */
	public class VScrollBar extends CompmentView
	{
		/**
		 * 向上滚动的按钮
		 */
		private var _btnArrowUp:ButtonStatus2=null;

		/**
		 * 向下滚动的按钮
		 */
		private var _btnArrowDown:ButtonStatus2=null;

		/**
		 * 中间的滑动条
		 */
		private var _btnDrag:ButtonDrag=null;

		/**
		 * 滑动条的背景
		 */
		private var _dragBG:DisplayObject=null;


		/**
		 * 通过滚动条管理的视图
		 */
		private var _view:ViewBase=null;

		/**
		 * 视图的滚动区域
		 */
		private var _scrollRect:Rectangle=null;

		private var _btnDragMinSize:Number=20;

		/**
		 * 滑动条最小高度 (在构造函数会赋值为滑块的正常大小)
		 */
		public function get btnDragMinSize():Number
		{
			return _btnDragMinSize;
		}

		/**
		 * @private
		 */
		public function set btnDragMinSize(value:Number):void
		{
			_btnDragMinSize=value;
		}


		/**
		 *
		 * @param gui 滚动条的GUI
		 *
		 */
		public function VScrollBar(gui:DisplayObject)
		{
			super(gui);
			init();
		}

		private function init():void
		{
			_btnArrowUp=new ButtonStatus2(getChildByName("btnArrowUp"));
			_btnArrowDown=new ButtonStatus2(getChildByName("btnArrowDown"));
			_btnDrag=new ButtonDrag(getChildByName("btnDrag"));
			_dragBG=getChildByName("dragBG");

			_btnDragMinSize=_dragBG.height;
			_scrollRect=new Rectangle();
		}


		override public function addListeners():void
		{
			removeListeners();

			_btnDrag.addEventListener(MouseEvent.MOUSE_DOWN, _btnDrag_mouseDownHandler);
			_btnArrowDown.addEventListener(MouseEvent.CLICK, _btnArrowDown_clickHandler);
			_btnArrowUp.addEventListener(MouseEvent.CLICK, _btnArrowUp_clickHandler);
			_dragBG.addEventListener(MouseEvent.CLICK, _dragBG_clickHandler);

			_view.addEventListener(ViewBaseEvent.CLOSED, _view_closedHandler);
		}

		override public function removeListeners():void
		{
			_btnDrag.removeEventListener(MouseEvent.MOUSE_DOWN, _btnDrag_mouseDownHandler);
			_btnArrowDown.removeEventListener(MouseEvent.CLICK, _btnArrowDown_clickHandler);
			_btnArrowUp.removeEventListener(MouseEvent.CLICK, _btnArrowUp_clickHandler);
			_dragBG.removeEventListener(MouseEvent.CLICK, _dragBG_clickHandler);

			if (null != _btnDrag.gui.stage)
			{
				_btnDrag.gui.removeEventListener(Event.ENTER_FRAME, _btnDrag_enterFrameHandler);
				_btnDrag.gui.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}

			_view.removeEventListener(ViewBaseEvent.CLOSED, _view_closedHandler);
		}

		override public function destroy():void
		{
			_view.removeEventListener(ViewBaseEvent.SHOWED, _view_showedHandler);
			super.destroy();
		}

		private function _view_showedHandler(e:Event):void
		{
			this.show(_view.gui.parent);
			updateUI();
		}

		private function _view_closedHandler(e:Event):void
		{
			this.close();
		}

		private function _dragBG_clickHandler(e:MouseEvent):void
		{
			var pos:Number=_gui.mouseY - (_btnDrag.height >> 1);
			scrollBarToPos(pos);
		}

		/**
		 * 点击按钮时滚动的屏幕的值
		 */
		private const SCROLL_VIEW_PERCENT_WHEN_CLICK:Number=0.2;

		/**
		 * 向下滚动点击，则让视图向下滚动2/3屏幕
		 * @param e
		 *
		 */
		private function _btnArrowDown_clickHandler(e:MouseEvent):void
		{
			var posY:Number=_scrollRect.y + (_scrollRect.height * SCROLL_VIEW_PERCENT_WHEN_CLICK);
			scrollViewToPos(posY);
		}

		/**
		 * 点击向上滚动，则让视图向上滚动一屏幕
		 * @param e
		 *
		 */
		private function _btnArrowUp_clickHandler(e:MouseEvent):void
		{
			var posY:Number=_scrollRect.y - (_scrollRect.height * SCROLL_VIEW_PERCENT_WHEN_CLICK);
			scrollViewToPos(posY);
		}

		/**
		 * 鼠标点下时拖动条的中心点和鼠标的Y轴距离
		 */
		private var _dragOffY:Number=0;

		private function _btnDrag_mouseDownHandler(e:MouseEvent):void
		{
			_btnDrag.gui.addEventListener(Event.ENTER_FRAME, _btnDrag_enterFrameHandler);
			_btnDrag.gui.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);

			//记录鼠标和滑动条的偏移值
			_dragOffY=_gui.mouseY - _btnDrag.y;
		}

		private function _btnDrag_enterFrameHandler(e:Event):void
		{
			//预算滑动条的位置
			var dragY:Number=_gui.mouseY - _dragOffY;
//			trace(dragY);
			scrollBarToPos(dragY);
		}

		private function stage_mouseUpHandler(e:MouseEvent):void
		{
			_btnDrag.gui.removeEventListener(Event.ENTER_FRAME, _btnDrag_enterFrameHandler);
			_btnDrag.gui.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}

		/**
		 * 得到滑动区域的高度(该区域包括了滑块的部分)
		 * 这里返回的是向上滚动按钮和向下滚动按钮之间的距离
		 * @return
		 *
		 */
		private function getDragRectHeight():Number
		{
			return _btnArrowDown.y - (_btnArrowUp.y + _btnArrowUp.height);
		}

		/**
		 * 得到当前滑动块在滑动区域中的位置
		 * @return
		 *
		 */
		private function getCurrentDragPos():Number
		{
			return _btnDrag.y - (_btnArrowUp.y + _btnArrowUp.height);
		}

		/**
		 * 滚动到百分比位置，这个数值是滚动条和视图公用的，所以两者都会产生改变
		 * @param k 数值为0.00~1.00表示0%到100%
		 *
		 */
		public function scrollToPercent(k:Number):void
		{
			//保证K值不超出范围
			if (k < 0)
			{
				k=0;
			}
			else if (k > 1)
			{
				k=1;
			}

			//视图的可是范围位置
			var scrollY:Number=k * (_viewRealH - _scrollRect.height);
			//同步滚动区域到视图
			_scrollRect.x=_view.scrollRect.x;
			_scrollRect.y=scrollY;
			_view.scrollRect=_scrollRect;

			//滑动条的位置
			var dragY:Number=k * (getDragRectHeight() - _btnDrag.height);
			_btnDrag.y=_btnArrowUp.y + _btnArrowUp.height + dragY;
		}

		/**
		 * 滚动视图的可视范围到Y位置,数据会影响到滚动条的位置
		 * @param posY
		 *
		 */
		public function scrollViewToPos(posY:Number):void
		{	
			//如果真实高度比设置的可视区域低，则直接滚动到0位置
			if(_viewRealH <= _scrollRect.height)
			{
				scrollToPercent(0);
				return;
			}
			
			//计算posY在视图中的位置的百分比
			var k:Number=posY / (_viewRealH - _scrollRect.height);
			scrollToPercent(k);
		}

		/**
		 * 滚动滚动条到Y位置,数据会影响到视图的可视范围
		 * @param posY
		 *
		 */
		private function scrollBarToPos(posY:Number):void
		{
			//如果真实高度比设置的可视区域低，则直接滚动到0位置
			if(_viewRealH <= _scrollRect.height)
			{
				scrollToPercent(0);
				return;
			}
			
			//计算posY在滚动条中的位置的百分比
			var k:Number=(posY - (_btnArrowUp.y + _btnArrowUp.height)) / (getDragRectHeight() - _btnDrag.height);
			scrollToPercent(k);
		}

		/**
		 *是否让滚动条显示在view的右边并且高度和view一样
		 */
		private var _isBindPosition:Boolean=true;

		/**
		 *
		 * @param view 实现了IScrollView接口的ViewBase对象
		 * @param scrollW 滚动区域的宽度
		 * @param scrollH 滚动区域的高度
		 * @param isBindPosition 是否让滚动条显示在view的右边并且高度和view一样
		 *
		 */
		public function bindScrollView(view:ViewBase, scrollW:Number, scrollH:Number, isBindPosition:Boolean=true):void
		{
			_view=view;
			_viewRealW=_view.width;
			_viewRealH=_view.height;
			_isBindPosition=isBindPosition;
			_scrollRect.width=scrollW;
			_scrollRect.height=scrollH;

			//这个事件单独监听，只有在对象被销毁时才移除
			_view.addEventListener(ViewBaseEvent.SHOWED, _view_showedHandler);

			addListeners();
			updateUI();
		}

		public function setScrollW(w:Number):void
		{
			_scrollRect.width=w;
			updateUI();
		}

		public function setScrollH(h:Number):void
		{
			_scrollRect.height=h;
			updateUI();
		}
		
		public function getScrollW():Number
		{
			return _scrollRect.width;
		}
		
		public function getScrollH():Number
		{
			return _scrollRect.height;
		}

		/**
		 * 视图的真实宽度
		 */
		private var _viewRealW:Number=0;

		public function get viewRealW():Number
		{
			return _viewRealW;
		}

		/**
		 * 视图的真实高度
		 */
		private var _viewRealH:Number=0;

		public function get viewRealH():Number
		{
			return _viewRealH;
		}

		/**
		 * 设置视图的真实宽度
		 * @param w
		 *
		 */
		public function setViewRealW(w:Number):void
		{
			_viewRealW=w;
//			updateUI();
		}

		/**
		 * 设置视图的真实高度
		 * @param h
		 *
		 */
		public function setViewRealH(h:Number):void
		{
			_viewRealH=h;
			updateUI();
		}

		/**
		 * 更新scrollBar的UI界面
		 *
		 */
		private function updateUI():void
		{
			if (true == _isBindPosition)
			{
				//定位滚动条
				this.x=_view.x + _scrollRect.width;
				this.y=_view.y;

				//确定滚动条的大小,宽度默认即可		
				_btnArrowDown.y=_scrollRect.height - _btnArrowDown.height;
				_dragBG.height=_btnArrowDown.y - _btnArrowUp.height;
				_btnDrag.y=_dragBG.y;

				//计算拖拽条的比例
				updateDragSize();

				_view.scrollRect=_scrollRect;
				scrollViewToPos(_scrollRect.y);
			}
		}

		/**
		 * 更新拖拽条大小
		 *
		 */
		private function updateDragSize():void
		{
			//这里只用到高度，所以只算高度
			var k:Number=_scrollRect.height / _viewRealH;

			//如果可视区域大于，则不显示拖拽条
			if (k >= 1)
			{
				_btnDrag.visible=false;
			}
			else
			{
				_btnDrag.visible=true;
				//计算出drag按钮的高度
				_btnDrag.height=k * _dragBG.height;
				if (_btnDrag.height < _btnDragMinSize)
				{
					_btnDrag.height=_btnDragMinSize;
				}
			}
		}

	}
}
