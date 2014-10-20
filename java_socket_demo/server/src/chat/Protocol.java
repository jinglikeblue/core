package chat;


public class Protocol
{
	/**
	 * 客户端到服务器的协议
	 * @author Jing
	 *
	 */
	public static enum PROTOCOL_C2S
	{
		NONE,
		/**
		 * 玩家登陆
		 * int16 名字长度
		 * String 名字
		 */
		LOGIN,
		/**
		 * uint16 消息长度
 		 * string 消息
	 	 * uint32 目标ID，0表示大厅聊天
		 */
		CHAT,
	}
	
	/**
	 * 服务器到客户端的协议
	 * @author Jing
	 *
	 */
	public static enum PROTOCOL_S2C
	{
		NONE,
		/**
			uint32 ID
			int8 是否在线
			uint16 名字长度(仅在线时存在)
			string 名字(仅在线时存在)
		 */
		USER,
		/**
			uint16 消息长度
			string  消息
			uint32 发送者ID
			int8 是否是悄悄话
		 */
		MSG
	}
	
	
	private Protocol()
	{
		// TODO Auto-generated constructor stub
	}

}
