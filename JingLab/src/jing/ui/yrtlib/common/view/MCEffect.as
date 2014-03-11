package jing.ui.yrtlib.common.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import jing.framework.core.view.base.ViewBase;


	/**
	 * MC特效播放
	 * @author jing
	 *
	 */
	public class MCEffect extends ViewBase
	{
		private var _mc:MovieClip=null;
		private var _onFinish:Function=null;

		public function MCEffect(gui:DisplayObject, onFinish:Function=null)
		{
			super(gui);
			_onFinish=onFinish;
			_mc=gui as MovieClip;
			_mc.mouseChildren=false;
			_mc.mouseEnabled=false;
		}

		override public function addListeners():void
		{
			_mc.addEventListener(Event.ENTER_FRAME, _mc_enterFrameHandler);
		}

		override public function removeListeners():void
		{
			_mc.removeEventListener(Event.ENTER_FRAME, _mc_enterFrameHandler);
		}

		private function _mc_enterFrameHandler(e:Event):void
		{
			if (_mc.currentFrame == _mc.totalFrames)
			{
				this.destroy();
				if (_onFinish != null)
				{
					_onFinish();
					_onFinish=null;
				}
			}
		}
	}
}
