package views
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    
    import jing.loader.DisplayLoader;
    
    import models.PuzzleModel;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.SubTexture;
    import starling.textures.Texture;
    
    import views.elements.Piece;
    
    import vos.PieceVO;

    /**
     * 拼图界面
     * @author Jing
     *
     */
    public class PuzzleMap extends Sprite
    {
        /**
         * 图片的源
         */
        private var _imgSource:String;

        /**
         * 图片
         */
        private var _pieces:Vector.<Piece>;

        /**
         * 拼图一列的格子数
         */
        private var _size:int;
		
		/**
		 * 数据模型 
		 */		
		private var _model:PuzzleModel;

        /**
         * 图片本身
         */
        private var _imgTexture:Texture;
		
		/**
		 * 每个拼图块的边长 
		 */		
		private var _pieceSide:int;

        public function PuzzleMap(imgSource:String, size:int)
        {
            super();
            _imgSource = imgSource;
            _size = size;
			init();
           
        }
		
		private function init():void
		{
			_model = new PuzzleModel(_size);
			loadImg();
		}
		
		

        private function loadImg():void
        {
            var dl:DisplayLoader = new DisplayLoader();
            dl.addEventListener(Event.COMPLETE, dl_completeHandler);
            dl.load(new URLRequest(_imgSource));
        }

        private function dl_completeHandler(e:Event):void
        {
            var dl:DisplayLoader = e.currentTarget as DisplayLoader;
            dl.removeEventListener(Event.COMPLETE, dl_completeHandler);
            var imgBmd:BitmapData = (dl.displayObject as Bitmap).bitmapData;

            _imgTexture = Texture.fromBitmapData(imgBmd);
			_pieceSide = _imgTexture.width / _size;
			
            cutImg();
        }

		/**
		 * 切图成碎片 
		 * 
		 */		
        private function cutImg():void
        {
            

            _pieces = new Vector.<Piece>(_size * _size, true);
			
			var subRect:Rectangle = new Rectangle();
			for(var i:int = 0; i < _size; i++)
			{
				for(var j:int = 0; j < _size; j++)
				{
					subRect.x = j * _pieceSide;
					subRect.y = i * _pieceSide;
					subRect.width = _pieceSide;
					subRect.height = _pieceSide;
					var subTexture:SubTexture = new SubTexture(_imgTexture,subRect);
					var no:int = i * _size + j;
					var piece:Piece = new Piece(subTexture, no);
					_pieces[no] = piece;
				}
			}
			
			
			start();
        }
		
		/**
		 * 刷新所有拼图的显示 
		 * 
		 */		
		private function freshPieces():void
		{
			var pieceSide:int = _imgTexture.width / _size;
			for(var i:int = 0; i < _pieces.length; i++)
			{
				var piece:Piece = _pieces[i];
				var pos:Point = _model.getPiecePos(piece.no);
				this.addChild(piece);
				if(null != pos)
				{						
					piece.x = pos.x * pieceSide;
					piece.y = pos.y * pieceSide;
				}
				else
				{
					piece.alpha = 0.2;	
				}
			}
		}
		
		/**
		 * 游戏开始 
		 * 
		 */		
		private function start():void
		{
			freshPieces();
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN)
			{
				var piece:Piece = e.target as Piece;
				if(piece != null)
				{
					var no:int = piece.no;
					if(true == _model.move(no))
					{
						var pos:Point = _model.getPiecePos(no);
						piece.moveTo(pos.x * _pieceSide, pos.y * _pieceSide, onPieceMoved);	
					}
				}
				
			}
		}
		
		private function onPieceMoved():void
		{			
			if(true == _model.checkPass())
			{
				for each(var piece:Piece in _pieces)
				{
					this.removeChild(piece);
				}
				
				var img:Image = new Image(_imgTexture);
				this.addChild(img);
				
				this.dispatchEventWith("passed");
			}
		}
		
		override public function dispose():void
		{
			this.removeChildren(0, -1, true);
			_imgTexture.dispose();
			for each(var piece:Piece in _pieces)
			{
				piece.dispose();
			}
			super.dispose();
		}
    }
}
