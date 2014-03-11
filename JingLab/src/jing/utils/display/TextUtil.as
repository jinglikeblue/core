package jing.utils.display
{
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * 文本框工具
     * @author jing
     *
     */
    public class TextUtil
    {
        /**
         * 文本的外发光
         */
        static public const GLOW_FILTERS:GlowFilter = new GlowFilter(0, 1, 2, 2, 5, 1);

        /**
         * 使元件中所有的文本加上描边
         * 黑色文本框会自动忽略
         * @param gui
         *
         */
        static public function glowSpriteTexts(gui:Sprite):void
        {
            var tf:TextField = null;

            for (var i:int = 0; i < gui.numChildren; i++)
            {
                tf = gui.getChildAt(i) as TextField;

                if (null != tf && tf.textColor != 0x000000)
                {
                    tf.antiAliasType = AntiAliasType.ADVANCED;
                    gui.getChildAt(i).filters = [GLOW_FILTERS];
                }
            }
        }

        /**
         * 字体描边
         * @param tf
         * @param color 颜色默认黑色
         *
         */
        public static function glow(tf:TextField, color:uint = 0x0, isUse:Boolean = true):void
        {
            if (isUse)
            {
                tf.filters = [new GlowFilter(color, 1, 2, 2, 5, 1)];
            }
            else
            {
                tf.filters = null;
            }
            tf.text = tf.text;
        }

        /**
         * 字体加粗
         * @param tf
         *
         */
        public static function bold(tf:TextField, isUse:Boolean = true):void
        {
            tf.defaultTextFormat = new TextFormat(null, null, null, isUse);
            tf.text = tf.text;
        }

        /**
         * 字体加下划线
         * @param tf
         *
         */
        public static function underline(tf:TextField, isUse:Boolean = true):void
        {
            tf.defaultTextFormat = new TextFormat(null, null, null, null, null, isUse);
            tf.text = tf.text;
        }
    }
}
