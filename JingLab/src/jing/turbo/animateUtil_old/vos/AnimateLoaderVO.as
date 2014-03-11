package jing.turbo.animateUtil_old.vos
{
    import jing.turbo.animateUtil_old.interfaces.ILoaderReport;
    
    import flash.geom.Point;

    /**
     * 动画加载数据对象
     * @author Jing
     *
     */
    public class AnimateLoaderVO
    {
		
		public function AnimateLoaderVO():void
		{
			
		}
		
        /**
         * 文件目录的路径
         */
        public var path:String = null;

        /**
         * 动作名称
         */
        public var actionName:String = null;

        /**
         * 文件命名格式,方向用"@_D"代替,帧数用"@_F"代替
         */
        public var fileNameFormat:String = null;

        /**
         * 动作的帧数
         */
        public var frameCount:int = int.MAX_VALUE;
		
		/**
		 * 用"@_F"代替的动画帧的起始索引
		 */		
		public var frameStartIndexFormat:int = int.MAX_VALUE;
		
        /**
         * 方向数量
         */
        public var direction:int = int.MAX_VALUE;
		
		/**
		 * 用"@_D"代替的方向的起始索引 
		 */		
		public var directionStartIndexFormat:int = int.MAX_VALUE;

        /**
         * 动画加载完毕，接收回调的对象
         */
        public var iReport:ILoaderReport = null;
		
		/**
		 * 单位图片的宽度 
		 */		
		public var imgUnitWidth:int = int.MAX_VALUE;
		
		/**
		 * 单位图片的高度 
		 */		
		public var imgUnitHeight:int = int.MAX_VALUE;
		
		/**
		 * 注册点 
		 */		
		public var originPoint:Point = null;
		
		/**
		 * 动画速度（每一帧显示多少毫秒） 
		 */		
		public var oneFrameTime:int = int.MAX_VALUE;
    }
}