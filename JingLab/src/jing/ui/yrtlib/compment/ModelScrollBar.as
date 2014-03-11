package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.events.ModelEvent;
	import jing.ui.yrtlib.compment.model.RangeModel;
	
	/**
	 * 滚动条,和数据模型绑定
	 * @author jing
	 * 
	 */	
	public class ModelScrollBar extends CompmentView
	{
		protected var _model:RangeModel = null;

		/**
		 * 向上滚动的按钮
		 */
		protected var _btnArrowUp:ViewBase=null;
		
		/**
		 * 向下滚动的按钮
		 */
		protected var _btnArrowDown:ViewBase=null;
		
		/**
		 * 中间的滑动条
		 */
		protected var _btnDrag:ViewBase=null;
		
		/**
		 * 滑动条的背景
		 */
		protected var _dragBG:DisplayObject=null;
		
		/**
		 * 拖条的最小高度 
		 */		
		protected var _btnDragMinSize:Number = 0;
	
		/**
		 * 数据模型 
		 */
		public function get model():RangeModel
		{
			return _model;
		}
		
		
		public function ModelScrollBar(gui:DisplayObject)
		{
			super(gui);
			init();
			addListeners();
		}
		
		public function setModel(model:RangeModel):void
		{
			_model = model;			
			_model.addEventListener(ModelEvent.STATE_CHANGED, _model_stateChangedHandler);
			draw();
		}
		
		private function _model_stateChangedHandler(e:ModelEvent):void
		{
			
			draw();
		}
		
		override public function destroy():void
		{
			_model.removeEventListener(ModelEvent.STATE_CHANGED, _model_stateChangedHandler);
			super.destroy();
		}
		
		
		
		override public function set height(h:Number):void
		{
			_dragBG.height = h - _btnArrowUp.height - _btnArrowDown.height;
			draw();
		}
		
		override public function draw():void
		{			
			//排列显示元件
			_dragBG.y = _btnArrowUp.height;			
			updateDrag();
			_btnArrowDown.y = _dragBG.y + _dragBG.height; 
		}
		
		protected function updateDrag():void
		{
			if(null == _model)
			{
				return;
			}
//			trace(_model.value);
			//滑条的高度和忽略的拖动范围的高度等比
			var k:Number = _model.extent / _model.max;
			_btnDrag.height = k * _dragBG.height;
			if(_btnDrag.height < _btnDragMinSize)
			{
				_btnDrag.height = _btnDragMinSize;
			}
			
			if(_btnDrag.height >= _dragBG.height)
			{
				_btnDrag.visible = false;
			}
			else
			{
				_btnDrag.visible = true;
				//定位btnDrag的位置
				var dragY:Number = (_model.value / (_model.max - _model.extent)) * (_dragBG.height - _btnDrag.height);
				dragY += _btnArrowUp.height;
				_btnDrag.y = dragY;
			}
		}
		
		private function init():void
		{		
			_btnArrowUp=createListButton(getChildByName("btnArrowUp"));
			_btnArrowDown=createListButton(getChildByName("btnArrowDown"));
			_btnDrag=createListButton(getChildByName("btnDrag"));
			_dragBG=getChildByName("dragBG");	
			_btnDrag.y = _dragBG.y;
			_btnDragMinSize = _btnDrag.height;
		}
		
		private function createListButton(obj:DisplayObject):ViewBase
		{
			if(obj is MovieClip)
			{
				if(2 == (obj as MovieClip).totalFrames)
				{
					return new ButtonStatus2(obj);
				}
				else if( 3 == (obj as MovieClip).totalFrames)
				{
					return new ButtonStatus3(obj);
				}
			}

			return new ViewBase(obj);
		
		}
		
		override public function addListeners():void
		{
			removeListeners();
			
			_btnDrag.addEventListener(MouseEvent.MOUSE_DOWN, _btnDrag_mouseDownHandler);
			_btnArrowDown.addEventListener(MouseEvent.CLICK, _btnArrowDown_clickHandler);
			_btnArrowUp.addEventListener(MouseEvent.CLICK, _btnArrowUp_clickHandler);
			_dragBG.addEventListener(MouseEvent.CLICK, _dragBG_clickHandler);
			
		}
		
		override public function removeListeners():void
		{
			_btnDrag.removeEventListener(MouseEvent.MOUSE_DOWN, _btnDrag_mouseDownHandler);
			_btnArrowDown.removeEventListener(MouseEvent.CLICK, _btnArrowDown_clickHandler);
			_btnArrowUp.removeEventListener(MouseEvent.CLICK, _btnArrowUp_clickHandler);
			_dragBG.removeEventListener(MouseEvent.CLICK, _dragBG_clickHandler);
			
			if (null != _btnDrag.gui.stage)
			{
				_btnDrag.gui.removeEventListener(Event.ENTER_FRAME, stage_mouseMoveHandler);
				_btnDrag.gui.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
		}

		/**
		 * 点击按钮时滚动的屏幕的值
		 */
		private const SCROLL_VIEW_PERCENT_WHEN_CLICK:Number = 0.5;
		
		/**
		 * 向下滚动点击，则让视图向下滚动2/3屏幕
		 * @param e
		 *
		 */
		private function _btnArrowDown_clickHandler(e:MouseEvent):void
		{
			var newValue:int = _model.value + (_model.extent * SCROLL_VIEW_PERCENT_WHEN_CLICK);
			if(_model.value == newValue)
			{
				_model.value += 1;
			}
			else
			{
				_model.value = newValue;
			}
		}
		
		/**
		 * 点击向上滚动，则让视图向上滚动一屏幕
		 * @param e
		 *
		 */
		private function _btnArrowUp_clickHandler(e:MouseEvent):void
		{
			var newValue:int = _model.value - (_model.extent * SCROLL_VIEW_PERCENT_WHEN_CLICK);
			if(_model.value == newValue)
			{
				_model.value -= 1;
			}
			else
			{
				_model.value = newValue;
			}
		}
		
		/**
		 * 鼠标点下时拖动条的中心点和鼠标的Y轴距离
		 */
		private var _dragOffY:Number=0;
		
		private function _btnDrag_mouseDownHandler(e:MouseEvent):void
		{
			_btnDrag.gui.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_btnDrag.gui.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);

			//记录鼠标和滑动条的偏移值
			_dragOffY = _gui.mouseY - _btnDrag.y;
		}
		
		private function stage_mouseMoveHandler(e:Event):void
		{
			//预算滑动条的位置
			var dragY:Number=_gui.mouseY - _dragOffY;
			//			trace(dragY);
//			scrollBarToPos(dragY);
//			_btnDrag.y = dragY;
			
			//算出该值在滚动条区域中的位置比
//			var k:Number = (dragY - _btnArrowUp.height) / (_dragBG.height - _btnDrag.height);
//			
//			_model.value = (_model.max -_model.extent) * k;
			changeModelValueByPos(dragY);
		}
		
		private function changeModelValueByPos(posY:Number):void
		{
			//算出该值在滚动条区域中的位置比
			var k:Number = (posY - _btnArrowUp.height) / (_dragBG.height - _btnDrag.height);

			_model.value = (_model.max -_model.extent) * k;
		}
			
		
		private function stage_mouseUpHandler(e:MouseEvent):void
		{
			_btnDrag.gui.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_btnDrag.gui.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			draw();
		}
		
		private function _dragBG_clickHandler(e:MouseEvent):void
		{
//			var pos:Number=_gui.mouseY - (_btnDrag.height >> 1);
//			scrollBarToPos(pos);
		}
	}
}