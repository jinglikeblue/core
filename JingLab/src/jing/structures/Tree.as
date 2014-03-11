package jing.structures
{
	import flash.utils.Dictionary;

	/**
	 * 树 
	 * @author jing
	 * 
	 */	
	public class Tree
	{
		private var _dic:Dictionary;
		private var _value:Object;
		public function Tree()
		{
			_dic = new Dictionary();
		}
		
		public function getNode(node:Object):Tree
		{
			if(null == _dic[node])
			{
				_dic[node] = new Tree;
			}
			return _dic[node];
		}
		
		public function getValue():Object
		{
			return _value;
		}
		
		public function setValue(value:Object):void
		{
			_value = value;
		}
	}
}