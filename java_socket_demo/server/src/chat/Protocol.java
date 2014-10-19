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
		 * 大厅聊天
		 * int16 内容长度
		 * String 内容
		 */
		HALL_CHAT,
		/**
		 * 悄悄话
		 * int32 目标ID
		 * int16 内容长度
		 * String 内容
		 */
		WHISPER
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
		 * 玩家信息
		 * byte 是否在线 0 or 1
		 * int16 名字长度
		 * String 名字
		 */
		USER,
		/**
		 * 收到的消息
		 * int32 发送者ID,0表示大厅消息
		 * int16 内容长度
		 * String 内容
		 */
		MSG
	}
	
	
	private Protocol()
	{
		// TODO Auto-generated constructor stub
	}

}
