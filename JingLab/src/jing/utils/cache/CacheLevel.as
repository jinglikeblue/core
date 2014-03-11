package jing.utils.cache
{
	/**
	 * 缓存等级枚举类
	 * @author Jing
	 * 
	 */	
	public class CacheLevel
	{
		/**
		 * 不缓存 
		 */		
		static public const NONE:int = 0;
		
		/**
		 * 缓存到内存
		 */		
		static public const MEM:int = 1;
		
		/**
		 * 缓存到内存，并且最后存到本地
		 */		
		static public const LOCAL:int = 2;
		
		/**
		 * 始终获取最新版本 
		 */		
		static public const NEWEST:int = 4;
	}
}