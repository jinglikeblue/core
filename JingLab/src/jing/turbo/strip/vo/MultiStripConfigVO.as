package jing.turbo.strip.vo
{
	public class MultiStripConfigVO
	{
		public function MultiStripConfigVO():void
		{
			
		}
		
		/**
		 * 单格图片的宽度 
		 */		
		public var unitW:int = 0;
		
		/**
		 * 单格图片的高度 
		 */	
		public var unitH:int = 0;
		
		/**
		 * 注册点的X坐标 
		 */	
		public var originX:int = 0;
		
		/**
		 * 注册点的Y坐标 
		 */	
		public var originY:int = 0;
		
		/**
		 * 总共可以读取的帧数 
		 */	
		public var frameCount:int = int.MAX_VALUE;
		
		/**
		 * 加载的序列图的路径 
		 */	
		public var path:String = null;
		
		/**
		 * 标识图片是否透明 
		 */	
		public var transparent:Boolean = false;
		
		/**
		 * 加载的子单元定义 
		 */		
		public var units:Vector.<MultiStripConfigUnitVO> = null;
		
		/**
		 * 处理完毕的回调方法，携带的参数为[Object],里面的参数为[StripVO]的集合
		 */		
		public var callBackFun:Function = null;
	}
}