package jing.turbo.turboB.elements
{
	import jing.turbo.handle.HandleDispatcher;
	import jing.turbo.interfaces.IElement;
	import jing.turbo.interfaces.ITurbo;
	import jing.turbo.ns.TurboNS;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace TurboNS;
	
	/**
	 * 元素是由一个不响应鼠标事件的sprite嵌套的bitmap组成
	 * @author jing
	 * 
	 */	
	public class ElementB extends HandleDispatcher implements IElement
	{
		
		
		public function ElementB(bmd:BitmapData = null)
		{
			_spr = new Sprite();
			_spr.mouseChildren = false;
			_spr.mouseEnabled = false;
			
			_bitmap = new Bitmap(bmd);
			
			_spr.addChild(_bitmap);
		}
		
		/**
		 * 元素所在的引擎 
		 */		
		private var _turbo:ITurbo = null;		
		
		public function get turbo():ITurbo
		{
			return _turbo;
		}
		
		/**
		 * 设置元素所在引擎 
		 * @param t
		 * 
		 */		
		TurboNS function setTurbo(t:ITurbo):void
		{
			_turbo = t;
		}
		
		/**
		 * 承载位图的sprite 
		 */		
		private var _spr:Sprite = null;
		
		/**
		 * 得到承载bitmap对象的sprite 
		 * @return 
		 * 
		 */		
		public function get sprite():Sprite
		{
			return _spr;
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
		 * 得到显示元素的舞台 
		 * @return 
		 * 
		 */		
		public function get stage():Stage
		{
			return _spr.stage;
		}
		
		/**
		 * 对象的名称 
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return _spr.name;
		}
		
		/**
		 * 对象的名称 
		 * @param value
		 * 
		 */		
		public function set name(value:String):void
		{
			_spr.name = value;
		}
		
		
		public function set x(value:int):void
		{
			_spr.x = value;
		}
		
		public function get x():int
		{
			return _spr.x;
		}
		
		public function get y():int
		{
			return _spr.y;
		}
		
		public function set y(value:int):void
		{
			_spr.y = value;
		}
		
		public function get width():int
		{
			return _spr.width;
		}
		
		public function set width(value:int):void
		{
			_spr.width = value;
		}
		
		public function get height():int
		{
			return _spr.height;
		}
		
		public function set height(value:int):void
		{
			_spr.height = value;
		}
		
		public function get alpha():Number
		{
			return _spr.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_spr.alpha = value;
		}
		
		public function get rotation():Number
		{
			return _spr.rotation;
		}
		
		public function set rotation(value:Number):void
		{
			_spr.rotation = value;
		}
		
		public function get scaleX():Number
		{
			return _spr.scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			_spr.scaleX = value;
		}
		
		public function get scaleY():Number
		{
			return _spr.scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			_spr.scaleY = value;
		}
		
		public function get centerPoint():Point
		{
			return new Point(-_bitmap.x,-_bitmap.y);
		}
		
		public function set centerPoint(value:Point):void
		{
			_bitmap.x = -value.x;
			_bitmap.y = -value.y;
		}
		
		private var _mouseEnable:Boolean = false;
		
		/**
		 * 是否响应鼠标事件 
		 */
		public function get mouseEnable():Boolean
		{
			return _mouseEnable;
		}
		
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
		
		public function set buttonMode(value:Boolean):void
		{
			_buttonMode = value;
		}
		
		public function get visible():Boolean
		{
			return _spr.visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_spr.visible = value;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmap.bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmap.bitmapData = value;
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
		public function hitTestPoint(x:int, y:int):Boolean
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
		public function hitTestPointAdvace(x:int, y:int):Boolean
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
		public function get isSleeping():Boolean
		{
			return _isSleeping;
		}
		
		public function sleep():void
		{
			_isSleeping = true;
			_spr.visible = false;
		}
		
		public function wake():void
		{
			_isSleeping = false;
		}
		
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
			return _spr;
		}
	}
	
	
}

namespace turbo_ns = "http://www.annjing.cn/turbo";