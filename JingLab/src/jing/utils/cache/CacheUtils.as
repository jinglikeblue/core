package jing.utils.cache
{
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	

	/**
	 * 缓存管理类
	 * @author Jing
	 *
	 */
	public class CacheUtils
	{
		/**
		 * 内存文件缓存
		 */
		static private var _memCacheDic:Object = new Object();

		/**
		 * 保存文件到缓存
		 * @param id 标识符,可以是文件的path
		 * @param data 缓存的数据
		 * @param cacheLevel 缓存的等级
		 * @param cacheVer 缓存的版本
		 *
		 */
		static public function saveCacheFile(id:String, data:Object, cacheLevel:int, cacheVer:String):void
		{
			if (null == data)
			{
				//				trace("缓存失败id: ", id, " 无数据");
				return;
			}
			id = getPath(id);
			var cacheObject:CacheObject = new CacheObject();
			cacheObject.data = data;
			cacheObject.ver = cacheVer;

			switch (cacheLevel)
			{
				case CacheLevel.NONE:
					//					trace("文件不被缓存",id);
					break;
				case CacheLevel.MEM:
					_memCacheDic[id] = cacheObject;
					//					trace("文件缓存到内存",id);
					break;
				case CacheLevel.LOCAL:
					_memCacheDic[id] = cacheObject;
					//					_localCacheDic[id] = data;
					SharedObjectUtil.saveSO(id, cacheObject);
					//					trace("文件缓存到本地",id);
					break;
				default:
					//					trace("缓存等级不匹配，缓存失败", id);
					break;
			}
		}

		/**
		 * 加载缓存中的文件
		 * @param id 标识符,可以是文件的path
		 * @param cacheLevel 缓存的等级
		 * @param cacheVer 缓存的版本
		 * @return
		 *
		 */
		static public function loadCacheFile(id:String, cacheLevel:int, cacheVer:String):Object
		{
			id = getPath(id);
			var co:CacheObject = null;

			switch (cacheLevel)
			{
				case CacheLevel.NONE:
					//					trace("文件不被缓存",id);
					break;
				case CacheLevel.MEM:
					//仅从内存中寻找对象					
					co = _memCacheDic[id];
					//					trace("从缓存中取出了对象", id);
					break;
				case CacheLevel.LOCAL:
					//先从内存中寻找对象，如无法找到，则从本地文件寻找，如从本地文件找到，返回之前缓存一份到内存中
					co = _memCacheDic[id];
					if (null == co)
					{
						var obj:Object = SharedObjectUtil.getValue(id)
						co = new CacheObject(obj);

						if (co != null)
						{							
							_memCacheDic[id] = co;
						}
					}
					break;
			}

			if(null == co)
			{
				//缓存对象不存在
				return null;
			}
			
			if(co.ver != cacheVer)
			{
				trace("对象存在但是版本不对!");
				return null;
			}
			
			trace("从本地取出了对象", id,  "   版本号:", co.ver);

			return co.data;
		}

		//---------------------------------------------------------
		/**
		 * 替换掉http://..../
		 */
		static private const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;

		/**
		 * 替换: . /
		 */
		static private const _reg2:RegExp = /[:|.|\/]/g;

		static private function getPath(path:String):String
		{
			//只取问号前面部分
			var index:int = path.indexOf("?");

			if (index != -1)
			{
				path = path.substring(0, index)
			}
			path = path.replace(_reg1, "");
			return path.replace(_reg2, "-");
		}
	}
}

/**
 * 缓存的数据对象 
 * @author jing
 * 
 */
class CacheObject
{
	public function CacheObject(obj:Object = null)
	{
		if(null != obj)
		{
			data = obj.data;
			ver = obj.ver;
		}
	}
	
	/**
	 * 数据 
	 */	
	public var data:Object = null;
	/**
	 * 版本号 
	 */	
	public var ver:String = null;
}