package jing.turbo.animateUtil_old.vos
{
	import flash.geom.Point;

	public class AnimateVO
	{
		public function AnimateVO():void
		{
			
		}
		/**
		 * 动画帧的数据 
		 */		
		public var frameData:Array = null;
		
		/**
		 * 注册点数组 
		 */		
		public var originList:Vector.<Point> = null;
		
		/**
		 * 帧数 
		 */		
		public var frameCount:int = 0;
		
		/**
		 * 每一帧显示多少毫秒 
		 */		
		public var oneFrameTime:int = 0;
		
		/**
		 * 动画所在文件夹的完整路径 
		 */		
		public var fileDirPath:String = null;
		
		/**
		 * 动作的名称
		 */		
		public var actionName:String = null;
	}
}