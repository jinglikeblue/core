package jing.multiThread
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.system.MessageChannel;
    import flash.utils.Dictionary;

    /**
     * 线程类的基类
     * @author Jing
     *
     */
    public class AThread extends EventDispatcher
    {
		/**
		 * 消息流入通道 
		 */		
        protected var _inMC:MessageChannel;

		/**
		 * 消息流出通道 
		 */		
        protected var _outMC:MessageChannel;

		/**
		 * 存储方法的字典 
		 */		
        protected var _funDic:Dictionary = new Dictionary();

        public function AThread()
        {
			
        }

		/**
		 * 注册方法给线程回调 
		 * @param funName 方法名称
		 * @param fun 方法体
		 * 
		 */		
        public function registFun(funName:String, fun:Function):void
        {
            _funDic[funName] = fun;
        }

		/**
		 * 收到消息后，根据消息中传来的调用方法名调用对应的方法 
		 * @param e
		 * 
		 */		
        protected function _inMC_channelMessageHandler(e:Event):void
        {
            var a:Array = _inMC.receive() as Array;
            var funName:String = a.pop();
            var fun:Function = _funDic[funName];

            if (null != fun)
            {
                fun.apply(null, a);
            }
        }
		
		/**
		 * 调用线程中的方法 
		 * @param funName 方法名称
		 * @param args 方法对应的参数
		 * 
		 */		
		public function call(funName:String, ... args):void
		{
			args.push(funName);
			var a:Array = args.concat();
			_outMC.send(a);
		}
		
		/**
		 * 主线程流出消息的通道 
		 */		
		protected const MAIN_THREAD_MESSAGE_OUT_CHANNEL_KEY:String = "MTMOCK";
		
		/**
		 * 主线程消息流入的通道 
		 */		
		protected const MAIN_THREAD_MESSAGE_IN_CHANNEL_KEY:String = "MTMICK";
    }
}
