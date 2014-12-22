
package chat.cachers;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Iterator;
import java.util.Map.Entry;

import chat.DataCenter;
import core.events.EventDispatcher;
import core.events.IEventListener;
import core.server.Client;
import core.server.Server;
import core.server.interfaces.IProtocolCacher;

public class Login implements IProtocolCacher, IEventListener
{

	public Login()
	{
		Server.instance().addEventListener(Server.EVENT.CLIENT_DISCONNECT.name(), this);
	}

	@Override
	public void onCacheProtocol(Client client, short protocolCode, ByteBuffer buf) throws IOException
	{
		// 验证name
		short strLen = buf.getShort();
		byte temp[] = new byte[strLen];
		buf.get(temp, 0, strLen);
		String name = new String(temp, "UTF-8");

		DataCenter dc = DataCenter.instance();

		// 将所有的玩家发送给这个用户
		Iterator<Entry<Integer, User>> it = dc.getUserIterator();
		while(it.hasNext())
		{
			User user = it.next().getValue();
			byte nameByte[] = user.name.getBytes("UTF-8");

			ByteBuffer userBuff = ByteBuffer.allocate(100);
			userBuff.putInt(user.id);
			userBuff.put((byte)1);
			userBuff.putShort((short)nameByte.length);
			userBuff.put(nameByte);
			userBuff.flip();
			client.sendProtocol((short)1, userBuff);
		}

		dc.idFlag += 1;
		// 生成ID
		int newId = dc.idFlag;
		dc.putUser(new User(newId, name, client));

		// 通知所有玩家有用户登陆
		ByteBuffer buff = ByteBuffer.allocate(1024);
		buff.putInt(newId);
		buff.put((byte)1);
		buff.putShort(strLen);
		buff.put(temp);
		buff.flip();
		dc.dispatchProtocol((short)1, buff);
	}

	@Override
	public void onReciveEvent(String type, EventDispatcher dispatcher, Object data)
	{
		if(type == Server.EVENT.CLIENT_DISCONNECT.name())
		{
			Client client = (Client)data;			

			DataCenter dc = DataCenter.instance();
			User user = dc.getUser(client);
			
			if(null != user)
			{			
				// 通知所有玩家有用户离线
				ByteBuffer buff = ByteBuffer.allocate(1024);
				buff.putInt(user.id);
				buff.put((byte)0);
				buff.flip();
				dc.dispatchProtocol((short)1, buff);
				
				dc.removeUser(user);;
			}
		}
		
	}

}
