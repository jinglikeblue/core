package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.events.ModelEvent;
	import jing.ui.yrtlib.compment.model.RangeModel;
	
	/**
	 * 老翟做的滚动条 
	 * @author jing
	 * 
	 */	
	public class ModelScrollBarZHY extends CompmentView
	{
		protected var _model:RangeModel = null;
		
		public function get model():RangeModel
		{
			return _model;
		}
		
		protected var _btnDrag:ZHYSprite = null;
		
		protected var _dragBG:ZHYSprite = null;
		
		/**
		 * 拖条的最小高度 
		 */		
		protected var _btnDragMinSize:Number = 0;
		
		public function ModelScrollBarZHY(gui:DisplayObject)
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
			_dragBG.height = h;
			draw();
		}
		
		override public function draw():void
		{			
			_dragBG.y = 0;
			_dragBG.x = 0;
			_btnDrag.x =(_dragBG.width - _btnDrag.width) >> 1;
			updateDrag();
			
		}
		
		protected function updateDrag():void
		{
			if(null == _model)
			{
				return;
			}
			
			//滑条的高度和忽略的拖动范围的高度等比
			var k:Number = 0;
			
			if(_model.max == 0)
			{
				k = 0;
			}
			else
			{
				k = _model.extent / _model.max;
			}
			var dragHeight:Number = k * _dragBG.height;

			if(dragHeight < _btnDragMinSize)
			{
				dragHeight = _btnDragMinSize;
			}
			
			if(dragHeight >= _dragBG.height || _model.max <= _model.extent)
			{
				_dragBG.visible = _btnDrag.visible = false;
			}
			else
			{
				_dragBG.visible = _btnDrag.visible = true;
				//定位btnDrag的位置
				var dragY:Number = (_model.value / (_model.max - _model.extent)) * (_dragBG.height - _btnDrag.height);
				_btnDrag.y = dragY;
			}
			
			_btnDrag.height = dragHeight;
		}
		
		private function init():void
		{
			_btnDrag = new ZHYSprite(getChildByName("btnDrag"));
			_dragBG = new ZHYSprite(getChildByName("dragBG"));
			
			_btnDragMinSize = 30;
			
			var height:int = _gui.height;
			_gui.scaleY = 1;
			this.height = height;
		}
		
		override public function addListeners():void
		{
			_btnDrag.addEventListener(MouseEvent.MOUSE_DOWN, _btnDrag_mouseDownHandler);
			_dragBG.addEventListener(MouseEvent.CLICK, _dragBG_clickHandler);
		}
		
		override public function removeListeners():void
		{
			_btnDrag.removeEventListener(MouseEvent.MOUSE_DOWN, _btnDrag_mouseDownHandler);
			_dragBG.removeEventListener(MouseEvent.CLICK, _dragBG_clickHandler);
			
			if (null != _btnDrag.gui.stage)
			{
				_btnDrag.gui.removeEventListener(Event.ENTER_FRAME, stage_mouseMoveHandler);
				_btnDrag.gui.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
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

			changeModelValueByPos(dragY);
		}
		
		private function changeModelValueByPos(posY:Number):void
		{
			//算出该值在滚动条区域中的位置比
			var k:Number = posY / (_dragBG.height - _btnDrag.height);
			
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
			
		}
	}
	
}
import flash.display.DisplayObject;
import flash.display.Sprite;

import jing.framework.core.view.base.ViewBase;

class ZHYSprite extends ViewBase
{
	private var _top:Sprite = null;
	private var _middle:Sprite = null;
	private var _bottom:Sprite = null;
	
	public function ZHYSprite(gui:DisplayObject)
	{
		super(gui);
		init();
	}
	
	private function init():void
	{
		_top = getChildByName("top") as Sprite;
		_middle = getChildByName("middle") as Sprite;
		_bottom = getChildByName("bottom") as Sprite;
	}
	
	override public function set height(h:Number):void
	{
		_middle.height = h - _top.height - _bottom.height;
		_bottom.y = _middle.y + _middle.height;
	}
}