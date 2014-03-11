package jing.easyGUI
{
	import flash.utils.Dictionary;
	
	import jing.easyGUI.vos.SpriteVO;

	/**
	 * 解包器，把XML转换成VO数据 
	 * @author Jing
	 * 
	 */	
	public class Unpackager
	{
		public function Unpackager()
		{
		}
		
		public function unpackageXML2SpriteVODic(xml:XML):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			for each(var sprXML:XML in xml.sprite)
			{
				var spriteVO:SpriteVO = EasyUtil.spriteXML2VO(sprXML);
				dic[spriteVO.define] = spriteVO;
			}
			return dic;
		}
	}
}