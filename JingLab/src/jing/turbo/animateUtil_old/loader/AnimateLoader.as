package jing.turbo.animateUtil_old.loader
{
    import jing.turbo.animateUtil_old.AnimateFactory;
    import jing.turbo.animateUtil_old.interfaces.ILoaderReport;
    import jing.turbo.animateUtil_old.vos.AnimateLoaderVO;
    import jing.turbo.animateUtil_old.vos.AnimateVO;
    
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    
    import spark.primitives.Rect;

    /**
     * 负责从外部去加载素材图片
     * @author jing
     *
     */
    public class AnimateLoader
    {
		/**
         * 加载图片的加载类
         */
        private var _loader:Loader = null;

        /**
         * 每个方向上动作的矩形范围
         */
        private var _maxRect:Vector.<Rectangle> = new Vector.<Rectangle>();

        /**
         * 注册点的数组
         */
        private var _originList:Vector.<Point> = new Vector.<Point>();

        //--------------------------------------------------------------------------------------

        /**
         * 已加载的数据
         */
        private var _loadedBmdArray:Array = [];

        /**
         * 正在加载的帧
         */
        private var _loadingFrame:int = int.MAX_VALUE;

        /**
         * 正在加载的方向
         */
        private var _loadingDirection:int = int.MAX_VALUE;

        //--------------------------------------------------------------------------------------

        private var _vo:AnimateLoaderVO = null;

        //--------------------------------------------------------------------------------------
        /**
         *
         * @param path 文件目录的路径
         * @param actionType 动作名称
         * @param fileNameFormat 文件命名格式,方向用"@_D"代替,帧数用"@_F"代替
         * @param frameCount 改动作帧数
         * @param direction 方向数
         *
         */
        public function AnimateLoader(vo:AnimateLoaderVO)
        {
            _vo = vo;

            _maxRect.length = _vo.direction;
            _originList.length = _vo.direction;
        }

        private function addListeners():void
        {
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loader_completeHandler);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loader_IOErrorHandler);
        }

        private function removeListeners():void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _loader_completeHandler);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loader_IOErrorHandler);
        }

        public function load():void
        {
			if(null == _animateVO)
			{
				_animateVO = new AnimateVO();
				_animateVO.fileDirPath = _vo.path;
				_animateVO.actionName = _vo.actionName;	
				_animateVO.frameCount = _vo.frameCount;
				_animateVO.oneFrameTime = _vo.oneFrameTime;
				AnimateFactory.putAnimateVOInPool(_animateVO);
			}
			
			
			
            //如果是第一次调用方法，则生成loader对象
            if (_loader == null)
            {
                _loader = new Loader();
                addListeners();
                //指定要加载的第一帧
                _loadingFrame = _vo.frameStartIndexFormat;
                _loadingDirection = _vo.directionStartIndexFormat;
            }

            //如果加载的是一个新的方向，则创建一个新的帧数组
            if (null == _loadedBmdArray[_loadingDirection])
            {
                _loadedBmdArray[_loadingDirection] = [];
            }

            //计算出加载的素材的地址
            var url:String = _vo.path + _vo.fileNameFormat.replace("@_D", _loadingDirection).replace("@_F", _loadingFrame);
            _loader.load(new URLRequest(url));
        }

        private function _loader_completeHandler(e:Event):void
        {
            var bmd:BitmapData = e.currentTarget.content.bitmapData as BitmapData;
            //处理加载完成的素材数据
            arrange(bmd);

            //判断当前方向是否加载完毕，是则处理已加载的当前方向的数据，并准备加载下一个方向,否则准备加载下一帧
            if (_loadingFrame == _vo.frameCount)
            {
                _loadingFrame = _vo.frameStartIndexFormat;
                process();
                _loadingDirection++;
            }
            else
            {
                _loadingFrame++;
            }

            //判断是否加载完成，没有则继续加载			 
            if (_loadingDirection == _vo.direction)
            {
                loadedOver();
            }
            else
            {
                load();
            }
        }

        private function _loader_IOErrorHandler(e:IOErrorEvent):void
        {
            trace(e);
            removeListeners();
        }

        /**
         * 整理加载的帧素材
         * @param bmd
         *
         */
        private function arrange(bmd:BitmapData):void
        {
            var rect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0xFF000000);

            var maxRect:Rectangle = _maxRect[_loadingDirection];

            if (null == maxRect)
            {
                maxRect = new Rectangle();
                maxRect.x = rect.x;
                maxRect.y = rect.y;
                maxRect.right = rect.right;
                maxRect.bottom = rect.bottom;
                _maxRect[_loadingDirection] = maxRect;
            }
            else
            {
                maxRect.left = maxRect.left < rect.left ? maxRect.left : rect.left;
                maxRect.top = maxRect.top < rect.top ? maxRect.top : rect.top;
                maxRect.right = maxRect.right > rect.right ? maxRect.right : rect.right;
                maxRect.bottom = maxRect.bottom > rect.bottom ? maxRect.bottom : rect.bottom;
            }

            _loadedBmdArray[_loadingDirection].push(bmd);
        }

        /**
         * 加工加载的方向素材
         *
         */
        private function process():void
        {
            //在这里处理加载的当前的方向
            var copyRect:Rectangle = _maxRect[_loadingDirection];

            var frames:Array = _loadedBmdArray[_loadingDirection];
            var frameIndex:int = frames.length;
            var dstPoint:Point = new Point(0, 0);
            var oldbmd:BitmapData = null;
            var bmd:BitmapData = null;

            while (--frameIndex > -1)
            {
                oldbmd = frames[frameIndex];
                bmd = new BitmapData(copyRect.width, copyRect.height, true, 0);
                bmd.copyPixels(oldbmd, copyRect, dstPoint);
                frames[frameIndex] = bmd;
                oldbmd.dispose(); //销毁旧的不用的数据
            }
            var originX:int = _vo.originPoint.x - copyRect.left;
            var originY:int = _vo.originPoint.y - copyRect.top;
            _originList[_loadingDirection] = new Point(originX, originY);
        }

		private var _animateVO:AnimateVO = null;
        /**
         * 加载完毕
         *
         */
        private function loadedOver():void
        {
            removeListeners();

//            var animateVO:AnimateVO = new AnimateVO();

            _animateVO.fileDirPath = _vo.path;
			_animateVO.actionName = _vo.actionName;
			_animateVO.frameCount = _vo.frameCount;
			_animateVO.frameData = _loadedBmdArray;
			_animateVO.oneFrameTime = _vo.oneFrameTime;
			_animateVO.originList = _originList;

			AnimateFactory.putAnimateVOInPool(_animateVO);
            _vo.iReport.report(_animateVO);
            _loader.unloadAndStop(true);
        }
    }
}