package jing.utils.display
{
	import flash.utils.getTimer;

	/**
	 * 计时器 
	 * @author Jing
	 * 
	 */	
	public class Time
	{
		public function Time():void
		{
			
		}
		
		/**
		 * 其实时间 
		 */		
		private var _startTime:int;
		
		/**
		 * 暂停开始的时刻 
		 */		
		private var _pauseStartTime:int = -1;
		
		/**
		 * 在暂停上总共花去的时间 
		 */		
		private var _pauseTotalTime:int;
		
		/**
		 * 启动计时器 
		 * @param passedTime 已经通过了的时间取值范围为int值的范围
		 * 
		 */		
		public function start(passedTime:int = 0):void
		{
			_startTime = getTimer() - passedTime;
			_pauseStartTime = -1;
			_pauseTotalTime = 0;
		}
		
		/**
		 * 设置计时器是否暂停 
		 * @param b
		 * 
		 */		
		public function setPause(b:Boolean):void
		{	
			if(isPause == b)
			{
				return;
			}
			
			if(true == b)
			{
				_pauseStartTime = getTimer();
			}
			else
			{
				_pauseTotalTime += getTimer() - _pauseStartTime;
				_pauseStartTime = -1;
			}
		}	
		
		/**
		 * 计时器是否暂停 
		 * @return 
		 * 
		 */		
		public function get isPause():Boolean
		{
			return _pauseStartTime > -1?true:false;
		}
		
		/**
		 * 计时器的时间 
		 * @return 
		 * 
		 */		
		public function get time():int
		{
			var nowTime:int = _pauseStartTime > -1?_pauseStartTime:getTimer();
			return nowTime - _startTime - _pauseTotalTime;
		}
	}
}