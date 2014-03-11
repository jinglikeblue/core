package jing.p2p.events
{
	import flash.events.Event;
	
	public class StreamEvent extends Event
	{
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		public function StreamEvent(type:String, data:Object = null)
		{
			_data = data;
			super(type);
		}
		
		static public const PLAY_START:String = "PlayStart";
		static public const PLAY_FAILED:String = "PlayFailed";
		static public const PLAY_UNPUBLISH_NOTIFY:String = "PlayUnpublishNotify";
		
		static public const ON_PEER_CONNECT:String = "OnPeerConnect";
		
		static public const PUBLISH_START:String = "PublishStart";
	}
}