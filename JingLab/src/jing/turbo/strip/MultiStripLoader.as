package jing.turbo.strip
{
	import jing.turbo.strip.vo.MultiStripConfigVO;
	import jing.turbo.strip.vo.StripVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class MultiStripLoader
	{
		/**
		 * 加载器
		 */	
		private var _loader:Loader = null;	
		
		/**
		 * 配置数据 
		 */		
		private var _configVO:MultiStripConfigVO  = null;
		
		public function MultiStripLoader()
		{
			init();
		}
		
		private function init():void
		{
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loader_completeHandler);
		}
		
		private function _loader_completeHandler(e:Event):void
		{
			var bmd:BitmapData = (_loader.content as Bitmap).bitmapData;
			
			var stripDatas:Vector.<BitmapData> = StripFactory.createStripDatas(bmd,_configVO.unitW,_configVO.unitH,_configVO.frameCount,_configVO.transparent);
			
			var stripVOS:Object = StripFactory.cretaeMultiStrip(stripDatas,_configVO);
//			var stripVO:StripVO = StripFactory.createStripVO(stripDatas,_configVO);
			
//			_configVO.iReport.imageLoadedReport(stripVO);
			_configVO.callBackFun(stripVOS);
			releaseLoader();
		}		
		
		public function load(configVO:MultiStripConfigVO):void
		{
			_configVO = configVO;
			_loader.load(new URLRequest(_configVO.path));
		}
		
		private function releaseLoader():void
		{
			_loader.unloadAndStop();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _loader_completeHandler);
			_loader.unload();
			_loader = null;
		}
	}
}