package jing.map.vo
{
	import flash.display.BitmapData;

	/**
	 * 和系统交互的数据类型接口 
	 * @author jing
	 * 
	 */	
	public class IODataVO
	{
		public function IODataVO():void
		{
			
		}
		
		public var mapInfo:XML = null;
		public var mapLogic:BitmapData = null;		
	}
}