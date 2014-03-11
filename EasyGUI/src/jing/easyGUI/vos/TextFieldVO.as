package jing.easyGUI.vos
{
	/**
	 * 文本对象VO 
	 * @author Jing
	 * 
	 */	
	public class TextFieldVO extends ADisplayObjectVO
	{
		public function TextFieldVO():void
		{
			
		}
		
		/**
		 * 内容 
		 */		
		public var content:String = "";
		
		/**
		 * 文本颜色 
		 */		
		public var color:uint;
		
		/**
		 * 字体名称 
		 */		
		public var fontName:String;
		
		/**
		 * 字体大小 
		 */		
		public var fontSize:Number;
	}
}