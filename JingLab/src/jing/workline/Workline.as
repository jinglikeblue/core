package jing.workline
{
    import flash.utils.getTimer;

    /**
     * 对list类型的数据结构进行基于时间片的遍历工作，避免通过for循环导致的cpu瞬时占用过大的情况
     * @author Jing
     *
     */
    public class Workline
    {
		/**
		 * 遍历到的索引 
		 */		
        protected var _index:int;

		/**
		 * 列表数据 
		 */		
		protected var _list:Array;

		/**
		 * 列表中数据传递给的方法 
		 */		
		protected var _fun:Function;

		/**
		 * 每次更新耗时限制 
		 */		
		protected var _costLimit:int;

		/**
		 * 是否循环遍历 
		 */		
		protected var _loop:Boolean;

        /**
         * 工作是否结束
         * 只有当_loop为false时，该值会被标记为true
         */
		protected var _workEnd:Boolean;

		/**
		 *  
		 * @param list 列表
		 * @param fun 对列表中项施加的方法
		 * @param costLimit 每次更新耗时限制
		 * @param loop 是否循环遍历
		 * 
		 */		
        public function Workline(list:Array, fun:Function, costLimit:int, loop:Boolean = false)
        {
            _list = list;
            _index = list.length;
            _fun = fun;
            _costLimit = costLimit;
            _loop = loop;
            _workEnd = false;
            super();
        }

        /**
         * 调用更新
         *
         */
        public function update():int
        {
            if (_workEnd)
            {
                return 0;
            }

            var count:int = _list.length;

            if (_index < 0 || _index > count)
            {
                _index = count;
            }
            var item:Object;
            var costTime:int;
            var startTime:int = getTimer();

            while (--_index > -1)
            {
                if (costTime >= _costLimit)
                {
					//trace(costTime);
                    break;
                }
                item = _list[_index];
                _fun.call(null, item);
				costTime = getTimer() - startTime;
            }

            if (_index < 0 && false == _loop)
            {
                _workEnd = true;
            }
			
			return costTime;
        }
    }
}
