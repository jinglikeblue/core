package jing.ui.plugin
{
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * 帧数、内存监测器
	 * @author GoSoon
	 *
	 */
	public class FPSMemCounter extends TextField
	{
		private var fontSize:Number; //the font size for the field
		private var bold:Boolean;
		private var lastUpdate:Number; // the results of getTimer() from the last update
		private var frameCount:Number; //stores the count of frames passed this second
		private var currentTime:Number;
		private static const UPDATE_INTERVAL:Number=1000; //the interval at which the frame count will be be posted

		public function FPSMemCounter(textColor:Number=0xFFFFFF, fontSize:Number=15, bold:Boolean=true):void
		{
			this.mouseEnabled=false;
			this.textColor=textColor;
			this.fontSize=fontSize;
			this.bold=bold;

			autoSize=TextFieldAutoSize.LEFT;

			selectable=false;
			mouseEnabled=false;

			addEventListener(Event.ADDED_TO_STAGE, setFPSUpdate);
			addEventListener(Event.REMOVED_FROM_STAGE, clearFPSUpdate);
		}

		/**
		 * 开始监测
		 * @param event
		 *
		 */
		private function setFPSUpdate(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, updateFPS);
			frameCount=0;
			updateText(frameCount);
			lastUpdate=getTimer();
		}

		/**
		 * 停止监测
		 * @param event
		 *
		 */
		private function clearFPSUpdate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, updateFPS);
		}

		/**
		 * 刷新监测器
		 * @param event
		 *
		 */
		private function updateFPS(event:Event):void
		{
			//get the current time and increment the frame counter
			currentTime=getTimer();
			frameCount++;

			//post the frame count if more then a second has passed
			if (currentTime >= lastUpdate + UPDATE_INTERVAL)
			{
				lastUpdate=currentTime;
				updateText(frameCount);
				frameCount=0;
			}
		}

		/**
		 * 刷新数据显示
		 * @param frameNum 数据
		 *
		 */
		private function updateText(frameNum:Number):void
		{
			var mem:String=Number(System.totalMemory / 1024 / 1024).toFixed(2) + 'Mb';
			htmlText="<span><strong>FPS:</strong>" + frameNum + " fps<strong> Memory:</strong>" + mem + "</span>";
			var tf:TextFormat=new TextFormat("Arial", this.fontSize, this.textColor, this.bold);
			this.setTextFormat(tf);
		}
	}
}