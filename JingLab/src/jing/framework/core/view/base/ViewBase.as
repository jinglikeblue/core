package jing.framework.core.view.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import jing.framework.core.events.ViewBaseEvent;
	import jing.framework.core.view.base.dragView.DragView;
	import jing.framework.core.view.interfaces.IView;
	import jing.framework.manager.stage.StageManager;

	/**
	 * 显示对象的基类
	 * @author jing
	 *
	 */
	public class ViewBase extends EventDispatcher implements IView
	{
		protected var _isDestroyed:Boolean = false;
		
		/**
		 * 对象是否被销毁了 
		 * @return 
		 * 
		 */		
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		
		protected var _modal:Sprite = null;

		/**
		 * 映射到UI列表上的事件列表
		 */
		static protected const MAPPING_UI_EVENT_LIST:Array = [Event.ENTER_FRAME, MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_WHEEL, MouseEvent.ROLL_OUT, MouseEvent.ROLL_OVER];

		protected var _gui:DisplayObject = null;

		/**
		 * 是否任何时候都保留监听
		 */		
		protected var _syncDataAlways:Boolean = false;

		/**
		 * 延迟调用方法，这里的方法会在程序进入下一帧的时候调用，只执行一次，可以用于优化UI渲染（避免同一帧中出现重复效用UI刷新的情况)
		 */
		protected var _delayCallFunDic:Dictionary = null;

		/**
		 * 设置方法在下一帧被调用 
		 * @param fun
		 * 
		 */		
		protected function delayCall(fun:Function):void
		{						
			if (null == _delayCallFunDic)
			{
				_delayCallFunDic = new Dictionary();
				_gui.addEventListener(Event.ENTER_FRAME, delayCall_enterFrameHandler);
			}

			_delayCallFunDic[fun] = fun;
		}

		private function delayCall_enterFrameHandler(e:Event):void
		{
			for each (var fun:Function in _delayCallFunDic)
			{
				fun();
			}

			_delayCallFunDic = null;
			_gui.removeEventListener(Event.ENTER_FRAME, delayCall_enterFrameHandler);
		}

		/**
		 * 对象不在舞台上的时候是否还进行数据的同步，默认值为false
		 */
		public function get syncDataAlways():Boolean
		{
			return _syncDataAlways;
		}

		/**
		 * @private
		 */
		public function set syncDataAlways(value:Boolean):void
		{
			_syncDataAlways = value;
		}

		/**
		 * 视图是否显示
		 * @return
		 *
		 */
		public function get isShowing():Boolean
		{
			return _gui.parent == null ? false : true;
		}

		/**
		 *
		 * @param gui 图形界面
		 *
		 */
		public function ViewBase(gui:DisplayObject)
		{
			if (gui != null)
			{
				constructor(gui);
			}
			else
			{
				throw new Error("ViewBase类中的gui不能为null");
			}
		}

		/**
		 * 构造函数
		 * @param gui
		 *
		 */
		protected function constructor(gui:DisplayObject):void
		{
			_gui = gui;
			//			addListeners();
			optimizationEventResponse();
		}
		
		
		/**
		 * 
		 * 优化gui,如果GUI是一个DisplayObjectContainer,则遍历其子项，对name为系统匹配名字的子项设置为不响应鼠标事件
		 */
		private function optimizationEventResponse():void
		{
			var container:DisplayObjectContainer = _gui as DisplayObjectContainer;
			if(null == container)
			{
				return;
			}
			
			var childNumber:int = container.numChildren;
			var child:DisplayObjectContainer = null;
			for(var i:int = 0; i < childNumber; i++)
			{
				child = container.getChildAt(i) as DisplayObjectContainer;
				if(null == child)
				{
					continue;
				}
				
				if(child.name.indexOf("instance") != -1)
				{
					child.mouseChildren = false;
					child.mouseEnabled = false;
				}
			}
		}

		/**
		 * 得到显示对象的图形界面
		 * @return
		 *
		 */
		public function get gui():DisplayObject
		{
			return _gui;
		}

		/**
		 * 在舞台上呈现显示对象
		 * @param container
		 * @param x
		 * @param y
		 * @param mode 是否制作隔离其它界面的操作
		 */
		public function show(container:DisplayObjectContainer, x:int = int.MAX_VALUE, y:int = int.MAX_VALUE, modal:Boolean = false):void
		{
			showAt(container, container.numChildren, x, y, modal);
		}

		public function showAt(container:DisplayObjectContainer, childIndex:int, x:int = int.MAX_VALUE, y:int = int.MAX_VALUE, modal:Boolean = false):void
		{
			if (int.MAX_VALUE != x)
			{
				_gui.x = x;
			}

			if (int.MAX_VALUE != y)
			{
				_gui.y = y;
			}

			if (null != container)
			{
				container.addChildAt(_gui, childIndex);
				this.dispatchEvent(new ViewBaseEvent(ViewBaseEvent.SHOWED));

				setModal(modal);
				
				if (false == _syncDataAlways)
				{
					addListeners();
					if(this is DragView)
					{
						(this as DragView).addDragEventListener();
					}
				}
			}

			
		}

		/**
		 * 设置是否隔离其它界面
		 * @param b
		 *
		 */
		public function setModal(b:Boolean, fontGUI:DisplayObject = null):void
		{
			if (true == b)
			{
				if (null == fontGUI)
				{
					fontGUI = _gui;
				}

				if (null == _modal)
				{
					_modal = new Sprite();
				}

				_modal.graphics.clear();
				_modal.graphics.beginFill(0x000000, 0.2);
				_modal.graphics.drawRect(0, 0, StageManager.stage.stageWidth, StageManager.stage.stageHeight);
				_modal.graphics.endFill();
				_modal.x = fontGUI.parent.globalToLocal(new Point(0, 0)).x;
				_modal.y = fontGUI.parent.globalToLocal(new Point(0, 0)).y;
				fontGUI.parent.addChild(_modal);
				fontGUI.parent.swapChildren(_modal, fontGUI);
					//					if(_gui.parent.addchi 

			}
			else
			{
				if (_modal != null && _modal.parent != null)
				{
					_modal.parent.removeChild(_modal);
				}
			}
		}

		/**
		 * 关闭对象
		 * !!对象只是从舞台上移除并没有被销毁，如果需要销毁对象，请使用destory方法
		 * 关闭的对象会根据syncDataAlways属性来判断是否执行removeListeners()方法
		 * 与removeListeners()对应的方法addListeners()会在调用show()方法时候被调用，
		 * 通过重写add/removeListeners方法，可以在界面不显示时屏蔽一些事件的响应
		 *
		 */
		public function close():void
		{
			if (null != _gui && null != _gui.parent)
			{

				_gui.parent.removeChild(_gui);
				this.dispatchEvent(new ViewBaseEvent(ViewBaseEvent.CLOSED));

				if (false == _syncDataAlways)
				{
					removeListeners();
					if(this is DragView)
					{
						(this as DragView).removeDragEventListener();
					}
				}
			}
			setModal(false);
		}

		/**
		 * 销毁对象数据
		 * !!只有在确定该对象不再使用时才执行
		 *
		 */
		public function destroy():void
		{
			if(true == _isDestroyed)
			{
				return;
			}
			_isDestroyed = true;
			close();
			removeListeners();
			if(this is DragView)
			{
				(this as DragView).removeDragEventListener();
			}
			_gui = null;
			//			_modal = null;			
			this.dispatchEvent(new ViewBaseEvent(ViewBaseEvent.DESTROYED));
		}

		/**
		 * 监听事件的方法，该方法会在show方法被调用时判断syncDataAlways方法来确定是否被调用
		 * syncDataAlways值为false时调用
		 *
		 *
		 */
		public function addListeners():void
		{
			//在每次执行事件监听前，先尝试移除之前的事件监听
			//			removeListeners();
		}

		/**
		 * 移除监听的事件
		 *
		 */
		public function removeListeners():void
		{

		}

		/**
		 * 重写过的事件监听方法，会根据MAPPING_UI_EVENT_LIST列表将一些交互事件映射到gui上
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 *
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (MAPPING_UI_EVENT_LIST.indexOf(type) == -1)
			{
				
			}
			else
			{
				(_gui as IEventDispatcher).addEventListener(type, eventHandler, useCapture, priority, useWeakReference);
			}

			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (MAPPING_UI_EVENT_LIST.indexOf(type) == -1)
			{
				
			}
			else
			{
				(_gui as IEventDispatcher).removeEventListener(type, eventHandler, useCapture);
			}

			super.removeEventListener(type, listener, useCapture);
		}

		private function eventHandler(e:Event):void
		{
			this.dispatchEvent(e.clone());
		}
		
//		override public function dispatchEvent(event:Event):Boolean
//		{
//			trace("广播事件！");
//			return super.dispatchEvent(event);
//		}

		/**
		 * 该方法映射到_gui的addChild上
		 * @param obj
		 *
		 */
		public function addChild(obj:DisplayObject):void
		{
			if (_gui is DisplayObjectContainer)
			{
				(_gui as DisplayObjectContainer).addChild(obj);
			}
		}

		/**
		 * 该方法映射到_gui的addChildAt上
		 * @param obj
		 *
		 */
		public function addChildAt(obj:DisplayObject, index:int):void
		{
			if (_gui is DisplayObjectContainer)
			{
				(_gui as DisplayObjectContainer).addChildAt(obj, index);
			}
		}
		
		/**
		 * 该方法映射到_gui的removeChild上 
		 * @param obj
		 * 
		 */		
		public function removeChild(obj:DisplayObject):void
		{
			if (_gui is DisplayObjectContainer)
			{
				(_gui as DisplayObjectContainer).removeChild(obj);
			}
		}
		
		/**
		 * 该方法映射到_gui的removeChildAt上 
		 * @param obj
		 * 
		 */
		public function removeChildAt(index:int):void
		{
			if (_gui is DisplayObjectContainer)
			{
				(_gui as DisplayObjectContainer).removeChildAt(index);
			}
		}

		/**
		 * 该方法映射到_gui的getChildAt上
		 * @param obj
		 *
		 */
		public function getChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = null;

			if (_gui is DisplayObjectContainer)
			{
				child = (_gui as DisplayObjectContainer).getChildAt(index);
			}

			return child;
		}

		/**
		 * 该方法映射到_gui的getChildByName上
		 * @param obj
		 *
		 */
		public function getChildByName(name:String):DisplayObject
		{
			var child:DisplayObject = null;

			if (_gui is DisplayObjectContainer)
			{
				child = (_gui as DisplayObjectContainer).getChildByName(name);
			}
			return child;
		}

		//-------------------------------------------------------------------------------------------------------
		public function set filters(array:Array):void
		{
			_gui.filters = array;
		}

		public function get filters():Array
		{
			return _gui.filters;
		}

		public function set width(w:Number):void
		{
			_gui.width = w;
		}

		public function get width():Number
		{
			return _gui.width;
		}

		public function set height(h:Number):void
		{
			_gui.height = h;
		}

		public function get height():Number
		{
			return _gui.height;
		}

		public function set alpha(value:Number):void
		{
			_gui.alpha = value;
		}

		public function get alpha():Number
		{
			return _gui.alpha;
		}

		public function set scaleX(value:Number):void
		{
			_gui.scaleX = value;
		}

		public function get scaleX():Number
		{
			return _gui.scaleX;
		}

		public function set scaleY(value:Number):void
		{
			_gui.scaleY = value;
		}

		public function get scaleY():Number
		{
			return _gui.scaleY;
		}

		public function set scrollRect(rect:Rectangle):void
		{
			_gui.scrollRect = rect;
		}

		public function get scrollRect():Rectangle
		{
			return _gui.scrollRect;
		}

		public function set visible(b:Boolean):void
		{
			_gui.visible = b;
		}

		public function get visible():Boolean
		{
			return _gui.visible;
		}

		public function set x(x:Number):void
		{
			_gui.x = x;
		}

		public function get x():Number
		{
			return _gui.x;
		}

		public function set y(y:Number):void
		{
			_gui.y = y;
		}

		public function get y():Number
		{
			return _gui.y;
		}

		public function get mouseX():Number
		{
			return _gui.mouseX;
		}

		public function get mouseY():Number
		{
			return _gui.mouseY;
		}		
		
		public function set buttonMode(b:Boolean):void
		{
			if(null != _gui as Sprite)
			{
				(_gui as Sprite).buttonMode = b;
			}
			
		}
		
		public function get buttonMode():Boolean
		{
			if(null == _gui as Sprite)
			{
				return false;
			}		
			
			return (_gui as Sprite).buttonMode;
		}
		
		public function set mouseEnabled(b:Boolean):void
		{
			if(null != _gui as DisplayObjectContainer)
			{
				(_gui as DisplayObjectContainer).mouseEnabled = b;
			}				
		}
		
		public function get mouseEnabled():Boolean
		{
			if(null == _gui as DisplayObjectContainer)
			{
				return false;
			}		
			
			return (_gui as DisplayObjectContainer).mouseEnabled;
		}
		
		public function set mouseChildren(b:Boolean):void
		{
			if(null != _gui as DisplayObjectContainer)
			{
				(_gui as DisplayObjectContainer).mouseChildren = b;
			}	
		}
		
		public function get mouseChildren():Boolean
		{
			if(null == _gui as DisplayObjectContainer)
			{
				return false;
			}	
			
			return (_gui as DisplayObjectContainer).mouseChildren;
		}
	}
}