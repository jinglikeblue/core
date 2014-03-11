package jing.ui.yrtlib.compment.events
{
	import flash.events.Event;
	
	public class ButtonBarEvent extends Event
	{
		private var _data:Object;
		
		public function ButtonBarEvent(type:String, data:Object)
		{
			super(type);
			_data = data;
		}
		/**
		 * 更改选项 
		 */
		static public const CHANGE_SELECT:String = "change select";
	}
}