package chat;

import java.io.IOException;
import java.nio.ByteBuffer;

import core.events.EventDispatcher;
import core.events.IEventListener;
import core.net.Client;
import core.net.Server;
import core.net.interfaces.IProtocolCacher;


public class Login implements IProtocolCacher,IEventListener
{

	public Login()
	{
		// TODO Auto-generated constructor stub
		Server.instance().addEventListener(Server.EVENT.CLIENT_DISCONNECT.name(), this);
	}

	@Override
	public void onCacheProtocol(Client client, short protocolCode, ByteBuffer buf) throws IOException
	{
		// TODO Auto-generated method stub
		
		short strLen = buf.getShort();
		byte temp[] = new byte[strLen];
		buf.get(temp, 0, strLen);
		String receivedString = null;

		receivedString = new String(temp, "UTF-8");

		System.out.println("接收来自" + client.channel().socket().getRemoteSocketAddress() + "的信息:" + receivedString);
		
		buf.position(4);
		client.sendProtocol((short) 1, buf.slice());
	}

	@Override
	public void onReciveEvent(String type, EventDispatcher dispatcher, Object data)
	{
		// TODO Auto-generated method stub
		if(type == Server.EVENT.CLIENT_DISCONNECT.name())
		{
			Client client = (Client)data;
			client.channel().socket().getLocalAddress();
		}
	}



}
