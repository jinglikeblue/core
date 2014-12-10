package jing.utils.data
{

    /**
     *数组工具
     * @author Jing
     *
     */
    public class ArrayUtil
    {
        /**
         *将数组中的内容进行一次随机排序
         * @param inputArray
         * @author Jing
         * @site www.annjing.cn
         * @return
         *
         */
        static public function randomPermutationArray(inputArray:Array):Array
        {
            var outputArray:Array = new Array();

            var i:int = 0;

            while (i < inputArray.length)
            {
                var randomIndex:int = Math.floor(inputArray.length * Math.random());
                outputArray.push(inputArray[randomIndex]);
                inputArray.splice(randomIndex, 1);
            }

            return outputArray;
        }

        /**
         * 判断数组中是否含有指定对象
         * @param a 指定数组
         * @param o 指定对象
         * @return
         *
         */
        static public function has(arr:Array, o:Object):Boolean
        {
            var temp:Object;

            for each (temp in arr)
            {
                if (o == temp)
                    return true;
            }
            return false;
        }

        /**
         * 判断数组中是否含有指定值得数据
         * @param arr
         * @param property
         * @param value
         * @return
         *
         */
        static public function hasByProperty(arr:Array, property:String, value:*):Boolean
        {
            var temp:Object;

            for each (temp in arr)
            {
                if (temp[property] == value)
                    return true;
            }
            return false;
        }

        /**
         * 取出含有指定属性值的数组元素
         * @param arr
         * @param property
         * @param value
         * @return
         *
         */
        static public function getByProperty(arr:Array, property:String, value:*):Object
        {
            var temp:Object;

            for each (temp in arr)
            {
                if (temp[property] == value)
                    return temp;
            }
            return null;
        }

        /**
         * 根据某一个指定的属性来排序（数字类型，默认升序）
         * @param arr
         * @param property
         * @param ascending
         *
         */
        static public function sortByProperty(arr:Array, property:*, ascending:Boolean = true):void
        {
            var temp:Object;

            for (var i:int = 0; i < arr.length; i++)
            {
                for (var j:int = i; j < arr.length; j++)
                {
                    if (ascending)
                    {
                        if (arr[i][property] > arr[j][property])
                        {
                            temp = arr[i];
                            arr[i] = arr[j];
                            arr[j] = temp;
                        }
                    }
                    else
                    {
                        if (arr[i][property] < arr[j][property])
                        {
                            temp = arr[i];
                            arr[i] = arr[j];
                            arr[j] = temp;
                        }
                    }
                }
            }
        }

        /**
         * 两数组是否相同
         * @param arr1
         * @param arr2
         * @return
         *
         */
        static public function isSame(arr1:Array, arr2:Array):Boolean
        {
            if (arr1.length != arr2.length)
                return false;
            var isSame:Boolean = false;
            var sameLen:int = 0;

            for each (var arr1Obj:Object in arr1)
            {
                for each (var arr2Obj:Object in arr2)
                {
                    if (arr1Obj == arr2Obj)
                        sameLen++;
                }
            }

            if (sameLen == arr1.length)
                isSame = true;
            return isSame;
        }
		
		/**
		 * 返回一个新数组，这个数组是两个数组的并集 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		static public function getUnion(a:Array, b:Array):Array
		{
			a = a.concat();
			var bAmount:int = b.length;
			while(--bAmount > -1)
			{
				if(a.indexOf(b[bAmount] == -1))
				{
					a.push(b[bAmount]);
				}
			}
			return a;
		}
		
		/**
		 * 返回一个新数组，这个数组是两个数组的交集 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		static public function getIntersection(a:Array, b:Array):Array
		{
			var c:Array = a.concat();
			c.length = 0; 
			var aAmount:int = a.length;
			while(--aAmount > -1)
			{
				if(b.indexOf(a[aAmount]) > -1)
				{
					c.push(a[aAmount]);
				}
			}
			return c;
		}
		
		/**
		 * 返回一个新数组，该数组是A对B的补集（A中有的元素B中没有的） 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		static public function getComplementary(a:Array, b:Array):Array
		{
			var c:Array = a.concat();
			c.length = 0;
			var aAmount:int = a.length;
			while(--aAmount > -1)
			{
				if(-1 == b.indexOf(a[aAmount]))
				{
					c.push(a[aAmount]);
				}
			}
			return c;
		}
		
		/**
		 * 从数组中随机获取一个对象 
		 * @param a
		 * @return 
		 * 
		 */		
		static public function getRandomObject(arr:Array):*
		{
			var randomIndex:int = int(Math.random() * arr.length);
			return arr[randomIndex];
		}
		
		/**
		 * 从数组中随机抽取指定数量的互相不重复的内容
		 * @param arr 数组源
		 * @param count 抽取的数量，不能大于
		 * @param keepSource false 原始数组的数据索引位置可能被调换 || true 保持原始数组不变
		 * @return 
		 * 
		 */		
		static public function getRandomNoRepeat(arr:Array, count:uint, keepSource:Boolean = false):Array
		{
			if(keepSource)
			{
				arr = arr.concat();
			}
			
			if(count > arr.length)
			{
				return null;
			}
			
			var result:Array = [];
			var len:int = arr.length;
			
			for(var i:int = 0; i < count; i++)
			{
				var index:int = Math.random() * len;
				len--;
				
				var temp:Object = arr[index];
				result.push(temp);
				arr[index] = arr[len];
				arr[len] = temp;				
			}			
			
			return result;
		}
    }
}
