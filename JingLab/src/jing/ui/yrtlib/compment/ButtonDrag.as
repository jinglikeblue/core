package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.framework.manager.stage.StageManager;

	/**
	 * 拖拽按钮
	 * {使用在滚动条的拖拽按钮，鼠标压下拖拽保持效果}
	 * @author Owen
	 */
	public class ButtonDrag extends ViewBase
	{
		private var _buttonSkin:MovieClip;
		
		private var _totalFrames:int;
		private var _mouseOverFrame:int;
		private var _mouseDownFrame:int;
		private var _mouseOutFrame:int;
		
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		public function ButtonDrag(gui:DisplayObject)
		{
			super(gui);
			initUI();
			addListeners();
		}
		
		private function initUI():void
		{
			_buttonSkin = gui as MovieClip;
			_totalFrames = _buttonSkin.totalFrames;
			_mouseOutFrame = 1;
			_mouseOverFrame = 2;
			_mouseDownFrame = _totalFrames;
			_buttonSkin.gotoAndStop(_mouseOutFrame);
		}
		
		override public function addListeners():void
		{
			_buttonSkin.addEventListener(MouseEvent.MOUSE_OVER, buttonSkin_mouseOverHandler);
			_buttonSkin.addEventListener(MouseEvent.MOUSE_OUT, buttonSkin_mouseOutHandler);
			_buttonSkin.addEventListener(MouseEvent.MOUSE_DOWN, buttonSkin_mouseDownHandler);
		}
		
		override public function removeListeners():void
		{
			_buttonSkin.removeEventListener(MouseEvent.MOUSE_OVER, buttonSkin_mouseOverHandler);
			_buttonSkin.removeEventListener(MouseEvent.MOUSE_OUT, buttonSkin_mouseOutHandler);
			_buttonSkin.removeEventListener(MouseEvent.MOUSE_DOWN, buttonSkin_mouseDownHandler);
		}
		
		private function buttonSkin_mouseOverHandler(event:MouseEvent):void
		{
			_isMouseOver = true;
			if(_isMouseDown)
			{
				return;
			}
			_buttonSkin.gotoAndStop(_mouseOverFrame);
		}
		
		private function buttonSkin_mouseOutHandler(event:MouseEvent):void
		{
			_isMouseOver = false;
			if(_isMouseDown)
			{
				return;
			}
			_buttonSkin.gotoAndStop(_mouseOutFrame);
		}
		
		private function buttonSkin_mouseDownHandler(event:MouseEvent):void
		{
			_isMouseDown = true;
			_buttonSkin.gotoAndStop(_mouseDownFrame);
			StageManager.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			_isMouseDown = false;
			if(_isMouseOver)
			{
				_buttonSkin.gotoAndStop(_mouseOverFrame);
			}
			else
			{
				_buttonSkin.gotoAndStop(_mouseOutFrame);
			}
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
	}
}