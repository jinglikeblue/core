package
{
	import flash.display.Sprite;
	
	import models.PuzzleModel;
	
	import views.Main;
	
	import vos.PieceVO;
	
	[SWF(width="480", height="800")]
	public class Puzzle extends Sprite
	{
		public function Puzzle()
		{
			stage.addChild(new Main());
			stage.removeChild(this);
		}
	}
}