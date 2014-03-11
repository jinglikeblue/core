package windows.easyUI.views
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Preview extends Sprite
	{
		public function Preview()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			init();
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function init():void
		{
			//ModelCenter.textures = new TextureAtlas(Texture.fromBitmapData(ModelCenter.assetsBMD),ModelCenter.assetsXML);
			var q:Quad = new Quad(1,1,0xFFFFFFFF);
			q.width = stage.stageWidth;
			q.height = stage.stageHeight;
			this.addChild(q);
			
			//var test1:JSprite = new JSprite(ModelCenter.dic["Test1"],ModelCenter.textures);
			
			//var obj:DisplayObject = test1.getChildByName("progress");
			//this.addChild(test1);
			
		}
	}
}