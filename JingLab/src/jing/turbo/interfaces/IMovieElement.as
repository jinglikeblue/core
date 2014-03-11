package jing.turbo.interfaces
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * 动画元素接口 
	 * @author jing
	 * 
	 */	
	public interface IMovieElement extends IElement
	{
		/**
		 * 取得当前包含的所有图像的总数
		 * 和frameOrderList的长度不同
		 * @return
		 *
		 */
		function get frameCount():int;
		
		function get bmds():Vector.<BitmapData>;
		
		function set bmds(value:Vector.<BitmapData>):void;
		
		function get curremtFrame():int;
		
		function get isBackwards():Boolean;
			
		function set isBackwards(value:Boolean):void;
		
		function get frameOrderList():Array;
		
		function set frameOrderList(value:Array):void;
		
		function gotoAndPlay(frameIndex:int):void;
		
		function gotoAndStop(frameIndex:int):void;
		
		function play():void;
		
		function stop():void;
		
		function prevFrame():void;
		
		function nextFrame():void;
	}
}