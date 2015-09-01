
package chat.cachers;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.Vector;

import chat.DataCenter;
import chat.Protocol;
import chat.Protocol.PROTOCOL_S2C;
import chat.User;
import core.events.EventDispatcher;
import core.events.IEventListener;
import core.net.server.Client;
import core.net.server.Server;
import core.net.server.interfaces.IPacket;
import core.net.server.interfaces.IProtocolCacher;

public class Login implements IProtocolCacher, IEventListener
{

	public Login()
	{
		Server.instance().addEventListener(Server.EVENT.CLIENT_DISCONNECT.name(), this);
	}

	@Override
	public void onCacheProtocol(Client client, IPacket packet) throws IOException
	{
		DataCenter dc = DataCenter.instance();
		if(dc.containsClient(client))
		{
			System.out.println("用户不能重复登录！");
			client.dispose();
			return;
		}
		ByteBuffer data = ByteBuffer.wrap(packet.getProtoData());
		short nameLen = data.getShort();
		byte[] nameBytes = new byte[nameLen];
		data.get(nameBytes);
		String name = new String(nameBytes, "UTF-8");

		dc.idFlag += 1;
		// 生成ID
		int newId = dc.idFlag;
		User me = new User(newId, name, client);
		dc.putUser(me);

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
			client.sendProtocol(Protocol.toShort(PROTOCOL_S2C.USER), userBuff);
		}

		// 通知所有玩家有用户登陆
		ByteBuffer buff = ByteBuffer.allocate(nameLen + 20);
		buff.putInt(newId);
		buff.put((byte)1);
		buff.putShort(nameLen);
		buff.put(nameBytes);
		buff.flip();
		Vector<User> blackList = new Vector<User>();
		blackList.add(me);
		dc.dispatchProtocol(Protocol.toShort(PROTOCOL_S2C.USER), buff, blackList);
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
				dc.removeUser(user);
				// 通知所有玩家有用户离线
				ByteBuffer buff = ByteBuffer.allocate(1024);
				buff.putInt(user.id);
				buff.put((byte)0);
				buff.flip();
				dc.dispatchProtocol(Protocol.toShort(PROTOCOL_S2C.USER), buff, null);

			}
		}

	}

}
