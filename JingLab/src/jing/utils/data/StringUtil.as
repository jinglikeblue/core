package jing.utils.data
{
	import flash.utils.ByteArray;


	/**
	 * 字符串处理工具
	 * @author Jing
	 *
	 */
	public class StringUtil
	{
		/**
		 * 格式化字符串
		 * 例:format("我{0}天赚了{1}块钱","今",99) 输出"我今天赚了99块钱" 
		 * @param format
		 * @param args
		 * @return 
		 * 
		 */		
		static public function format(format:String, ...args):String
		{
			for (var i:int=0; i<args.length; ++i)
				format = format.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			
			return format;
		}
		
		/**
		 * 判断一个字符串是否包含另一段字符串
		 * @param source 源字符串
		 * @param target 判断是否包含的字符串
		 * @return
		 *
		 */
		public static function isContainStr(source:String, target:String):Boolean
		{
			return source.indexOf(target) >= 0
		}

		/**
		 * 找到指定字符之间的内容
		 * @param source
		 * @param startChar
		 * @param endChar
		 * @return
		 *
		 */
		public static function getContentBetweenChar(source:String, startChar:String, endChar:String):String
		{
			if (source.indexOf(startChar) == -1 || source.indexOf(endChar) == -1)
			{
				return null;
			}
			if (source.indexOf(startChar) > source.indexOf(endChar))
			{
				return null;
			}
			var tagStr:String=source.split(startChar)[1];
			tagStr=tagStr.split(endChar)[0];
			return tagStr;
		}

		/**
		 *字符串超出整理
		 * 如果字符串的长度超过指定的最大长度，则切割字符串并返回省略部分
		 * @param input 要整理的字符串
		 * @param maxLength 最大长度
		 * @return
		 *
		 */
		public static function overLengthDeal(input:String, maxLength:int):String
		{
			var output:String=input;

			if (output.length > maxLength)
			{
				output=output.substr(0, maxLength - 3) + "...";
			}
			return output;
		}

		/**
		 * 将制定索引范围内的文字去掉，然后将该范围内的文字替换为指定的字符串
		 * @param input 要整理的字符串
		 * @param beginIndex 去掉字符串的起始索引
		 * @param endIndex 去掉字符串的末尾索引
		 * @param value 替换的值
		 * @return
		 *
		 */
		public static function replacePartStringByIndex(input:String, beginIndex:int, endIndex:int, value:String):String
		{
			var leftString:String=input.slice(0, beginIndex);
			var rightString:String=input.slice(endIndex + 1);
			var output:String=leftString + value + rightString;
			return output;
		}

		/**
		 * 忽略大小字母比较字符是否相等;
		 * @param char1
		 * @param char2
		 * @return
		 *
		 */
		public static function equalsIgnoreCase(char1:String, char2:String):Boolean
		{
			return char1.toLowerCase() == char2.toLowerCase();
		}

		/**
		 * 比较字符是否相等;
		 * @param char1
		 * @param char2
		 * @return
		 *
		 */
		public static function equals(char1:String, char2:String):Boolean
		{
			return char1 == char2;
		}

		/**
		 * 是否为Email地址;
		 * @param char
		 * @return
		 *
		 */
		public static function isEmail(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否是数值字符串;
		 * @param char
		 * @return
		 *
		 */
		public static function isNumber(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			return !isNaN(Number(char));
		}

		/**
		 * 是否为Double型数据;
		 * @param char
		 * @return
		 *
		 */
		public static function isDouble(char:String):Boolean
		{
			char=trim(char);
			var pattern:RegExp=/^[-\+]?\d+(\.\d+)?$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * Integer;
		 * @param char
		 * @return
		 *
		 */
		public static function isInteger(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[-\+]?\d+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * English
		 * @param char
		 * @return
		 *
		 */
		public static function isEnglish(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[A-Za-z]+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 中文;
		 * @param char
		 * @return
		 *
		 */
		public static function isChinese(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[\u0391-\uFFE5]+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 双字节
		 * @param char
		 * @return
		 *
		 */
		public static function isDoubleChar(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/^[^\x00-\xff]+$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 含有中文字符
		 * @param char
		 * @return
		 *
		 */
		public static function hasChineseChar(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char);
			var pattern:RegExp=/[^\x00-\xff]/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 注册字符;
		 * @param char
		 * @param len
		 * @return
		 *
		 */
		public static function hasAccountChar(char:String, len:uint=15):Boolean
		{
			if (char == null)
			{
				return false;
			}
			if (len < 10)
			{
				len=15;
			}
			char=trim(char);
			var pattern:RegExp=new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + len + "}$", "");
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * URL地址;
		 * @param char
		 * @return
		 *
		 */
		public static function isURL(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char=trim(char).toLowerCase();
			var pattern:RegExp=/^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result:Object=pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 是否为空
		 * @param char
		 * @return
		 *
		 */
		public static function isEmpty(char:String):Boolean
		{
			if (char != null)
			{
				switch (char)
				{
					case "":
					case " ":
					case "\t":
					case "\r":
					case "\n":
					case "\f":
						return true;
					default:
						return false;
				}
			}
			return true;
		}

		/**
		 * 去左右空格;
		 * @param char
		 * @return
		 *
		 */
		public static function trim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			return rtrim(ltrim(char));
		}

		/**
		 * 去左空格;
		 * @param char
		 * @return
		 *
		 */
		public static function ltrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp=/^\s*/;
			return char.replace(pattern, "");
		}

		/**
		 * 去右空格;
		 * @param char
		 * @return
		 *
		 */
		public static function rtrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp=/\s*$/;
			return char.replace(pattern, "");
		}

		/**
		 * 是否为前缀字符串;
		 * @param char
		 * @param prefix
		 * @return
		 *
		 */
		public static function beginsWith(char:String, prefix:String):Boolean
		{
			return (prefix == char.substring(0, prefix.length));
		}

		/**
		 * 是否为后缀字符串;
		 * @param char
		 * @param suffix
		 * @return
		 *
		 */
		public static function endsWith(char:String, suffix:String):Boolean
		{
			return (suffix == char.substring(char.length - suffix.length));
		}

		/**
		 * 去除指定字符串;
		 * @param char
		 * @param remove
		 * @return
		 *
		 */
		public static function remove(char:String, remove:String):String
		{
			return replace(char, remove, "");
		}

		/**
		 * 字符串替换;
		 * @param char
		 * @param replace
		 * @param replaceWith
		 * @return
		 *
		 */
		public static function replace(char:String, replace:String, replaceWith:String):String
		{
			return char.split(replace).join(replaceWith);
		}

		/**
		 * utf16转utf8编码;
		 * @param char
		 * @return
		 *
		 */
		public static function utf16to8(char:String):String
		{
			var out:Array=new Array();
			var len:uint=char.length;
			for (var i:uint=0; i < len; i++)
			{
				var c:int=char.charCodeAt(i);
				if (c >= 0x0001 && c <= 0x007F)
				{
					out[i]=char.charAt(i);
				}
				else if (c > 0x07FF)
				{
					out[i]=String.fromCharCode(0xE0 | ((c >> 12) & 0x0F), 0x80 | ((c >> 6) & 0x3F), 0x80 | ((c >> 0) & 0x3F));
				}
				else
				{
					out[i]=String.fromCharCode(0xC0 | ((c >> 6) & 0x1F), 0x80 | ((c >> 0) & 0x3F));
				}
			}
			return out.join('');
		}

		/**
		 * utf8转utf16编码;
		 * @param char
		 * @return
		 *
		 */
		public static function utf8to16(char:String):String
		{
			var out:Array=new Array();
			var len:uint=char.length;
			var i:uint=0;
			var char2:int, char3:int;
			while (i < len)
			{
				var c:int=char.charCodeAt(i++);
				switch (c >> 4)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
						// 0xxxxxxx  
						out[out.length]=char.charAt(i - 1);
						break;
					case 12:
					case 13:
						// 110x xxxx   10xx xxxx  
						char2=char.charCodeAt(i++);
						out[out.length]=String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
						break;
					case 14:
						// 1110 xxxx  10xx xxxx  10xx xxxx  
						char2=char.charCodeAt(i++);
						char3=char.charCodeAt(i++);
						out[out.length]=String.fromCharCode(((c & 0x0F) << 12) | ((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
						break;
				}
			}
			return out.join('');
		}

		/**
		 * 转换字符编码;
		 * @param char
		 * @param charset
		 * @return
		 *
		 */
		public static function encodeCharset(char:String, charset:String):String
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeUTFBytes(char);
			bytes.position=0;
			return bytes.readMultiByte(bytes.length, charset);
		}

		/**
		 * 添加新字符到指定位置;
		 * @param char
		 * @param value
		 * @param position
		 * @return
		 *
		 */
		public static function addAt(char:String, value:String, position:int):String
		{
			if (position > char.length)
			{
				position=char.length;
			}
			var firstPart:String=char.substring(0, position);
			var secondPart:String=char.substring(position, char.length);
			return (firstPart + value + secondPart);
		}

		/**
		 * 替换指定位置字符;
		 * @param char
		 * @param value
		 * @param beginIndex
		 * @param endIndex
		 * @return
		 *
		 */
		public static function replaceAt(char:String, value:String, beginIndex:int, endIndex:int):String
		{
			beginIndex=Math.max(beginIndex, 0);
			endIndex=Math.min(endIndex, char.length);
			var firstPart:String=char.substr(0, beginIndex);
			var secondPart:String=char.substr(endIndex, char.length);
			return (firstPart + value + secondPart);
		}

		/**
		 * 删除指定位置字符;
		 * @param char
		 * @param beginIndex
		 * @param endIndex
		 * @return
		 *
		 */
		public static function removeAt(char:String, beginIndex:int, endIndex:int):String
		{
			return StringUtil.replaceAt(char, "", beginIndex, endIndex);
		}

		/**
		 * 修复双换行符;
		 * @param char
		 * @return
		 *
		 */
		public static function fixNewlines(char:String):String
		{
			return char.replace(/\r\n/gm, "\n");
		}

	}
}
