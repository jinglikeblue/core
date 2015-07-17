
package chat.cachers;

import java.io.IOException;
import java.nio.ByteBuffer;

import chat.DataCenter;
import chat.Protocol;
import chat.Protocol.PROTOCOL_S2C;
import core.net.Packet;
import core.net.server.Client;
import core.net.server.Server;
import core.net.server.interfaces.IProtocolCacher;

public class Chat implements IProtocolCacher
{

	public Chat()
	{

	}

	@Override
	public void onCacheProtocol(Client client, Packet packet) throws IOException
	{
		// String name = new String(temp, "UTF-8");
		ByteBuffer data = ByteBuffer.wrap(packet.getProtoData());
		short msgLen = data.getShort();
		byte[] msgBA = new byte[msgLen];
		data.get(msgBA);
		int targetId = data.getInt();

		DataCenter dc = DataCenter.instance();
		int senderId = dc.getUser(client).id;

		ByteBuffer newBuff = ByteBuffer.allocate(Server.instance().buffSize());
		newBuff.putShort(msgLen);
		newBuff.put(msgBA);
		newBuff.putInt(senderId);

		if(targetId > 0)
		{
			newBuff.put((byte)1);
			newBuff.flip();
			dc.getUser(targetId).client.sendProtocol(Protocol.toShort(PROTOCOL_S2C.MSG), newBuff);
		}
		else
		{
			newBuff.put((byte)0);
			newBuff.flip();
			dc.dispatchProtocol(Protocol.toShort(PROTOCOL_S2C.MSG), newBuff, null);
		}
	}

}
