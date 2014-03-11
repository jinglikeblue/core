package jing.structures
{

    /**
     *分页类
     * @author Jing
     *
     */
    public class Pagination
    {
        //全部数据
        private var _data:Array;

        public function getData():Array
        {
            return _data;
        }

        //当前页数据
        private var _presentData:Array = new Array();

        //每页的行数
        private var _rowsPage:int;

        //指定页
        private var _presentPage:int;

        //总页数
        private var _countPage:int;


        /**
         *构造函数
         * @param rowsPage 设置每页数量
         *
         */
        public function Pagination(rowsPage:int = 10)
        {
            _rowsPage = rowsPage;
        }


        //检查指定页是否存在
        private function CheckAppointPage(pageNumber:int):Boolean
        {
            if (pageNumber < 1 || pageNumber > _countPage)
            {
                return false;
            }
            else
            {
                return true;
            }
        }


        //-------------------------------------公共方法
        //
        //


        /**
         * 设置分页数据
         * @param	a 数据源
         */
        public function setData(a:Array):void
        {
            if (null == a)
            {
                return;
            }
            _data = a;
            _presentData.length = 0;
            _countPage = ((a.length - 1) / _rowsPage) + 1;

            if (_countPage < 1)
                _countPage = 1
            page(1);
        }


        /**
         * 获得指定页数据
         * @param	pageNumber 页面号码
         * @return
         */
        public function page(pageNumber:int):Array
        {
            //检查是否存在要的页码 或者 要的页码是否和当前也相同
            if (!CheckAppointPage(pageNumber))
            {
                return null;
            }

            //设置当前页码
            _presentPage = pageNumber;
            //清空当前数组数据
            _presentData.length = 0;
            //计算起点索引
            var beginIndex:int = _rowsPage * (_presentPage - 1);
            //计算结束点索引
            var endIndex:int = _rowsPage * _presentPage;

            if (endIndex > _data.length)
            {
                endIndex = _data.length;
            }

            //当前数据引用
            while (beginIndex < endIndex)
            {
                _presentData.push(_data[beginIndex]);
                beginIndex++;
            }

            //返回数据
            return _presentData;
        }


        /**
         * 获得下一页数据
         * @return
         */
        public function nextPage():Array
        {
            return page(_presentPage + 1);
        }


        /**
         * 获得上一页数据
         * @return
         */
        public function previousPage():Array
        {
            return page(_presentPage - 1);
        }


        /**
         * 获得首页数据
         * @return
         */
        public function firstPage():Array
        {
            return page(1);
        }


        /**
         * 获得末页数据
         * @return
         */
        public function lastPage():Array
        {
            return page(_countPage);
        }

        public function clear():void
        {
            _data = null;
        }

        //-----------公共属性
        //
        //

        /**
         * 得到每页内容数
         */
        public function get rowsEachPage():int
        {
            return _rowsPage;
        }


        /**
         *设置每页内容数
         * @param i
         *
         */
        public function set rowsEachPage(i:int):void
        {
            _rowsPage = i;
            setData(_data);
        }


        /**
         * 得到当前的页码
         */
        public function get presentPageNumber():int
        {
            return _presentPage;
        }


        /**
         * 得到总页数,同时也是最后一页的数字
         */
        public function get pageCount():int
        {
            return _countPage;
        }


        /**
         *是否有上一页
         * @return
         *
         */
        public function get hasPreviousPage():Boolean
        {
            return CheckAppointPage(_presentPage - 1);
        }


        /**
         *是否有下一页
         * @return
         *
         */
        public function get hasNextPage():Boolean
        {
            return CheckAppointPage(_presentPage + 1);
        }
    }
}
