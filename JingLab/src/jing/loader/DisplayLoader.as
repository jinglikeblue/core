package jing.loader
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;
    
    import jing.loader.interfaces.ILoader;

    public class DisplayLoader extends ALoader implements ILoader
    {
        private var _displayObject:DisplayObject;

        /**
         * 加载到的显示数据
         */
        public function get displayObject():DisplayObject
        {
            return _displayObject;
        }

        /**
         * 加载显示对象的加载器
         */
        private var _loader:Loader;

        /**
         * 加载SWF时用于指定安全域
         */
        private var _context:LoaderContext;

        public function DisplayLoader(urlRequest:URLRequest = null, context:LoaderContext = null, tryTime:int = 0)
        {
            _context = context;
            super(urlRequest,tryTime);
        }

        override protected function _urlStream_completeHandler(event:Event):void
        {
            var ba:ByteArray = getByteArray();
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loader_completeHandler);
            _loader.loadBytes(ba, _context);
        }

        protected function _loader_completeHandler(event:Event):void
        {
            _displayObject = _loader.contentLoaderInfo.content;
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _loader_completeHandler);
            _loader = null;
            this.dispatchEvent(new Event(Event.COMPLETE));
        }


        override public function dispose():void
        {
            if (_loader)
            {
                _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _loader_completeHandler);
                _loader = null;
            }
            _displayObject = null;
            super.dispose();
        }

    }
}
