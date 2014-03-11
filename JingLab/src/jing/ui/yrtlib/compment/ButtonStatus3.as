package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import jing.framework.manager.sound.SoundManager;
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.utils.img.ColorMatrixFilterUtil;

	/**
	 * 有不可用状态的按钮
	 * @author Owen
	 */	
	public class ButtonStatus3 extends CompmentView
	{
		/**
		 * 按钮状态:
		 * 值为1表示正常状态
		 * 值为2表示鼠标移上
		 * 值为3表示鼠标压下
		 */
		protected var _status:int;
		/**
		 * 是否可用
		 */		
		protected var _enable:Boolean = true;
		
		
		protected var _skin:MovieClip;
		
		protected var _clickSound:String = "bs001";
		
		public function setClickSound(value:String):void
		{
			_clickSound = value;
		}
		
		public function getClickSound():String
		{
			return _clickSound;
		}
		
		public function ButtonStatus3(gui:DisplayObject)
		{
			super(gui);
			initUI();
			addListeners();
		}
		
		private function initUI():void
		{
			_status = 1;
			_skin = _gui as MovieClip;
			_skin.buttonMode = true;
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
		
		protected function skin_rollOverHandler(event:MouseEvent):void
		{
			if(_status == 3)
			{
				return;
			}
			_skin.addEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
			_skin.removeEventListener(MouseEvent.MOUSE_UP, skin_mouseUpHandler);
			_status = 2;
			_skin.gotoAndStop(_status);
		}
		
		protected function skin_rollOutHandler(event:MouseEvent):void
		{
			_skin.removeEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
			_status = 1;
			_skin.gotoAndStop(_status);
		}
		
		protected function skin_mouseDownHandler(event:MouseEvent):void
		{
			_skin.addEventListener(MouseEvent.MOUSE_UP, skin_mouseUpHandler);
			_status = 3;
			_skin.gotoAndStop(_status);
		}
		
		protected function skin_mouseUpHandler(event:MouseEvent):void
		{
			_skin.addEventListener(MouseEvent.MOUSE_UP, skin_mouseUpHandler);
			_status = 2;
			_skin.gotoAndStop(_status);
		}
		
		protected function skin_clickHandler(event:MouseEvent):void
		{
			if(_clickSound != null)
			{
				SoundManager.playEffect(_clickSound);
			}
		}
		/**
		 * 设置可用
		 * @param boo
		 */		
		public function set enable(boo:Boolean):void
		{
			_enable = boo;
			if(_enable)
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
	}
}