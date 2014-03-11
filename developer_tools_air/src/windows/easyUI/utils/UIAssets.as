package windows.easyUI.utils
{
	import flash.utils.Dictionary;
	
	import jing.easyGUI.vos.SpriteVO;
	
	import starling.textures.TextureAtlas;
	
	import windows.easyUI.models.vos.PackageVO;

	public class UIAssets
	{
		static public var packageDic:Dictionary = new Dictionary();
		public function UIAssets()
		{
		}
		
		static public function registPackage(packageName:String, sprDic:Dictionary, textureAtlas:TextureAtlas):void
		{
			var packageVO:PackageVO = new PackageVO();
			packageVO.sprDic = sprDic;
			packageVO.ta = textureAtlas;
			packageDic[packageName] = packageVO;
		}
		
		static public function getUI(packageName:String, sprName:String):Array
		{
			var packageVO:PackageVO = packageDic[packageName];
			if(packageVO)
			{
				var spriteVO:SpriteVO = packageVO.sprDic[sprName];
				if(spriteVO)
				{
					return [spriteVO,packageVO.ta];
				}
			}
			return null;
		}
	}
}