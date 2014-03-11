package jing.turbo.turboS
{
    
    import jing.turbo.handle.Handle;
    import jing.turbo.handle.MouseHandle;
    import jing.turbo.interfaces.IElement;
    import jing.turbo.interfaces.ITurbo;
    import jing.turbo.ns.TurboNS;
    import jing.turbo.turboS.elements.ElementS;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.utils.getTimer;

	use namespace TurboNS;
	
    /**
     * 位图引擎基本类
	 * 单位图引擎
     * @author jing
     *
     */
    public class TurboS implements ITurbo
    {
		private var _isRedraw:Boolean = false;
		
		/**
		 * 设置需要重绘舞台 
		 * @param value
		 * 
		 */		
		public function needRedraw():void
		{
			_isRedraw = true;
		}
		
        private var _bm:Bitmap = new Bitmap();

        private var _bmd:BitmapData = null;

        private var _eleList:Vector.<IElement> = null;

        private var _color:uint = 0;

        private var _width:uint = 0;

        private var _height:uint = 0;

		/**
		 * 
		 */		
		private var _buildBox:Sprite = null;
		
		public function get buildBox():Sprite
		{
			return _buildBox;
		}
		
        /**
         *
         * @param width 宽度
         * @param height 高度
         * @param color 背景颜色
         *
         */
        public function TurboS(buildBox:Sprite = null)
        {
			if(null == buildBox)
			{
				buildBox = new Sprite();				
			}
			_buildBox = buildBox;
			_eleList = new Vector.<IElement>();
			init();
        }
		
		/**
		 * 初始化引擎 
		 * @param w
		 * @param h
		 * @param color
		 * @param alpha
		 * 
		 */	
		public function config(w:uint,h:uint,color:uint = 0, alpha:Number = 0):void
		{
			_width = w;
			_height = h;
			_color = color;
			_bmd = new BitmapData(w, h, true, color);
			_bm.bitmapData = _bmd;
			_buildBox.addChild(_bm);
		}
		
		/**
		 * 启动引擎
		 * @param container
		 * 如果buildBox已经在舞台上，则不用传入容器
		 */		
		public function startup(container:DisplayObjectContainer = null):void
		{
			if(null != container)
			{
				container.addChild(_buildBox);
			}
		}
		
		/**
		 * 关闭引擎 
		 * 
		 */		
		public function shutdown():void
		{
			if(_buildBox.parent != null)
			{
				_buildBox.parent.removeChild(_buildBox);
			}
		}

        private function init():void
        {
			_buildBox.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_buildBox.addEventListener(MouseEvent.CLICK, clickHandler);
			_buildBox.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
		
		/**
		 * 是否有鼠标移动事件 
		 */		
		private var _hasMouseMoveEvent:Boolean = false;
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			_hasMouseMoveEvent = true;
		}
		
        private function enterFrameHandler(e:Event):void
        {
			checkMouseMove();
			enterFrameMove();
            draw();
        }
		
		private function enterFrameMove():void
		{
			for(var i:int = 0; i < _eleList.length; i++)
			{
				_eleList[i].enterNextFrame();
			}
		}
		
		/**
		 * 在这里通过判断_hasMouseMoveEvent属性来进行处理，比在每次MouseMove事件中执行函数效率高
		 * 
		 */		
		private function checkMouseMove():void
		{
			if(false == _hasMouseMoveEvent)
			{
				return;
			}
			_hasMouseMoveEvent = false;
			
			Mouse.cursor = MouseCursor.AUTO;
			var childCount:int = _eleList.length;
			var ele:ElementS = null;
			var firstPoint:Point = null;
			var hitTestPoint:Point = null;
			
			while (--childCount > -1)
			{
				ele = _eleList[childCount] as ElementS;
				
				if (false == ele.mouseEnable)
				{
					continue;
				}
				
				if (null == firstPoint)
				{
					firstPoint = new Point(0, 0);
				}
				
				if (null == hitTestPoint)
				{
					hitTestPoint = new Point();
				}
				
				hitTestPoint.x = _buildBox.mouseX - ele.getPosition().x;
				hitTestPoint.y = _buildBox.mouseY - ele.getPosition().y;
				
				//基于点的像素碰撞进行碰撞测试,在旋转过后会出问题
				if (false == ele.bitmapData.hitTest(firstPoint, 0xFF, hitTestPoint))
				{
					continue;
				}
				
				//下面试检测到碰撞后执行的操作
				
				if (true == ele.buttonMode)
				{
					Mouse.cursor = MouseCursor.BUTTON;	
				}
			}
		}

        /**
         * 接收鼠标点击事件后，遍历子对象判断鼠标点击行为
         * @param e
         *
         */
        private function clickHandler(e:MouseEvent):void
        {
            var childCount:int = _eleList.length;
            var ele:ElementS = null;

            while (--childCount > -1)
            {
                ele = _eleList[childCount] as ElementS;

                if (false == ele.mouseEnable)
                {
                    continue;
                }

                //基于点的像素碰撞进行碰撞测试,在旋转过后会出问题
                if (false == ele.hitTestPointAdvace( _buildBox.mouseX,_buildBox.mouseY))
                {
                   continue;
                }
				
				//下面试检测到碰撞后执行的操作
				ele.sendHandle(new MouseHandle(MouseHandle.CLICK));
            }
        }

        /**
         * 在每一帧调用draw方法绘制舞台数据
         */
        private function draw():void
        {
			if(false == _isRedraw)
			{
				return;
			}
			_isRedraw = false;
			
            _bmd.lock();
			
            _bmd.fillRect(new Rectangle(0, 0, _width, _height), _color);

            var childNumber:int = _eleList.length;

            var ele:ElementS = null;

            var reg:Rectangle = new Rectangle();

            var ct:ColorTransform = new ColorTransform();

            var childIndex:int = -1;

			var graphicRect:Rectangle = new Rectangle();
			
            while (++childIndex < childNumber)
            {
                ele = _eleList[childIndex] as ElementS;
				ele.sendHandle(new Handle(Handle.ENTER_FRAME));
				
				/*
				* 过滤掉不在显示区域范围内的对象
				*/
				graphicRect = ele.getGraphicRect();
				if(graphicRect.right < 0 || graphicRect.left > _buildBox.width || graphicRect.bottom < 0 || graphicRect.top > _buildBox.height)
				{
					continue;
				}
				
				if (ele.hasMatrix || ele.alpha != 1)
                {
					/*
					* 在这里加入判断语句是因为我暂时认为copyPixels的效率比draw高，所以在
					* 不需要使用draw的时候尽量使用copyPixels
					*/
                    ct.alphaMultiplier = ele.alpha;
                    _bmd.draw(ele.bitmapData, ele.getMatrix(), ct);
                }
                else
                {
                    reg.width = ele.width;
                    reg.height = ele.height;
                    _bmd.copyPixels(ele.bitmapData, reg, ele.getPosition(), null, null, true);
                }
            }

            _bmd.unlock();
        }

        /**
         * 添加一个元素到引擎显示列表中
         * @param ele
         *
         */
        public function addElement(ele:IElement):void
        {
            _eleList.push(ele);
			(ele as ElementS).setTurbo(this);
			needRedraw();
        }

        /**
         * 从引擎中删除一个显示元素
         * @param ele
         *
         */
        public function removeElement(ele:IElement):void
        {
            var index:int = _eleList.indexOf(ele);
            if (-1 != index)
            {
				(_eleList[index] as ElementS).setTurbo(null);
                _eleList.splice(index, 1);
				needRedraw();
            }
        }

        /**
         * 从引擎中删除指定索引位置的元素
         * @param index
         *
         */
        public function removeElementAt(index:int):void
        {
			var ele:ElementS = _eleList[index] as ElementS;
			if(null != ele)
			{
				ele.setTurbo(null);
            	_eleList.splice(index, 1);
				needRedraw();
			}
        }

        /**
         * 在制定索引位置插入元素
         * @param ele
         * @param childIndex
         * @return
         *
         */
        public function addElementAt(ele:IElement, childIndex:int):void
        {
            _eleList.splice(childIndex, 0, ele);
			(ele as ElementS).setTurbo(this);
			needRedraw();
        }

        /**
         * 获取元素的索引位置
         * @param child
         * @return
         *
         */
        public function getElementIndex(child:IElement):int
        {
            return _eleList.indexOf(child);
        }


        /**
         * 获取指定索引位置的元素
         * @param childIndex
         * @return
         *
         */
        public function getElementAt(childIndex:int):IElement
        {
            return _eleList[childIndex];
        }

        /**
         * 得到显示元素数量
         * @return
         *
         */
        public function get numElements():uint
        {
            return _eleList.length;
        }
		
		/**
		 * 引擎占用宽度 
		 * @return 
		 * 
		 */		
		public function get width():Number
		{
			return _buildBox.width;	
		}
		
		/**
		 * 引擎占用高度 
		 * @return 
		 * 
		 */		
		public function get height():Number
		{
			return _buildBox.height;
		}

        /**
         * 销毁引擎对象
         *
         */
        public function destory():void
        {

        }
    }
}