package chat.protocolHandles
{
	import chat.notices.ChatNotice;
	
	import interfaces.IProtocolHandles;
	
	import jing.framework.manager.notice.NoticeManager;
	import jing.net.server.ByteBuffer;
	
	public class UserHandle implements IProtocolHandles
	{
		public function UserHandle()
		{
		}
		
		public function handle(buff:ByteBuffer):void
		{
			var obj:Object = {};
			obj.id = buff.readUnsignedInt();
			obj.online = buff.readUnsignedByte();
			if(obj.online)
			{
				obj.name = buff.readString();
				
			}
			
			NoticeManager.sendNotice(new ChatNotice(ChatNotice.USER, obj));
		}
	}
}