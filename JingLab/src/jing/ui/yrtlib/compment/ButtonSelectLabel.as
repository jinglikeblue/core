package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;

	/**
	 * 带文本内容的可选中按钮
	 * @author Owen
	 */	
	public class ButtonSelectLabel extends ButtonSelect
	{
		private var _labelStr:String;
		private var _label:TextField;
		
		public function ButtonSelectLabel(gui:DisplayObject, label:String = null)
		{
			super(gui);
			if(label == null)
			{
				label = "";
			}
			_labelStr = label;
			displayLabel();
		}
		/**
		 * 显示文本内容
		 */		
		private function displayLabel():void
		{
			_label = new TextField();
			_label.mouseEnabled = false;
			_label.x = 10;
			_label.y = 5;
			_label.width = gui.width;
			_label.height = gui.height;
			(gui as DisplayObjectContainer).addChild(_label);
			_label.text = _labelStr;
			
			var labelFormat:TextFormat = new TextFormat("微软雅黑", 16, 0x2d1e19, true);
			_label.defaultTextFormat = labelFormat;
		}
		/**
		 * 
		 * @param event
		 */
		override protected function buttonSkin_clickHandler(event:MouseEvent):void
		{
			super.buttonSkin_clickHandler(event);
			var labelFormat:TextFormat;
			if(selected)
			{
				labelFormat = new TextFormat("微软雅黑", 16, 0xfa693f, true);
			}
			else
			{
				labelFormat = new TextFormat("微软雅黑", 16, 0x2d1e19, true);
			}
			_label.defaultTextFormat = labelFormat;
		}
	}
}