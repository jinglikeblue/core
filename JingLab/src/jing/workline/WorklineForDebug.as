package jing.workline
{

    public class WorklineForDebug extends Workline
    {

        private var _periodCost:int;

		/**
		 * 遍历完成一次总耗时
		 */
        public function get periodCost():int
        {
            return _periodCost;
        }

        private var _tempCost:int;

        public function WorklineForDebug(list:Array, fun:Function, costLimit:int, loop:Boolean = false)
        {
            super(list, fun, costLimit, loop);
        }

        /**
         * 调用更新
         *
         */
        override public function update():int
        {
            var costTime:int = super.update();
            _tempCost += costTime;

            if (_index < 0)
            {
                _periodCost = _tempCost;
				_tempCost = 0;
            }
            return costTime;
        }
    }
}
