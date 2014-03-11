package jing.game.keyboradToward.events
{
    import flash.events.Event;

    /**
     *方向键事件
     * @author jing
     *
     */
    public class KeyboardTowardEvent extends Event
    {
        private var _toward:String = null;

        public function get toward():String
        {
            return _toward;
        }

        public function set toward(value:String):void
        {
            _toward = value;
        }

        public function KeyboardTowardEvent(type:String, newToward:String)
        {
            this._toward = newToward;
            super(type);
        }

        /**
         *方向改变
         */
        static public const TOWARD_CHANGE:String = "towardChange";


    }
}