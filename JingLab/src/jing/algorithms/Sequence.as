package jing.algorithms
{
    /**
     * 排序算法
     * @author Jing
     *
     */
    public class Sequence
    {
		/**
		 * 利用二分法在队列中插入对象 
		 * @param list 列表对象 必须是Array或Vector
		 * @param obj 插入的对象
		 * @param compareFun 比较方法，如果返回值1则插在后面，-1则插在前面
		 * @return 插入到列表的位置索引
		 * 
		 */		
        static public function insert(list:*, obj:*, compareFun:Function):int
        {
            var right:int = list.length - 1;

            if (-1 == right)
            {
                list.push(obj);
                return 0;
            }
            var left:int = 0;
            var mid:int = 0;
            var index:int = 0;
            var tempObj:* = null;

            do
            {
                mid = (left + right) >> 1;
                tempObj = list[mid];

                var mask:int = compareFun.call(null, obj, tempObj);

                if (mask > 0)
                {
                    index = left = mid + 1;
                }
                else if (mask < 0)
                {
                    index = right = mid - 1;
                }
                else
                {
                    index = mid;
                    break;
                }
            } while (left <= right)

            list.splice(index, 0, obj);
            return index;
        }

    }
}
