package chat
{
	import flash.utils.Dictionary;
	
	import jing.net.server.ByteBuffer;
	import jing.net.server.Server;
	
	public class ChatServer extends Server
	{ 
		private var _handleDic:Dictionary = new Dictionary();
		
		public function ChatServer()
		{
			super();
		}
		
		public function login(name:String):void
		{
			var buff:ByteBuffer = new ByteBuffer();
			buff.writeString(name);
			sendProtocol(1, buff);
		}
		
		public function chat(msg:String, targetId:int = 0):void
		{
			var buff:ByteBuffer = new ByteBuffer();
			buff.writeString(msg);
			buff.writeUnsignedInt(targetId);
			sendProtocol(2, buff);
		}
	}
}