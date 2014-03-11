package jing.framework.manager.module
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    
    import jing.framework.manager.loader.DisplayLoader;
    import jing.framework.manager.loader.LoaderManager;
    import jing.framework.manager.loader.interfaces.ILoader;
    import jing.framework.manager.module.gui.GUIFactory;
    import jing.framework.manager.module.gui.SwfVerVO;
    import jing.framework.manager.stage.StageManager;
    import jing.utils.cache.CacheLevel;

    /**
     * 模块加载类
     * @author Jing
     *
     */
    public class ModuleManager
    {
        /**
         * 应用域字典
         */
        static private var _domainDic:Dictionary = null;

        /**
         * 创建一个应用域
         * @param name
         * @return
         *
         */
        static public function createDomain(name:String):ApplicationDomain
        {
            if (null == _domainDic[name])
            {
                _domainDic[name] = new ApplicationDomain();
            }
            return _domainDic[name];
        }

        /**
         * 得到一个应用域
         * @param name
         * @return
         *
         */
        static public function getDomain(name:String):ApplicationDomain
        {
            return _domainDic[name];
        }

        /**
         * 已加载的模块总数
         */
        static private var _moduleLoadedCount:int = 0;

        /**
         * 得到已加载的模块总数
         * @return
         *
         */
        static public function get moduleLoadedCount():int
        {
            return _moduleLoadedCount;
        }

        //		static internal var loadedModuleDic:Dictionary = null;
        //
        //		static public function checkModuleLoaded(name:String):void
        //		{
        //			
        //		}

        /**
         * 默认模块应用域
         * @return
         *
         */
        static public function get defaultDomain():ApplicationDomain
        {
            return _domainDic["defaultDomain"];
        }

        /**
         * 初始化模块管理类
         * @param domain 模块管理类使用的域,如果设置为null则使用的是本地域
         */
        static public function init(defaultDomain:ApplicationDomain = null):void
        {
            _domainDic = new Dictionary();

            //			loadedModuleDic = new Dictionary();
            if (null == defaultDomain)
            {
                _domainDic["defaultDomain"] = new ApplicationDomain();
            }
            else
            {
                _domainDic["defaultDomain"] = defaultDomain;
            }
        }

        /**
         * 加载模块队列
         * @param moduleQueue
         *
         */
        static public function loadModuleQueue(moduleQueue:ModuleQueue):void
        {
            moduleQueue.startLoad();
        }


        /**
         * 加载一个模块
         * @param modulePath
         * @callBackFunc 指定模块加载完毕的回调方法，携带的数据类型为[ModuleLoadInfo]
         */
        static public function loadModule(modulePath:String, progressFun:Function = null, complementFun:Function = null, loaderContent:LoaderContext = null, cacheLevel:int = CacheLevel.NONE, cacheVer:String = null):void
        {
            var mq:ModuleQueue = new ModuleQueue(progressFun, complementFun);			
			
            mq.addModule(modulePath, loaderContent, cacheLevel, 0, cacheVer);
            loadModuleQueue(mq);
        }

        /**
         * 判断加载的模块中是否有指定的类
         * @param name
         * @return
         *
         */
        static public function hasClass(name:String, domain:ApplicationDomain = null):Boolean
        {
            if (null == domain)
            {
                domain = defaultDomain;
            }
            return domain.hasDefinition(name);
        }

        /**
         * 从加载的模块中取出指定的类
         * @param name
         * @return
         *
         */
        static public function getClass(name:String, domain:ApplicationDomain = null):Class
        {
            if (null == domain)
            {
                domain = defaultDomain;
            }

            if (true == domain.hasDefinition(name))
            {
                return domain.getDefinition(name) as Class;
            }
            else
            {
                return null;
            }
        }

        /**
         * 通过指定类名从模块中抽取一个实例对象
         * @param name
         * @return
         *
         */
        static public function getObject(name:String, domain:ApplicationDomain = null):Object
        {
            if (null == domain)
            {
                domain = defaultDomain;
            }

            if (true == domain.hasDefinition(name))
            {
                var cls:Class = domain.getDefinition(name) as Class;
                return new cls();
            }
            else
            {
                return null;
            }
        }

        /**
         * 通过指定类名从模块中抽取一个实例为显示对象的对象
         * @param name
         * @param domain
         * @return
         *
         */
        static public function getDisplayObject(name:String, domain:ApplicationDomain = null):DisplayObject
        {
            return getObject(name, domain) as DisplayObject;
        }

    }
}