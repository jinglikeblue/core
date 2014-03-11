package jing.turbo.turboS.elements
{    
    import jing.turbo.animateUtil_old.vos.AnimateVO;
    import jing.turbo.handle.AnimateHandle;
    import jing.turbo.handle.Handle;
    
    import flash.display.BitmapData;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import flashx.textLayout.formats.Direction;

    /**
     * 位图动画类
	 * 可以用当前类构建一个动画角色，可以添加不同的动作、不同的朝向的动画
     * @author Jing
     *
     */
    public class Animate2DS_old extends ElementS
    {
		/**
		 * 动作字典 
		 */		
        private var _actionsDirection:Object = null;


        private var _frameTimer:Timer = null;

		/**
		 * 当前播放帧的索引
		 */		
        private var _frameIndex:int = 0;

		/**
		 * 动画人物的方向 
		 */		
        private var _dir:int = 0;
		
		/**
		 * 临时位图数据,在VO中没有动画数据的时候，用临时数据替代动画数据 
		 */		
		private var _tempBmd:BitmapData = null;
		
		/**
		 * 动画中的时间 
		 */		
		private var _time:int = 0;

		/**
		 * 角色的方向 
		 * @return 
		 * 
		 */		
		public function get dir():int
		{
			return _dir;
		}

		/**
		 * 角色的方向 
		 * @return 
		 * 
		 */	
		public function set dir(value:int):void
		{
			_dir = value;
		}


        private var _runningAction:AnimateVO = null;

		/**
		 * 当前正在执行的动作 
		 * @return 
		 * 
		 */		
		public function get runningAction():AnimateVO
		{
			return _runningAction;
		}

		/**
		 * 默认使用的图像数据，如果没有，则生成一个高宽为1的位图数据 
		 * @param bmd
		 * 
		 */
        public function Animate2DS_old(bmd:BitmapData = null)
        {
            if (null == bmd)
            {
                bmd = _tempBmd = new BitmapData(1, 1);
            }
            super(bmd);
        }

		/**
		 * 通过动作名称得到动作 
		 * @param actionName
		 * @return 
		 * 
		 */		
        public function getAction(actionName:String):AnimateVO
        {
			if(null == _actionsDirection)
			{
				return null;
			}
            return _actionsDirection[actionName];
        }

		/**
		 * 为动画类增加一个动作 
		 * @param vo
		 * 
		 */		
        public function addAction(vo:AnimateVO):void
        {
            if (null == _actionsDirection)
            {
                _actionsDirection = new Object();
            }

            _actionsDirection[vo.actionName] = vo;
        }
		
		/**
		 * 改变当前动作的方向 
		 * @param dir
		 * 
		 */		
		public function changeDir(dir:int):void
		{
			if(_dir == dir)
			{
				return;
			}
			_dir = dir;
			refreshFrame();
			this.centerPoint = _runningAction.originList[_dir];
		}

		/**
		 * 执行动作 
		 * @param actionName 动作名称
		 * @param dir 动作方向
		 * @return 
		 * 
		 */		
        public function runAction(actionName:String, dir:int = int.MAX_VALUE):Boolean
        {
			if(null != _runningAction && actionName == _runningAction.actionName)
			{
				return true;	
			}
			
			var toAction:AnimateVO = getAction(actionName);            
			
            if (null == toAction)
            {
                return false;
            }

			_runningAction = toAction;
			if(int.MAX_VALUE != dir)
			{
				_dir = dir;
			}			
			
            if (null == _frameTimer)
            {
                _frameTimer = new Timer(_runningAction.oneFrameTime);
                _frameTimer.addEventListener(TimerEvent.TIMER, _frameTimer_timerHandler);
            }
			else
			{
				_frameTimer.delay = _runningAction.oneFrameTime;
			}
			
			_frameTimer.reset();
			_frameTimer.start();
//			start();
			_frameIndex = 0;			
			refreshFrame();
			
			if(null != _runningAction.originList)
			{
				super.centerPoint = _runningAction.originList[_dir];
			}
			return true;
        }
		
		private function start():void
		{
			this.addHandleListener(Handle.ENTER_FRAME, enterFrameHandler);
			_time = getTimer();
		}
		
		
		private function enterFrameHandler(e:Handle):void
		{
			var nowTime:int = getTimer();
			var intervalTime:int = getTimer() - _time;
			if(intervalTime >= _runningAction.oneFrameTime)
			{
//				trace("_time：",_time);
				refreshFrame();
				_time = nowTime - (intervalTime % _runningAction.oneFrameTime);
			}
		}
		
		private function stop():void
		{
			this.removeHandleListener(Handle.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * 计时器事件
		 * @param e
		 * 
		 */		
        private function _frameTimer_timerHandler(e:TimerEvent):void
        {
			refreshFrame();
        }
		
		/**
		 * 刷新帧
		 * 如果这个时候只有VO对象但是没有实际的图像数据，还是计算帧数并广播对应事件
		 * 
		 */		
		private function refreshFrame():Boolean
		{
			if(null != _runningAction.frameData)
			{
				super.bitmapData = _runningAction.frameData[_dir][_frameIndex];
			} 
			
			_frameIndex++;
			if (_frameIndex >= _runningAction.frameCount)
			{
				this.sendHandle(new AnimateHandle(AnimateHandle.FRAME_OVER));
				_frameIndex = 0;
			}	
			
			return true;
		}
		
		/**
		 * 继续运行动画 
		 * 
		 */		
		public function continueAnimate():void
		{
			_frameTimer.start();
		}
		
		/**
		 * 暂停动画播放 
		 * 
		 */		
		public function pauseAnimate():void
		{
			_frameTimer.stop();
		}

		/**
		 * 销毁对象 
		 * 
		 */		
        override public function destory():void
        {
			if(null != _tempBmd)
			{
				_tempBmd.dispose();
			}
			
//            if (null != _frameTimer)
//            {
//                _frameTimer.removeEventListener(TimerEvent.TIMER, _frameTimer_timerHandler);
//            }
			
			super.destory();
        }
    }
}