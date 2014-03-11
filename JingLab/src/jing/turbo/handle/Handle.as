package jing.turbo.handle
{
	/**
	 * 事件
	 * @author Jing
	 * 
	 */	
	public class Handle
	{
		private var _type:String;	

		/**
		 * 事件类型 
		 * @return 
		 * 
		 */		
		public function get type():String
		{
			return _type;
		}

		private var _target:Object;

		/**
		 * 触发事件的对象 
		 * @return 
		 * 
		 */		
		public function get target():Object
		{
			return _target;
		}
		
		/**
		 *  
		 * @param type 事件类型
		 * @param target 事件对象
		 * 
		 */		
		public function Handle(type:String)
		{
			_type = type;
		}
		
		//--------------------------------------------------------
		
		/**
		 * 设置广播事件的对象
		 * 只有本包中的对象可以使用该方法，主要提供与HandleDispatcher使用
		 * @param obj
		 * 
		 */		
		internal function setTarget(obj:Object):void
		{
			_target = obj;
		}
		
		
		//-----------------------------------------------------------
		
		/**
		 * 心跳事件，每一帧广播 
		 */		
		static public const ENTER_FRAME:String = "enterFrame";
		
		static public const COMPLETE:String = "complete";
	}
}