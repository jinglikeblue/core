package jing.map
{
	import jing.map.consts.FixedPath;
	import jing.map.events.MapLoadToolEvent;
	import jing.map.util.MapUtil;
	import jing.map.vo.MapInfoVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * 地图加载工具 
	 * @author jing
	 * 
	 */	
	public class MapLoadTool extends EventDispatcher
	{					
		private var _xmlLoader:URLLoader = null;
		
		private var _mapLogicBytesLoader:URLLoader = null;
		
		private var _mapLogicLoader:Loader = null;
		
		private var _mapInfoXML:XML = null;
		
		private var _mapLogic:BitmapData = null;
		
		private var _mapDirPath:String = null;
		public function MapLoadTool()
		{
			init();
		}
		
		private function init():void
		{
			_xmlLoader = new URLLoader();
			_mapLogicBytesLoader = new URLLoader();
			_mapLogicLoader = new Loader();
		}
		
		/**
		 *  
		 * @param mapDir 目录需要以"/"结尾
		 * 
		 */		
		public function load(mapDir:String = ""):void
		{
			_mapDirPath = mapDir;
			
			_xmlLoader.addEventListener(Event.COMPLETE, _xmlLoader_completeHandler);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, _xmlLoader_ioErrorHandler);
			_xmlLoader.load(new URLRequest(mapDir + FixedPath.MAP_INFO_XML_PATH));
			
			_mapLogicBytesLoader.addEventListener(Event.COMPLETE, _mapLogicBytesLoader_completeHandler);
			_mapLogicBytesLoader.addEventListener(IOErrorEvent.IO_ERROR, _mapLogicBytesLoader_ioErrorHandler);
			_mapLogicBytesLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_mapLogicBytesLoader.load(new URLRequest(mapDir + FixedPath.MAP_LOGIC_PATH));
		}
		
		private function _mapLogicLoader_completeHandler(e:Event):void
		{
			_mapLogic = (_mapLogicLoader.content as Bitmap).bitmapData;
			checkLoaded();
		}
		
		private function _mapLogicLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			error("地图逻辑图生成失败");
		}
		
		private function _mapLogicBytesLoader_completeHandler(e:Event):void
		{
			//地图逻辑图加载完毕，需要用loader加载bytes来取出数据
			_mapLogicLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _mapLogicLoader_completeHandler);
			_mapLogicLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _mapLogicLoader_ioErrorHandler);
			_mapLogicLoader.loadBytes(_mapLogicBytesLoader.data);
		}
		
		private function _mapLogicBytesLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			error("地图逻辑图加载失败");
		}			
		
		private function _xmlLoader_completeHandler(e:Event):void
		{
			_mapInfoXML = XML(_xmlLoader.data);
			
			checkLoaded();
		}
		
		private function _xmlLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			error("地图XML加载失败");
		}
		
		private function checkLoaded():void
		{
			if(null != _mapInfoXML && null != _mapLogic)
			{
				cancelListeners();
				var mapInfoVO:MapInfoVO = MapUtil.getMapInfoVO(_mapInfoXML,_mapLogic);
				if(mapInfoVO.hasMapIMG == true)
				{
					mapInfoVO.mapImgPath = FixedPath.MAP_IMG_PATH;
				}
				mapInfoVO.mapDirPath = _mapDirPath;
				this.dispatchEvent(new MapLoadToolEvent(MapLoadToolEvent.COMPLETE,mapInfoVO));
			}
		}
		
		private function error(value:String):void
		{
			cancelListeners();
			this.dispatchEvent(new MapLoadToolEvent(MapLoadToolEvent.ERROR));
		}
		
		private function cancelListeners():void
		{
			_xmlLoader.removeEventListener(Event.COMPLETE, _xmlLoader_completeHandler);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _xmlLoader_ioErrorHandler);
			
			_mapLogicBytesLoader.removeEventListener(Event.COMPLETE, _mapLogicBytesLoader_completeHandler);
			_mapLogicBytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, _mapLogicBytesLoader_ioErrorHandler);
			
			_mapLogicLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _mapLogicLoader_completeHandler);
			_mapLogicLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _mapLogicLoader_ioErrorHandler);
		}
	}
}