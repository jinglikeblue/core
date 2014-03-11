package jing.framework.manager.language
{
	import flash.utils.Dictionary;
	
	import jing.utils.data.StringUtil;

	/**
	 * 语言包
	 * @author GoSoon
	 *
	 */
	public class LanguagePack
	{
		/**
		 * 语言包地址
		 */
		public var url:String;
		/**
		 * 语言包语言种类
		 */
		public var langType:String;
		/**
		 * 解析好的语言内容索引
		 */
		private var _trimContentDic:Dictionary=new Dictionary();

		/**
		 * 语言包构造函数
		 * @param url 语言包地址
		 * @param langType 语言包语言种类
		 * @param content 语言包内容
		 *
		 */
		public function LanguagePack(url:String, langType:String)
		{
			this.url=url;
			this.langType=langType;
		}

		/**
		 * 设置语言包内容
		 * 内部自动解析
		 * @param value
		 *
		 */
		public function set content(value:String):void
		{
			//首先把内容提出来，但里面可能包含带"#"开头的注释以及空白
			var temp1:Array=value.split("|");
			//把注释移除
			var content:String;
			for each (content in temp1)
			{
				//先每个字符串去空白
				content=StringUtil.trim(content);
				//找非注释部分，就是需要的语言包内容了
				if (content.charAt(0) != "#")
				{
					//取出文字
					var temp2:Array=content.split(":");
					_trimContentDic[temp2[0]]=temp2[1];
				}
			}
		}

		public function getCharacters(id:String):String
		{
			return _trimContentDic[id];
		}

	}
}
