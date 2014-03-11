package jing.framework.core.events
{
	import flash.events.Event;
	
	/**
	 * 显示基类的事件 
	 * @author jing
	 * 
	 */	
	public class ViewBaseEvent extends Event
	{
		public function ViewBaseEvent(type:String)
		{
			super(type, false, false);
		}
		
		//--------------------------------------------------------------------------------
				
		static public const SHOWED:String = "Showed";
		static public const CLOSED:String = "Closed";
		static public const DESTROYED:String = "Destroyed";
	}
}