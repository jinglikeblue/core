package jing.turbo.turboM.elements
{	
	import jing.turbo.handle.HandleDispatcher;
	import jing.turbo.interfaces.IElement;
	import jing.turbo.interfaces.ITurbo;
	import jing.turbo.ns.TurboNS;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace TurboNS;
	
	/**
	 * 该元素管理一个Bitmap对象
	 * 
	 * --------------------------------------------------------------
	 * Bitmap 对象可通过以下两种方式之一将 BitmapData 对象绘制到屏幕上：
	 * 使用矢量渲染器作为填充位图形状，或使用更快的像素复制例程。
	 * 像素复制例程的速度比矢量渲染器要快很多，但 Bitmap 对象必须满足
	 * 某些条件才能使用该例程：
	 *
	 *	1.不能将拉伸、旋转或倾斜效果应用于 Bitmap 对象。 
	 *	2.不能将颜色转换应用于 Bitmap 对象。 
	 *	3.不能将混合模式应用于 Bitmap 对象。 
	 *	4.不能通过蒙版或 setMask() 方法进行剪裁。 
	 *	5.图像本身不能是遮罩。 
	 *	6.目标坐标必须位于一个整像素边界上。 
	 *-----------------------------------------------------------------
	 * 
	 * @author Jing
	 * 
	 */	
	public class ElementM extends HandleDispatcher implements IElement
	{
		/**
		 * 元素所在的引擎 
		 */	
		private var _turbo:ITurbo = null;
		/**
		 * 元素所在的引擎
		 * @return 
		 * 
		 */	
		public function get turbo():ITurbo
		{
			return _turbo;
		}
		/**
		 * 设置元素所在引擎 
		 * @param value
		 * 
		 */	
		TurboNS function setTurbo(t:ITurbo):void
		{
			_turbo = t;
		}		
		
		private var _bitmap:Bitmap = null;
		
		/**
		 * 得到和Element关联的bitmap对象 
		 * @return 
		 * 
		 */		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		/**
		 * 显示元素的舞台 
		 * @return 
		 * 
		 */		
		public function get stage():Stage
		{
			return _bitmap.stage;
		}
		
		/**
		 * 对象的名称
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return _bitmap.name;
		}
		
		/**
		 * 对象的名称 
		 * @param value
		 * 
		 */		
		public function set name(value:String):void
		{
			_bitmap.name = value;
		}
		
		/**
		 * 相对于父级的x坐标
		 * @return
		 *
		 */
		public function get x():int
		{
			return _bitmap.x + _centerPoint.x;
		}
		
		/**
		 * 相对于父级的x坐标
		 * @return
		 *
		 */
		public function set x(value:int):void
		{
			_bitmap.x = value - _centerPoint.x;
		}
		
		/**
		 * 相对于夫级的y坐标 
		 * @return 
		 * 
		 */		
		public function get y():int
		{
			return _bitmap.y + _centerPoint.y;
		}
		
		/**
		 * 相对于夫级的y坐标 
		 * @param value
		 * 
		 */		
		public function set y(value:int):void
		{
			_bitmap.y = value - _centerPoint.y;
		}
		
		/**
		 * 元素的宽度 
		 * @return 
		 * 
		 */		
		public function get width():int
		{
			return _bitmap.width;
		}
		
		/**
		 * 元素的宽度 
		 * @param value
		 * 
		 */		
		public function set width(value:int):void
		{
			_bitmap.width = value;
		}
		
		/**
		 * 元素的高度 
		 * @return 
		 * 
		 */		
		public function get height():int
		{
			return _bitmap.height;
		}
		
		/**
		 * 元素的高度 
		 * @param value
		 * 
		 */		
		public function set height(value:int):void
		{
			_bitmap.height = value;
		}
		
		/**
		 * 元素的透明度 
		 * @return 
		 * 
		 */		
		public function get alpha():Number
		{
			return _bitmap.alpha;
		}
		
		/**
		 * 元素的透明度 
		 * @param value
		 * 
		 */		
		public function set alpha(value:Number):void
		{
			_bitmap.alpha = value;
		}
			
		/**
		 * 元素旋转的度数 
		 * @return 
		 * 
		 */		
		public function get rotation():Number
		{
			return _bitmap.rotation;
		}
		
		/**
		 * 元素旋转的度数
		 * @param value
		 * 
		 */		
		public function set rotation(value:Number):void
		{
			_bitmap.rotation = value;
		}
		
		/**
		 * 元素X轴上的缩放值
		 * @return
		 *
		 */
		public function get scaleX():Number
		{
			return _bitmap.scaleX;
		}
		
		/**
		 * 元素X轴上的缩放值
		 * @param value
		 *
		 */
		public function set scaleX(value:Number):void
		{
			_bitmap.scaleX = value;
		}
		
		/**
		 * 元素Y轴上的缩放值
		 * @return
		 *
		 */
		public function get scaleY():Number
		{
			return _bitmap.scaleY;
		}
		
		/**
		 * 元素Y轴上的缩放值
		 * @param value
		 *
		 */
		public function set scaleY(value:Number):void
		{
			_bitmap.scaleY = value;
		}
		
		private var _centerPoint:Point = null;
		
		/**
		 * 元素的注册点 
		 * @return 
		 * 
		 */		
		public function get centerPoint():Point
		{
			return _centerPoint;
		}
		
		/**
		 * 元素的注册点 
		 * @return 
		 * 
		 */	
		public function set centerPoint(value:Point):void
		{
			_centerPoint = value;
		}
		
		private var _mouseEnable:Boolean = false;

		/**
		 * 是否响应鼠标事件 
		 */
		public function get mouseEnable():Boolean
		{
			return _mouseEnable;
		}

		/**
		 * @private
		 */
		public function set mouseEnable(value:Boolean):void
		{
			_mouseEnable = value;
		}
		
		
		private var _buttonMode:Boolean = false;

		/**
		 * 是否按钮模式 
		 */
		public function get buttonMode():Boolean
		{
			return _buttonMode;
		}

		/**
		 * @private
		 */
		public function set buttonMode(value:Boolean):void
		{
			_buttonMode = value;
		}
		
		private var _visible:Boolean = true;
		
		/**
		 * 对象是否可见 
		 */
		public function get visible():Boolean
		{
			return _visible;
		}
		
		/**
		 * @private
		 */
		public function set visible(value:Boolean):void
		{
			_visible = value;
			_bitmap.visible = _visible;
		}
		
		/**
		 * 元素位图数据 
		 * @return 
		 * 
		 */		
		public function get bitmapData():BitmapData
		{
			return _bitmap.bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmap.bitmapData = value;
		}
		
		/**
		 * 构造方法 
		 * @param bmd
		 * 
		 */		
		public function ElementM(bmd:BitmapData = null)
		{
			if(null == _centerPoint)
			{
				_centerPoint = new Point(0,0);
			}
			
			_bitmap = new Bitmap(bmd);
			
			super();
		}
		
		/**
		 * 得到在父级对象中的真实坐标矩形 
		 * @return 
		 * 
		 */		
		public function getGraphicRect():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			rect.x = _bitmap.x;
			rect.y = _bitmap.y;
			rect.width = _bitmap.width;
			rect.height = _bitmap.height;
			return rect;
		}
		
		/**
		 * 对指定点进行碰撞测试 
		 * @param x
		 * @param y
		 * 
		 */		
		public function hitTestPoint(x:int,y:int):Boolean
		{
			var result:Boolean = false;
			
			var rect:Rectangle = getGraphicRect();			
			
			if(rect.x <= x && x <= rect.x + rect.width)
			{
				if(rect.y <= y && y <= rect.y + rect.height)
				{
					result = true;
				}
			}
			
			return result;
		}
		
		/**
		 * 检测和指定元素的绘制区域有没有碰撞 
		 * @param target 用来做碰撞测试的目标元素
		 * @return 
		 * 
		 */		
		public function hitTest(target:IElement):Boolean
		{
			var result:Boolean = true;
			
			var selfRect:Rectangle = getGraphicRect();
			var targetRect:Rectangle = target.getGraphicRect();
			
			if(targetRect.right < selfRect.left || selfRect.right < targetRect.left)
			{
				result = false;
			}
			else if(targetRect.bottom < selfRect.top || selfRect.bottom < targetRect.top)
			{
				result = false;
			}
			
			return result;
		}
		
		/**
		 * 基于位图的高级别的碰撞测试，更精确，效率消耗也更大 
		 * @param x 
		 * @param y
		 * 
		 */		
		public function hitTestPointAdvace(x:int,y:int):Boolean
		{
			//先进性简单的矩形碰撞
			if(false == hitTestPoint(x,y))
			{
				return false;
			}
			
			//换算成相对坐标
			var currentX:int = x - _bitmap.x;
			var currentY:int = y - _bitmap.y;
			
			if(0 == _bitmap.bitmapData.getPixel32(currentX,currentY))
			{
				return false;
			}
			return true;
		}
		
		private var _isSleeping:Boolean = false;
		
		/**
		 * 是否正在休眠 
		 * @return 
		 * 
		 */		
		public function get isSleeping():Boolean
		{
			return _isSleeping;
		}
		
		/**
		 * 睡眠状态
		 * 启用该方法的时候，对象必须在可不见状态，此时的对象被冻结不更新数据也不更新界面 
		 * 
		 */		
		public function sleep():void
		{			
			_bitmap.visible = false;
			_isSleeping = true;
		}
		
		/**
		 * 唤醒 
		 * 将对象从书面状态唤醒
		 * 
		 */		
		public function wake():void
		{
			_bitmap.visible = true;
			_isSleeping = false;
		}
		

		/**
		 * 销毁对象 
		 * 
		 */		
		public function destory():void
		{
			if(null != _turbo)
			{
				_turbo.removeElement(this);
			}
		}
		
		public function enterNextFrame():void
		{
			
		}
		
		public function get displayCore():DisplayObject
		{
			return _bitmap;
		}
	}
}