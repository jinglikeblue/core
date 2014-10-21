package chat;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Iterator;
import java.util.Map.Entry;

import core.server.Client;
import core.server.interfaces.IProtocolCacher;


public class Chat implements IProtocolCacher
{

	public Chat()
	{
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onCacheProtocol(Client client, short protocolCode, ByteBuffer buff) throws IOException
	{
		short strLen = buff.getShort();
		byte temp[] = new byte[strLen];
		buff.get(temp, 0, strLen);
		//String name = new String(temp, "UTF-8");
		
		int targetId = buff.getInt();
		
		ByteBuffer newBuff = ByteBuffer.allocate(1024);
		newBuff.putShort(strLen);
		newBuff.put(temp);
		
		
		int senderId = 0;
		DataCenter dc = DataCenter.instance();
		Iterator<Entry<Integer, User>> it = dc.userMap.entrySet().iterator();
		while(it.hasNext())
		{
			User tempUser = it.next().getValue();
			if(tempUser.client == client)
			{
				senderId = tempUser.id;
				break;
			}
		}
		
		newBuff.putInt(senderId);
		
		
		if(targetId > 0)
		{		
			newBuff.put((byte)1);
			newBuff.flip();
			dc.userMap.get(targetId).client.sendProtocol((short)2, newBuff);
		}
		else
		{
			newBuff.put((byte)0);
			newBuff.flip();
			dc.dispatchProtocol((short)2, newBuff);
		}
	}

}
