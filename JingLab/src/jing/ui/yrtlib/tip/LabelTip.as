package jing.ui.yrtlib.tip
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.framework.manager.tip.interfaces.ITip;
	
	/**
	 * 标签类型的Tip 
	 * @author jing
	 * 
	 */	
	public class LabelTip extends ViewBase implements ITip
	{
		private var _tf:TextField = null;
		public function LabelTip()
		{
			_tf = new TextField();
			super(_tf);
			init();
		}
		
		private function init():void
		{
			_tf.background = true;
			_tf.backgroundColor = 0x000000;
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFFFFFF;
			tf.size = 16;
			tf.bold = true;
			_tf.defaultTextFormat = tf;
			_tf.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * 设置Tip对象的数据 
		 * @param obj
		 * 
		 */		
		public function setData(obj:Object):void
		{
			var value:String = obj.toString();
			_tf.text = value;			
		}
		
		public function setIsAppend(b:Boolean):void
		{
			
		}
	}
}