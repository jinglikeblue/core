package jing.map.events
{
	import jing.map.vo.MapInfoVO;
	
	import flash.events.Event;

	/**
	 * 地图加载完毕广播的事件 
	 * @author jing
	 * 
	 */	
	public class MapLoadToolEvent extends Event
	{
		private var _mapInfoVO:MapInfoVO = null;

		public function get mapInfoVO():MapInfoVO
		{
			return _mapInfoVO;
		}

		public function MapLoadToolEvent(type:String,mapInfoVO:MapInfoVO = null)
		{
			_mapInfoVO = mapInfoVO;
			super(type, false, false);
		}
		
		/**
		 * 加载完毕 
		 */		
		static public const COMPLETE:String = "MapLoadedToolEvent:Complete";
		
		/**
		 * 加载失败 
		 */		
		static public const ERROR:String = "MapLoadedToolEvent:Error";
	}
}