package jing.framework.manager.camera
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * 摄像头 
	 * @author jing
	 * 
	 */	
	public class Camera
	{
		/**
		 * 相机绑定的显示对象 
		 */		
		private var _displayObject:DisplayObject = null;
		
		/**
		 * 相机的大小 
		 */		
		private var _cameraRect:Rectangle = null;
		
		private var _displayObjectWidth:Number = 0;
		private var _displayObjectHeight:Number = 0;
		
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		public function Camera()
		{
		}
		
		public function bind(displayObject:DisplayObject,cameraRect:Rectangle, realWidth:int, realHeight:int):void
		{
			_displayObject = displayObject;
			_displayObjectWidth = realWidth;
			_displayObjectHeight = realHeight;
			_cameraRect = cameraRect;
			_displayObject.scrollRect = cameraRect;
		}
		
		public function setCameraCenterOffect(x:int,y:int):void
		{
			_offsetX = x;
			_offsetY = y;
		}
		
		public function updateSize(w:int,h:int):void
		{
			_displayObjectWidth = w;
			_displayObjectHeight = h;
		}
		
		public function moveTo(x:int,y:int):void
		{			
			var targetX:Number = x - (_cameraRect.width >> 1) - _offsetX;
			var targetY:Number = y - (_cameraRect.height >> 1) - _offsetY;
			
			//判断相机的边框，不可超出舞台
			if(targetX < 0)
			{
				targetX = 0;
			}
			else if(targetX + _cameraRect.width > _displayObjectWidth)
			{
				targetX = _displayObjectWidth - _cameraRect.width;
			}
			
			if(targetY < 0)
			{
				targetY = 0;
			}
			else if(targetY + _cameraRect.height > _displayObjectHeight)
			{
				targetY = _displayObjectHeight - _cameraRect.height;
			}
			
			if(_cameraRect.x == targetX && _cameraRect.y == targetY)
			{
				return;
			}
			
//			trace("目标位置",x,y);
			//相机的中心点为制定的X,Y值，推算出相机真实的XY值			
			_cameraRect.x = targetX;
			_cameraRect.y = targetY;
				
			
			_displayObject.scrollRect = _cameraRect;
		}
		
		public function get scrollRect():Rectangle
		{
			return _cameraRect;
		}
	}
}