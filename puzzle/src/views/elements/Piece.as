package views.elements
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * 拼图的碎片 
	 * @author Jing
	 * 
	 */	
	public class Piece extends Sprite
	{
		private var _no:int;
		public function get no():int
		{
			return _no;
		}
		
		private var _image:Image;
		
		private var _noTxt:TextField;
		
		/**
		 *  
		 * @param texture 纹理
		 * @param no 编号
		 * 
		 */		
		public function Piece(texture:Texture, no:int)
		{			
			super();
			_no = no;
			_image = new Image(texture);
			_noTxt = new TextField(_image.width, _image.height, no.toString());
			_noTxt.color = 0xFFFFFF;
			//_noTxt.border = true;
			_noTxt.fontSize = 80;
			this.addChild(_image);
			this.addChild(_noTxt);
			this.touchGroup = true;
		}
		
		/**
		 * 移动到指定位置 
		 * @param x
		 * @param y
		 * 
		 */		
		public function moveTo(x:int, y:int, onMoved:Function):void
		{			
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT);
			tween.animate("x", x);
			tween.animate("y", y);	
			tween.onComplete = onMoved;
			Starling.juggler.add(tween); 
		}
		
		override public function dispose():void
		{
			_image.texture.dispose();
			_image.dispose();
			_noTxt.dispose();
			Starling.juggler.removeTweens(this);
			_image = null;
			_noTxt = null;
			super.dispose();
		}
	}
}