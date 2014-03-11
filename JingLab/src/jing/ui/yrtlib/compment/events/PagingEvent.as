package jing.ui.yrtlib.compment.events
{
	import flash.events.Event;

	/**
	 * 分页事件
	 * @author GoSoon
	 *
	 */
	public class PagingEvent extends Event
	{
		/** 刷新 */
		public static const UPDATE_PAGE:String="PagingEvent.UPDATE_PAGE";

		public function PagingEvent(type:String, pageData:Array, pageNumber:int)
		{
			super(type);
			_pageData=pageData;
			_pageNumber=pageNumber;
		}

		private var _pageData:Array=null;

		public function get pageData():Array
		{
			return _pageData;
		}

		private var _pageNumber:int=0;

		public function get pageNumber():int
		{
			return _pageNumber;
		}
	}
}
