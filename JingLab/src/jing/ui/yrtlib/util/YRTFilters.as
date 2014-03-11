package jing.ui.yrtlib.util
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class YRTFilters
	{
		public static var filter1:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.3, 0.3, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0, 0, 0, 1, 1]);
		public static var filter2:GlowFilter = new GlowFilter(0, 1, 2, 2, 4, 1);
		public static var filter3:DropShadowFilter = new DropShadowFilter(4);
		public static var filter6:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 45, 0, 1, 0, 0, 45, 0, 0, 1, 0, 45, 0, 0, 0, 1, 0]);
		public static var dropFilter:DropShadowFilter = new DropShadowFilter(0, 45, 0, 1, 2, 2, 10);
	}
}