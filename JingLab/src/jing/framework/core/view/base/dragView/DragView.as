package jing.framework.core.view.base.dragView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.framework.manager.stage.StageManager;

	/**
	 * 在ViewBase的基础上实现了拖拽功能
	 * @author Owen
	 */	
	public class DragView extends ViewBase
	{
		/**
		 * 拖拽部分
		 */
		private var _dragTitle:DisplayObject;
		/**
		 * 
		 * @param gui
		 * @param dragTile拖拽对象在gui中的命名
		 */
		public function DragView(gui:DisplayObject, dragTitle:String = "dragTitle")
		{
			super(gui);
			setDragTitle(_gui[dragTitle] as DisplayObject);
		}
		/**
		 * 设置拖拽条
		 * @param dragTitle
		 */
		public function setDragTitle(dragTitle:DisplayObject):void
		{
			_dragTitle = dragTitle;
		}
		//拖拽实现--------------------------------------------------------------------------------------------------------------
		private function _dragTitle_mouseDownHandler(e:MouseEvent):void
		{
			if(null == _dragStartGUIPoint)
			{
				_dragStartGUIPoint = new Point();				
			}
			if(null == _dragStartMousePoint)
			{
				_dragStartMousePoint = new Point();
			}
			
			startDrag();
		}
		//拖动开始时元件
		private var _dragStartGUIPoint:Point = null;
		//拖动开始时鼠标的位置
		private var _dragStartMousePoint:Point = null;
		private var dragCacheImg:Bitmap = new Bitmap();
		/**
		 * 开始拖动边框元件 
		 * 
		 */		
		private function startDrag():void
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
		 */
		private function stopDrag():void
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
		private function stage_mouseUpHandler(e:MouseEvent):void
		{
			stopDrag();
		}
		private function stage_enterFrameHandler(e:Event):void
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
			if(dragCacheImg.x <= 0)
			{
				dragCacheImg.x = 0;
			}
			if(dragCacheImg.x >= StageManager.stage.stageWidth - dragCacheImg.width)
			{
				dragCacheImg.x = StageManager.stage.stageWidth - dragCacheImg.width;
			}
			if(dragCacheImg.y <= 0)
			{
				dragCacheImg.y = 0;
			}
			if(dragCacheImg.y >= StageManager.stage.stageHeight - dragCacheImg.height)
			{
				dragCacheImg.y = StageManager.stage.stageHeight - dragCacheImg.height;
			}
		}
		//拖拽实现完--------------------------------------------------------------------------------------------------------------
		
		override public function close():void
		{
			_dragTitle.removeEventListener(MouseEvent.MOUSE_DOWN, _dragTitle_mouseDownHandler);
			super.close();
		}
		
		override public function destroy():void
		{
			_dragTitle.removeEventListener(MouseEvent.MOUSE_DOWN, _dragTitle_mouseDownHandler);
			super.destroy();
		}
		/**
		 * 添加拖拽事件
		 */		
		public function addDragEventListener():void
		{
			_dragTitle.addEventListener(MouseEvent.MOUSE_DOWN, _dragTitle_mouseDownHandler);
		}
		/**
		 * 移除拖拽事件
		 */		
		public function removeDragEventListener():void
		{
			_dragTitle.removeEventListener(MouseEvent.MOUSE_DOWN, _dragTitle_mouseDownHandler);
		}
	}
}