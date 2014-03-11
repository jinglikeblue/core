package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jing.framework.manager.sound.SoundManager;
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.utils.img.ColorMatrixFilterUtil;


	/**
	 * 只有两种状态的按钮：普通状态和鼠标按下状态
	 * @author Owen
	 */
	public class ButtonStatus2 extends CompmentView
	{
		private var _skin:MovieClip;
		/**
		 * 是否可用
		 */
		private var _enable:Boolean=true;

		private var _clickSound:String="bs001";

		public function setClickSound(value:String):void
		{
			_clickSound=value;
		}

		public function getClickSound():String
		{
			return _clickSound;
		}

		public function ButtonStatus2(gui:DisplayObject)
		{
			super(gui);
			initUI();
			addListeners();
		}

		private function initUI():void
		{
			_skin=_gui as MovieClip;
			_skin.gotoAndStop(1);
		}

		override public function addListeners():void
		{
			_skin.addEventListener(MouseEvent.ROLL_OVER, skin_rollOverHandler);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, skin_mouseDownHandler);
			_skin.addEventListener(MouseEvent.CLICK, skin_clickHandler);
		}

		override public function removeListeners():void
		{
			_skin.removeEventListener(MouseEvent.ROLL_OVER, skin_rollOverHandler);
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN, skin_mouseDownHandler);
			_skin.removeEventListener(MouseEvent.CLICK, skin_clickHandler);
		}

		private function skin_rollOverHandler(event:MouseEvent):void
		{
			if (!_enable)
				return;
			_skin.addEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
			_skin.removeEventListener(MouseEvent.MOUSE_UP, skin_mouseUpHandler);
			_skin.gotoAndStop(2);
		}

		private function skin_rollOutHandler(event:MouseEvent):void
		{
			if (!_enable)
				return;
			_skin.removeEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
			_skin.gotoAndStop(1);
		}

		private function skin_mouseDownHandler(event:MouseEvent):void
		{
			if (!_enable)
				return;
			_skin.addEventListener(MouseEvent.MOUSE_UP, skin_mouseUpHandler);
//			_skin.addEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
			_skin.gotoAndStop(1);
		}

		private function skin_mouseUpHandler(event:MouseEvent):void
		{
			if (!_enable)
				return;
			_skin.removeEventListener(MouseEvent.MOUSE_UP, skin_mouseUpHandler);
//			_skin.removeEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
			_skin.gotoAndStop(2);
		}

		private function skin_clickHandler(event:MouseEvent):void
		{
			if (!_enable)
				return;
//			_skin.addEventListener(Event.ENTER_FRAME, nextFrameHandler);

			if (_clickSound != null)
			{
				SoundManager.playEffect(_clickSound);
			}
		}

		/**
		 * 点击后的一帧执行
		 * @param event
		 */
		private function nextFrameHandler(event:Event):void
		{
			_skin.removeEventListener(Event.ENTER_FRAME, nextFrameHandler);
		}

		/**
		 * 设置可用
		 * @param boo
		 */
		public function set enable(boo:Boolean):void
		{
			_enable=boo;
			if (_enable)
			{
				this.mouseChildren=true;
				this.mouseEnabled=true;
				_skin.gotoAndStop(1);
				_skin.filters=null;
			}
			else
			{
				this.mouseChildren=false;
				this.mouseEnabled=false;
				_skin.gotoAndStop(1);
				_skin.filters=[ColorMatrixFilterUtil.getBlackWhiteFilter()];
			}
		}

		/**
		 * 获取可用
		 * @return
		 */
		public function get enable():Boolean
		{
			return _enable;
		}

		public function getCurrentFrame():int
		{
			return _skin.currentFrame;
		}

	}
}
