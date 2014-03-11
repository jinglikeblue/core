package jing.framework.core.view.base.window
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import jing.framework.core.view.base.ViewBase;
	import jing.framework.core.events.ViewBaseEvent;

	/**
	 * 独立窗口显示界面
	 * @author jing
	 *
	 */
	public class WindowViewBase extends ViewBase
	{
		/**
		 * gui显示内容
		 */
		protected var _border:WindowBorderBase = null;

		/**
		 *
		 * @param gui显示内容
		 * @param border GUI边框对象
		 * @param marginTop 显示内容距离边框上边的距离
		 * @param marginLeft 显示内容距离边框左边的距离
		 * @param marginDown 显示内容距离边框下面的距离
		 * @param marginRight 显示内容距离边框右边的距离
		 *
		 */
		public function WindowViewBase(gui:DisplayObject, border:WindowBorderBase, marginTop:int = int.MAX_VALUE, marginLeft:int = int.MAX_VALUE, marginDown:int = int.MAX_VALUE, marginRight:int = int.MAX_VALUE)
		{
			_border = border;
			_border.marginTop = marginTop;
			_border.marginLeft = marginLeft;
			_border.marginDown = marginDown;
			_border.marginRight = marginRight;
			super(gui);
			initGUI();
		}

		protected function initGUI():void
		{
			_border.addContentGUI(_gui, this);
			//			var _bg:DisplayObject = null;
			//			if(_borderGUI is DisplayObjectContainer)
			//			{
			//				_bg = (_borderGUI as DisplayObjectContainer).getChildByName(BORDER_BG);
			//			}
			//			
			//			if(null == _bg)
			//			{
			//				_bg = _borderGUI;
			//			}
			//			
			//			_bg.width = _gui.width + _marginLeft + _marginRight;
			//			_bg.height = _gui.height + _marginTop + _marginDown;
		}

		override public function show(container:DisplayObjectContainer, x:int = int.MAX_VALUE, y:int = int.MAX_VALUE, modal:Boolean = false):void
		{
			if (null != container)
			{
				_border.show(container, x, y);
				this.dispatchEvent(new ViewBaseEvent(ViewBaseEvent.SHOWED));

				if (false == _syncDataAlways)
				{
					addListeners();
				}
			}
			setModal(modal, _border.borderGUI);

			//			if(int.MAX_VALUE != x)
			//			{
			//				_borderGUI.x = x;
			//				_gui.x = _borderGUI.x + _marginLeft;
			//			}
			//			
			//			if(int.MAX_VALUE != y)
			//			{
			//				_borderGUI.y = y;
			//				_gui.y = _borderGUI.y + _marginTop;
			//			}
		}

		override public function close():void
		{
			//			if(null != _gui.parent)
			//			{				
			//				_gui.parent.removeChild(_gui);
			//			}
			//			
			//			if(null != _borderGUI.parent)
			//			{
			//				_borderGUI.parent.removeChild(_borderGUI);
			//			}
			_border.close();
			this.dispatchEvent(new ViewBaseEvent(ViewBaseEvent.CLOSED));

			if (false == _syncDataAlways)
			{
				removeListeners();
			}
		}

		override public function destroy():void
		{
			close();
			removeListeners();
			_border.destroy();
			_gui = null;
			_border = null;
			this.dispatchEvent(new ViewBaseEvent(ViewBaseEvent.DESTROYED));
		}

		//---------------------------------------------------------------------------------------------
	}
}