package jing.game.move
{
	import flash.utils.getTimer;

	public class MoveCompute
	{
		private var _startX:int;
		private var _startY:int;
		private var _endX:int;
		private var _endY:int;
		private var _totalTime:int;
		private var _startTime:int;
		private var _dx:int;
		private var _dy:int;
		
		private var _nowX:int;

		public function get nowX():int
		{
			return _nowX;
		}

		private var _nowY:int;

		public function get nowY():int
		{
			return _nowY;
		}

		public function MoveCompute()
		{
		}
		
		public function reset(startX:int, startY:int, endX:int, endY:int, speed:Number):void
		{
			_startX = startX;
			_startY = startY;
			_endX = endX;
			_endY = endY;
			_dx= endX - startX; 
			_dy = endY - startY;
			var distance:Number = Math.sqrt(_dx * _dx + _dy * _dy);
			_totalTime = Math.ceil(distance / speed);
			_startTime = getTimer();
		}
		
		public function update():Boolean
		{
			var costTime:int = getTimer() - _startTime;
			if(costTime > _totalTime)
			{
				_nowX = _endX;
				_nowY = _endY;
				return true;
			}
			var k:Number = costTime / _totalTime;
			_nowX = _startX + _dx * k;
			_nowY = _startY + _dy * k;
			return false;
		}
	}
}