package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 有三种状态的按钮 加动画显示
	 * @author Owen
	 */
	public class ButtonStatus3Animation extends ButtonStatus3
	{
		/**
		 * 按钮状态:
		 * 值为1表示正常状态
		 * 值为2表示鼠标移上
		 * 值为3表示鼠标压下
		 * 值为4表示按钮动画状态，此状态可以接受点击
		 */
		
		public function ButtonStatus3Animation(gui:DisplayObject)
		{
			super(gui);	
		}
		
		override protected function skin_rollOverHandler(event:MouseEvent):void
		{
			if(_status == 4)
			{
				return;
			}
			super.skin_rollOverHandler(event);
		}
		
		override protected function skin_rollOutHandler(event:MouseEvent):void
		{
			if(_status == 4)
			{
				return;
			}
			super.skin_rollOutHandler(event);
		}
		
		override protected function skin_mouseDownHandler(event:MouseEvent):void
		{
			if(_status == 4)
			{
				return;
			}
			super.skin_mouseDownHandler(event);
		}
		
		override protected function skin_mouseUpHandler(event:MouseEvent):void
		{
			if(_status == 4)
			{
				return;
			}
			super.skin_mouseUpHandler(event);
		}
		
		override protected function skin_clickHandler(event:MouseEvent):void
		{
			super.skin_clickHandler(event);
			if(_status == 4)
			{
				removeEnterFrame();
				_status = 1;
				_skin.gotoAndStop(_status);
			}
		}
		
		override public function set enable(boo:Boolean):void
		{
			if(_status == 4)
			{
				removeEnterFrame();
				_status = 1;
				_skin.gotoAndStop(_status);
			}
			super.enable = boo;
		}
		/** 动画开始帧 */
		private var _animationStartFrame:int;
		/**
		 * 设置动画开始帧
		 * @param value
		 */
		public function set animationStartFrame(value:int):void
		{
			_animationStartFrame = value;
		}
		/** 动画结束帧 */
		private var _animationEndFrame:int;
		/**
		 * 设置动画结束帧
		 * @param value
		 */
		public function set animationEndFrame(value:int):void
		{
			_animationEndFrame = value;
		}
		
		private const CHANGE_PIC_FRAME:int = 10;
		/**
		 * 记录是否进入下一帧的标志
		 */
		private var _countFrame:int;
		/**
		 * 动画帧数
		 * 多少帧变化一次
		 */
		private const ANIMATION_FRAME_COUNT:int = 5;
		
		public function playAnimation():void
		{
			if(!_enable)
			{
				return;
			}
			_status = 4;
			_countFrame = 0;
			_skin.gotoAndStop(_animationStartFrame);
			_skin.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		/**
		 * 每帧执行
		 * @param event
		 */
		private function enterFrameHandler(event:Event):void
		{
			if(_countFrame < ANIMATION_FRAME_COUNT)
			{
				_countFrame++;
				return;
			}
			_countFrame = 0;
			if(_skin.currentFrame < _animationEndFrame)
			{
				_skin.gotoAndStop(_skin.currentFrame + 1);
			}
			else
			{
				_skin.gotoAndStop(_animationStartFrame);
			}
		}
		/**
		 * 取消播放动画
		 */
		public function cancelPlayAnimation():void
		{
			if(_status == 4)
			{
				removeEnterFrame();
				_status = 1;
				_skin.gotoAndStop(_status);
			}
		}
		
		private function removeEnterFrame():void
		{
			if(_skin.hasEventListener(Event.ENTER_FRAME))
			{
				_skin.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		override public function close():void
		{
			removeEnterFrame();
			super.close();
		}
		
		override public function destroy():void
		{
			removeEnterFrame();
			super.destroy();
		}
	}
}