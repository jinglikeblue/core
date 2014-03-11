package jing.structures
{
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    /**
     * 对象池
     * @author GoSoon
     *
     */
    public class ObjectPool
    {
        //对象字典
        private static var _dicCls:Dictionary = new Dictionary();

        /**
         * 放回对象池
         * @param obj
         *
         */
        public static function returnObj(obj:Object):void
        {

            var cls:String = getQualifiedClassName(obj);
            //			trace("对象池--->存入对象：" + obj + "类名字符串：" + cls);
            var pool:Array = _dicCls[cls];

            if (!pool)
            {
                pool = [];
                _dicCls[cls] = pool;
            }
            pool.push(obj);
        }

        /**
         * 使用类名从对象池中取出对象
         * @param cls
         * @return
         *
         */
        public static function borrowObjByClass(object:Class):Object
        {
            var cls:String = getQualifiedClassName(object);
            return borrowObjByClassString(cls);
        }

        /**
         * 使用类名字符串从对象池中取出对象
         * @param cls
         * @return
         *
         */
        public static function borrowObjByClassString(cls:String):Object
        {
            var pool:Array = _dicCls[cls];

            if (!pool)
            {
                //				trace("对象池--->不存在对象：" + cls);
                return null;
            }
            var element:Object = pool.pop();
            //			trace("对象池--->取出对象：" + element);
            return element;
        }

    }
}
