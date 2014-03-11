package jing.turbo.turboM
{
	import jing.turbo.handle.MouseHandle;
	import jing.turbo.interfaces.IElement;
	import jing.turbo.interfaces.ITurbo;
	import jing.turbo.ns.TurboNS;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import jing.turbo.turboM.elements.ElementM;

	use namespace TurboNS;
	
	/**
	 * 引擎核心显示类，所有基于Element的类都是该类的子元素 
	 * 多位图引擎
	 * @author Jing
	 * 
	 */	
	public class TurboM implements ITurbo
	{
		
		/**
		 * 用这个来包括Bitmap对象，因为Sprite才能接收鼠标事件 
		 */		
		private var _buildBox:Sprite = null;
		
		public function get buildBox():Sprite
		{
			return _buildBox;
		}
		
		/**
		 * 元素列表 
		 */		
		private var _eleList:Vector.<IElement> = null;
		
		/**
		 * 构造方法 
		 * @buildBox 呈现引擎的显示元件，没有的话引擎会自己创建一个
		 */		
		public function TurboM(buildBox:Sprite = null)
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
			_buildBox.graphics.beginFill(color,alpha);
			_buildBox.graphics.drawRect(0,0,width,height);
			_buildBox.graphics.endFill();
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
		
		private function enterFrameHandler(e:Event):void
		{
			checkMouseMove();
			enterFrameMove();
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
			var ele:IElement = null;
			var firstPoint:Point = null;
			var hitTestPoint:Point = null;
			
			while (--childCount > -1)
			{
				ele = _eleList[childCount];
				
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
				
				//基于点的像素碰撞进行碰撞测试,在旋转过后会出问题
				if(false == ele.hitTestPointAdvace(_buildBox.mouseX,_buildBox.mouseY)) 
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
		
		private function clickHandler(e:MouseEvent):void
		{
			var childCount:int = _buildBox.numChildren;
			var ele:IElement = null;
			
			while (--childCount > -1)
			{
				ele = _eleList[childCount];
				
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
		 * 是否有鼠标移动事件 
		 */		
		private var _hasMouseMoveEvent:Boolean = false;
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			_hasMouseMoveEvent = true;
		}
		
		/**
		 * 添加一个元素到引擎显示列表中
		 * @param ele
		 *
		 */
		public function addElement(ele:IElement):void
		{
			if(ele.turbo != null)
			{
				ele.turbo.removeElement(ele);
			}
			_buildBox.addChild((ele as ElementM).bitmap);
			_eleList.push(ele);
			(ele as ElementM).setTurbo(this);
		}
		
		/**
		 * 从引擎中删除一个显示元素 
		 * @param ele
		 * 
		 */		
		public function removeElement(ele:IElement):void
		{
			var index:int = _eleList.indexOf(ele);
			if(-1 != index)
			{
				(ele as ElementM).setTurbo(null);
				_buildBox.removeChild((_eleList[index] as ElementM).bitmap);
				_eleList.splice(index,1);
			}
		}
		
		/**
		 * 从引擎中删除指定索引位置的元素
		 * @param index
		 *
		 */
		public function removeElementAt(index:int):void
		{
			var ele:IElement = _eleList[index];
			if(null != ele)
			{
				(ele as ElementM).setTurbo(null);
				_buildBox.removeChild((ele as ElementM).bitmap);
				_eleList.splice(index,1);
			}
		}
		
		/**
		 * 在指定索引位置插入元素 
		 * @param ele
		 * @param childIndex
		 * @return 
		 * 
		 */		
		public function addElementAt(ele:IElement, childIndex:int):void
		{
			if(ele.turbo != null)
			{
				ele.turbo.removeElement(ele);
			}
			(ele as ElementM).setTurbo(this);
			_eleList.splice(childIndex,0,ele);
			_buildBox.addChildAt((ele as ElementM).bitmap,childIndex);
		}
		
		/**
		 * 获取元素的索引位置 
		 * @param child
		 * 
		 */		
		public function getElementIndex(ele:IElement):int
		{
			return _eleList.indexOf(ele);
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
	}
}