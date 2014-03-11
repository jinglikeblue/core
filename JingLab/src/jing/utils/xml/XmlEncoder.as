package jing.utils.xml
{
    import flash.utils.describeType;

    /**
     * @author Jing
     * 2007-11-20
     */
    public class XmlEncoder
    {

        public static function encode(node:String, object:Object):XML
        {
            var temp:String = "<" + node + " ";

            var classInfo:XML = describeType(object);

            if (classInfo.@name.toString() == "Object")
            {

                var value:Object;

                for (var key:String in object)
                {
                    value = object[key];

                    if (!(value is Function))
                    {
                        temp += encodingProperty(key, value);
                    }
                }
            }
            else
            {
                for each (var v:XML in classInfo..*.(name() == "variable" || name() == "accessor"))
                {
                    temp += encodingProperty(v.@name.toString(), object[v.@name]);
                }
            }
            temp += "/>";
            return new XML(temp);
        }

        private static function encodingProperty(name:String, value:Object):String
        {
            if (value is Array)
            {
                return "";
            }
            else
            {
                return escapeString(name) + "=\"" + String(value) + "\" ";
            }
        }

        /**
         * Escapes a string accoding to the JSON specification.
         *
         * @param str The string to be escaped
         * @return The string with escaped special characters
         * 		according to the JSON specification
         */
        private static function escapeString(str:String):String
        {
            // create a string to store the string's jsonstring value
            var s:String = "";
            // current character in the string we're processing
            var ch:String;
            // store the length in a local variable to reduce lookups
            var len:Number = str.length;

            // loop over all of the characters in the string
            for (var i:int = 0; i < len; i++)
            {
                // examine the character to determine if we have to escape it
                ch = str.charAt(i);

                switch (ch)
                {

                    case '"':
                        // quotation mark
                        s += "\\\"";
                        break;

                    case '/': // solidus
                        s += "\\/";
                        break;

                    case '\\':
                        // reverse solidus
                        s += "\\\\";
                        break;

                    case '\b':
                        // bell
                        s += "\\b";
                        break;

                    case '\f':
                        // form feed
                        s += "\\f";
                        break;

                    case '\n':
                        // newline
                        s += "\\n";
                        break;

                    case '\r':
                        // carriage return
                        s += "\\r";
                        break;

                    case '\t':
                        // horizontal tab
                        s += "\\t";
                        break;

                    default:
                        // everything else

                        // check for a control character and escape as unicode
                        if (ch < ' ')
                        {
                            // get the hex digit(s) of the character (either 1 or 2 digits)
                            var hexCode:String = ch.charCodeAt(0).toString(16);

                            // ensure that there are 4 digits by adjusting
                            // the # of zeros accordingly.
                            var zeroPad:String = hexCode.length == 2 ? "00" : "000";

                            // create the unicode escape sequence with 4 hex digits
                            s += "\\u" + zeroPad + hexCode;
                        }
                        else
                        {

                            // no need to do any special encoding, just pass-through
                            s += ch;
                        }
                }
            }

            return s;
        }
    }
}
