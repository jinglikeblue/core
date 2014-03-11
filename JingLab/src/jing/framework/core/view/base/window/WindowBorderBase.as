package jing.framework.core.view.base.window
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.framework.manager.stage.StageManager;
	import jing.utils.data.StringUtil;
	
	/**
	 * 承载窗口内容的框
	 * @author jing
	 * 
	 */	
	public class WindowBorderBase extends ViewBase
	{		

		protected var _father:WindowViewBase = null;
		
		protected var _title:String = null;

		/**
		 * 窗口的标题 
		 */
		public function get title():String
		{
			return _title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			_title = value;
			
			if(null == _txtTitle || null == value)
			{
				return;
			}
			
			_txtTitle.text = StringUtil.overLengthDeal(_title,10);
		}
		
		
		protected var _dragEnable:Boolean = false;

		/**
		 * 窗口是否允许拖动 
		 */
		public function get dragEnable():Boolean
		{
			return _dragEnable;
		}

		/**
		 * @private
		 */
		public function set dragEnable(value:Boolean):void
		{
			_dragEnable = value;
			
			if(null == _dragMC && null != _bgMC)
			{
				_dragMC = _bgMC;
			}
			
			if(null != _dragMC && true == _dragEnable)
			{
				addDragListeners();
			}	
		}
		
		
		
		protected var _borderGUI:DisplayObjectContainer = null;
		
		/**
		 * 得到边框的显示对象 
		 * @return 
		 * 
		 */		
		public function get borderGUI():DisplayObjectContainer
		{
			return _borderGUI;
		}
		
		protected var _contentGUI:DisplayObject = null;
		
		public function get contentGUI():DisplayObject
		{
			return _contentGUI;
		}
		
		protected var _marginTop:int = int.MAX_VALUE;

		/**
		 *  显示内容距离边框上边的距离
		 */
		public function get marginTop():int
		{
			return _marginTop;
		}

		/**
		 * @private
		 */
		public function set marginTop(value:int):void
		{
			_marginTop = value;
			if(int.MAX_VALUE == _marginTop)
			{
				_marginTop = 50;
			}
		}

		
		protected var _marginLeft:int = int.MAX_VALUE;

		/**
		 *  显示内容距离边框左边的距离
		 */
		public function get marginLeft():int
		{
			return _marginLeft;
		}

		/**
		 * @private
		 */
		public function set marginLeft(value:int):void
		{
			_marginLeft = value;
			if(int.MAX_VALUE == _marginLeft)
			{
				_marginLeft = 50;
			}
		}

		
		protected var _marginDown:int = int.MAX_VALUE;

		/**
		 *  显示内容距离边框下边的距离
		 */
		public function get marginDown():int
		{
			return _marginDown;
		}

		/**
		 * @private
		 */
		public function set marginDown(value:int):void
		{
			_marginDown = value;
			if(int.MAX_VALUE == _marginDown)
			{
				_marginDown = 50;
			}
		}

		
		protected var _marginRight:int = int.MAX_VALUE;

		/**
		 *  显示内容距离边框右边的距离
		 */
		public function get marginRight():int
		{
			return _marginRight;
		}

		/**
		 * @private
		 */
		public function set marginRight(value:int):void
		{
			_marginRight = value;
			if(int.MAX_VALUE == _marginRight)
			{
				_marginRight = 50;
			}
		}

		//背景显示元件
		protected var _bgMC:DisplayObject = null;
		//标题显示元件
		protected var _txtTitle:TextField = null;
		//拖动条显示元件
		protected var _dragMC:DisplayObject = null;
		
		public function WindowBorderBase(borderGUI:DisplayObjectContainer)
		{
			_borderGUI = borderGUI;
			super(borderGUI);
		}
		
		/**
		 * 添加内容UI 
		 * @param contentGUI
		 * 
		 */		
		internal function addContentGUI(contentGUI:DisplayObject,father:WindowViewBase):void
		{
			_contentGUI = contentGUI;
			_father = father;
			_bgMC = _borderGUI.getChildByName(BORDER_BG);
			_txtTitle = _borderGUI.getChildByName(BORDER_TITLE) as TextField;
			_dragMC = _borderGUI.getChildByName(BORDER_DRAG);
			initUI();

			
			_borderGUI.addChild(contentGUI);			

		}
		
		protected function initUI():void
		{			
			if(null != _bgMC)
			{
				_bgMC.width  = _contentGUI.width + _marginLeft + _marginRight;
				_bgMC.height = _contentGUI.height +  _marginTop + _marginDown;
				if(_dragMC != null)
				{
					_dragMC.width = _bgMC.width - (_dragMC.x << 1);
				}
			}
			
			if(null != _txtTitle)
			{
				_txtTitle.mouseEnabled = false;
				_txtTitle.autoSize = TextFieldAutoSize.LEFT;
				title = _title;
			}
			
			
			
			if(true == dragEnable)
			{
				addDragListeners();
			}			
			
			_contentGUI.x = _marginLeft;
			_contentGUI.y = _marginTop;
		}
		//拖动开始时元件
		private var _dragStartGUIPoint:Point = null;
		//拖动开始时鼠标的位置
		private var _dragStartMousePoint:Point = null;
		
		protected function addDragListeners():void
		{
			if(null == _dragStartGUIPoint)
			{
				_dragStartGUIPoint = new Point();				
			}
			if(null == _dragStartMousePoint)
			{
				_dragStartMousePoint = new Point();
			}
			
			if(null == _dragMC)
			{
				_dragMC = _bgMC;
			}
			
			_dragMC.addEventListener(MouseEvent.MOUSE_DOWN, _dragMC_mouseDownHandler);
		}		
		
		protected function _dragMC_mouseDownHandler(e:MouseEvent):void
		{			
			startDrag();
		}
		
		static protected var dragCacheImg:Bitmap = new Bitmap();
		
		/**
		 * 开始拖动边框元件 
		 * 
		 */		
		protected function startDrag():void
		{
			//高宽各一个像素主要是为了边框
			var bmd:BitmapData = new BitmapData(_gui.width + 1,_gui.height + 1,true,0);
			bmd.draw(_gui);
			dragCacheImg.bitmapData = bmd;
			dragCacheImg.x = _gui.x;
			dragCacheImg.y = _gui.y;
			_gui.parent.addChild(dragCacheImg);
			_gui.visible = false;
			
			
			_dragStartGUIPoint.x = _gui.x; 
			_dragStartGUIPoint.y = _gui.y;
			_dragStartMousePoint.x = StageManager.stage.mouseX;
			_dragStartMousePoint.y = StageManager.stage.mouseY;
			
			StageManager.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			StageManager.stage.addEventListener(Event.ENTER_FRAME,stage_enterFrameHandler);
		}
		
		/**
		 * 停止拖动边框元件 
		 * 
		 */		
		protected function stopDrag():void
		{
			_gui.x = dragCacheImg.x;
			_gui.y = dragCacheImg.y;
			dragCacheImg.parent.removeChild(dragCacheImg);
			dragCacheImg.bitmapData.dispose();
			dragCacheImg.bitmapData = null;
			_gui.visible = true;
			
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			StageManager.stage.removeEventListener(Event.ENTER_FRAME,stage_enterFrameHandler);
		}
		
		protected function stage_mouseUpHandler(e:MouseEvent):void
		{
			stopDrag();
		}
		
		protected function stage_enterFrameHandler(e:Event):void
		{			
			var stage:DisplayObjectContainer = StageManager.getStage();
			
			if(StageManager.stage.mouseX > StageManager.stage.stageWidth || StageManager.stage.mouseX < 0 || StageManager.stage.mouseY > StageManager.stage.stageHeight || StageManager.stage.mouseY < 0)
			{
				return;
			}
			
			var dx:int = stage.mouseX - _dragStartMousePoint.x;
			var dy:int = stage.mouseY - _dragStartMousePoint.y;
			dragCacheImg.x = _dragStartGUIPoint.x + dx;
			dragCacheImg.y = _dragStartGUIPoint.y + dy;
		}
		
		override public function destroy():void
		{
			stopDrag();
			_dragMC.removeEventListener(MouseEvent.MOUSE_DOWN, _dragMC_mouseDownHandler);
			super.destroy();
		}
		
		//------------------------------------------------------------
		static public const BORDER_BG:String = "bg"; 
		
		static public const BORDER_TITLE:String = "txtTitle";
		
		static public const BORDER_DRAG:String = "dragBar";
		
	}
}