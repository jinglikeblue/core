package jing.turbo.interfaces
{
	import jing.turbo.handle.IHandleDispatcher;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 元素的接口 
	 * @author jing
	 * 
	 */	
	public interface IElement extends IHandleDispatcher
	{
		/**
		 * 位图对象 
		 * @return 
		 * 
		 */		
//		function get bitmap():Bitmap;
		
		/**
		 * 得到负载的引擎 
		 * @return 
		 * 
		 */		
		function get turbo():ITurbo;
		
		/**
		 * 得到舞台 
		 * @return 
		 * 
		 */		
		function get stage():Stage;
		
		/**
		 * 得到名称 
		 * @return 
		 * 
		 */		
		function get name():String;
		
		/**
		 * 设置元素的名称 
		 * @param value
		 * 
		 */		
		function set name(value:String):void;
		
		function set x(value:int):void;
		
		function get x():int;
		
		/**
		 * 相对于夫级的y坐标 
		 * @return 
		 * 
		 */		
		function get y():int;
		
		/**
		 * 相对于夫级的y坐标 
		 * @param value
		 * 
		 */		
		function set y(value:int):void;
		
		/**
		 * 元素的宽度 
		 * @return 
		 * 
		 */		
		function get width():int;
		
		/**
		 * 元素的宽度 
		 * @param value
		 * 
		 */		
		function set width(value:int):void;
		
		/**
		 * 元素的高度 
		 * @return 
		 * 
		 */		
		function get height():int;
		
		/**
		 * 元素的高度 
		 * @param value
		 * 
		 */		
		function set height(value:int):void;
		
		/**
		 * 元素的透明度 
		 * @return 
		 * 
		 */		
		function get alpha():Number;
		
		/**
		 * 元素的透明度 
		 * @param value
		 * 
		 */		
		function set alpha(value:Number):void;
		
		/**
		 * 元素旋转的度数 
		 * @return 
		 * 
		 */		
		function get rotation():Number;
		
		/**
		 * 元素旋转的度数
		 * @param value
		 * 
		 */		
		function set rotation(value:Number):void;
		
		/**
		 * 元素X轴上的缩放值
		 * @return
		 *
		 */
		function get scaleX():Number;
		
		/**
		 * 元素X轴上的缩放值
		 * @param value
		 *
		 */
		function set scaleX(value:Number):void;
		
		/**
		 * 元素Y轴上的缩放值
		 * @return
		 *
		 */
		function get scaleY():Number;
		
		/**
		 * 元素Y轴上的缩放值
		 * @param value
		 *
		 */
		function set scaleY(value:Number):void;
		
		/**
		 * 元素的注册点 
		 * @return 
		 * 
		 */		
		function get centerPoint():Point;
		
		/**
		 * 元素的注册点 
		 * @return 
		 * 
		 */	
		function set centerPoint(value:Point):void;
		
		/**
		 * 是否响应鼠标事件 
		 */
		function get mouseEnable():Boolean;
		
		/**
		 * @private
		 */
		function set mouseEnable(value:Boolean):void;
		
		/**
		 * 是否按钮模式 
		 */
		function get buttonMode():Boolean;
		
		/**
		 * @private
		 */
		function set buttonMode(value:Boolean):void;
		
		/**
		 * 对象是否可见 
		 */
		function get visible():Boolean;
		
		/**
		 * @private
		 */
		function set visible(value:Boolean):void;
		
		/**
		 * 元素位图数据 
		 * @return 
		 * 
		 */		
		function get bitmapData():BitmapData;
		
		function set bitmapData(value:BitmapData):void;
		
		/**
		 * 得到在父级对象中的真实坐标矩形 
		 * @return 
		 * 
		 */		
		function getGraphicRect():Rectangle;
		
		/**
		 * 对指定点进行碰撞测试 
		 * @param x
		 * @param y
		 * 
		 */		
		function hitTestPoint(x:int,y:int):Boolean;
		
		/**
		 * 检测和指定元素的绘制区域有没有碰撞 
		 * @param target 用来做碰撞测试的目标元素
		 * @return 
		 * 
		 */		
		function hitTest(target:IElement):Boolean;
		
		/**
		 * 基于位图的高级别的碰撞测试，更精确，效率消耗也更大 
		 * @param x 
		 * @param y
		 * 
		 */		
		function hitTestPointAdvace(x:int,y:int):Boolean;
		
		/**
		 * 是否正在休眠 
		 * @return 
		 * 
		 */		
		function get isSleeping():Boolean;
		
		/**
		 * 睡眠状态
		 * 启用该方法的时候，对象必须在可不见状态，此时的对象被冻结不更新数据也不更新界面 
		 * 
		 */		
		function sleep():void;
		
		/**
		 * 唤醒 
		 * 将对象从书面状态唤醒
		 * 
		 */		
		function wake():void;
		
		/**
		 * 销毁对象 
		 * 
		 */		
		function destory():void;
		
		/**
		 * 进入下一帧 
		 * 
		 */		
		function enterNextFrame():void;
	}
}