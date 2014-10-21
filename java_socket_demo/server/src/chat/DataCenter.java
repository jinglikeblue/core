
package chat;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

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
	public HashMap<Integer, User> userMap = new HashMap<Integer, User>();
	
	/**
	 * 广播协议
	 * @param protocolCode 协议号
	 * @param buff
	 */
	public void dispatchProtocol(short protocolCode, ByteBuffer buff)
	{
		Iterator<Entry<Integer, User>> iter = userMap.entrySet().iterator();
		while(iter.hasNext())
		{
			User user = iter.next().getValue();			
			user.client.sendProtocol(protocolCode, buff);
			buff.flip();			
		}
	}

}
