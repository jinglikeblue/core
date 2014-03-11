package jing.utils.data
{
    import flash.geom.Point;

    /**
     * 数字工具
     * @author jing
     *
     */
    public class IntUtil
    {
        /**
         * 混合两个字节以下的数字, 单个数字最大值0xFFFF
         * @param x
         * @param y
         * @return
         *
         */
        static public function mixedTwoInt(x:uint, y:uint):int
        {
            return x | y << 16;
        }

        /**
         * 从混合数字中抽离出两个数字
         * @param value
         * @return
         *
         */
        static public function unmixedTwoInt(value:uint):Point
        {
            var x:int = value & 0xFFFF;
            var y:int = value >> 16;
            return new Point(x, y);
        }

        /**
         * 得到小数点的字符串，如果小数点后是0，则返回整数
         * @param value number类型数字
         * @param p 小数点位数
         * @return
         *
         */
        static public function getNumStr(value:Number, p:int = 2):String
        {
            if (value == Number.POSITIVE_INFINITY || value == Number.NEGATIVE_INFINITY || isNaN(value))
            {
                return "0";
            }

            if (value % 1 == 0)
            {
                return value.toFixed(0);
            }
            else
            {
                return value.toFixed(p);
            }
        }
    }
}
