package jing.multiThread
{
    import flash.events.Event;
    import flash.system.Worker;

	/**
	 * 创建的子线程文件的线程体 
	 * @author Jing
	 * 
	 */	
    public class ThreadBody extends AThread
    {
        public function ThreadBody()
        {
			try
			{
            	init();
			}
			catch(e:Error)
			{
				trace("线程启动失败!");
			}
        }

        private function init():void
        {
            _inMC = Worker.current.getSharedProperty(MAIN_THREAD_MESSAGE_OUT_CHANNEL_KEY);
            _outMC = Worker.current.getSharedProperty(MAIN_THREAD_MESSAGE_IN_CHANNEL_KEY);
            _inMC.addEventListener(Event.CHANNEL_MESSAGE, _inMC_channelMessageHandler);
            call(ThreadFixedFun.INITED);
//			registFun("sayHello",sayHello);
        }
		
		private function sayHello():void
		{
			trace("hello!");
		}

        override protected function _inMC_channelMessageHandler(e:Event):void
        {
            try
            {
                super._inMC_channelMessageHandler(e);
            }
            catch (err:Error)
            {
                super.call(ThreadFixedFun.ERROR, err.toString());
            }
        }
    }
}
