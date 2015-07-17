package chat
{
	import flash.utils.Dictionary;
	
	import interfaces.IProtocolHandles;
	
	import jing.net.Packet;
	import jing.net.server.ByteBuffer;
	import jing.net.server.Server;
	
	public class ChatServer extends Server
	{ 
		private var _handleDic:Dictionary = new Dictionary();
		
		public function ChatServer()
		{
			super();
		}
		
		public function registProtocolHandle(protocolCode:int, handle:IProtocolHandles):void
		{
			_handleDic[protocolCode] = handle;
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
		
		override protected function onAcceptProtocol(packet:Packet):void
		{
			var handle:IProtocolHandles =  _handleDic[packet.protoId];
			if(null != handle)
			{
				handle.handle(packet.protoData);
			}
			else
			{
				trace("协议号 " + packet.protoId + " 没有对应的处理!");
			}
		}
		
		override public function sendProtocol(protocolCode:int, ba:ByteBuffer):void
		{
			if(false == isConnected)
			{
				return;
			}
			super.sendProtocol(protocolCode, ba);
		}
	}
}