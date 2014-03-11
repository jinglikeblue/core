package jing.framework.manager.module.gui
{
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    
    import flashx.textLayout.events.ModelChange;
    
    import jing.framework.manager.loader.LoaderQueueInfo;
    import jing.framework.manager.module.ModuleManager;
    import jing.framework.manager.module.ModuleQueue;
    import jing.utils.cache.CacheLevel;

    /**
     * 界面加载器
     * @author jing
     *
     */
    public class GUILoader extends EventDispatcher
    {
        private var _guiName:String = null;

        /**
         * 视图的名称
         * @return
         *
         */
        public function get guiName():String
        {
            return _guiName;
        }

        private var _swfPaths:Array = null;

        /**
         * 视图所在SWF的名称
         * @return
         *
         */
        public function get swfPaths():Array
        {
            return _swfPaths;
        }

        private var _createComplete:Function = null;

        /**
         * 创建完毕用的方法
         * @return
         *
         */
        public function get createComplete():Function
        {
            return _createComplete;
        }

        public function set createComplete(fun:Function):void
        {
            _createComplete = fun;
        }

        private var _guiDefinition:String = null;

        /**
         * 返回GUI的定义 供ModuleManager.getObject使用
         */
        public function get guiDefinition():String
        {
            return _guiDefinition;
        }

        public function GUILoader()
        {
        }

        /**
         *
         * @param viewName 视图的名称
         * @param guiName 视图所在SWF的名称
         * @param createComplete 创建完毕用的方法
         *
         */
        public function load(guiName:String, swfPaths:Array, createComplete:Function):void
        {
            _guiName = guiName;
            _guiDefinition = guiName;


            _createComplete = createComplete;

            _swfPaths = swfPaths;
			
            var swfPath:String = null;


            if (null != swfPaths && swfPaths.length > 0)
            {
                var mq:ModuleQueue = new ModuleQueue(moduleLoadProgress, viewGUI_loadCompleteHandler);
                var count:int = swfPaths.length;
                var eachPercent:int = 100 / count;

                for (var i:int = 0; i < count; i++)
                {
                    swfPath = swfPaths[i];
					
					if(null !=  GUIFactory.swfVerDic)
					{
						var swfVerVO:SwfVerVO = GUIFactory.swfVerDic[swfPath];
						
						if(null != swfVerVO)
						{
							mq.addModule(swfPath, null, swfVerVO.cacheLevel, eachPercent, swfVerVO.ver);
							continue;
						}
						
					}

                    mq.addModule(swfPath, null, CacheLevel.MEM, eachPercent);
                }
                ModuleManager.loadModuleQueue(mq);
            }
        }

        private function moduleLoadProgress(info:LoaderQueueInfo):void
        {
            this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, info.currentListValue, 100));
        }

        private function viewGUI_loadCompleteHandler(obj:LoaderQueueInfo):void
        {
            if (null == _createComplete)
            {
                return;
            }
            _createComplete(_guiName);
        }
    }
}