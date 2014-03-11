package jing.framework.manager.notice
{
	public class Notice
	{
		private var _type:String;
		
		public function get type():String
		{
			return _type;
		}
		
		public function Notice(type:String)
		{
			_type = type;
		}
	}
}