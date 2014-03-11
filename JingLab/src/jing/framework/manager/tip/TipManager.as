package jing.framework.manager.tip
{
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import jing.framework.manager.stage.StageManager;
    import jing.framework.manager.tip.interfaces.ITip;
    import jing.framework.manager.tip.interfaces.ITipUser;
    import jing.framework.manager.tip.vo.TipVO;

    /**
     * 悬浮提示管理
     * 因为游戏中无论鼠标怎样移动或者情况怎样，只会出现一个悬浮窗，所以这里使用静态的方式来控制悬浮窗的呈现
     *
     * @author Jing
     * @data 2011-5-13
     */
    public class TipManager
    {
        static private var _stage:Stage = null;

        static public function init(stage:Stage):void
        {
            _stage = stage;
        }

        /**
         * 存储实现Tip的对象的字典[key为ITipUser.tipDiplayObject, 返回为ITipUser]
         */
        static private var _tipUserDir:Dictionary = new Dictionary();

        /**
         * 存储使用过的TipTools[key为TipType,返回为ITip]
         */
        static private var _tipInstanceDic:Object = new Object();

        /**
         * Tip的类的字典，用来实例化对象用[key为TipType,返回为Class]
         */
        static private var _tipClassDic:Dictionary = new Dictionary();

        /**
         * 当前正在使用的TIP TOOLS
         */
        static private var _nowTip:ITip = null;

        /**
         * 附加的Tip
         */
        static private var _appendTips:Vector.<ITip> = new Vector.<ITip>();

        /**
         * Tip对象和Tip调用者之间的间距
         */
        static private var _tipMarginUser:int = 5;

        /**
         * 控制一个实现了ITipUser接口的对象，绑定Tip监控
         * @param tipUser
         *
         */
        static public function control(tipUser:ITipUser):void
        {
            var tipUsetDisplayerObject:DisplayObject = tipUser.tipDisplayObject;
            _tipUserDir[tipUsetDisplayerObject] = tipUser;

            if (null != tipUsetDisplayerObject)
            {
                tipUsetDisplayerObject.addEventListener(MouseEvent.ROLL_OVER, tipUser_rollOverHandler);
            }
        }

        /**
         * 解除一个ITipUser的Tip监控
         * @param tipUser
         *
         */
        static public function uncontrol(tipUser:ITipUser):void
        {
            var tipUsetDisplayerObject:DisplayObject = tipUser.tipDisplayObject;

            if (null != _tipUserDir[tipUsetDisplayerObject])
            {
                tipUsetDisplayerObject.removeEventListener(MouseEvent.ROLL_OVER, tipUser_rollOverHandler);
                _tipUserDir[tipUsetDisplayerObject] = null;
                delete _tipUserDir[tipUsetDisplayerObject];
            }
        }

        /**
         * 注册Tip类型
         * @param tipType
         * @param tip
         *
         */
        static public function registTip(tipType:String, tip:ITip, tipClass:Class):void
        {
            _tipInstanceDic[tipType] = tip;
            _tipClassDic[tipType] = tipClass;
        }

        /**
         * 得到Tip
         * @param tipType
         * @return
         *
         */
        static public function getTip(tipType:String):ITip
        {
            return _tipInstanceDic[tipType];
        }

        static private function tipUser_rollOverHandler(e:MouseEvent):void
        {
            showTip(e.currentTarget as DisplayObject);
        }

        static private function tipUser_rollOutHandler(e:MouseEvent):void
        {
            closeTip(e.currentTarget as DisplayObject);
        }

        //		static private function showTipEasy(tipVO:TipVO):void
        //		{
        //			_nowTip = _tipInstanceDic[tipVO.tipType];
        //			
        //		}

        static private function showTip(tipDO:DisplayObject):void
        {
            tipDO.addEventListener(MouseEvent.ROLL_OUT, tipUser_rollOutHandler);

            clearAppendTips();

            var tipUser:ITipUser = _tipUserDir[tipDO] as ITipUser;

            if (null == tipUser.tipVO)
            {
                return;
            }

            if (null == _tipInstanceDic[tipUser.tipVO.tipType])
            {
                return;
            }

            _nowTip = _tipInstanceDic[tipUser.tipVO.tipType];

            //检查是否存在指定的tip,或者是否有数据信息
            if (null == _nowTip || null == tipUser.tipVO.tipData)
            {
                return;
                closeTip(tipDO);
            }

            _nowTip.setData(tipUser.tipVO.tipData);

            if (_stage == null)
            {
                return;
            }

            var i:int = 0;

            //判断是否有附加的TIP，有的话则生成
            if (null != tipUser.tipVO.appendTipVO)
            {
                var appendTipAmount:int = tipUser.tipVO.appendTipVO.length;
                var appendTipVO:TipVO = null;
                var tipObject:ITip = null;

                for (i = 0; i < appendTipAmount; i++)
                {
                    appendTipVO = tipUser.tipVO.appendTipVO[i];
                    tipObject = new _tipClassDic[appendTipVO.tipType]();
                    tipObject.setData(appendTipVO.tipData);
                    tipObject.setIsAppend(true);
                    _appendTips.push(tipObject);
                }
            }

            var stageW:int = _stage.stageWidth;
            var stageH:int = _stage.stageHeight;

            /*
            * 定位TIP的位置
            */
            var tipX:int = int.MAX_VALUE;
            var tipY:int = int.MAX_VALUE;

            var tipWidth:int = _nowTip.width;
            var tipHeight:int = _nowTip.height;

            for (i = 0; i < _appendTips.length; i++)
            {
                tipWidth += _appendTips[i].width;
                tipHeight = Math.max(_appendTips[i].height, tipHeight);
            }


            if (null != tipUser.tipVO.tipPos)
            {
                tipX = tipUser.tipVO.tipPos.x;
                tipY = tipUser.tipVO.tipPos.y;
            }
            else
            {
                var globalPoint:Point = tipUser.tipDisplayObject.localToGlobal(new Point(0, 0));
                var tipMarginX:int = _tipMarginUser;
                var tipMarginY:int = _tipMarginUser;

                if (null != tipUser.tipVO.tipMargin)
                {
                    tipMarginX = tipUser.tipVO.tipMargin.x;
                    tipMarginY = tipUser.tipVO.tipMargin.y;
                }

                tipX = globalPoint.x + tipUser.tipDisplayObject.width + tipMarginX;
                tipY = globalPoint.y + (tipUser.tipDisplayObject.height >> 1) + tipMarginY;

                if (tipX + tipWidth > stageW)
                {
                    tipX = globalPoint.x - tipWidth - tipMarginX;
                }

                if (tipY + tipHeight > stageH)
                {
                    tipY = globalPoint.y - tipHeight - tipMarginY;
                }

                if (tipX < 0)
                {
                    tipX = 0;
                }

                if (tipY <= 0)
                {
                    //					tipY = 0;
                    tipY = (StageManager.stage.stageHeight - tipHeight) >> 1;
                }
            }

            _nowTip.show(_stage, tipX, tipY);

            tipX += _nowTip.width;

            //			tipY += _nowTip.height;

            for (i = 0; i < _appendTips.length; i++)
            {
                _appendTips[i].show(_stage, tipX, tipY);
                tipX += _appendTips[i].width;
                    //				tipY += _appendTips[i].height;
            }
        }

        /**
         * 清楚附加的TIP
         *
         */
        static private function clearAppendTips():void
        {
            var appendTipAmount:int = _appendTips.length;

            for (var i:int = 0; i < appendTipAmount; i++)
            {
                _appendTips[i].destroy();
            }
            _appendTips.length = 0;
        }


        static private function closeTip(tipDO:DisplayObject):void
        {			
			var iTipUser:ITipUser = _tipUserDir[tipDO];
			
			if(null == iTipUser || null == iTipUser.tipVO)
			{
				return;
			}
			
			var tipType:String = iTipUser.tipVO.tipType;
			if(_tipInstanceDic[tipType] != _nowTip)
			{
				return;
			}
			
            clearAppendTips();

            if (null != tipDO)
            {
                tipDO.removeEventListener(MouseEvent.ROLL_OUT, tipUser_rollOutHandler);
            }

            if (_nowTip != null)
            {
                _nowTip.close();
                    //				trace("关闭了TIP");
            }
        }


    }
}
