package jing.multiThread
{
    import flash.events.Event;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    /**
     * 在主线程中创建的线程对象
     * @author Jing
     *
     */
    public class Thread extends AThread
    {
        protected var _worker:Worker;

        /**
         * 是否捕获错误并打印
         * @param b
         *
         */
        public function set catchError(b:Boolean):void
        {
            if (true == b)
            {
                registFun(ThreadFixedFun.ERROR, error);
            }
            else
            {
                delete _funDic[ThreadFixedFun.ERROR];
            }
        }

        public function get catchError():Boolean
        {
            return null == _funDic[ThreadFixedFun] ? false : true;
        }

        /**
         *
         * @param bytes 线程对应的SWF文件
         * @param initedFun 线程启动成功后执行的方法，通过该方法确定线程正在执行
         *
         */
        public function Thread(bytes:ByteArray, initedFun:Function = null)
        {
            _worker = WorkerDomain.current.createWorker(bytes);
            var toWorkerMC:MessageChannel = Worker.current.createMessageChannel(_worker);
            var fromWorkerMC:MessageChannel = _worker.createMessageChannel(Worker.current);
            _worker.setSharedProperty(MAIN_THREAD_MESSAGE_OUT_CHANNEL_KEY, toWorkerMC);
            _worker.setSharedProperty(MAIN_THREAD_MESSAGE_IN_CHANNEL_KEY, fromWorkerMC);
            _outMC = toWorkerMC;
            _inMC = fromWorkerMC;

            if (null != initedFun)
            {
                registFun(ThreadFixedFun.INITED, initedFun);
            }
        }

        /**
         * 启动线程
         *
         */
        public function start():void
        {
            _inMC.addEventListener(Event.CHANNEL_MESSAGE, _inMC_channelMessageHandler);
            _worker.start();
        }

        /**
         * 停止线程
         * @return
         *
         */
        public function stop():Boolean
        {
            _inMC.removeEventListener(Event.CHANNEL_MESSAGE, _inMC_channelMessageHandler);
            return _worker.terminate();
        }

        /**
         * 如果彻底不用改线程了，则销毁掉
         *
         */
        public function destroy():void
        {
            _worker.setSharedProperty(MAIN_THREAD_MESSAGE_OUT_CHANNEL_KEY, null);
            _worker.setSharedProperty(MAIN_THREAD_MESSAGE_IN_CHANNEL_KEY, null);
            stop();
            _funDic = new Dictionary();
            _inMC = null;
            _outMC = null;
        }

        /**
         * 错误信息
         * @param info
         *
         */
        private function error(info:String):void
        {
            var errorInfo:String = "****Thread Error: " + info + "****";
            trace(errorInfo);
            this.dispatchEvent(new ThreadErrorEvent(ThreadErrorEvent.ERROR, errorInfo));
        }
    }
}
