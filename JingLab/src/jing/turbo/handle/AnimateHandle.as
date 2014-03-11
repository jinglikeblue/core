package jing.turbo.handle
{

	/**
	 * 动画的操作 
	 * @author jing
	 * 
	 */	
	public class AnimateHandle extends Handle
	{
		public function AnimateHandle(type:String)
		{
			super(type);
		}
		
		/**
		 * 播放完动作的最后一帧 
		 */		
		static public const FRAME_OVER:String = "frameOver";
	}
}