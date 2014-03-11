package jing.p2p.events
{
	import flash.events.Event;
	
	public class ConnectionEvent extends Event
	{
		
		
		public function ConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		static public const STATUS_CONNECT_SUCCESS:String = "StatusConnectSuccess";
		static public const STATUS_CONNECT_FAILED:String = "StatusConnectFailed";
		static public const STATUS_CONNECT_CLOSED:String = "StatusConnectClosed";
	}
}