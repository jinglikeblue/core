package jing.ui.yrtlib.compment.interfaces
{
	

	/**
	 * 数据列表，按顺序组织的项目的集合。提供基于索引的访问和处理方法。
	 * 这种List维护一个数据提供者，同时将数据序列化隐射到每一个DataListItem中
	 * @author GoSoon
	 *
	 */
	public interface IDataList
	{
		/**
		 * 设置数据提供者
		 * @param data
		 *
		 */
		function set dataProvider(data:Object):void;

		/**
		 * 返回数据提供者
		 * @return
		 *
		 */
		function get dataProvider():Object;
	}
}
