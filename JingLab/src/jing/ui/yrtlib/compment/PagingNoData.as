package jing.ui.yrtlib.compment
{
	import jing.ui.yrtlib.compment.events.PagingEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * 高级分页（不带数据）
	 * @author GoSoon
	 *
	 */
	public class PagingNoData extends Paging
	{
		/** 当前页码 */
		private var _curPage:int;
		/** 总页数 */
		private var _totalPage:int;
		/** 总条数 */
		private var _totalSize:int;
		/** 每页条量 */
		private var _perSize:int;

		public function PagingNoData(gui:DisplayObject)
		{
			super(gui);
		}

		protected override function init():void
		{
			_curPage=1;
			super.init();
		}

		/**
		 * 当前页码
		 * @return
		 *
		 */
		public function get curPage():int
		{
			return _curPage;
		}

		public function get totalSize():int
		{
			return _totalSize;
		}

		public function set totalSize(value:int):void
		{
			_totalSize=value;
			calcPage();
		}

		public function set perSize(value:int):void
		{
			_perSize=value;
			if (_perSize < 1)
			{
				_perSize=1;
			}
			calcPage();
		}

		private function calcPage():void
		{
			_totalPage=_totalSize / _perSize;
			showPageText(_curPage, _totalPage);
		}

		// 事件 --------------------------------------------------------------------

		protected override function _pageButton_clickHandler(event:MouseEvent):void
		{
			var pageChanged:Boolean=false;
			switch (event.currentTarget)
			{
				case _btn_first:
					if (_curPage > 1)
					{
						pageChanged=true;
						_curPage=1;
					}
					break;
				case _btn_pre:
					if (_curPage > 1)
					{
						pageChanged=true;
						_curPage--;
					}
					break;
				case _btn_next:
					if (_curPage < _totalPage)
					{
						pageChanged=true;
						_curPage++;
					}
					break;
				case _btn_last:
					if (_curPage < _totalPage)
					{
						pageChanged=true;
						_curPage == _totalPage;
					}
					break;
			}
			if (pageChanged)
			{
				showPageText(_curPage, _totalPage);
				this.dispatchEvent(new PagingEvent(PagingEvent.UPDATE_PAGE, null, _curPage));
			}
		}

	}
}
