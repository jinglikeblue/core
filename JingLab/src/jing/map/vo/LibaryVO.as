package jing.map.vo
{
	import flash.display.BitmapData;

	/**
	 * 图像数据对象 
	 * @author jing
	 * 
	 */	
	public class LibaryVO
	{				
		public function LibaryVO():void
		{
			
		}
		
		/**
		 * X轴偏移量 
		 */		
		public var offX:int = 0;
		
		/**
		 * Y轴偏移量 
		 */		
		public var offY:int = 0;
		
		/**
		 * 图像的源(唯一标识符，可以当做ID) 
		 */		
		public var path:String = null;
		
		/**
		 * 图像的数据 
		 */		
		public var bmd:BitmapData = null;
	}
}