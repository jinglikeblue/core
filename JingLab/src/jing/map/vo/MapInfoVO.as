package jing.map.vo
{
	import flash.display.BitmapData;

	/**
	 * 地图信息数据对象 
	 * @author jing
	 * 
	 */	
	public class MapInfoVO
	{
		public function MapInfoVO():void
		{
			
		}
		
		/**
		 * 地图名称 
		 */		
		public var name:String = "";
		
		/**
		 * 地图描述 
		 */		
		public var decription:String = "";
		
		/**
		 * 单元格大小 
		 */		
		public var unitSize:int = 0;
		
		/**
		 * 是否有地图图片 
		 */		
		public var hasMapIMG:int = 0;
		
		/**
		 * 地图单元格列数
		 */		
		public var column:int = 0;
		
		/**
		 * 地图单元格行数 
		 */		
		public var row:int = 0;
		
		/**
		 * 地图逻辑格子数据 
		 */		
		public var mapBlockDic:Object = {};
		
		/**
		 * 地图标志点数据
		 */		
		public var mapMarkDic:Object = {};
		
		/**
		 * 库数据 
		 */		
		public var libaryDic:Object = {};
		
		/**
		 * 图层字典 
		 */		
		public var layerArray:Array = ["default"];
		
		/**
		 * 图像字典 
		 */		
		public var imageVOs:Array = [];
		
		/**
		 * 地图图片路径 
		 */		
		public var mapImgPath:String = null;
		
		/**
		 * 指向地图文件夹的目录路径 
		 */		
		public var mapDirPath:String = null;
	}
}