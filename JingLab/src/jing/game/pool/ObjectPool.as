package jing.game.pool
{
	/**
	 * 对象池 
	 * @author Jing
	 * 
	 */	
	public class ObjectPool
	{
		/**
		 * 对象集合 
		 */		
		private var _pool:Vector.<Object> = null;
		
		private var _maxCapacity:int = 0;

		/**
		 * 最大对象数 
		 */
		public function get maxCapacity():int
		{
			return _maxCapacity;
		}

		public function get currentCapacity():int
		{
			return _pool.length;
		}
		
		private var _clsType:Class = null;

		/**
		 * 对象类型 
		 */
		public function get clsType():Class
		{
			return _clsType;
		}

		
		/**
		 * 创建一个对象池 
		 * @param maxCapacity 对象池最大对象数量
		 * @param clsType 对象的类型
		 * 
		 */		
		public function ObjectPool(maxCapacity:int, clsType:Class)
		{
			_pool = new Vector.<Object>();
			_maxCapacity = maxCapacity;
			_clsType = clsType;
		}
		
		/**
		 * 将对象放回池中 
		 * @param obj
		 * 
		 */		
		public function returnObject(obj:Object):void
		{
			if(obj is _clsType)
			{
				var nowCapacity:int = _pool.length;
				if(nowCapacity < _maxCapacity)
				{					
					_pool.push(obj);
				}
			}
		}
		
		/**
		 * 从对象池中取对象 
		 * @return 
		 * 
		 */		
		public function getObject():Object
		{
			var obj:Object = null;
			if(_pool.length > 0)
			{
//				trace("取已有对象！");
				obj = _pool.pop();
			}
			else
			{
//				trace("创建新对象！");
				obj = new _clsType();
			}
			return obj;
		}
	}
}