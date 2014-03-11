package jing.game.keyboradToward
{

    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import jing.game.keyboradToward.events.KeyboardTowardEvent;

    /**
     *按键朝向工具
     * @author jing
	 * @date 2010-8-20
     *
     */
    public class KeyboardToward extends EventDispatcher
    {
		//接收键盘事件的显示容器
        private var container:DisplayObjectContainer = null;

        //当前方向
        private var toward:String = null;

        //方向向上对应的键盘按键
        private var up:uint = Keyboard.UP;

        //方向向下对应的键盘按键
        private var down:uint = Keyboard.DOWN;

        //方向向左对应的键盘按键
        private var left:uint = Keyboard.LEFT;

        //方向向右对应的键盘按键
        private var right:uint = Keyboard.RIGHT;

        //忽略上键
        private var neglectUp:Boolean = false;

        //忽略下键
        private var neglectDown:Boolean = false;

        //忽略左键
        private var neglectLeft:Boolean = false;

        //忽略右键
        private var neglectRight:Boolean = false;

        //上键是否按下
        private var isUpPressed:Boolean = false;

        //下键是否按下
        private var isDownPressed:Boolean = false;

        //左键是否按下
        private var isLeftPressed:Boolean = false;

        //右键是否按下
        private var isRightPressed:Boolean = false;

        /**
         *
         * @param container 监听键盘事件的显示容器，这里最好传入stage属性
         *
         */
        public function KeyboardToward(container:DisplayObjectContainer)
        {
            this.container = container;
        }

        /**
         *开始运行
         *
         */
        public function start():void
        {
            container.addEventListener(KeyboardEvent.KEY_DOWN, container_keyDownHandler);
            container.addEventListener(KeyboardEvent.KEY_UP, container_keyUpHandler);
        }

        /**
         *停止运行
         *
         */
        public function stop():void
        {
            container.removeEventListener(KeyboardEvent.KEY_DOWN, container_keyDownHandler);
            container.removeEventListener(KeyboardEvent.KEY_UP, container_keyUpHandler);
        }

        /**
         *改变按键的映射
         * @param up
         * @param down
         * @param left
         * @param right
         *
         */
        public function changeKeyMapping(up:uint, down:uint, left:uint, right:uint):void
        {
            this.up = up;
            this.down = down;
            this.left = left;
            this.right = right;
        }

        /**
         *设置要忽略的方向
         * @param up
         * @param down
         * @param left
         * @param right
         *
         */
        public function setNeglectKey(up:Boolean = false, down:Boolean = false, left:Boolean = false, right:Boolean = false):void
        {
            neglectUp = up;
            neglectDown = down;
            neglectLeft = left;
            neglectRight = right;
        }

        /**
         *得到当前按键的朝向
         * @return
         *
         */
        public function getToward():String
        {
            return toward;
        }

		/*-------------------------------------------------------------------------------*/
		
        private function container_keyDownHandler(e:KeyboardEvent):void
        {
            if (e.keyCode == left && neglectLeft == false)
            {
                isLeftPressed = true;
            }
            else if (e.keyCode == right && neglectRight == false)
            {
                isRightPressed = true;
            }
            else if (e.keyCode == up && neglectUp == false)
            {
                isUpPressed = true;
            }
            else if (e.keyCode == down && neglectDown == false)
            {
                isDownPressed = true;
            }
            dealToward();
        }

        private function container_keyUpHandler(e:KeyboardEvent):void
        {
            if (e.keyCode == left && neglectLeft == false)
            {
                isLeftPressed = false;
            }
            else if (e.keyCode == right && neglectRight == false)
            {
                isRightPressed = false;
            }
            else if (e.keyCode == up && neglectUp == false)
            {
                isUpPressed = false;
            }
            else if (e.keyCode == down && neglectDown == false)
            {
                isDownPressed = false;
            }
            dealToward();
        }

        private function dealToward():void
        {
			//在X轴上的方向
            var towardX:String = null;

			//在Y轴上的方向
            var towardY:String = null;

            if (isLeftPressed && !isRightPressed)
            {
                towardX = Toward.WEST;
            }
            else if (!isLeftPressed && isRightPressed)
            {
                towardX = Toward.EAST;
            }
            else
            {
                towardX = null;
            }

            if (isUpPressed && !isDownPressed)
            {
                towardY = Toward.NORTH;
            }
            else if (!isUpPressed && isDownPressed)
            {
                towardY = Toward.SOUTH;
            }
            else
            {
                towardY = null;
            }

            var newToward:String = getNewToward(towardX, towardY);

            if (toward != newToward)
            {
                toward = newToward;

                if (toward == null)
                {
                    toward = Toward.NONE;
                }
                this.dispatchEvent(new KeyboardTowardEvent(KeyboardTowardEvent.TOWARD_CHANGE, toward));
            }
        }

		/**
		 *通过X,Y轴上的方向值，得到方向(方向为8方向） 
		 * @param towardX
		 * @param towardY
		 * @return 
		 * 
		 */		
        private function getNewToward(towardX:String, towardY:String):String
        {
            var newToward:String = toward;

            if (towardX == null && towardY == null)
            {
                newToward = null;
            }
            else if (towardX == null)
            {
                newToward = towardY;
            }
            else if (towardY == null)
            {
                newToward = towardX;
            }
            else if (towardY == Toward.NORTH)
            {
                if (towardX == Toward.WEST)
                {
                    newToward = Toward.NORTH_WEST;
                }
                else if (towardX == Toward.EAST)
                {
                    newToward = Toward.NORTH_EAST;
                }
            }
            else if (towardY == Toward.SOUTH)
            {
                if (towardX == Toward.WEST)
                {
                    newToward = Toward.SOUTH_WEST;
                }
                else if (towardX == Toward.EAST)
                {
                    newToward = Toward.SOUTH_EAST;
                }
            }

            return newToward;
        }
    }
}