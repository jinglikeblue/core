package jing.turbo.turboM.elements
{
	import jing.turbo.interfaces.IMovieElement;
	import jing.turbo.strip.vo.StripVO;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * 多帧连环画元素
	 * @author jing
	 *
	 */
	public class MovieElementM extends ElementM implements IMovieElement
	{
		private var _frameCount:int = 0;

		/**
		 * 取得当前包含的所有图像的总数
		 * 和frameOrderList的长度不同
		 * @return
		 *
		 */
		public function get frameCount():int
		{
			return _frameCount;
		}

		private var _bmds:Vector.<BitmapData> = null;

		/**
		 * 帧数据集合
		 */
		public function get bmds():Vector.<BitmapData>
		{
			return _bmds;
		}

		/**
		 * @private
		 */
		public function set bmds(value:Vector.<BitmapData>):void
		{
			_bmds = value;
			_frameCount = _bmds.length;
			gotoAndStop(1);
		}

		private var _currentFrame:int = 0;

		/**
		 * 播放帧列表中所指向的帧的位置
		 * @return
		 *
		 */
		public function get curremtFrame():int
		{
			return _currentFrame;
		}
		
		private var _isBackwards:Boolean = false;
		
		/**
		 * 是否倒着播放 
		 */
		public function get isBackwards():Boolean
		{
			return _isBackwards;
		}
		
		/**
		 * @private
		 */
		public function set isBackwards(value:Boolean):void
		{
			_isBackwards = value;
		}
		
		/**
		 * 是否播放动画 
		 */		
		private var _isPlay:Boolean = false;
		

		private var _frameOrderList:Array = null;

		/**
		 * 动画播放的顺序列表，如果为空，则按图像数组的顺序播放
		 * 顺序列表为每一帧的帧索引组成的数组
		 * 例如：[1,1,2,4,0] 表示数组索引1的图像播放两帧，第三帧为数组索引2的图像，第四帧为数组索引为4的动画
		 */
		public function get frameOrderList():Array
		{
			return _frameOrderList;
		}

		/**
		 * @private
		 */
		public function set frameOrderList(value:Array):void
		{
			_frameOrderList = value;
		}


		/**
		 * 默认使用的图像数据，如果没有，则生成一个高宽为1的位图数据
		 * @param bmd
		 *
		 */
		public function MovieElementM(bmd:BitmapData = null)
		{
			if (null == bmd)
			{
				bmd = new BitmapData(1, 1);
			}
			super(bmd);
		}	

		/**
		 * 从指定位置开始播放
		 * @param frameIndex 从0开始
		 *
		 */
		public function gotoAndPlay(frameIndex:int):void
		{
			showFrame(frameIndex);
			play();
		}

		/**
		 * 停止到指定帧
		 * @param frameIndex 从0开始
		 *
		 */
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