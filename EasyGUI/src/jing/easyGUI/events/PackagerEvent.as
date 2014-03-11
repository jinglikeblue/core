package jing.easyGUI.events
{
	import flash.events.Event;
	
	/**
	 * 打包事件 
	 * @author Jing
	 * 
	 */	
	public class PackagerEvent extends Event
	{
		private var _guiXML:XML;

		public function get guiXML():XML
		{
			return _guiXML;
		}

		
		public function PackagerEvent(type:String, guiXML:XML = null)
		{
			_guiXML = guiXML;
			super(type);
		}
		
		/**
		 * 完成打包 
		 */		
		static public const COMPLETE:String = "Complete";
	}
}