package notices
{
	import jing.framework.manager.notice.Notice;
	
	public class SystemNotice extends Notice
	{
		public function SystemNotice(type:String)
		{
			super(type);
		}
		
		static public const HIDE_WINDOW:String = "System:HideWindow";
	}
}