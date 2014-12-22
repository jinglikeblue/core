
package chat;

import java.io.IOException;
import java.nio.ByteBuffer;

import core.server.Client;
import core.server.interfaces.IProtocolCacher;

public class Chat implements IProtocolCacher
{

	public Chat()
	{

	}

	@Override
	public void onCacheProtocol(Client client, short protocolCode, ByteBuffer buff) throws IOException
	{
		short strLen = buff.getShort();
		byte temp[] = new byte[strLen];
		buff.get(temp, 0, strLen);
		// String name = new String(temp, "UTF-8");

		int targetId = buff.getInt();

		ByteBuffer newBuff = ByteBuffer.allocate(1024);
		newBuff.putShort(strLen);
		newBuff.put(temp);

		DataCenter dc = DataCenter.instance();
		int senderId = dc.getUser(client).id;

		newBuff.putInt(senderId);

		if(targetId > 0)
		{
			newBuff.put((byte)1);
			newBuff.flip();
			dc.getUser(targetId).client.sendProtocol((short)2, newBuff);
		}
		else
		{
			newBuff.put((byte)0);
			newBuff.flip();
			dc.dispatchProtocol((short)2, newBuff);
		}
	}

}
