package jing.utils.time
{

    /**
     * 时间处理工具
     * @author Jing
     *
     */
    public class TimeUtil
    {
        /**
         *时间单元
         */
        static public const UNIT:int = 60;

        /**
         *给秒数，得时间字符串
         * @param input
         * @return
         *
         */
        static public function conversionFormat(input:Number, haveDecimal:Boolean = true):String
        {
            var array:Array = input.toString().split(".");

            var seconds:int = int(array[0]);

            if (array.length >= 0)
            {
                var decimal:int = int(array[1]);
            }

            var result:String = "00:00:00.00";

            var hour:int = seconds / Math.pow(UNIT, 2);

            var minute:int = seconds % Math.pow(UNIT, 2) / UNIT;

            var second:int = seconds % Math.pow(UNIT, 2) % UNIT;

            result = doubleDigits(hour) + ":" + doubleDigits(minute) + ":" + doubleDigits(second);

            if (haveDecimal == true)
            {
                result += "." + doubleDigits(decimal);
            }

            return result;
        }

        /**
         *给时间字符串，得秒数
         * 字符串格式为 "11:11:11.11" 或 "11:11:11"
         * @param input
         *
         */
        static public function getSeconds(input:String):Number
        {
            var result:Number = 0;

            //整数
            var integer:int = 0;
            //小数
            var decimal:Number = 0;

            var array1:Array = input.split(".");

            var array2:Array = array1[0].split(":");

            integer = int(array2[0]) * Math.pow(UNIT, 2) + int(array2[1]) * UNIT + int(array2[2]);

            if (array1.length > 1)
            {
                decimal = Number("0." + array1[1].toString());
            }

            result = integer + decimal;
            return result;
        }

        static private function doubleDigits(input:int):String
        {
            if (input < 10)
            {
                return "0" + input;
            }
            else
            {
                return input.toString();
                ;
            }
        }


    }
}