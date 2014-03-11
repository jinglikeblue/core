package jing.game.utils
{
    import flash.geom.Point;

    /**
     * 移动工具类
     * @author Jing
     *
     */
    public class MoveUtil
    {
        /**
         * 根据移动的数据，得到移动后的新位置
         * @param nowPosX 当前所在坐标X
         * @param nowPosY 当前所在坐标Y
         * @param targetPosX 目的地坐标X
         * @param targetPosY 目的地坐标Y
         * @param speed 移动的速度
         * @return
         *
         */
        static public function getMoveNewPos(nowPosX:Number, nowPosY:Number, targetPosX:Number, targetPosY:Number, speed:Number):Point
        {
            var newX:Number;
            var newY:Number;
            var dx:Number = targetPosX - nowPosX;
            var dy:Number = targetPosY - nowPosY;
            var squareLen:Number = dx * dx + dy * dy;
            if (squareLen < speed * speed)
            {
                return new Point(targetPosX, targetPosY);
            }

            var len:Number = Math.sqrt(squareLen);
            var udx:Number = dx / len;
            var udy:Number = dy / len;
            udx *= speed;
            udy *= speed;
            newX = nowPosX + udx;
            newY = nowPosY + udy;
            return new Point(newX, newY);
        }
    }
}
