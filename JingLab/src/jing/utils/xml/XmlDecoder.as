package jing.utils.xml
{

    public class XmlDecoder
    {
        internal var items:Object;

        public function XmlDecoder()
        {
            items = new Object();
        }

        public function readXmlNode(node:XML):void
        {
            for each (var i:XML in node.attributes())
            {
                putItem(i.name().toString(), i);
            }
        }

        /**
         * 根据键值取得一项的值
         *
         * @param key
         */
        public function getItem(key:String):Object
        {
            return items[key];
        }

        /**
         * 加入一项
         */
        public function putItem(key:String, value:String):void
        {
            items[key] = value;
        }

        /**
         * 根据键值，获取对应它的字符串值
         *
         * @param key
         */
        public function getString(key:String):String
        {
            var item:Object = items[key];

            if (item == null)
            {
                return (null);
            }
            else
            {
                return item.toString();
            }
        }

        /**
         * 根据键值，获取对应它的整数值
         *
         * @param key
         */
        public function getInt(key:String):int
        {
            var item:Number = parseInt(items[key]);

            if (isNaN(item))
            {
                return 0;
            }
            return item;
        }

        public function getUint(key:String):uint
        {
            var item:Number = parseInt(items[key]);

            if (isNaN(item))
            {
                return 0;
            }
            return uint(item);
        }

        /**
         * 根据键值，获取对应它的浮点值
         *
         * @param key
         */
        public function getNumber(key:String):Number
        {
            var item:Number = Number(items[key]);

            if (isNaN(item))
            {
                return 0;
            }
            return item;
        }

        public function getBoolean(key:String):Boolean
        {
            if (items[key] == null)
            {
                return false;
            }
            else
            {
                return String(items[key]).toLowerCase() == "true";
            }
        }
    }
}
