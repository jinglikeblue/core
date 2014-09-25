package jing.utils.debug
{
    import flash.display.DisplayObjectContainer;
    import flash.net.FileReference;


    /**
     * 控制台
     * @author Jing
     *
     */
    public class Consoles
    {
        /**
         * 是否同步打印信息到IDE上
         */
        public var isPrintSyncIde:Boolean = true;

        /**
         * 打印的信息内容
         */
        private var _printContent:String = "";

        /**
         * 打印的内容
         */
        private var _printContents:Vector.<String> = new Vector.<String>();

        /**
         * 面板
         */
        private var _panel:ConsolePanel;

        /**
         * 绑定的界面
         */
        private var _bindView:DisplayObjectContainer;

        private var _maxContents:uint = 100;

        /**
         * 最大内容数
         */
        public function get maxContents():uint
        {
            return _maxContents;
        }

        /**
         * @private
         */
        public function set maxContents(value:uint):void
        {
            _maxContents = value;
        }


        public function Consoles()
        {
            _panel = new ConsolePanel();
        }

        /**
         * 绑定到一个显示界面上
         * @param view
         * @return
         *
         */
        public function bind(view:DisplayObjectContainer):void
        {
            _bindView = view;
            _panel.addListeners();
        }

        /**
         * 从一个显示界面上解绑
         * @return
         *
         */
        public function unbind():void
        {
            hide();
            _bindView = null;
            _panel.removeListeners();
        }

        /**
         * 在绑定的界面上显示控制台
         *
         */
        public function show():void
        {
            if (_bindView && null == _panel.parent)
            {
                _bindView.addChild(_panel);
            }
        }

        /**
         * 隐藏显示的控制台
         *
         */
        public function hide():void
        {
            if (_panel.parent)
            {
                _panel.parent.removeChild(_panel);
            }
        }

        /**
         * 打印信息到控制台
         * @param arg
         *
         */
        public function print(... arg):void
        {
            if (isPrintSyncIde)
            {
                trace(arg);
            }

            var content:String = "".concat(arg) + "\n";
            _printContents.push(content);

            if (_printContents.length > _maxContents)
            {
                //清除一半
                _printContents.splice(0, _maxContents >> 1);
                _panel.clear();

                var contentsCount:int = _printContents.length;

                for (var i:int = 0; i < contentsCount; i++)
                {
                    _panel.addOutContent(_printContents[i]);
                }
            }
            else
            {
                _panel.addOutContent(content);
            }
        }

        /**
         * 清除控制台信息
         *
         */
        public function clear():void
        {
            _printContents.length = 0;
            _panel.clear();
        }

        /**
         * 保存打印信息
         *
         */
        public function savePrint(name:String = "content.txt"):void
        {
            var file:FileReference = new FileReference();
            file.save(_printContent, name);
        }
    }
}

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

/**
 * 控制台显示面板
 * @author Jing
 *
 */
class ConsolePanel extends Sprite
{
    private const DEFAULT_HEIGHT:int = 500;

    private var _bg:Shape;

    private var _inText:TextField;

    private var _outText:TextField;


    public function ConsolePanel():void
    {
        _bg = new Shape();
        _bg.graphics.beginFill(0, 0.9);
        _bg.graphics.drawRect(0, 0, 50, DEFAULT_HEIGHT);
        _bg.graphics.endFill();
        this.addChild(_bg);

        var tf:TextFormat = new TextFormat();
        tf.color = 0x00FF00;
        //tf.bold = true;
        tf.size = 14;
        tf.leading = 2;

        _inText = new TextField();
        _inText.background = false;
        _inText.border = true;
        _inText.borderColor = 0xFFFFFF;
        _inText.type = TextFieldType.INPUT;
        _inText.defaultTextFormat = tf;
        _inText.multiline = false;
        this.addChild(_inText);



        _outText = new TextField();
        _outText.wordWrap = true;
        _outText.multiline = true;
        _outText.background = false;

        _outText.defaultTextFormat = tf;
        this.addChild(_outText);

        _inText.filters = _outText.filters = [new GlowFilter(0, 1, 2, 2, 5, 1)];

        updateView();
    }

    /**
     * 更新显示
     *
     */
    private function updateView():void
    {
        _inText.width = _bg.width - 2;
        _inText.height = 25;
        _inText.y = _bg.height - _inText.height - 2;

        _outText.width = _bg.width;
        _outText.height = _inText.y;
    }

    public function addListeners():void
    {
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }


    public function removeListeners():void
    {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    protected function removedFromStageHandler(event:Event):void
    {
        this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    protected function enterFrameHandler(event:Event):void
    {
        parent.addChild(this);
    }

    protected function addedToStageHandler(event:Event):void
    {
        if (parent)
        {
            var parentW:int = parent.width;
            var parentH:int = parent.height;

            if (parent is Stage)
            {
                parentW = stage.stageWidth;
                parentH = stage.stageHeight;
            }

            _bg.width = parentW;
            _bg.height = DEFAULT_HEIGHT > parentH ? parentH : DEFAULT_HEIGHT;
        }

        updateView();
        stage.focus = _inText;
        this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    /**
     * 添加输出内容
     */
    public function addOutContent(content:String):void
    {
        _outText.appendText(content);
        _outText.scrollV = _outText.maxScrollV;
    }

    /**
     * 设置输出内容
     * @param content
     *
     */
    public function setOutContent(content:String):void
    {
        _outText.htmlText = content;
        _outText.scrollV = _outText.maxScrollV;
    }

    public function clear():void
    {
        _outText.htmlText = "";
    }
}


