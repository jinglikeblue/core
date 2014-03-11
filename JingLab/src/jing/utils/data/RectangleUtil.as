package jing.utils.data
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * 矩形工具类
     * @author Jing
     *
     */
    public class RectangleUtil
    {
        static public function correctRect(rect:Rectangle):Rectangle
        {
            var topLeft:Point = rect.topLeft;
            var bottomRight:Point = rect.bottomRight;
            var newRect:Rectangle = new Rectangle();
            newRect.x = Math.min(topLeft.x, bottomRight.y);
            newRect.y = Math.min(topLeft.y, bottomRight.y);
            newRect.width = Math.max(topLeft.x, bottomRight.x) - newRect.x;
            newRect.height = Math.max(topLeft.y, bottomRight.y) - newRect.y;
            return newRect;
        }

        /**
         * 确定矩形A是否完全包含矩形B
         * @param rectA
         * @param rectB
         * @return
         *
         */
        static public function checkRectInclude(rectA:Rectangle, rectB:Rectangle):Boolean
        {
            if (rectB.x >= rectA.x && rectB.right <= rectA.right && rectB.y >= rectA.y && rectB.bottom <= rectA.bottom)
            {
                return true;
            }
            return false;
        }
		
		/**
		 * 检查两个矩形是否是相邻的 
		 * @param rectA
		 * @param rectB
		 * @param off 模糊值，距离低于这个范围都算相邻
		 * @return 
		 * 
		 */		
		static public function checkAdjacent(rectA:Rectangle, rectB:Rectangle, off:Number = 0):Boolean
		{
			var offH:Number = off / 2;
			rectA = rectA.clone();
			rectB = rectB.clone();
			rectA.inflate(offH,offH);
			rectB.inflate(offH,offH);
			return checkRectIntersects(rectA,rectB);
		}
		
        /**
         * 检查两个矩形是否相交
         * @param rectA
         * @param rectB
         * @return
         *
         */
        static public function checkRectIntersects(rectA:Rectangle, rectB:Rectangle):Boolean
        {
            if (rectA.x + rectA.width < rectB.x)
            {
                return false;
            }

            if (rectA.x > rectB.x + rectB.width)
            {
                return false;
            }

            if (rectA.y + rectA.height < rectB.y)
            {
                return false;
            }

            if (rectA.y > rectB.y + rectB.height)
            {
                return false;
            }

            return true;
        }

        /**
         * 得到矩形的相交区域
         * @param rectA
         * @param rectB
         * @return
         *
         */
        static public function getIntersectRect(rectA:Rectangle, rectB:Rectangle):Rectangle
        {
            var intersectX:int;
            var intersectY:int;

            if (rectA.x + rectA.width < rectB.x)
            {
                return null;
            }

            if (rectA.x > rectB.x + rectB.width)
            {
                return null;
            }

            if (rectA.y + rectA.height < rectB.y)
            {
                return null;
            }

            if (rectA.y > rectB.y + rectB.height)
            {
                return null;
            }

            intersectX = rectA.x > rectB.x ? rectA.x : rectB.x;
            intersectY = rectA.y > rectB.y ? rectA.y : rectB.y;
            var intersectRect:Rectangle = new Rectangle(intersectX, intersectY);
            intersectRect.right = rectA.right < rectB.right ? rectA.right : rectB.right;
            intersectRect.bottom = rectA.bottom < rectB.bottom ? rectA.bottom : rectB.bottom;
            return intersectRect;
        }

        /**
         * 检查矩形中是否包含指定的点
         * @param x
         * @param y
         * @param rect
         * @return
         *
         */
        static public function containsPoint(x:int, y:int, rect:Rectangle):Boolean
        {
            if (rect.x > x || rect.width + rect.x < x || rect.y > y || rect.height + rect.y < y)
            {
                return false;
            }
            return true;
        }
    }
}
