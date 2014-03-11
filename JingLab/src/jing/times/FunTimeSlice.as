package jing.times
{
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	/**
	 * 对方法进行分时间处理的工具类,该类将会按照指定的时间间隔来执行方法
	 * @author Jing
	 *
	 */
	public class FunTimeSlice
	{
		public function FunTimeSlice():void
		{
			
		}
		
		private var _funs:Vector.<FunVO> = new Vector.<FunVO>();
		
		public function update():void
		{
			var index:int = _funs.length;
			var funVO:FunVO;
			var time:uint;
			while(--index > -1)
			{
				funVO = _funs[index];
				time = getTimer();
				if(time >= funVO.beCallTime)
				{
					funVO.fun.call(null);
					funVO.costTime = getTimer() - time;
					funVO.beCallTime = getTimer() + funVO.interval;
				}
			}
		}
		
		public function addFun(fun:Function,interval:uint, delay:uint = 0):void
		{
			var vo:FunVO = new FunVO();			
			vo.fun = fun;
			vo.beCallTime = getTimer() + delay;
			vo.interval = interval;
			vo.delay = delay;
			_funs.push(vo);
			
		}
	}
}

class FunVO
{
	public function FunVO():void
	{
		
	}
	
	public var fun:Function;
	public var beCallTime:uint;
	public var interval:uint;
	public var delay:uint;
	public var costTime:uint;
	
}
