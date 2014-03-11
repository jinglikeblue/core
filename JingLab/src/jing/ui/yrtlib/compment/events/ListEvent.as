package jing.ui.yrtlib.compment.events
{
	import flash.events.Event;

	/**
	 * 列表事件
	 * @author GoSoon
	 *
	 */
	public class ListEvent extends Event
	{
		public static const SELECT_ITEM:String="SELECT_ITEM";

		public function ListEvent(type:String)
		{
			super(type);
		}
	}
}
