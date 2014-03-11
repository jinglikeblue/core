package jing.turbo.turboS.elements
{
	import jing.turbo.interfaces.IMovieElement;
	
	import flash.display.BitmapData;
	
	public class MovieElementS extends ElementS implements IMovieElement
	{
		public function MovieElementS(bmd:BitmapData=null)
		{
			super(bmd);
		}
		
		private var _frameCount:int = 0;
		
		public function get frameCount():int
		{
			return _frameCount;
		}
		
		private var _bmds:Vector.<BitmapData> = null;
		
		public function get bmds():Vector.<BitmapData>
		{
			return _bmds;
		}
		
		public function set bmds(value:Vector.<BitmapData>):void
		{
			_bmds = value;
			_frameCount = _bmds.length;
			gotoAndStop(1);
		}
		
		private var _currentFrame:int = 0;
		
		public function get curremtFrame():int
		{
			return _currentFrame;
		}		
		
		private var _isBackwards:Boolean = false;		
		
		public function get isBackwards():Boolean
		{
			return _isBackwards;
		}
		
		public function set isBackwards(value:Boolean):void
		{
			_isBackwards = value;
		}
		
		/**
		 * 是否播放动画 
		 */		
		private var _isPlay:Boolean = false;
		
		
		private var _frameOrderList:Array = null;
		
		public function get frameOrderList():Array
		{
			return _frameOrderList;
		}
		
		public function set frameOrderList(value:Array):void
		{
			_frameOrderList = value;
		}
		
		public function gotoAndPlay(frameIndex:int):void
		{
			showFrame(frameIndex);
			play();
		}
		
		public function gotoAndStop(frameIndex:int):void
		{
			showFrame(frameIndex);
			stop();
		}
		
		/**
		 * 显示指定帧 
		 * @param frameIndex
		 * 
		 */		
		private function showFrame(frameIndex:int):void
		{
			_currentFrame = frameIndex;
			if (null != _frameOrderList)
			{
				frameIndex = _frameOrderList[_currentFrame];
			}
			super.bitmapData = _bmds[frameIndex];
		}
		
		/**
		 * 刷新 
		 * 
		 */		
		public function fresh():void
		{
			if(false == _isPlay)
			{
				return;
			}
			
			if(true == _isBackwards)
			{
				prevFrame();
			}
			else
			{
				nextFrame();
			}
		}

		
		/**
		 * 播放
		 *
		 */
		public function play():void
		{
			_isPlay = true;
		}
		
		/**
		 * 停止
		 *
		 */
		public function stop():void
		{
			_isPlay = false;
		}	
		
		/**
		 * 上一帧
		 *
		 */
		public function prevFrame():void
		{
			var newFrameIndex:int = _currentFrame - 1;
			
			if(0 == newFrameIndex)
			{
				if(false == _isBackwards)
				{
					return;
				}
				
				//如果是倒播，则跳到最后一帧
				if(null == _frameOrderList)
				{
					newFrameIndex = _bmds.length - 1;
				}
				else
				{
					newFrameIndex = _frameOrderList.length - 1;
				}
			}
			
			showFrame(newFrameIndex);
		}
		
		/**
		 * 下一帧
		 *
		 */
		public function nextFrame():void
		{
			var newFrameIndex:int = _currentFrame + 1;
			if(null == _frameOrderList)
			{
				if(newFrameIndex == _bmds.length)
				{
					newFrameIndex = 0;
				}
			}
			else
			{
				if(newFrameIndex == _frameOrderList.length)
				{
					newFrameIndex = 0;
				}
			}			
			
			showFrame(newFrameIndex);
		}
		
		/**
		 * 销毁对象
		 *
		 */
		override public function destory():void
		{
			super.destory();
		}
		
		override public function enterNextFrame():void
		{
			this.fresh();
		}
	}
}