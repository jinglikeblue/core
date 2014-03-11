package jing.algorithms
{

    /**
     * 2009-11-7
     * 函数公式类
     * @author Jing
     *
     */
    public class Formula
    {
        public function Formula()
        {

        }

        /**
         * 检查两个Number在一定精度下是否相等，当a-b的绝对值小于precision时，视为这两个数相等
         * @param a
         * @param b
         * @param precision
         * @return
         *
         */
        static public function equalNumber(a:Number, b:Number, precision:Number):Boolean
        {
            return Math.abs(a - b) < precision ? true : false;
        }

        /**
         * 求阶乘的函数
         * @param input 传入的值不可以小于1，否则返回的值为0
         * @return
         *
         */
        public static function Factorial(input:int):int
        {
            var result:int = 0;

            if (input >= 1)
            {
                result = 1;

                for (var i:int = 2; i <= input; i++)
                {
                    result *= i;
                }
            }
            return result;
        }

        /**
         * 得到等差数列的前N项和
         * @param n 数列前N项
         * @param a1 数列首项值
         * @param d 数列等差值
         *
         */
        static public function getSumOfNOfAnArithmeticProgression(n:uint, a1:int, d:int):int
        {
            var value:int = n * a1 + n * (n - 1) * (d / 2);
            return value;
        }

        /**
         * 得到等差数列的第N项的值
         * @param n 数列第N项
         * @param a1 数列首项值
         * @param d 数列等差值
         * @return
         *
         */
        static public function getNValueOfAnArithmeticProgression(n:uint, a1:int, d:int):int
        {
            var value:int = a1 + (n - 1) * d;
            return value;
        }
    }
}
