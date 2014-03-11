package jing.turbo.turboS.elements
{
 
	
    import jing.turbo.handle.HandleDispatcher;
    import jing.turbo.interfaces.IElement;
    import jing.turbo.interfaces.ITurbo;
    import jing.turbo.ns.TurboNS;
    
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.Stage;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getQualifiedClassName;
    
    import spark.primitives.Rect;
    import jing.turbo.turboS.TurboS;
	
	use namespace TurboNS;
	

    /**
     * 位图引擎中最基本的元素，用来保存颗粒最小的位图对象
     * @author jing
     *
     */
    public class ElementS extends HandleDispatcher implements IElement
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
		
		public function get stage():Stage
		{
			return _turbo.buildBox.stage;
		}
		
		private var _name:String = null;

		/**
		 * 对象的名称 
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			if(null == _name)
			{
				return getQualifiedClassName(this);
			}
			return _name;
		}

		/**
		 * 对象的名称 
		 * @return 
		 * 
		 */	
		public function set name(value:String):void
		{
			_name = value;
		}
		
		
		
		
        private var _x:int = 0;

        /**
         * 得到相对于父级的x坐标
         * @return
         *
         */
        public function get x():int
        {
            return _x;
        }

        /**
         * 设置相对于父级的x坐标
         * @param value
         *
         */
        public function set x(value:int):void
        {
			if(_x != value)
			{
            	_x = value;
				needRedraw();
			}
        }

        private var _y:int = 0;

        /**
         * 得到相对于父级的y坐标
         * @return
         *
         */
        public function get y():int
        {
            return _y;
        }

        /**
         * 设置相对于父级的y坐标
         * @param value
         *
         */
        public function set y(value:int):void
        {
			if(_y != value)
			{
	            _y = value;
				needRedraw();
        	}
		}

        private var _bmd:BitmapData = null;

        /**
         * 得到元素中的位图数据对象
         * @return
         *
         */
        public function get bitmapData():BitmapData
        {
            return _bmd;
        }

        /**
         * 设置元素中的位图数据对象
         * @param value
         *
         */
        public function set bitmapData(value:BitmapData):void
        {
			if(_bmd != value)
			{
            	_bmd = value;
				needRedraw();
			}
        }
		
        /**
         * 得到元素的宽度
         * @return
         *
         */
        public function get width():int
        {
            return _bmd.width * _scaleX;
        }
		
		public function set width(value:int):void
		{
			if(value != _bmd.width)
			{
				_scaleX= value / _bmd.width;
				needRedraw();
			}
		}

		private var _height:int = int.MAX_VALUE;
		
        /**
         * 得到元素的高度
         * @return
         *
         */
        public function get height():int
        {
            return _bmd.height * _scaleY;
        }
		
		public function set height(value:int):void
		{
			if(value != _bmd.height)
			{
				_scaleY = value / _bmd.height;
				needRedraw();
			}
		}

        private var _alpha:Number = 1;

        /**
         * 得到元素的透明度
         * @return
         *
         */
        public function get alpha():Number
        {
            return _alpha;
        }

        /**
         * 设置元素的透明度
         * @param value
         *
         */
        public function set alpha(value:Number):void
        {
			if(_alpha != value)
			{
            	_alpha = value;
				needRedraw();
			}
        }

		
		/**
		 * 旋转的弧度，由角度转换而来 
		 */		
        private var _angle:Number = 0;
		
		private var _rotation:Number = 0;

		/**
		 * 得到元素的旋转的度数 
		 * @return 
		 * 
		 */		
		public function get rotation():Number
		{
			return _rotation;
		}

		/**
		 * 设置元素的旋转的度数
		 * @param value
		 * 
		 */		
		public function set rotation(value:Number):void
		{
			if(_rotation != value)
			{
				_angle = value * Math.PI / 180;
				_rotation = value;
				needRedraw();
			}
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
		}
		

        private var _scaleX:Number = 1;

        /**
         * 得到元素X轴上的缩放值
         * @return
         *
         */
        public function get scaleX():Number
        {
            return _scaleX;
        }

        /**
         * 设置元素X轴上的缩放值
         * @param value
         *
         */
        public function set scaleX(value:Number):void
        {
			if(_scaleX != value)
			{
            	_scaleX = value;
				needRedraw();
			}
        }

        private var _scaleY:Number = 1;

        /**
         * 得到元素Y轴上的缩放值
         * @return
         *
         */
        public function get scaleY():Number
        {
            return _scaleY;
        }

        /**
         * 设置元素Y轴上的缩放值
         * @param value
         *
         */
        public function set scaleY(value:Number):void
        {
			if(_scaleY != value)
			{
            	_scaleY = value;
				needRedraw();
			}
        }

		private var _centerPoint:Point = null;
		
		/**
		 * 元素的注册点 
		 */
		public function get centerPoint():Point
		{
			return _centerPoint;
		}
		
		/**
		 * 元素的注册点
		 * @private
		 */
		public function set centerPoint(value:Point):void
		{
			if(_centerPoint != value)
			{
				_centerPoint = value;
				needRedraw();
			}
		}
		
        /**
         *
         * @param bmd 元素的位图数据对象
         *
         */
        public function ElementS(bmd:BitmapData = null)
        {
			if(null == _centerPoint)
			{
				_centerPoint = new Point(0,0);
			}
			if(null == _graphicRect)
			{
				_graphicRect = new Rectangle();
			}
            _bmd = bmd;
			needRedraw();
        }		
		
		private var _positionPoint:Point = new Point(int.MAX_VALUE,int.MAX_VALUE);
		
        /**
         * 得到图片的实际坐标位置
         * @return
         *
         */
        public function getPosition():Point
        {
			_positionPoint.x = _x - _centerPoint.x;
			_positionPoint.y = _y - _centerPoint.y;
            return _positionPoint;
        }	

        /**
         * 得到元素的变形矩阵
         *
         * 关联的参数
         * @return
         *
         */
        public function getMatrix():Matrix
        {
            var matrix:Matrix = new Matrix();
            matrix.translate(-_centerPoint.x, -_centerPoint.y);
            matrix.rotate(_angle);
            matrix.scale(_scaleX, _scaleY);
            matrix.translate(_x, _y);
            return matrix;
        }
		
		/**
		 * 得到一个布尔值指示当前元素是否有有用的矩阵变量
		 * 和以下属性有关联(angle,rotation,scaleX,scaleY)
		 * @return 
		 * 
		 */		
		public function get hasMatrix():Boolean
		{
			if(_rotation != 0 || _scaleX != 1 || _scaleY != 1)
			{
				return true;
			}
			return false;
		}
		
		private var _graphicRect:Rectangle = null;
		/**
		 * 得到对象占用的绘画矩形范围 
		 * 
		 */		
		public function getGraphicRect():Rectangle
		{			
			var position:Point = getPosition();
			
			_graphicRect.x = position.x;
			_graphicRect.y = position.y;
			_graphicRect.width = this.width;
			_graphicRect.height = this.height;
			
			return _graphicRect;
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
		public function hitTestPointAdvace(stageX:int,stageY:int):Boolean
		{
			//先进性简单的矩形碰撞
			if(false == hitTestPoint(stageX,stageY))
			{
				return false;
			}
			
			//换算成相对坐标
			var currentX:int = stageX - _x + _centerPoint.x;
			var currentY:int = stageY - _y + _centerPoint.y;
			
			if(0 == _bmd.getPixel32(currentX,currentY))
			{
				return false;
			}
			return true;
		}
	
		private var _mouseEnable:Boolean = false;

		/**
		 * 是否响应鼠标操作 
		 * @return 
		 * 
		 */		
		public function get mouseEnable():Boolean
		{
			return _mouseEnable;
		}

		/**
		 * 是否响应鼠标操作 
		 * @return 
		 * 
		 */	
		public function set mouseEnable(value:Boolean):void
		{
			_mouseEnable = value;
		}
		
		private var _buttonMode:Boolean = false;

		/**
		 * 按钮模式 
		 * @return 
		 * 
		 */		
		public function get buttonMode():Boolean
		{
			return _buttonMode;
		}

		/**
		 * 按钮模式 
		 * @param value
		 * 
		 */		
		public function set buttonMode(value:Boolean):void
		{
			_buttonMode = value;
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
			_isSleeping = true;
		}
		
		/**
		 * 唤醒 
		 * 将对象从书面状态唤醒
		 * 
		 */		
		public function wake():void
		{
			_isSleeping = false;
		}
		
		/**
		 * 销毁对象 
		 * 
		 */		
		public function destory():void
		{
			if(null != this.turbo)
			{
				this.turbo.removeElement(this);
			}
		}
		
		/**
		 * 该对象改变了，需要重绘舞台 
		 * 
		 */		
		private function needRedraw():void
		{
			if(_turbo != null)
			{
				(_turbo as TurboS).needRedraw();
			}
		}
		
		public function enterNextFrame():void
		{
			
		}
    }
}