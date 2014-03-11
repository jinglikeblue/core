package jing.utils.data
{
	public class RandomUtil
	{
		/**
		 * 在a，b闭区间中随机抽取一个值 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		static public function getIntValueBetween(a:int,b:int):int
		{
			var distance:int = b - a;
			return a + int(Math.random() * (distance + 1));
		}
		
		/**
		 * 从数组中随机抽取一个值 
		 * @param arr
		 * @return 
		 * 
		 */		
		static public function getRandomInArray(arr:Array):*
		{
			return arr[int(Math.random() * arr.length)];
		}
	}
}