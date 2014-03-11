package jing.turbo.strip.vo
{
	import jing.turbo.strip.interfaces.IStripLoadedReport;
	

	/**
	 * 序列图加载使用的配置数据 
	 * @author jing
	 * 
	 */	
	public class StripConfigVO
	{
		public function StripConfigVO():void
		{
			
		}
		
		/**
		 * 连环画的名字 
		 */		
		public var name:String = null;
		
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
		 * 接收回调的接口实现者 
		 */		
		public var iReport:IStripLoadedReport = null;
	}
}