package chat
{
	import flash.utils.Dictionary;
	
	import interfaces.IProtocolHandles;
	
	import net.server.ByteBuffer;
	import net.server.Server;
	
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
		
		override protected function onAcceptProtocol(protocolCode:int, data:ByteBuffer):void
		{
			var handle:IProtocolHandles =  _handleDic[protocolCode];
			if(null != handle)
			{
				handle.handle(data);
			}
			else
			{
				trace("协议号 " + protocolCode + " 没有对应的处理!");
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