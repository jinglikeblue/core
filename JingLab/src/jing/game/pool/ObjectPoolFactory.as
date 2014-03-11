package jing.game.pool
{
	import flash.utils.Dictionary;

    /**
     * 对象池工厂类
     * @author Jing
     *
     */
    public class ObjectPoolFactory
    {
		static private var _poolDic:Dictionary = new Dictionary();
		
        /**
         * 创建一个对象池
         * @param maxCapacity 该对象池的最大对象数量
         * @param clsType 对象池中对象的类型
         * @return
         *
         */
        static public function createPool(maxCapacity:int, clsType:Class):ObjectPool
        {
			var pool:ObjectPool = null;
			if(null == _poolDic[clsType])
			{
				pool = new ObjectPool(maxCapacity, clsType);
				_poolDic[clsType] = pool;				
			}
			else
			{
				pool = _poolDic[clsType] as ObjectPool;
			}
			return pool;
        }
		
		/**
		 * 得到对象池 
		 * @param clsType
		 * @return 
		 * 
		 */		
		static public function getPool(clsType:Class):ObjectPool
		{
			return _poolDic[clsType];
		}
    }
}