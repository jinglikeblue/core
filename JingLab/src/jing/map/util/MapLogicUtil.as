package jing.map.util
{
	public class MapLogicUtil
	{
		static private const COLOR_TO_VALUE_DIC:Object = 
			{
				0x000000:0, //不可通过
				0x00FF00:1  //可通过
			};
		
		static private const VALUE_TO_COLOR_DIC:Object = 
			{
				0:0x000000,
				1:0x00FF00
			};
		
		/**
		 * 将地图逻辑图中的颜色转换为值 
		 * @param color
		 * @return 
		 * 
		 */		
		static public function colorToValue(color:uint):int
		{
			return COLOR_TO_VALUE_DIC[color];
		}
		
		/**
		 * 将值转换为地图逻辑图中的颜色 
		 * @param value
		 * @return 
		 * 
		 */		
		static public function valueToColor(value:int):uint
		{
			return VALUE_TO_COLOR_DIC[value];
		}
		
		static public const CAN_NOT_PASS:int = 0;
		static public const CAN_PASS:int = 1;
	}
}