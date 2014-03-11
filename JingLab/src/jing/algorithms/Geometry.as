package jing.algorithms
{
    import flash.geom.Point;

    /**
     * 几何计算
     * @author Jing
     *
     */
    public class Geometry
    {
        /**
         * 得到线段的长度
         * @param startX 线段起点的X坐标
         * @param startY 线段起点的Y坐标
     * @param endX 线段终点的X坐标
            * @param endY 线段终点的Y坐标
         * @return
         *
         */
        static public function getSegmentLength(startX:Number, startY:Number, endX:Number, endY:Number):Number
        {
            var dx:Number = endX - startX;
            var dy:Number = endY - startY;
            return Math.sqrt(dx * dx + dy * dy);
        }

        /**
         *通过三个点求出夹角的度数
         * @param firstSidePoint 第一条边上的点
         * @param apexsPoint 形成的角的顶点（两条边交点）
         * @param secondSidePoint 第二条边上的点
         *
         */
        public static function getAngleFromThreePoints(firstSidePoint:Point, apexsPoint:Point, secondSidePoint:Point):Number
        {
            var angle1:Number = Math.atan2(firstSidePoint.y - apexsPoint.y, firstSidePoint.x - apexsPoint.x);
            var angle2:Number = Math.atan2(secondSidePoint.y - apexsPoint.y, secondSidePoint.x - apexsPoint.x);
            var angle:Number = Math.abs((angle1 - angle2)) * 180 / Math.PI;

            if (angle > 180)
            {
                angle = 360 - angle;
            }
            return Number(angle.toFixed(2));
        }

        /**
         * 求出给予的显示对象集合的坐标点
         * @param displayObjects 显示对象集合
         * @return
         *
         */
        public static function getPointsOfDisplayObjects(displayObjects:Array):Vector.<Point>
        {
            var points:Vector.<Point> = new Vector.<Point>();

            for (var i:int = 0; i < displayObjects.length; i++)
            {
                points.push(new Point(displayObjects[i].x, displayObjects[i].y));
            }
            return points;
        }

        /**
         *求指定点是否在给定的两点组成的线上
         * @param linePoint1 线段的其中一个端点
         * @param linePoint2 线段的另一个端点
         * @param checkedPoint 所要检查的点
         * @param isSegment 是否是线段
         * @return 结果[true(点在线上)|false(不在线上)]
         */
        public static function countPointIsInLine(checkPoint:Point, linePoint1:Point, linePoint2:Point, isSegment:Boolean = false):Boolean
        {
			if(true == isSegment)
			{
				//如果是线段，则做范围检查
				if (Math.min(linePoint1.x, linePoint2.x) > checkPoint.x || Math.max(linePoint1.x, linePoint2.x) < checkPoint.x)
				{
					return false;
				}
				if (Math.min(linePoint1.y, linePoint2.y) > checkPoint.y || Math.max(linePoint1.y, linePoint2.y) < checkPoint.y)
				{
					return false;
				}
			}
			
            var result:Boolean = false;

            if (linePoint1.x == linePoint2.x && checkPoint.x == linePoint1.x) // 如果这条直线是垂直的且指定点的X坐标也在直线上
            {
                result = true;
            }
            else if (linePoint1.y == linePoint2.y && checkPoint.y == linePoint1.y) //如果这条直线式水平的，且指定点的Y坐标也在水平线上
            {
                result = true;
            }
            else if (true == Formula.equalNumber((checkPoint.y - linePoint1.y) / (linePoint2.y - linePoint1.y),(checkPoint.x - linePoint1.x) / (linePoint2.x - linePoint1.x),0.05))
            {
                result = true; //确定是在构成的直线上
            }

            return result;
        }

        /**
         *求出两条直线的交点
         * @param point1 直线1的一个端点
         * @param point2 直线1的另一个端点
         * @param point3 直线2的一个端点
         * @param point4 直线2的另一个端点
         * @param isSegment 是否是线段(是否阻止直线无限延长)
         * @return
         *
         */
        public static function countPointOfIntersection(point1:Point, point2:Point, point3:Point, point4:Point, isSegment:Boolean = false):Point
        {
            var result:Point = new Point();

            if (point1.x == point2.x)
            {
                result.x = point1.x;
                result.y = getPointYOfLineByPointX(point3, point4, result.x, true);
            }
            else if (point3.x == point4.x)
            {
                result.x = point3.x;
                result.y = getPointYOfLineByPointX(point1, point2, result.x, true);
            }
            else if (point1.y == point2.y)
            {
                result.y = point1.y;
                result.x = getPointXOfLineByPointY(point3, point4, result.y, true);
            }
            else if (point3.y == point4.y)
            {
                result.y = point3.y;
                result.x = getPointXOfLineByPointY(point1, point2, result.y, true);
            }
            else
            {
                var a:Number = (point2.y - point1.y) / (point2.x - point1.x) * point1.x;
                var b:Number = (point4.y - point3.y) / (point4.x - point3.x) * point3.x;
                var c:Number = (point2.y - point1.y) / (point2.x - point1.x) - (point4.y - point3.y) / (point4.x - point3.x);
                var d:Number = a - b + point3.y - point1.y;
                var e:Number = d / c;


                var pointX:Number = e;
                var pointYOfLine1:Number = getPointYOfLineByPointX(point1, point2, pointX, true);
                var pointYOfLine2:Number = getPointYOfLineByPointX(point3, point4, pointX, true);
                var pointY:Number;

                if (int(pointYOfLine1) == int(pointYOfLine2))
                {
                    pointY = pointYOfLine1;
                    result = new Point(pointX, pointY);
                }
            }

            if (isNaN(result.x) || isNaN(result.y))
            {
                return null;
            }
            else if (isSegment == true)
            {
                if (false == countPointIsInLine(result, point1, point2, true))
				{
					return null;
				}
				
				if(false == countPointIsInLine(result, point3, point4, true))
                {
                    return null;
                }
            }

            return result;

        }

        /**
         *通过给出的X坐标求出两点构成的直线上的Y坐标
         * @param point1 直线的一个点
         * @param point2 直线的另一个点
         * @param pointX X坐标
         * @param isSegment 是否是线段(是否阻止直线无限延长)
         * @return
         *
         */
        public static function getPointYOfLineByPointX(point1:Point, point2:Point, pointX:Number, isSegment:Boolean = false):Number
        {
            //首先检查线段定义
            if (true == isSegment)
            {
                //如果是线段，则当X坐标不在线段范围内时，返回NaN值
                if (Math.min(point1.x, point2.x) > pointX || Math.max(point1.x, point2.x) < pointX)
                {
                    return Number.NaN;
                }
            }

            var result:Number;

            if (point2.y == point1.y)
            {
                result = point1.y;
            }
            else
            {
                result = (pointX - point1.x) / (point2.x - point1.x) * (point2.y - point1.y) + point1.y;
            }
            return result;
        }

        /**
         *通过给出的Y坐标求出两点构成的直线上的X坐标
         * @param point1 直线的一个点
         * @param point2 直线的另一个点
         * @param pointY Y坐标
         * @param isSegment 是否是线段(是否阻止直线无限延长)
         * @return
         *
         */
        public static function getPointXOfLineByPointY(point1:Point, point2:Point, pointY:Number, isSegment:Boolean = false):Number
        {
            //首先检查线段定义
            if (true == isSegment)
            {
                //如果是线段，则当X坐标不在线段范围内时，返回NaN值
                if (Math.min(point1.y, point2.y) > pointY || Math.max(point1.y, point2.y) < pointY)
                {
                    return Number.NaN;
                }
            }

            var result:Number;

            if (point2.x == point1.x)
            {
                result = point1.x;
            }
            else
            {
                result = (pointY - point1.y) / (point2.y - point1.y) * (point2.x - point1.x) + point1.x;
            }

            return result;
        }

        /**
         * 求出两个向量的点乘
         * @param uStart 向量U起点
         * @param uEnd 向量U终点
         * @param vStart 向量V起点
         * @param vEnd 向量V终点
         * @return
         *
         */
        static public function vectorDotProduct(uStart:Point, uEnd:Point, vStart:Point, vEnd:Point):Number
        {
            var ux:Number = uEnd.x - uStart.x;
            var uy:Number = uEnd.y - uStart.y;
            var vx:Number = vEnd.x - vStart.x;
            var vy:Number = vEnd.y - vStart.y;
            return ux * vx + uy * vy;
        }

        /**
         * 求向量的模
         * @param start 向量起点
         * @param end 向量终点
         * @return
         *
         */
        static public function vectorNormalized(start:Point, end:Point):Point
        {
            var vectorX:Number = end.x - start.x;
            var vectorY:Number = end.y - start.y;
            var len:Number = Math.sqrt(vectorX * vectorX + vectorY * vectorY);
            return new Point(vectorX / len, vectorY / len);
        }


    }
}





