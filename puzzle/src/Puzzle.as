package
{
	import flash.display.Sprite;
	
	import models.PuzzleModel;
	
	import vos.PieceVO;
	
	public class Puzzle extends Sprite
	{
		public function Puzzle()
		{
			var pieces:Vector.<PieceVO> = new Vector.<PieceVO>();
			for(var i:int = 0; i < 9; i++)
			{
				var vo:PieceVO = new PieceVO();
				vo.no = i;
				pieces.push(vo);
			}
			
			var model:PuzzleModel = new PuzzleModel(pieces);
			model.move(1);
			model.move(1);
		}
	}
}