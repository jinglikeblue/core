package jing.turbo.strip.vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 连环画的数据 
	 * @author jing
	 * 
	 */	
	public class StripVO
	{
		public function StripVO():void
		{
			
		}
		
		/**
		 * 连环画的数据 
		 */		
		public var pictures:Vector.<BitmapData> = null;
		
		/**
		 * 注册点X
		 */		
		public var originX:int = 0;
		
		/**
		 * 注册点Y
		 */		
		public var originY:int = 0;
		
		/**
		 * 连环画的帧数 
		 */		
		public var length:int = 0;
		
		/**
		 * 连环画的名字 
		 */		
		public var name:String = null;
	}
}