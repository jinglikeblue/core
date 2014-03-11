package jing.ui.yrtlib.compment.interfaces
{
	import jing.ui.yrtlib.compment.DataList;

	/**
	 * 数据列表项
	 * 持有数据的ListItem
	 * @author GoSoon
	 *
	 */
	public interface IDataListItem extends IListItem
	{
		/**
		 * 列表
		 * @return
		 *
		 */
		function get list():DataList;

		/**
		 * 设置数据引用
		 * @param data
		 *
		 */
		function set data(data:Object):void;

		/**
		 * 返回数据引用
		 * @return
		 *
		 */
		function get data():Object;

		/**
		 * 设置在列表中的下标
		 * @param index
		 *
		 */
		function set index(index:int):void;

		/**
		 * 在列表中的下标
		 * @return
		 *
		 */
		function get index():int;
	}
}
