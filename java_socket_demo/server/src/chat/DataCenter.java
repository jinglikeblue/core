
package chat;

import java.util.HashMap;

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

}
