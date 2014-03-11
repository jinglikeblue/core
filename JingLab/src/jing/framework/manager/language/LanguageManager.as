package jing.framework.manager.language
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import jing.utils.data.StringUtil;

	/**
	 * 语言管理器
	 * @author GoSoon
	 *
	 */
	public class LanguageManager
	{
		//环境语言种类
		private static var _environmentLangType:String=LanguageTypes.CN;
		//加载队列
		private static var _loadQueue:Array=new Array();
		//语言包索引
		private static var _packsDic:Dictionary=new Dictionary();
		//加载好的语言包
		private static var _packs:Array=new Array();
		//正在记载的语言包
		private static var _loadingPack:LanguagePack;
		//加载中
		private static var _loading:Boolean=false;
		//加载完毕回调
		private static var _completeHandler:Function;

		public function LanguageManager(environmentLangType:String)
		{
			//做不了事情
		}

		/**
		 * 设置语言环境
		 * 使用Languages类中的语言标记
		 * @param value
		 *
		 */
		public static function set environmentLangType(value:String):void
		{
			_environmentLangType=value;
		}

		public static function get environmentLangType():String
		{
			return _environmentLangType;
		}

		//------------------------------------------------------------------------------
		//
		//------------------------------------------------------------------------------

		/**
		 * 获得语言包中的文字
		 * 给出文字的ID
		 * 默认使用环境语言的语言包，如果有语言需求则指定needType（使用Languages类中的语言标记）
		 * @param id 文字ID
		 * @param needType 需要的语言类型（使用Languages类中的语言标记）
		 * @return
		 *
		 */
		public static function getCharacters(id:String, needType:String=null):String
		{
			var temp:String="";
			var pack:LanguagePack;
			needType ? pack=_packsDic[needType] : pack=_packsDic[_environmentLangType];
			if (!pack)
				return "没有文字";
			temp=pack.getCharacters(id);
			return temp;
		}

		//------------------------------------------------------------------------------
		//
		//------------------------------------------------------------------------------

		/**
		 * 初始化LanguageManager，读取语言包列表
		 * @param completeHandler 加载完毕处理handler
		 * @param listURL 语言包列表地址（默认地址"languages.txt"）
		 * 
		 */
		public static function init(completeHandler:Function, listURL:String="languages.txt"):void
		{
			_completeHandler = completeHandler;
			var urlRequest:URLRequest=new URLRequest(listURL);
			var listLoader:URLLoader=new URLLoader();
			listLoader.addEventListener(Event.COMPLETE, listLoader_completeHandler);
			listLoader.addEventListener(IOErrorEvent.IO_ERROR, listLoader_ioErrorHandler);
			listLoader.load(urlRequest);
		}

		private static function listLoader_completeHandler(event:Event):void
		{
			var temp:String=event.currentTarget.data;
			var tempArr1:Array=temp.split(";");
			var content:String
			for each (content in tempArr1)
			{
				content=StringUtil.trim(content);
				if (StringUtil.isEmpty(content))
					break;
				var tempArr2:Array=content.split(":");
				addLangPack(tempArr2[1], tempArr2[0]);
			}
			clearListURLLoader(event.currentTarget as URLLoader);
		}

		private static function listLoader_ioErrorHandler(event:Event):void
		{
			clearListURLLoader(event.currentTarget as URLLoader);
		}

		//------------------------------------------------------------------------------
		//
		//------------------------------------------------------------------------------

		/**
		 * 添加语言包
		 * LangManager会自动的加载其内容
		 * @param packURL 语言包地址
		 * @param packLangType 语言包语言种类
		 *
		 */
		private static function addLangPack(packURL:String, packLangType:String):void
		{
			if (_packsDic[packLangType])
				return;
			var newPack:LanguagePack=new LanguagePack(packURL, packLangType);
			_packsDic[packLangType]=newPack;
			_loadQueue.push(newPack);
			loadLangPack();
		}

		/**
		 * 加载语言包
		 * @param packURL 语言包路径
		 *
		 */
		private static function loadLangPack():void
		{
			if (_loading)
				return;
			//语言包全部加在完毕
			if (_loadQueue.length == 0)
			{
				_completeHandler();
				return;
			}
			_loadingPack=_loadQueue.pop();
			var urlRequest:URLRequest=new URLRequest(_loadingPack.url);
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_ioErrorHandler);
			urlLoader.load(urlRequest);
			_loading=true;
		}

		/**
		 * 语言包加载完毕
		 * @param event
		 *
		 */
		private static function urlLoader_completeHandler(event:Event):void
		{
			var pack:LanguagePack=new LanguagePack(_loadingPack.url, _loadingPack.langType);
			pack.content=event.currentTarget.data;
			_packsDic[pack.langType]=pack;
			_packs.push(pack);
			clearPackURLLoader(event.currentTarget as URLLoader);
		}

		/**
		 * 语言包地址错误
		 * @param event
		 *
		 */
		private static function urlLoader_ioErrorHandler(event:IOErrorEvent):void
		{
			clearPackURLLoader(event.currentTarget as URLLoader);
		}

		//------------------------------------------------------------------------------
		//
		//------------------------------------------------------------------------------

		/**
		 * 清除语言包列表的urlloader
		 * @param urlLoader
		 *
		 */
		private static function clearListURLLoader(urlLoader:URLLoader):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, listLoader_completeHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, listLoader_ioErrorHandler);
			urlLoader.close();
			urlLoader=null;
		}

		/**
		 * 清除语言包的urlloader
		 * @param urlLoader
		 *
		 */
		private static function clearPackURLLoader(urlLoader:URLLoader):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, urlLoader_completeHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoader_ioErrorHandler);
			urlLoader.close();
			urlLoader=null;
			_loadingPack=null;
			_loading=false;
			loadLangPack();
		}

		//end
	}
}