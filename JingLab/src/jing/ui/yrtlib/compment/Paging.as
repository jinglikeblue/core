package jing.ui.yrtlib.compment
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import jing.framework.core.view.base.ViewBase;
	import jing.structures.Pagination;
	import jing.ui.yrtlib.compment.events.PagingEvent;

	/**
	 * 分页组件
	 * @author GoSoon
	 *
	 */
	[Event(name="PagingEvent.UPDATE_PAGE", type="jing.ui.yrtlib.compment.events.PagingEvent")]
	public class Paging extends ViewBase
	{
		/** 可能有的数据 */
		protected var _data:Pagination;

		protected var _btn_first:Button;
		protected var _btn_pre:Button=null;
		protected var _btn_next:Button=null;
		protected var _btn_last:Button;
		protected var _txt_page:TextField=null;

		public function Paging(gui:DisplayObject)
		{
			super(gui);
			init();
			addListeners();
		}

		protected function init():void
		{
			if (_gui["btn_first"])
			{
				_btn_first=new Button(_gui["btn_first"]);
			}
			_btn_pre=new Button(_gui["btn_pre"]);
			_btn_next=new Button(_gui["btn_next"]);
			if (_gui["btn_last"])
			{
				_btn_last=new Button(_gui["btn_last"]);
			}
			if (_gui["txt_page"])
			{
				_txt_page=_gui["txt_page"];
				showPageText(1, 1);
			}
		}

		public override function addListeners():void
		{
			if (_btn_first)
			{
				_btn_first.addEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			}
			_btn_pre.addEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			_btn_next.addEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			if (_btn_last)
			{
				_btn_last.addEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			}
		}

		public override function removeListeners():void
		{
			if (_btn_first)
			{
				_btn_first.removeEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			}
			_btn_pre.removeEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			_btn_next.removeEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			if (_btn_last)
			{
				_btn_last.removeEventListener(MouseEvent.CLICK, _pageButton_clickHandler);
			}
		}

		public override function destroy():void
		{
			if (_data)
			{
				_data.clear();
			}
			super.destroy();
		}

		// 数据 ---------------------------------------------------------------------------

		public function set data(value:Pagination):void
		{
			_data=value;
			if (_data)
			{
				showPageText(_data.presentPageNumber, _data.pageCount);
			}
		}

		public function get data():Pagination
		{
			return _data;
		}

		public function get curPageData():Array
		{
			return _data.page(_data.presentPageNumber);
		}

		/**
		 * 显示页数
		 * @param page
		 * @param totalPage
		 *
		 */
		public function showPageText(page:int, totalPage:int):void
		{
			if (!_txt_page)
			{
				return;
			}
			if (_btn_last)
			{
				_txt_page.text=page + "/" + totalPage;
			}
			else
			{
				_txt_page.text=page.toString();
			}
		}

		// 事件 --------------------------------------------------------------------

		protected function _pageButton_clickHandler(event:MouseEvent):void
		{
			if (_data)
			{
				var page:Array=null;
				switch (event.currentTarget)
				{
					case _btn_first:
						page=_data.firstPage();
						break;
					case _btn_pre:
						page=_data.previousPage();
						break;
					case _btn_next:
						page=_data.nextPage();
						break;
					case _btn_last:
						page=_data.lastPage();
						break;
				}
				if (page)
				{
					showPageText(_data.presentPageNumber, _data.pageCount);
					this.dispatchEvent(new PagingEvent(PagingEvent.UPDATE_PAGE, page, _data.presentPageNumber));
				}
			}
		}
	}
}
