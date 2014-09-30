package views
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jing.utils.data.StringUtil;
	
	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 主类 
	 * @author Jing
	 * 
	 */	
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public function Main()
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			Starling.handleLostContext = true;
			
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			stage_resizeHandler(null);
		}
		
		private function stage_resizeHandler(e:Event):void
		{			
			if(null == _starling)
			{
				const initW:int = stage.stageWidth;
				const initH:int = stage.stageHeight;
				trace(StringUtil.format("starling_init {0}*{1}", initW, initH));
				_starling = new Starling(Scene, stage, new Rectangle(0, 0, initW, initH));
				_starling.viewPort = new Rectangle(0, 0, initW, initH);
				_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
				_starling.showStats = true;
				_starling.showStatsAt(HAlign.LEFT, VAlign.TOP, 1);
				_starling.start();
			}
			else
			{
				trace(StringUtil.format("stage_resize {0}*{1}", stage.stageWidth, stage.stageHeight));
				_starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
		}	
		
		private function onContextCreated(e:Event):void
		{
			trace("3d created");
		}		
	}
}