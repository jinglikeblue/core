package jing.net.server
{
    import jing.net.Packet;
    import jing.net.server.ByteBuffer;

    /**
     * 协议处理器
     * @author Jing
     *
     */
    public interface IProtocolHandles
    {
        function handle(packet:Packet):void;
    }
}
