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
	 * 选择按钮
	 * @author Owen
	 */
	public class ButtonSelect extends CompmentView
	{
		/** 按钮文本 */
		private var _labelTxt:TextField;
		/** 按钮文本内容 */
		private var _label:String;
		private var _buttonSkin:MovieClip;
		/** 是否可用 */
		private var _enable:Boolean=true;
		/** 不可以用状态帧 */
		private var _disenableFrame:int=-1;
		/** 是否已经被选择 */
		private var _selected:Boolean=false;
		/** 鼠标移上 */
		private var _mouseOverFrame:int=-1;
		/** 选中 */
		private var _selectedFrame:int=-1;
		/** 选中后鼠标移上 */
		private var _selectedMouseOverFrame:int=-1;

		private var _clickSound:String="bs001";

		public function setClickSound(value:String):void
		{
			_clickSound=value;
		}

		public function getClickSound():String
		{
			return _clickSound;
		}

		public function ButtonSelect(gui:DisplayObject, label:String = "")
		{
			super(gui);
			initUI(label);
			addListeners();
		}

		private function initUI(label:String):void
		{
			_label = label;
			if(_gui.hasOwnProperty("label"))
			{
				_labelTxt = _gui["label"] as TextField;
				_labelTxt.text = label;
				_labelTxt.mouseEnabled = false;
			}
//			if(_gui.hasOwnProperty("skin"))
//			{
//				_buttonSkin=_gui["skin"] as MovieClip;
//			}
//			else
//			{
				_buttonSkin=_gui as MovieClip;
//			}
			_disenableFrame=_buttonSkin.totalFrames;
			if (_buttonSkin.totalFrames == 2)
			{
				_mouseOverFrame=1;
			}
			if (_buttonSkin.totalFrames >= 3)
			{
				_mouseOverFrame=2;
			}
			if (_buttonSkin.totalFrames >= 4)
			{
				_selectedFrame=3;
				_selectedMouseOverFrame=4;
			}
			else
			{
				_selectedFrame=_buttonSkin.totalFrames;
			}
			_buttonSkin.gotoAndStop(1);
		}

		override public function addListeners():void
		{
			_gui.addEventListener(MouseEvent.CLICK, buttonSkin_clickHandler);
			_gui.addEventListener(MouseEvent.ROLL_OVER, buttonSkin_rollOverHandler);
			_gui.addEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
		}

		override public function removeListeners():void
		{
			_gui.removeEventListener(MouseEvent.CLICK, buttonSkin_clickHandler);
			_gui.removeEventListener(MouseEvent.ROLL_OVER, buttonSkin_rollOverHandler);
			_gui.removeEventListener(MouseEvent.ROLL_OUT, skin_rollOutHandler);
		}

		private function buttonSkin_rollOverHandler(event:MouseEvent):void
		{
			if (_selected)
			{
				if (_selectedMouseOverFrame != -1)
				{
					_buttonSkin.gotoAndStop(_selectedMouseOverFrame);
				}
			}
			else
			{
				if (_mouseOverFrame != -1)
				{
					_buttonSkin.gotoAndStop(_mouseOverFrame);
				}
			}
		}

		private function skin_rollOutHandler(event:MouseEvent):void
		{
			if (_selected)
			{
				if (_selectedMouseOverFrame != -1)
				{
					_buttonSkin.gotoAndStop(_selectedFrame);
				}
			}
			else
			{
				if (_mouseOverFrame != -1)
				{
					_buttonSkin.gotoAndStop(1);
				}
			}
		}

		protected function buttonSkin_clickHandler(event:MouseEvent):void
		{
			_selected=!_selected;
			if (_selected)
			{
				if (_selectedMouseOverFrame != -1)
				{
					_buttonSkin.gotoAndStop(_selectedMouseOverFrame);
				}
				else
				{
					_buttonSkin.gotoAndStop(_selectedFrame);
				}
			}
			else
			{
				if (_mouseOverFrame != -1)
				{
					_buttonSkin.gotoAndStop(_mouseOverFrame);
				}
				else
				{
					_buttonSkin.gotoAndStop(1);
				}
			}

			if (_clickSound != null)
			{
				SoundManager.playEffect(_clickSound);
			}
		}

		/**
		 * 获取当前状态
		 * @return
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (true == value)
			{
				setSelect();
			}
			else
			{
				cancelSelect();
			}
		}

		/**
		 * 取消选择
		 */
		public function cancelSelect():void
		{
			_selected=false;
			_buttonSkin.gotoAndStop(1);
		}

		/**
		 * 设置选择
		 */
		public function setSelect():void
		{
			_selected=true;
			_buttonSkin.gotoAndStop(_selectedFrame);
		}

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(boo:Boolean):void
		{
			_enable=boo;
			_buttonSkin.mouseEnabled=_enable;
			if (_enable)
			{
				this.mouseChildren=true;
				this.mouseEnabled=true;
				_buttonSkin.gotoAndStop(1);
				_buttonSkin.filters=null;
			}
			else
			{
				this.mouseChildren=false;
				this.mouseEnabled=false;
				_buttonSkin.gotoAndStop(1);
				_buttonSkin.filters=[ColorMatrixFilterUtil.getBlackWhiteFilter()];
			}
		}
		
		public function set label(value:String):void
		{
			_label = value;
			if(_labelTxt != null)
			{
				_labelTxt.text = value;
			}
		}
		
		public function get label():String
		{
			if(_labelTxt != null)
			{
				return _label;
			}
			return "";
		}
		/**
		 * 文本粗体
		 */
		public function setBold():void
		{
			if(_labelTxt == null)
			{
				return;
			}
			TextUtil.bold(_labelTxt);
		}
		/**
		 * 文本发光
		 * @param color
		 */
		public function setGlow(color:uint = 0):void
		{
			if(_labelTxt == null)
			{
				return;
			}
			TextUtil.glow(_labelTxt, color);
		}
	}
}
