package jing.turbo.interfaces
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * 引擎方法接口 
	 * @author jing
	 * 
	 */	
	public interface ITurbo
	{
		/**
		 * 引擎容器 
		 * @return 
		 * 
		 */		
		function get buildBox():Sprite;
		
		/**
		 * 初始化引擎 
		 * @param w
		 * @param h
		 * @param color
		 * @param alpha
		 * 
		 */		
		function config(w:uint,h:uint,color:uint = 0, alpha:Number = 0):void;
		
		/**
		 * 启动引擎 
		 * 
		 * @parent 父显示对象
		 */		
		function startup(parent:DisplayObjectContainer = null):void;
		
		/**
		 * 关闭引擎 
		 * 
		 */		
		function shutdown():void;
		
		/**
		 * 添加一个元素到引擎显示列表中
		 * @param ele
		 *
		 */	
		function addElement(ele:IElement):void;
		
		/**
		 * 从引擎中移除一个显示元素 
		 * @param ele
		 * 
		 */		
		function removeElement(ele:IElement):void;
		
		/**
		 * 从引擎中删除指定索引位置的元素
		 * @param index
		 *
		 */
		function removeElementAt(index:int):void;
		
		/**
		 * 在指定索引位置插入元素 
		 * @param ele
		 * @param childIndex
		 * @return 
		 * 
		 */		
		function addElementAt(ele:IElement, childIndex:int):void;
			
		/**
		 * 获取元素的索引位置 
		 * @param child
		 * 
		 */		
		function getElementIndex(ele:IElement):int;
		
		/**
		 * 获取指定索引位置的元素
		 * @param childIndex
		 * @return
		 *
		 */
		function getElementAt(childIndex:int):IElement;
		
		
		/**
		 * 得到显示元素数量
		 * @return
		 *
		 */
		function get numElements():uint;
		
		/**
		 * 引擎占用宽度 
		 * @return 
		 * 
		 */		
		function get width():Number;
		
		/**
		 * 引擎占用高度 
		 * @return 
		 * 
		 */		
		function get height():Number;
	}
}