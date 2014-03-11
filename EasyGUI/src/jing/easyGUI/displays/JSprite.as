package jing.easyGUI.displays
{
	import jing.easyGUI.DisplayObjectType;
	import jing.easyGUI.vos.ADisplayObjectVO;
	import jing.easyGUI.vos.BitmapVO;
	import jing.easyGUI.vos.SpriteVO;
	import jing.easyGUI.vos.TextFieldVO;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 容器类 
	 * @author Jing
	 * 
	 */	
	public class JSprite extends Sprite
	{
		/**
		 * 使用的数据 
		 */		
		private var _spriteVO:SpriteVO;
		
		/**
		 * 使用的纹理集 
		 */		
		private var _texturesAtlas:TextureAtlas;
		
		public function JSprite(spriteVO:SpriteVO, texturesAtlas:TextureAtlas)
		{
			super();
			_spriteVO = spriteVO;
			_texturesAtlas = texturesAtlas;
			init();
		}
		
		private function init():void
		{
			var childNum:int = _spriteVO.childSprites.length;
			for(var i:int = 0; i < childNum; i++)
			{
				var childVO:ADisplayObjectVO = _spriteVO.childSprites[i];
				switch(childVO.type)
				{
					case DisplayObjectType.BITMAP:
						addImage(childVO as BitmapVO);
						break;
					case DisplayObjectType.SPRITE:
						addJSprite(childVO as SpriteVO);
						break;
					case DisplayObjectType.TEXT_FIELD:
						addTextField(childVO as TextFieldVO);
						break;
				}
			}
		}
		
		/**
		 * 添加图片 
		 * @param bitmapVO
		 * 
		 */		
		[inline]
		private function addImage(bitmapVO:BitmapVO):void
		{
			var texture:Texture = _texturesAtlas.getTexture(bitmapVO.source);
			var image:Image = new Image(texture);
			showChild(image,bitmapVO);
		}
		
		/**
		 * 添加文本 
		 * @param tfVO
		 * 
		 */		
		[inline]
		private function addTextField(tfVO:TextFieldVO):void
		{
			var tf:TextField = new TextField(tfVO.width,tfVO.height,tfVO.content);
			tf.color = tfVO.color;
			tf.fontName = tfVO.fontName;
			tf.fontSize = tfVO.fontSize;
			showChild(tf,tfVO);
		}
		
		/**
		 * 添加子容器 
		 * @param spriteVO
		 * 
		 */		
		[inline]
		private function addJSprite(spriteVO:SpriteVO):void
		{
			var childSpr:Sprite = new JSprite(spriteVO,_texturesAtlas);
			showChild(childSpr,spriteVO);
		}
		
		[inline]
		/**
		 * 将子对象显示到容器中 
		 */
		private function showChild(obj:DisplayObject, vo:ADisplayObjectVO):void
		{	
			obj.x = vo.x;
			obj.y = vo.y;
			obj.width = vo.width;
			obj.name = vo.name;
			obj.height = vo.height;
			obj.alpha = vo.alpha;
//			trace(obj.name, "child: ", vo.childIndex);
			this.addChildAt(obj,vo.childIndex);
		}
	}
}