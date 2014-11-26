package jing.net.server
{
	import flash.events.Event;
	
	/**
	 * 客户端事件 
	 * @author Jing
	 * 
	 */	
	public class ServerEvent extends Event
	{
		private var _data:*;
		/**
		 * 携带的数据 
		 * @return 
		 * 
		 */		
		public function get data():*
		{
			return _data;
		}
			
		public function ServerEvent(type:String, data:* = null)
		{
			_data = data;
			super(type);
		}
		
		/**
		 * 连接成功 
		 */		
		static public const CONNECT_SUCCESS:String = "connect_success";
		
		/**
		 * 连接失败 
		 */		
		static public const CONNECT_FAIL:String = "connect_fail"
		
		/**
		 * 连接断开 
		 */		
		static public const CLOSED:String = "closed";
		
		/**
		 * 接收到协议包 
		 * data数据结构
		 * {
		 * 		id:int	//协议号
		 * 		data:ByteBuffer //协议数据内容
		 * }
		 */		
		static public const ACCEPT_PROTOCOL:String = "accpet_protocol";
	}
}