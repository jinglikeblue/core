package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import jing.framework.manager.sound.SoundManager;
	import jing.ui.yrtlib.compment.base.CompmentView;
	import jing.utils.display.TextUtil;
	import jing.utils.img.ColorMatrixFilterUtil;

	/**
	 * 忍影堂按钮组件
	 * @author Owen
	 */
	public class Button extends CompmentView
	{
		/** 按钮文本内容 */
		protected var _label:String;
		/** 按钮文本 */
		protected var _labelTxt:TextField;

		public function get labelTxt():TextField
		{
			return _labelTxt;
		}

		/** 按钮影片剪辑 */
		protected var _buttonMc:MovieClip;
		/** 普通状态 */
		private var _normalFrame:int;
		/** 鼠标移上状态 */
		private var _mouseOverFrame:int;
		/** 鼠标压下状态 */
		private var _mouseDownFrame:int;

		protected var _enable:Boolean;

		protected var _clickSound:String="bs001";

//		private var _lable:TextField;
//		private var _lableX:int;
//		private var _lableY:int;
//		private var _lableOffsetX:int;
//		private var _lableOffsetY:int;

		public function setClickSound(value:String):void
		{
			_clickSound=value;
		}

		public function getClickSound():String
		{
			return _clickSound;
		}

		public function Button(gui:DisplayObject, label:String=null)
		{
			super(gui);
			initUI(label);
			addListeners();
		}

		private function initUI(label:String):void
		{
			_enable=true;
			if (_gui.hasOwnProperty("label"))
			{
				_labelTxt=_gui["label"] as TextField;
				_label=label;
				if (label != null)
				{
					_labelTxt.text=label;
				}
				_labelTxt.mouseEnabled=false;
			}
//			if(_gui.hasOwnProperty("skin"))
//			{
//				_buttonMc = _gui["skin"] as MovieClip;
//			}
//			else
//			{
			_buttonMc=_gui as MovieClip;
//			}
			var totalFrames:int=_buttonMc.totalFrames;
			_normalFrame=1;
			_mouseOverFrame=2;
			if (totalFrames == 1)
			{
				_mouseOverFrame=1;
				_mouseDownFrame=1;
			}
			else if (totalFrames == 2)
			{
				_mouseDownFrame=1;
			}
			else if (totalFrames == 3)
			{
				_mouseDownFrame=3;
			}
			_buttonMc.gotoAndStop(_normalFrame);

		}

		override public function addListeners():void
		{
			_buttonMc.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_buttonMc.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_buttonMc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_buttonMc.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_buttonMc.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		override public function removeListeners():void
		{
			_buttonMc.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_buttonMc.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_buttonMc.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_buttonMc.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_buttonMc.removeEventListener(MouseEvent.CLICK, clickHandler);
		}

		/**
		 * 鼠标移上
		 * @param event
		 */
		protected function rollOverHandler(event:MouseEvent):void
		{
			if (_enable)
			{
				if (_mouseOverFrame > 1)
				{
					_buttonMc.gotoAndStop(_mouseOverFrame);
				}
				else
				{
					_buttonMc.filters=[ColorMatrixFilterUtil.getHighlightFilter()];
				}

				if (1 == _buttonMc.totalFrames && _labelTxt != null)
				{
					setUnderline(true);
				}
			}
		}

		public function flash():void
		{
			_buttonMc.play();
		}

		/**
		 * 鼠标移出
		 * @param event
		 */
		protected function rollOutHandler(event:MouseEvent):void
		{
			if (_enable)
			{
				_buttonMc.gotoAndStop(_normalFrame);
				_buttonMc.filters=null;

				if (1 == _buttonMc.totalFrames && _labelTxt != null)
				{
					setUnderline(false);
				}
			}
		}

		/**
		 * 鼠标压下
		 * @param event
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if (_enable)
			{
				_buttonMc.gotoAndStop(_mouseDownFrame);
			}
		}

		/**
		 * 鼠标抬起
		 * @param event
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (_enable)
			{
				_buttonMc.gotoAndStop(_mouseOverFrame);
			}
		}

		protected function clickHandler(event:MouseEvent):void
		{
			if (_clickSound != null)
			{
				SoundManager.playEffect(_clickSound);
			}
		}

		/**
		 * 设置文本内容
		 * @param str
		 */
		public function set label(str:String):void
		{
			_label=str;
			if (_labelTxt != null)
			{
				_labelTxt.htmlText=_label;
			}
		}

		/**
		 * 获取文本内容
		 * @return
		 */
		public function get label():String
		{
			if (_labelTxt != null)
			{
				return _label;
			}
			return "";
		}

		/**
		 * 设置可用
		 * @param boo
		 */
		public function set enable(boo:Boolean):void
		{
			_enable=boo;
			this.mouseChildren=_enable;
			this.mouseEnabled=_enable;
			_buttonMc.gotoAndStop(1);
			if (_enable)
			{
				_buttonMc.filters=null;
			}
			else
			{
				_buttonMc.filters=[ColorMatrixFilterUtil.getBlackWhiteFilter()];
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

		/**
		 * 设置文本颜色
		 * @param color
		 *
		 */
		public function set labelColor(color:uint):void
		{
			_labelTxt.textColor=color;
		}

		/**
		 * 文本粗体
		 */
		public function setBold(b:Boolean=true):void
		{
			if (_labelTxt == null)
			{
				return;
			}
			TextUtil.bold(_labelTxt, b);
		}

		/**
		 * 文本发光
		 * @param color
		 */
		public function setGlow(color:uint=0):void
		{
			if (_labelTxt == null)
			{
				return;
			}
			TextUtil.glow(_labelTxt, color);
		}

		/**
		 * 使用下滑线
		 *
		 */
		public function setUnderline(b:Boolean=true):void
		{
			if (_labelTxt == null)
			{
				return;
			}
			TextUtil.underline(_labelTxt, b);
		}
	}
}
