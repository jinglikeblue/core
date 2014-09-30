package jing.utils.debug
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.net.FileReference;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;

    /**
     * 使用该类
     * @author jing
     *
     */
    public class DebugUtil
    {
		
        static private var _inited:Boolean = false;

        /**
         * 调试信息的具体内容
         */
        static private var _debugInfo:String = "";

        /**
         * 初始化的时间
         */
        static private var _initTime:int = 0;

        /**
         * 网络流量
         */
        static private var _netStream:int = 0;

        /**
         * 调试文本框式框
         */
        static private var _debugText:TextField = null;

        /**
         * 命令输入框
         */
        static private var _cmdInputText:TextField = null;

        static private var _stage:Stage = null;

        static public var cmdCatcher:Function = null;

        static private var _fpsUtil:FPSUtil;

        static public function get debugText():TextField
        {
            return _debugText;
        }

        public function DebugUtil()
        {

        }



        static public function init(stage:Stage = null):void
        {
            if (true == _inited)
            {
                return;
            }
            _inited = true;
            _initTime = getTimer();
            _debugText = new TextField();
            _debugText.mouseEnabled = true;
            _debugText.background = true;
            _debugText.wordWrap = false;
            _debugText.multiline = true;
            _debugText.alpha = 0.7;
            _cmdInputText = new TextField();
            _cmdInputText.background = true;
            _cmdInputText.multiline = false;
            _cmdInputText.wordWrap = false;
            _cmdInputText.type = TextFieldType.INPUT;
            _cmdInputText.height = 20;
            _cmdInputText.alpha = 0.7;

            if (null != stage)
            {
                _stage = stage;
                _stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
            }
        }

        static public function fpsShow(isShow:Boolean = true):void
        {
            if (false == isShow)
            {
                if (null != _fpsUtil)
                {
                    _fpsUtil.close();
                }
            }
            else
            {
                if (null == _fpsUtil)
                {
                    _fpsUtil = new FPSUtil();
                }
                _fpsUtil.show(_stage, true, true);
            }
        }

        static private function stage_keyUpHandler(e:KeyboardEvent):void
        {
            if (e.keyCode == Keyboard.BACKQUOTE)
            {
                if (null == _debugText.parent)
                {
                    _cmdInputText.width = _stage.stageWidth;
                    _debugText.width = _stage.stageWidth;
                    _debugText.height = _stage.stageHeight * 0.5;
                    _stage.addChild(_debugText);
                    _debugText.x = (_stage.stageWidth - _debugText.width) >> 1;
                    _cmdInputText.x = _debugText.x;
                    _cmdInputText.y = _debugText.height;
                    _stage.addChild(_cmdInputText);
                }
                else
                {
                    _debugText.parent.removeChild(_debugText);
                    _cmdInputText.parent.removeChild(_cmdInputText);
                }
            }
            else if (e.keyCode == Keyboard.ENTER && _cmdInputText.parent != null)
            {
                cmdCatcher(_cmdInputText.text);
                checkCMD(_cmdInputText.text);
            }
        }

        static protected function checkCMD(cmd:String):void
        {
            if ("" == cmd)
            {
                return;
            }

            cmd = cmd.toLocaleLowerCase();

            switch (cmd)
            {
                case "clear":
                    _debugText.text = "";
                    break;
            }

            _cmdInputText.text = "";

        }

        static public function output(... arg):void
        {
            if (false == _inited)
            {
                return;
            }
            trace(arg);
            var argLength:int = arg.length;
            _debugInfo = _debugInfo.concat(arg);

            var newDebugText:String = "".concat(arg);
            _debugText.appendText(newDebugText + "\n");
            _debugText.scrollV = _debugText.maxScrollV;

            _debugInfo += "\r\n";
        }

        /**
         * 增加网络流量
         * @param kb 单位为KB
         * @return
         *
         */
        static public function addNetStream(kb:int):void
        {
            if (false == _inited)
            {
                return;
            }
            _netStream += kb;
        }

        /**
         * 保存调试信息到本地
         *
         */
        static public function saveToLocal():void
        {
            if (false == _inited)
            {
                return;
            }

            _debugInfo += "\r\n";
            _debugInfo += "--------------------------------------------\r\n";
            _debugInfo += "程序执行总时间： " + ((getTimer() - _initTime) / 1000) + "S \r\n";
            _debugInfo += "内存消耗: " + (System.totalMemoryNumber >> 10) + "KB \r\n";
            _debugInfo += "网络流量：" + _netStream + "KB \r\n";
            _debugInfo += new Date().toString();
            var file:FileReference = new FileReference();
            file.save(_debugInfo, "DebugInfo.txt");


        }

        /**
         * 方法的效率测试
         * @param fun 要测试的方法
         * @param funName 方法的名称
         * @param arg 方法的参数
         *
         */
        static public function funEfficiencyTest(fun:Function, funName:String, ... arg):int
        {
            var mem:Number = System.privateMemory;
            var t:uint = getTimer();
            fun.apply(null, arg);
            t = getTimer() - t;
            mem = System.privateMemory - mem;
            mem >>= 12;
            trace("[" + funName + "]执行耗时:", t, " 内存改变：", mem + "KB");
			return t;
        }
    }
}
