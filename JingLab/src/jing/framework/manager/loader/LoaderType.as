package jing.framework.manager.loader
{
	/**
	 * 加载的数据类型 
	 * @author Jing
	 * 
	 */	
	public class LoaderType
	{
		/**
		 * 显示对象类型，如SWF、图片等 
		 * 如果有回调函数，回调函数得到的对象参数类型为[DisplayObject]
		 */		
		static public var DISPLAY:int = 0;
		
		/**
		 * 加载数据类型的文件 
		 * 如果有回调函数，回调函数得到的对象参数类型为[Ojbect]
		 */		
		static public var BYTES:int = 1;
		
		/**
		 * 加载txt文本文件 
		 * 如果有回调函数，回调函数得到的对象参数类型为[Object]
		 */		
		static public var TEXT:int = 2;
	}
}