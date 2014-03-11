package jing.turbo.strip.vo
{
	public class MultiStripConfigUnitVO
	{
		/**
		 *  
		 * @param name
		 * @param startFrame 其实索引，最低为0
		 * @param frameCount 包含的帧数
		 * 
		 */		
		public function MultiStripConfigUnitVO(name:String,startFrame:int,frameCount:int):void
		{
			this.name = name;
			this.startFrame = startFrame;
			this.frameCount = frameCount;
		}
		
		public var name:String = null;
		
		public var startFrame:int = 0;
		
		public var frameCount:int = 0;
	}
}