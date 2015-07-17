package chat.protocolHandles
{
	import chat.notices.ChatNotice;
	
	import interfaces.IProtocolHandles;
	
	import jing.framework.manager.notice.NoticeManager;
	import jing.net.server.ByteBuffer;
	
	public class MsgHandle implements IProtocolHandles
	{
		public function MsgHandle()
		{
		}
		
		public function handle(buff:ByteBuffer):void
		{
			var obj:Object = {};
			obj.msg = buff.readString();
			obj.sender = buff.readUnsignedInt();
			obj.isWhisper = buff.readUnsignedByte();
			
			NoticeManager.sendNotice(new ChatNotice(ChatNotice.MSG, obj));
		}
	}
}