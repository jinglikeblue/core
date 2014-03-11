package jing.utils.img
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 *混合位图生成带ALPHA通道的位图
	 * @author jing
	 *
	 */
	public class JPGMixer
	{
		public function JPGMixer()
		{
		}
		
		/**
		 * 混合位图生成带ALPHA通道的位图
		 * 效率更高
		 * @param sourceBMD
		 * @param alphaBMD
		 * @param mixRect 要混合的图形的区域,不设置则默认为全部
		 * @return
		 * 
		 */		
		static public function mixPlus(sourceBMD:BitmapData, alphaBMD:BitmapData, mixRect:Rectangle = null):BitmapData
		{
			var time:int = getTimer();
			
			var rect:Rectangle = new Rectangle(0, 0, sourceBMD.width, sourceBMD.height);
			var bmd:BitmapData = new BitmapData(sourceBMD.width, sourceBMD.height, true, 0);
			bmd.copyPixels(sourceBMD, rect, new Point());
			
			if (null == mixRect)
			{
				mixRect = rect;
			}
			
			bmd.copyChannel(alphaBMD,mixRect,new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			
//			trace("效率消耗:", getTimer() - time);
			return bmd;
		}
	}
}