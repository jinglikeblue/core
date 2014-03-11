package jing.utils.xml
{
    import flash.utils.describeType;

    import jing.utils.time.DateUtil;

    public class XmlSerialize
    {

        /**
         * 把obj对象serialize为名为nodename的XML节点
         * @return <{nodename} {property}="{value}" ..... />
         */
        public static function encode(nodename:String, obj:Object):XML
        {
            return XmlEncoder.encode(nodename, obj);
        }

        /*
         * 把XML节点deserialize为Object对象
         */
        public static function decode(x:XML):Object
        {
            var decoder:XmlDecoder = new XmlDecoder();
            decoder.readXmlNode(x);
            return decoder.items;
        }

        /*
         * 把XML节点deserialize为type对象
         */
        public static function decodeType(x:XML, type:Class, classInfo:XML = null):*
        {
            var decoder:XmlDecoder = new XmlDecoder();
            decoder.readXmlNode(x);

            var result:Object = new type();
            var ci:XML = classInfo == null ? describeType(result) : classInfo;
            copyProperty(decoder, result, ci);
            return result;
        }

        public static function decodeObject(x:XML, value:*):*
        {
            var decoder:XmlDecoder = new XmlDecoder();
            decoder.readXmlNode(x);
            copyProperty(decoder, value, describeType(value));
            return value;
        }

        private static function copyProperty(decoder:XmlDecoder, result:Object, classInfo:XML):void
        {
            for each (var v:XML in classInfo..*.(name() == "variable" || name() == "accessor"))
            {
                var t:String = v.@type;

                switch (t)
                {
                    case "Boolean":
                        result[v.@name] = decoder.getBoolean(v.@name);
                        break;
                    case "int":
                        result[v.@name] = decoder.getInt(v.@name);
                        break;
                    case "Number":
                        result[v.@name] = decoder.getNumber(v.@name);
                        break;
                    case "uint":
                        result[v.@name] = decoder.getUint(v.@name);
                        break;
                    case "String":
                        result[v.@name] = decoder.getString(v.@name);
                        break;
                    case "Date":
                        result[v.@name] = DateUtil.getDateByStr(decoder.getString(v.@name));
                        break;
                }
            }
        }
    }
}
