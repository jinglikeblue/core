package jing.framework.core.view.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * 所有和显示有关的对象通过实现该接口可以管理显示内容的呈现和隐藏
	 * @author Jing
	 *
	 */
	public interface IView extends IEventDispatcher
	{
		/**
		 * 得到现实对象的图形元素
		 * @return
		 *
		 */
		function get gui():DisplayObject;

		/**
		 * 显示对象
		 * @param container 显示对象的容器
		 * @param x 对象的X坐标
		 * @param y 对象的Y坐标
		 *
		 */
		function show(container:DisplayObjectContainer, x:int = int.MAX_VALUE, y:int = int.MAX_VALUE, modal:Boolean = false):void;

		
		/**
		 * 显示对象
		 * @param container 显示对象的容器
		 * @param childIndex 对象的深度
		 * @param x 对象的X坐标
		 * @param y 对象的Y坐标
		 */
		function showAt(container:DisplayObjectContainer, childIndex:int, x:int = int.MAX_VALUE, y:int = int.MAX_VALUE, modal:Boolean = false):void
		
		/**
		 * 关闭对象
		 * !!对象只是从舞台上移除并没有被销毁，如果需要销毁对象，请使用destory方法
		 *
		 */
		function close():void;

		/**
		 * 销毁对象数据
		 * !!只有在确定该对象不再使用时才执行
		 *
		 */
		function destroy():void;


		//---------------------------------------------------------------------------------------------------------------
		
		function set filters(array:Array):void;

		function get filters():Array;

		function set width(w:Number):void;
		function get width():Number;
		function set height(h:Number):void;
		function get height():Number;		
		function set alpha(value:Number):void;
		function get alpha():Number;
		function set scaleX(value:Number):void;
		function get scaleX():Number;
		function set scaleY(value:Number):void;
		function get scaleY():Number;
		function set scrollRect(rect:Rectangle):void;
		function get scrollRect():Rectangle;
		function set visible(b:Boolean):void;
		function get visible():Boolean;
		function set x(x:Number):void;
		function get x():Number;
		function set y(y:Number):void;
		function get y():Number;
		function get mouseX():Number;
		function get mouseY():Number;

	}
}