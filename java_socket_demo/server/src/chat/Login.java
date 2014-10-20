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
		short strLen = buf.getShort();
		byte temp[] = new byte[strLen];
		buf.get(temp, 0, strLen);
		String name = new String(temp, "UTF-8");
		
		// TODO Auto-generated method stub
		DataCenter dc = DataCenter.instance();
		//生成ID
		int newId = dc.idFlag + 1;
		dc.userMap.put(newId, new User(newId, name, client));		


		//通知所有玩家有用户登陆
		ByteBuffer buff = ByteBuffer.allocate(1024);
		buff.putInt(newId);
		buff.put((byte)1);
		buff.putShort(strLen);
		buff.put(temp);
		buff.flip();
		Server.instance().dispatchProtocol((short)1, buff);
		
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
		
		//通知所有玩家有用户离线
	}



}
