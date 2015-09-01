
package chat;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.Vector;

import core.net.server.Client;

/**
 * 数据中心
 * 
 * @author Jing
 */
public class DataCenter
{

	static private DataCenter _instance = null;

	static public DataCenter instance()
	{
		if(null == _instance)
		{
			_instance = new DataCenter();
		}
		return _instance;
	}

	private DataCenter()
	{

	}

	public int idFlag = 0;

	private HashMap<Client, User> _client2UserMap = new HashMap<Client, User>();

	private HashMap<Integer, User> _id2UserMap = new HashMap<Integer, User>();

	/**
	 * 是否指定的客户端已连接
	 * @param client
	 * @return
	 */
	public boolean containsClient(Client client)
	{
		return _client2UserMap.containsKey(client);
	}
	
	/**
	 * 增添一个玩家
	 * 
	 * @param user
	 */
	public void putUser(User user)
	{		
		_client2UserMap.put(user.client, user);
		_id2UserMap.put(user.id, user);
	}

	/**
	 * 通过ID获取玩家
	 * 
	 * @param id
	 * @return
	 */
	public User getUser(Integer id)
	{
		return _id2UserMap.get(id);
	}

	/**
	 * 通过客户端连接获取玩家
	 * 
	 * @param client
	 * @return
	 */
	public User getUser(Client client)
	{
		return _client2UserMap.get(client);
	}

	/**
	 * 移除玩家
	 * 
	 * @param user
	 */
	public void removeUser(User user)
	{
		_id2UserMap.remove(user.id);
		_client2UserMap.remove(user.client);
	}

	/**
	 * 获取玩家列表迭代器
	 * 
	 * @return
	 */
	public Iterator<Entry<Integer, User>> getUserIterator()
	{
		return _id2UserMap.entrySet().iterator();
	}

	/**
	 * 广播协议
	 * 
	 * @param protocolCode 协议号
	 * @param buff
	 */
	public void dispatchProtocol(short protocolCode, ByteBuffer buff, Vector<User> blackList)
	{
		Iterator<Entry<Client, User>> iter = _client2UserMap.entrySet().iterator();
		while(iter.hasNext())
		{
			User user = iter.next().getValue();
			if(null != blackList && blackList.contains(user))
			{
				continue;
			}
			user.client.sendProtocol(protocolCode, buff);
			buff.flip();
		}
	}

}
