package jing.turbo.handle
{

	/**
	 * 鼠标事件 
	 * @author Jing
	 * 
	 */	
	public class MouseHandle extends Handle
	{
		public function MouseHandle(type:String)
		{
			super(type);
		}
		
		/**
		 * 鼠标点击 
		 */		
		static public const CLICK:String = "click";
	}
}