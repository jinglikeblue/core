package jing.times
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;

	/**
	 * 强化的Timer，带有暂停功能
	 * @author jing
	 * @date 2010-10-27 
	 */	
    public class TimerAdvance extends Timer
    {
        private var _delay:Number = 0;

        private var _timerStartDate:Date = null;

        private var _pastTime:Number = -1;

        public function TimerAdvance(delay:Number, repeatCount:int = 0)
        {
            _delay = delay;
            super(delay, repeatCount);
        }

        private function timerHandler(e:TimerEvent):void
        {
			syncDelay();
            _timerStartDate = new Date();
        }
		
		private function syncDelay():void
		{
			if(super.delay != _delay)
			{
				super.delay = _delay;	
			}
		}

        override public function start():void
        {
            super.addEventListener(TimerEvent.TIMER, timerHandler);
            _timerStartDate = new Date();
            super.start();
        }

        override public function stop():void
        {
			syncDelay();
            _timerStartDate = null;
            super.removeEventListener(TimerEvent.TIMER, timerHandler);
            super.stop();
        }

		private var _isTimerPause:Boolean = false;
		
		/**
		 * pause the timer and record the past delay time
		 * when call continueTimer function, the timer
		 * will run and will dispatch TimerEvent when 
		 * the remaining delay time pass 
		 * 
		 */		
        public function pauseTimer():void
        {
            if (false == _isTimerPause && true == super.running)
            {
				_isTimerPause = true;
                _pastTime = new Date().time - _timerStartDate.time;
                super.stop();
            }
        }

		/**
		 * continue run the timer by pause record
		 * 
		 */		
        public function continueTimer():void
        {
            if (true == _isTimerPause && false == super.running)
            {
				_isTimerPause = false;
                var newDelay:int = super.delay - _pastTime;
                super.delay = newDelay;
                _timerStartDate = new Date();
                super.start();
            }
        }
		
		/**
		 * this function can return a number value the past delay time.
		 * if game not paused, this function will return -1 
		 * @return 
		 * 
		 */		
		public function getPastDelay():Number
		{
			return _pastTime;
		}
		
		/**
		 * this function can return a number value the remaining delay time.
		 * if game not paused, this function will return -1
		 * @return 
		 * 
		 */		
		public function getRemainingDelay():Number
		{
			var result:Number = -1;
			if(true == _isTimerPause)
			{
				result = super.delay - _pastTime;
			}
			return result;
		}

		
        override public function reset():void
        {
            stop();
            super.reset();
        }

        override public function set delay(value:Number):void
        {
            _delay = value;
            _timerStartDate = new Date();
            super.delay = value;
        }

        override public function get delay():Number
        {
            return _delay;
        }
    }
}
