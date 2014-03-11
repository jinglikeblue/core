package jing.easyGUI.displays.controls
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 图像数字 
	 * @author Jing
	 * 
	 */	
	public class ImageNumber extends Sprite
	{
		private var _value:uint;
		private var _ta:TextureAtlas;
		private var _prefix:String;
		private var _imgs:Vector.<Image>;
		
		public function ImageNumber(ta:TextureAtlas, prefix:String)
		{
			_ta = ta;
			_prefix = prefix;
			super();
		}
		
		public function set value(v:uint):void
		{
			if(_value == v)
			{
				return;
			}
			_value = v;
			refresh();
		}
		
		public function get value():uint
		{
			return _value;
		}
		
		private function clear():void
		{
			if(_imgs)
			{
				for each(var img:Image in _imgs)
				{
					this.removeChild(img);
					img.dispose();
					img = null;
				}
				_imgs = null;
			}
		}
		
		/**
		 * 刷新显示 
		 * 
		 */		
		private function refresh():void
		{
			clear();
			var arr:Array = _value.toString().split("");
			var char:String;
			var t:Texture;
			var img:Image;
			
			var posX:int = 0;
			var posY:int = 0;
			
			var count:int = arr.length;
			_imgs = new Vector.<Image>(count,true);
			
			for(var i:int = 0; i < count; i++)
			{
				char = arr[i];
				t = _ta.getTexture(_prefix + char);
				img = new Image(t);
				img.x = posX;
				posX += img.width;
				this.addChild(img);
				_imgs[i] = img;
			}
		}
	}
}