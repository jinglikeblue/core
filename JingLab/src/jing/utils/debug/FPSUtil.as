package jing.utils.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 用来显示FPS
	 * @author jing
	 * @date 2010-11-09
	 */	
	public class FPSUtil
	{
		private var _textFPS:TextField = null;
		
		private var _fps:uint = 0;
		
		private var _timer:Timer = new Timer(1000,0);
		
		private var _isShowMemory:Boolean = true;
		
		public function FPSUtil():void
		{

		}
		
		/**
		 *  
		 * @param container 父显示对象
		 * @param isShowMemory 是否显示内存占用
		 * @param isGlow 是否发光文字（对于画面比较复杂的情况，建议开启）
		 * 
		 */		
		public function show(container:DisplayObjectContainer,isShowMemory:Boolean = true, isGlow:Boolean = false):void
		{
			if(_textFPS == null)
			{
				_isShowMemory = isShowMemory;
				_textFPS = new TextField();
				if(isGlow == true)
				{
					_textFPS.filters = [new GlowFilter(0xFFFFFF,1,2,2,15)];
				}
				_textFPS.autoSize = TextFieldAutoSize.LEFT;
				_textFPS.mouseEnabled = false;
				_textFPS.addEventListener(Event.ENTER_FRAME, _textFPS_enterFrameHandler);
				_timer.addEventListener(TimerEvent.TIMER, _timer_timerHandler);
				_timer.start();
				_fps = 0;
				container.addChild(_textFPS);				
			}			
		}
		
		public function close():void
		{
			if(_textFPS != null && _textFPS.parent != null)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _timer_timerHandler);
				_textFPS.removeEventListener(Event.ENTER_FRAME, _textFPS_enterFrameHandler);
				_textFPS.parent.removeChild(_textFPS);
				_textFPS = null;
			}
		}
		
		private function _textFPS_enterFrameHandler(e:Event):void
		{
			_fps++;		
		}
		
		private function _timer_timerHandler(e:TimerEvent):void
		{
			_textFPS.text = "FPS: " + _fps.toString();
			_fps = 0;
			if(true == _isShowMemory)
			{
				_textFPS.appendText("\n" + "Memory：" + (System.totalMemory / 1204 >> 0) + " K");
			}
			
			var childIndex:int = _textFPS.parent.getChildIndex(_textFPS);
			_textFPS.parent.swapChildrenAt(childIndex,_textFPS.parent.numChildren - 1);
		}
		

	}
}