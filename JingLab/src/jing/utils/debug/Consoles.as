package jing.utils.debug
{
    import flash.display.DisplayObjectContainer;
    import flash.net.FileReference;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;


    /**
     * 控制台
     * @author Jing
     *
     */
    public class Consoles
    {
        /**
         * 打印的信息内容
         */
        private var _printContent:String = "";
		
		/**
		 * 打印的内容 
		 */		
		private var _printContents:Vector.<PrintContentVO> = new Vector.<PrintContentVO>();
		
		/**
		 * 注册的指令 
		 */		
		private var _registeredCommand:Dictionary = new Dictionary();

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
			registCommand("clear", clear);
        }

        /**
         * 绑定到一个显示界面上
         * @param view
         * @return
         *
         */
        public function bind(view:DisplayObjectContainer):void
        {
			if(_bindView == view)
			{
				return;
			}
			
			if(_bindView != null)
			{
				unbind();
			}
			
            _bindView = view;
			_panel.addListeners();
            _panel.addEventListener(ConsolePanelEvent.INPUT_COMMAND, _panel_inputCommandHandler);
        }

        /**
         * 从一个显示界面上解绑
         * @return
         *
         */
        public function unbind():void
        {
			if(null == _bindView)
			{
				return;
			}
			
            hide();
            _bindView = null;
            _panel.removeListeners();
			_panel.removeEventListener(ConsolePanelEvent.INPUT_COMMAND, _panel_inputCommandHandler);
        }
		
		protected function _panel_inputCommandHandler(event:ConsolePanelEvent):void
		{
			var command:String = event.data;
			var args:Array = command.split(" ");
			var commandName:String = args.shift();
			var commandFunction:Function = _registeredCommand[commandName];
			if(commandFunction != null)
			{
				commandFunction.apply(null, args);
			}
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
         * @param content 打印的内容
		 * @param color 颜色
		 * @param isBold 是否粗体
		 * @param isPrintSyncIde 是否同步显示到IDE
         *
         */
        public function print(content:String, color:uint = 0xFFFFFF, isBold:Boolean = false, isPrintSyncIde:Boolean = true):void
        {
            if (isPrintSyncIde)
            {
                trace(content);
            }
			
			content += "\n";
			
			var tf:TextFormat = new TextFormat();
			tf.color = color;
			tf.bold = isBold;
			
			var vo:PrintContentVO = new PrintContentVO(content, tf);
            _printContents.push(vo);

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
                _panel.addOutContent(vo);
            }
        }
		
		/**
		 * 注册一个控制台指令 
		 * @param name
		 * @param fun
		 * 
		 */		
		public function registCommand(name:String, fun:Function):void
		{
			_registeredCommand[name] = fun;
		}
		
		/**
		 * 注销一个控制台指令 
		 * @param name
		 * 
		 */		
		public function unregisterCommand(name:String):void
		{
			if(_registeredCommand[name])
			{
				delete _registeredCommand[name];
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

/**
 * 打印内容数据 
 * @author Jing
 * 
 */
class PrintContentVO
{
	public function PrintContentVO(content:String, tf:TextFormat):void
	{
		this.content = content;
		this.tf = tf;
	}
	
	/**
	 * 文本内容 
	 */	
	public var content:String;
	
	/**
	 * 文本格式 
	 */	
	public var tf:TextFormat;
}

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import jing.utils.data.StringUtil;

/**
 * 控制台显示面板
 * @author Jing
 *
 */
[Event(name="input command", type="ConsolePanelEvent")]
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
        tf.color = 0xFFFFFF;
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
		_inText.addEventListener(KeyboardEvent.KEY_UP, _inText_keyUpHandler);
    }


    public function removeListeners():void
    {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		_inText.removeEventListener(KeyboardEvent.KEY_UP, _inText_keyUpHandler);
    }
	
	private function _inText_keyUpHandler(e:KeyboardEvent):void
	{
		if(e.keyCode == Keyboard.ENTER)
		{
			this.dispatchEvent(new ConsolePanelEvent(ConsolePanelEvent.INPUT_COMMAND, StringUtil.trim(_inText.text)));
			_inText.text = "";
		}
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
    public function addOutContent(contentVO:PrintContentVO):void
    {
		_outText.defaultTextFormat = contentVO.tf;
        _outText.appendText(contentVO.content);
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

/**
 * 控制台面板的事件 
 * @author Jing
 * 
 */
class ConsolePanelEvent extends Event
{
	static public const INPUT_COMMAND:String = "input command";
	
	private var _data:* = null;

	/**
	 * 数据 
	 * @return 
	 * 
	 */	
	public function get data():*
	{
		return _data;
	}

	public function ConsolePanelEvent(type:String, data:*):void
	{
		_data = data;
		super(type);
	}
}
