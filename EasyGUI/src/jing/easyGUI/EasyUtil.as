package jing.easyGUI
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	import jing.easyGUI.vos.ADisplayObjectVO;
	import jing.easyGUI.vos.BitmapVO;
	import jing.easyGUI.vos.SpriteVO;
	import jing.easyGUI.vos.TextFieldVO;

	public class EasyUtil
	{
		/**
		 * 将显示对象转换成数据
		 */
		static public function createSpriteVO(spr:Sprite):SpriteVO
		{
			var sprVO:SpriteVO = new SpriteVO();
			sprVO.name = spr.name;
			sprVO.define = getQualifiedClassName(spr);
			if(sprVO.define.indexOf("flash.display") > -1)
			{
				//官方包
				sprVO.define = null;
			}
			for(var i:int = 0; i < spr.numChildren; i++)
			{
				var displayObject:DisplayObject = spr.getChildAt(i);
				
				var displayObjectVO:ADisplayObjectVO;
				if(displayObject is Sprite)
				{						
					var childSprVO:SpriteVO = createSpriteVO(displayObject as Sprite);
					displayObjectVO = childSprVO;
					displayObjectVO.type = DisplayObjectType.SPRITE;
				}
				else if(displayObject is Bitmap)
				{
					var bitmapVO:BitmapVO = new BitmapVO();
					bitmapVO.source = getQualifiedClassName((displayObject as Bitmap).bitmapData);
					var suffixIndex:int = bitmapVO.source.indexOf("::");
					if(suffixIndex > -1)
					{
						bitmapVO.source = bitmapVO.source.substring(0,suffixIndex);
					}
					displayObjectVO = bitmapVO;
					displayObjectVO.type = DisplayObjectType.BITMAP;
				}
				else if(displayObject is TextField)
				{
					var tf:TextField = displayObject as TextField;
					var tfVO:TextFieldVO = new TextFieldVO();
					tfVO.content = encodeURI(tf.text);
					var textFormat:TextFormat = tf.getTextFormat();
					tfVO.color = uint(textFormat.color);
					tfVO.fontSize = Number(textFormat.size);
					tfVO.fontName = textFormat.font.toString();
					displayObjectVO = tfVO;
					displayObjectVO.type = DisplayObjectType.TEXT_FIELD;
				}
				
				if(null == displayObjectVO)
				{
					throw new Error("无法识别的元素类型： " + typeof(displayObjectVO));
				}
				
				displayObjectVO.name = displayObject.name;
				displayObjectVO.x = displayObject.x;
				displayObjectVO.y = displayObject.y;
				displayObjectVO.childIndex = i;
				displayObjectVO.width = displayObject.width;
				displayObjectVO.height = displayObject.height;
				displayObjectVO.alpha = displayObject.alpha;
				
				sprVO.childSprites.push(displayObjectVO);
			}
			return sprVO;
		}
		
		/**
		 * 创建Sprite的XML描述
		 */
		static public function createSpriteXML(sprVO:SpriteVO):XML
		{
			var sprXML:XML = <sprite />;
			if(sprVO.define != null)
			{
				sprXML.@define = sprVO.define;
			}
			for(var i:int = 0; i < sprVO.childSprites.length; i++)
			{
				var childXML:XML = <child />;
				var childVO:ADisplayObjectVO = sprVO.childSprites[i];
				childXML.@name = childVO.name;
				childXML.@type = childVO.type;
				childXML.@x = childVO.x;
				childXML.@y = childVO.y;
				childXML.@childIndex = childVO.childIndex;
				childXML.@width = childVO.width;
				childXML.@height = childVO.height;
				childXML.@alpha = childVO.alpha;						
				switch(childVO.type)
				{
					case DisplayObjectType.BITMAP:
						childXML.@source = (childVO as BitmapVO).source;
						break;
					case DisplayObjectType.SPRITE:
						childXML.appendChild(createSpriteXML(childVO as SpriteVO));
						break;
					case DisplayObjectType.TEXT_FIELD:
						var tfVO:TextFieldVO = childVO as TextFieldVO;
						var content:String = tfVO.content;
						var contentXML:XML = <content>{content}</content>;
						contentXML.@color = tfVO.color;
						contentXML.@fontSize = tfVO.fontSize;
						contentXML.@fontName = tfVO.fontName;
						childXML.appendChild(contentXML);
						break;
				}
				sprXML.appendChild(childXML);
			}
			return sprXML;
		}
		
		/**
		 * 将XML描述的Sprite转换成数据 
		 * @param sprXML
		 * @return 
		 * 
		 */		
		static public function spriteXML2VO(sprXML:XML):SpriteVO
		{
			var spriteVO:SpriteVO = new SpriteVO();
			if(sprXML.hasOwnProperty("@define"))
			{
				spriteVO.define = sprXML.@define.toString();
			}
			
			for each(var childXML:XML in sprXML.child)
			{
				var childVO:ADisplayObjectVO;
				var type:String = childXML.@type.toString();
				switch(type)
				{
					case DisplayObjectType.BITMAP:
						var bitmapVO:BitmapVO = new BitmapVO();
						childVO = bitmapVO;
						bitmapVO.source = childXML.@source;
						break;
					case DisplayObjectType.SPRITE:
						var childSpriteVO:SpriteVO = spriteXML2VO(XML(childXML.sprite));
						childVO = childSpriteVO;
						childSpriteVO.name = childXML.@name.toString();
						break;
					case DisplayObjectType.TEXT_FIELD:
						var tfVO:TextFieldVO = new TextFieldVO();
						childVO = tfVO;
						tfVO.content = decodeURI(childXML.content.toString());
						tfVO.color = uint(childXML.content.@color);
						tfVO.fontSize = Number(childXML.content.@fontSize);
						tfVO.fontName = childXML.content.@fontName.toString();
						break;
				}
				
				childVO.type = type;
				childVO.name = childXML.@name;
				childVO.x = childXML.@x;
				childVO.y = childXML.@y;
				childVO.childIndex = childXML.@childIndex;
				childVO.width = childXML.@width;
				childVO.height = childXML.@height;
				childVO.alpha = Number(childXML.@alpha);
				spriteVO.childSprites.push(childVO);
			}
			
			return spriteVO;
		}
	}
}