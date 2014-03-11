package jing.ui.yrtlib.compment.events
{
	import flash.events.Event;
	
	/**
	 * 数据模型事件 
	 * @author jing
	 * 
	 */	
	public class ModelEvent extends Event
	{
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 * 状态改变 
		 */		
		static public const STATE_CHANGED:String = "StateChanged";
	}
}