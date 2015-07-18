package chat.protocolHandles
{
    import chat.notices.ChatNotice;

    import jing.framework.manager.notice.NoticeManager;
    import jing.net.Packet;
    import jing.net.server.ByteBuffer;
    import jing.net.server.IProtocolHandles;

    public class UserHandle implements IProtocolHandles
    {
        public function UserHandle()
        {
        }

        public function handle(packet:Packet):void
        {
            var obj:Object = {};
            var buff:ByteBuffer = packet.protoData;
            obj.id = buff.readUnsignedInt();
            obj.online = buff.readUnsignedByte();

            if (obj.online)
            {
                obj.name = buff.readString();

            }

            NoticeManager.sendNotice(new ChatNotice(ChatNotice.USER, obj));
        }
    }
}
