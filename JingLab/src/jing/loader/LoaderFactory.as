package jing.loader
{
	import flash.events.EventDispatcher;
	
	import jing.loader.interfaces.ILoader;
	
	/**
	 * 加载工厂(可以抱有多条流水线) 
	 * @author Jing
	 * 
	 */	
	public class LoaderFactory extends EventDispatcher
	{
		/**
		 * 工作线程集合 
		 */		
		private var _workers:Vector.<LoaderWorker>;
		
		/**
		 * 插入的新加载器所放入的流水线的索引 
		 */		
		private var _addIndex:int;
		
		/**
		 * 
		 * @param workerCount 加载线程数量,需大于等于1且小于等于15
		 * 
		 */		
		public function LoaderFactory(workerCount:int = 6)
		{
			if(workerCount < 1 || workerCount > 15)
			{
				throw new Error("workerCount不能小于1或大于15");
			}
			_workers = new Vector.<LoaderWorker>(workerCount,true);
			while(--workerCount > -1)
			{
				_workers[workerCount] = new LoaderWorker();
			}
 		}
		
		/**
		 * 添加的加载器会自动负载均衡分配到对应的流水线上 
		 * @param loader
		 * 
		 */		
		public function add(loader:ILoader):void
		{
			_workers[_addIndex++].add(loader);
			if(_addIndex >= _workers.length)
			{
				_addIndex = 0;
			}
		}
	}
}