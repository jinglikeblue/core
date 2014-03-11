package jing.easyGUI.vos
{
	public class ADisplayObjectVO
	{
		public function ADisplayObjectVO():void
		{
			
		}
		
		public var name:String = "";
		/**
		 * 显示对象的类型 
		 */		
		public var type:String;
		
		/**
		 * 坐标X 
		 */		
		public var x:int;
		
		/**
		 * 坐标Y 
		 */		
		public var y:int;
		
		/**
		 * 索引位置 
		 */		
		public var childIndex:int;
		
		/**
		 * 宽度 
		 */		
		public var width:int;
		
		/**
		 * 高度 
		 */		
		public var height:int;
		
		/**
		 * 透明度 
		 */		
		public var alpha:Number = 1;
	}
}