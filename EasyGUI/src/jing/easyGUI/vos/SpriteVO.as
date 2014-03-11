package jing.easyGUI.vos
{
	/**
	 * 容器VO 
	 * @author Jing
	 * 
	 */	
	public class SpriteVO extends ADisplayObjectVO
	{
		public function SpriteVO():void
		{
			
		}
		
		/**
		 * 定义 
		 */		
		public var define:String = null;
		
		/**
		 * 子对象数据 
		 */		
		public var childSprites:Vector.<ADisplayObjectVO> = new Vector.<ADisplayObjectVO>();
	}
}