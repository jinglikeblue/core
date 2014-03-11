package jing.ui.yrtlib.compment.base
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.framework.manager.tip.TipManager;
	import jing.framework.manager.tip.interfaces.ITipUser;
	import jing.framework.manager.tip.vo.TipVO;

	/**
	 * 组件基础类
	 * @author jing
	 *
	 */
	public class CompmentView extends ViewBase implements ITipUser
	{
		private var _isCallDraw:Boolean=false;

		public function CompmentView(gui:DisplayObject)
		{
			super(gui);
			TipManager.control(this);
		}

		public override function destroy():void
		{
			TipManager.uncontrol(this);
			super.destroy();
		}
		
		public function cancelTipManager():void
		{
			TipManager.uncontrol(this);
		}

		/**
		 * 重写该方法以达到完全刷新组件内容的目的
		 * 该方法最好作为最后一条语句在其它方法中调用（因为里面的内容实在下一帧执行的，有延迟)
		 *
		 */
		protected function callDraw():void
		{
			if (_isDestroyed)
			{
				return;
			}
			
			if (true == _isCallDraw)
			{
				return;
			}

			_isCallDraw=true;
			_gui.addEventListener(Event.ENTER_FRAME, _gui_enterFrameHandelr);
		}

		private function _gui_enterFrameHandelr(e:Event):void
		{
			if (_isDestroyed)
				return;
			_gui.removeEventListener(Event.ENTER_FRAME, _gui_enterFrameHandelr);
			draw();
			_isCallDraw=false;
		}

		/**
		 * 绘制视图
		 *
		 */
		public function draw():void
		{
			//该方法被各子类重写，用于完全绘制组件内容时通过callDraw来引发
		}

		// 默认tip --------------------------------------------------------------

		private var _tipLabel:String=null;

		public function get tipLabel():String
		{
			return _tipLabel;
		}

		public function set tipLabel(value:String):void
		{
			_tipLabel=value;
		}

		public function get tipDisplayObject():DisplayObject
		{
			return _gui;
		}

		public function get tipVO():TipVO
		{
			if(null == _tipLabel)
			{
				return null;
			}
			var tipVO:TipVO=new TipVO("LabelTip");
			tipVO.tipData=tipLabel;
			
			return tipVO;
		}
	}
}
