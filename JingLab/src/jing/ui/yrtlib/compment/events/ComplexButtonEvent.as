package jing.ui.yrtlib.compment.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComplexButtonEvent extends MouseEvent
	{
		public function ComplexButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 按钮点下 
		 */		
		static public const BUTTON_DOWN:String = "ButtonDown";
		
		/**
		 * 按钮单击 
		 */		
		static public const BUTTON_CLICK:String = "ButtonClick";
		
		/**
		 * 按钮双击 
		 */		
		static public const BUTTON_DOUBLE_CLICK:String = "ButtonDoubleClick";
	}
}