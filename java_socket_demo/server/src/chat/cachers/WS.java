package chat.cachers;

import java.io.IOException;

import chat.Protocol;
import chat.Protocol.PROTOCOL_S2C;
import core.net.server.Client;
import core.net.server.interfaces.IPacket;
import core.net.server.interfaces.IProtocolCacher;


public class WS implements IProtocolCacher
{

	@Override
	public void onCacheProtocol(Client client, IPacket packet) throws IOException
	{
		client.sendProtocol(Protocol.toShort(PROTOCOL_S2C.WS_SHAKE), packet.getProtoData());
		

	}

}
