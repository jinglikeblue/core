package chat;

import java.io.IOException;
import java.nio.ByteBuffer;

import core.net.Client;
import core.net.interfaces.IProtocolCacher;


public class Chat implements IProtocolCacher
{

	public Chat()
	{
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onCacheProtocol(Client client, short protocolCode, ByteBuffer data) throws IOException
	{
		
		
		// TODO Auto-generated method stub
		switch(protocolCode)
		{
//			case Protocol.PROTOCOL_C2S.LOGIN:
//				break;
		}
	}

}
