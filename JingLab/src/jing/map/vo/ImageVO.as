package jing.map.vo
{
	import jing.map.vo.LibaryVO;

	/**
	 * 舞台上的图像数据对象 
	 * @author jing
	 * 
	 */	
	public class ImageVO
	{
		public function ImageVO():void
		{
			
		}
		
		/**
		 * 图片的id 
		 */		
		public var id:String = "";
		
		/**
		 * 所在的格子X 
		 */		
		public var unitX:int = 0;
		
		/**
		 * 所在的格子Y
		 */		
		public var unitY:int = 0;
		
		/**
		 * 关联的库对象 
		 */		
		public var libaryVO:LibaryVO = null;
		/**
		 * 所在图层 
		 */		
		public var layerId:String = null;
	}
}