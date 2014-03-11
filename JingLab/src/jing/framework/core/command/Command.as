package jing.framework.core.command
{
	import flash.utils.Dictionary;

	/**
	 * 命令的基类 
	 * @author jing
	 * @date 2012-03-12
	 * 
	 */	
	public class Command implements ICommand
	{
		/**
		 * 命令类型 
		 */		
		private var _type:String = null;
		
		/**
		 * 命令字典 
		 */		
		private var _cmds:Dictionary = null;
		
		public function Command(type:String)
		{
			_type = type;
		}
		
		/**
		 * 注册一个命令类型 
		 * @param type 命令的类型名
		 * @param fun 对应的方法
		 * 
		 */		
		public function regType(type:String, fun:Function):void
		{
			if(null == _cmds)
			{
				_cmds = new Dictionary();
			}
			
			_cmds[type] = fun;
		}
		
		public function excute():void
		{
			_cmds[_type]();
		}
	}
}