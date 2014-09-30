package views.elements
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
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
		
		private var _onMoved:Function;
		
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
			this.x = x;
			this.y = y;
			
			_onMoved = onMoved;
			
			_onMoved();
			_onMoved = null;
		}
	}
}