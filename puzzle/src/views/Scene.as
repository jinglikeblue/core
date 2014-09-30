package views
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 游戏的主场景 
	 * @author Jing
	 * 
	 */	
	public class Scene extends Sprite
	{
		public function Scene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		private function init():void
		{
			drawBG();
			var puzzle:PuzzleMap = new PuzzleMap("assets/img.png", 3);
			puzzle.addEventListener("passed", puzzle_passedHandler);
			puzzle.y = (stage.stageHeight - 420) >> 1;
			puzzle.x = (stage.stageWidth - 420) >> 1;
			this.addChild(puzzle);
		}
		
		private function puzzle_passedHandler(e:Event):void
		{
			var puzzle:PuzzleMap = e.currentTarget as PuzzleMap;
			puzzle.removeEventListener("passed", puzzle_passedHandler);
			this.removeChild(puzzle);
			puzzle.dispose();
			
			puzzle = new PuzzleMap("assets/img.png", 3);
			puzzle.addEventListener("passed", puzzle_passedHandler);
			puzzle.y = (stage.stageHeight - 420) >> 1;
			puzzle.x = (stage.stageWidth - 420) >> 1;
			this.addChild(puzzle);
		}
		
		private function drawBG():void
		{
			var quad:Quad = new Quad(1,1,0,false);
			quad.width = stage.stageWidth;
			quad.height = stage.stageHeight;
			this.addChild(quad);
		}
	}
}