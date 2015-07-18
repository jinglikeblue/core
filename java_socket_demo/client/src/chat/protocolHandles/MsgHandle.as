package chat.protocolHandles
{
	import chat.notices.ChatNotice;
	
	import jing.framework.manager.notice.NoticeManager;
	import jing.net.Packet;
	import jing.net.server.ByteBuffer;
	import jing.net.server.IProtocolHandles;
	
	public class MsgHandle implements IProtocolHandles
	{
		public function MsgHandle()
		{
		}
		
		public function handle(packet:Packet):void
		{
			var obj:Object = {};
			var buff:ByteBuffer = packet.protoData;			
			obj.msg = buff.readString();
			obj.sender = buff.readUnsignedInt();
			obj.isWhisper = buff.readUnsignedByte();
			
			NoticeManager.sendNotice(new ChatNotice(ChatNotice.MSG, obj));
		}
	}
}