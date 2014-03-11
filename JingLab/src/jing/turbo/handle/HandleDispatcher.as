package jing.turbo.handle
{
	import jing.turbo.handle.Handle;
	
	import flash.utils.Dictionary;

	/**
	 * 操作广播器,类似于EventDispatcher,更加轻量级，没有冒泡机制，效率更高 
	 * @author Administrator
	 * 
	 */	
	public class HandleDispatcher
	{
		public function HandleDispatcher()
		{
			
		}
		
		private var _registeredHandle:Dictionary = new Dictionary();
		
		/**
		 * 注册一个操作监听（类似于事件机制,通过回调实现) 
		 * @param handleType 操作类型
		 * @param handler 回调方法
		 * 
		 */		
		public function addHandleListener(handleType:String, handler:Function):void
		{
//			if(null == _registeredHandle)
//			{
//				_registeredHandle = new Dictionary();
//			}
//			
			if(null == _registeredHandle[handleType])
			{
				_registeredHandle[handleType] = new Vector.<Function>;
			}
			
			var handlers:Vector.<Function> = _registeredHandle[handleType] as Vector.<Function>;
			if(null != handler && -1 == handlers.indexOf(handler))
			{
				handlers.push(handler);
			}
		}
		
		/**
		 * 注销一个操作监听 
		 * @param handleType 操作类型
		 * @param handler 回调方法
		 * 
		 */		
		public function removeHandleListener(handleType:String, handler:Function):void
		{
			if(null == _registeredHandle)
			{
				return;
			}
			
			if(null == _registeredHandle[handleType])
			{
				return;
			}
			
			var handlers:Vector.<Function> = _registeredHandle[handleType] as Vector.<Function>;
			var handlerIndex:int = handlers.indexOf(handler);
			
			if(-1 != handlerIndex)
			{
				handlers.splice(handlerIndex,1);
			}
		}
		
		/**
		 * 发送一个操作 
		 * @param handle
		 * 
		 */		
		public function sendHandle(handle:Handle):void
		{
			if(null == _registeredHandle)
			{
				return;
			}
			
			if(null == _registeredHandle[handle.type])
			{
				return;
			}
			
			//设置操作对象的target属性
			handle.setTarget(this);
			
			//和该事件关联的所有的方法
			var handlers:Vector.<Function> = _registeredHandle[handle.type] as Vector.<Function>;
			var handlerCount:int = handlers.length;
			
			while(--handlerCount > -1)
			{						
				handlers[handlerCount](handle);
			}
		}
	}
}