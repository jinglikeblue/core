package jing.easyGUI
{	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import jing.easyGUI.events.PackagerEvent;
	import jing.easyGUI.vos.SpriteVO;
	import jing.utils.file.FileUtil;
	import jing.utils.file.SWFUtil;

	/**
	 * 打包器，将SWF里的GUI资源用打包成XML格式描述 
	 * @author Jing
	 * 
	 */	
	[Event(name="Complete", type="jing.easyGUI.events.PackagerEvent")]
	public class Packager extends EventDispatcher
	{
		private var _swfName:String;
		private var _loader:Loader;
		private var _swfInfo:Object;
		private var _domain:ApplicationDomain;
		public function Packager():void
		{
			
		}
		
		public function packageSWF2XML(swfBytes:ByteArray,swfName:String):void
		{
			_swfName = swfName;
			_swfInfo = SWFUtil.getSWFInfo(swfBytes);
			_domain = new ApplicationDomain();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loader_completeHandler);
			var lc:LoaderContext = new LoaderContext(false,_domain);
			lc.allowCodeImport = true;
			_loader.loadBytes(swfBytes, lc);
		}
		
		private function _loader_completeHandler(e:Event):void
		{
			var fileName:String = FileUtil.getFileNameWithouExtension(_swfName);
			var dic:Dictionary = new Dictionary();
			for each(var className:String in _swfInfo.classList)
			{
				var cls:Class;
				try
				{
					cls = _domain.getDefinition(className) as Class;
				}
				catch(e:Error)
				{
					continue;
				}
				var obj:Sprite = new cls() as Sprite;
				if(null == obj)
				{
					continue;
				}
				var spriteVO:SpriteVO = EasyUtil.createSpriteVO(obj);
				dic[spriteVO.define] = spriteVO;
			}
			var xml:XML = createXML(dic,fileName);
			
			this.dispatchEvent(new PackagerEvent(PackagerEvent.COMPLETE,xml));
		}
		
		/**
		 * 将SWF中的元件发布出来
		 */
		private function createXML(dic:Dictionary, guiName:String):XML
		{
			var guiXML:XML = <{guiName} />;
			for each(var sprVO:SpriteVO in dic)
			{
				var sprXML:XML = EasyUtil.createSpriteXML(sprVO);
				guiXML.appendChild(sprXML);
			}
			return guiXML;
		}
	}
}