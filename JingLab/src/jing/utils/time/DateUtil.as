package jing.utils.time
{

    /**
     * 日期工具
     * @author Jing
     *
     */
    public class DateUtil
    {
        /**
         * 获取日期
         * @param value
         * @return
         *
         */
        public static function getDateByStr(value:String):Date
        {
            if (value)
            {
                var temp:Array = value.split(" ");
                var date:Array = temp[0].split("-");
                var year:int = date[0];
                var month:int = date[1] - 1;
                var day:int = date[2];
                var time:Array = temp[1].split(":");
                var hour:int = time[0];
                var minute:int = time[1];
                var second:int = time[2];
                return new Date(year, month, day, hour, minute, second)
            }
            else
            {
                return new Date(0);
            }
        }

        /**
         * 获取两个时间的小时差
         * @param start
         * @param end
         * @return
         *
         */
        public static function getHourDifference(start:Number, end:Number):int
        {
            return Math.floor(Math.abs(end - start) / 3600000);
        }

        /**
         * 通过毫秒数返回所在小时
         * @param time
         * @return
         *
         */
        public static function getHour(time:Number):Number
        {
            var hour:Number;
            var date:Date = new Date();
            date.setTime(time);
            hour = date.getHours() + date.getMinutes() / 60;
            return hour;
        }

        /**
         * 判断时间a是否是时间b x小时后的时间
         * @param a
         * @param a
         * @param x 小时差（默认1小时）
         * @return
         *
         */
        public static function isNextHours(a:Number, b:Number, x:int = 1):Boolean
        {
            var isNextHours:Boolean = false;
            var aDate:Date = new Date();
            aDate.setTime(a);
            var bDate:Date = new Date();
            bDate.setTime(b);
            var dayDiffer:int = Math.abs(aDate.date - bDate.date);
            var hourDiffer:int = Math.abs(aDate.hours - bDate.hours);

            if (dayDiffer >= 1)
            {
                isNextHours = true;
            }
            else if (hourDiffer >= x)
            {
                isNextHours = true;
            }
            return isNextHours;
        }

        /**
         * 判断时间a是否是时间b x天后的时间
         * @param a
         * @param b
         * @param x 天差（默认1天）
         * @return
         *
         */
        public static function isNextDay(a:Number, b:Number, x:int = 1):Boolean
        {
            var isNextDays:Boolean = false;
            var aDate:Date = new Date();
            aDate.setTime(a);
            var bDate:Date = new Date();
            bDate.setTime(b);
            var dayDiffer:int = Math.abs(aDate.date - bDate.date);
            var hourDiffer:int = Math.abs(aDate.hours - bDate.hours);

            if (dayDiffer >= x)
            {
                isNextDays = true;
            }
            return isNextDays;
        }

    }
}
