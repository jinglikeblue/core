package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.ui.yrtlib.compment.events.ComplexButtonEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name = "ButtonDown",type = "jing.ui.yrtlib.compment.events.ComplexButtonEvent")]
	[Event(name = "ButtonClick",type = "jing.ui.yrtlib.compment.events.ComplexButtonEvent")]
	[Event(name = "ButtonDoubleClick",type = "jing.ui.yrtlib.compment.events.ComplexButtonEvent")]
	public class ComplexButton extends CompmentView
	{
		/**
		 * 鼠标弹起的次数 
		 */		
		private var _mouseUpCount:int = 0;
		
		/**
		 * 检查鼠标的计时器 
		 */		
		private var _checkTimer:Timer = null;
		
		/**
		 * 计时器检查的间隔 
		 */		
		private var _checkDelay:int = 350;
		
		/**
		 * 是否正在监听计数 
		 */		
		private var _isListening:Boolean = false;
		
		private var _shiftKey:Boolean  =false;
		
		private var _mouse:DisplayObject = null;
		
		public function ComplexButton(gui:DisplayObject, mouse:DisplayObject = null)
		{
			_mouse = mouse;
			_checkTimer = new Timer(_checkDelay,1);
			super(gui);
			
			initComplexButton();
		}
		
		private function initComplexButton():void
		{
			_checkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _checkTimer_timerCompleteHandler);
			if(null == _mouse)
			{
				_mouse = _gui;
			}
			_mouse.addEventListener(MouseEvent.MOUSE_UP, _gui_mouseUpHandler);
			_mouse.addEventListener(MouseEvent.MOUSE_DOWN, _gui_mouseDownHandler);
			_mouse.addEventListener(MouseEvent.ROLL_OUT, _gui_rollOutHandler);
		}
		
		private function _gui_mouseDownHandler(e:MouseEvent):void
		{
			_shiftKey = e.shiftKey;
			if(false == _checkTimer.running)
			{
				_mouseUpCount = 0;
				startListening();
			}
		}
		
		private function _gui_mouseUpHandler(e:MouseEvent):void
		{
			_shiftKey = e.shiftKey;
			if(true == _checkTimer.running)
			{
				_mouseUpCount++;
				if(_mouseUpCount >= 2)
				{
					checkClikType();
				}
			}
		}
		
		private function _gui_rollOutHandler(e:MouseEvent):void
		{
			_shiftKey = e.shiftKey;
			if(true == _checkTimer.running)
			{
				checkClikType();
			}
		}
		
		private function _checkTimer_timerCompleteHandler(e:TimerEvent):void
		{
			checkClikType();
		}
		
		private function startListening():void
		{
			_mouseUpCount = 0;
			_isListening = true;
			_checkTimer.start();			
		}
		
		private function stopListening():void
		{
			_checkTimer.stop();
			_isListening = false;
			_shiftKey = false;
			_mouseUpCount = 0;
		}
		
		protected function checkClikType():void
		{
			if(false == _isListening)
			{
				return;
			}
			
			var eventType:String;
			switch(_mouseUpCount)
			{
				case 0:
					//					trace("按下按钮");
					eventType = ComplexButtonEvent.BUTTON_DOWN;
					break;
				case 1:
					//					trace("单击按钮");
					eventType = ComplexButtonEvent.BUTTON_CLICK;
					break;
				case 2:
					//					trace("双击按钮");
					eventType = ComplexButtonEvent.BUTTON_DOUBLE_CLICK;
					break;
			}
			
			var cbe:ComplexButtonEvent = new ComplexButtonEvent(eventType);
			cbe.shiftKey = _shiftKey;
			this.dispatchEvent(cbe);
			
			stopListening();			
		}
		
		override public function destroy():void
		{
			_checkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _checkTimer_timerCompleteHandler);
			_mouse.removeEventListener(MouseEvent.MOUSE_UP, _gui_mouseUpHandler);
			_mouse.removeEventListener(MouseEvent.MOUSE_DOWN, _gui_mouseDownHandler);
			_mouse.addEventListener(MouseEvent.ROLL_OUT, _gui_rollOutHandler);
			super.destroy();
		}
	}
}