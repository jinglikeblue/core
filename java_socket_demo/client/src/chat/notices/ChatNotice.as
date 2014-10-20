package chat.notices
{
	import jing.framework.manager.notice.Notice;
	
	public class ChatNotice extends Notice
	{
		private var _data:*;
		public function get data():*
		{
			return _data;
		}
		
		public function ChatNotice(type:String, data:* = null)
		{
			_data = data;
			super(type);
		}
		
		static public const USER:String = "user";
		static public const MSG:String = "msg";
	}
}