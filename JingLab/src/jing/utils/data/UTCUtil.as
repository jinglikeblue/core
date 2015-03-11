package jing.utils.data
{
	/**
	 * UTC时间工具 
	 * 这里使用的UTC单位以秒计算
	 * @author Jing
	 * 
	 */	
	public class UTCUtil
	{
		/**
		 * 一个小时的秒数 
		 */		
		static public const ONE_HOUR_SECONDS:int = 60 * 60;
		
		/**
		 * 一天的秒数 
		 */		
		static public const ONE_DAY_SECONDS:int = ONE_HOUR_SECONDS * 24;		
		
		/**
		 * 计算两个UTC(单位为秒)时间的时间差(a相对于b)为多少天
		 * 返回值N：
		 * =0 表示为同一天
		 * >0 表示超过N天
		 * <0 表示落后N天
		 * @param a 单位(秒)
		 * @param b 单位(秒)
		 * @param timezone a、b的时区，如果a、b的时间为utc + timezone，则需要传入该值
		 * @return 
		 * 
		 */		
		static public function getDayGap(a:int, b:int, timezone:int = 0):int
		{		
			var timeDifference:int = timezone * ONE_HOUR_SECONDS
			var a:int = (a + timeDifference) / ONE_DAY_SECONDS;
			var b:int = (b + timeDifference) / ONE_DAY_SECONDS;
			var gap:int = a - b;
			return gap;
		}		
		
		
		/**
		 * 将传入的时间转换为UTC(单位为秒)时间
		 * @param year 年
		 * @param month 月
		 * @param date 日
		 * @param hour 时
		 * @param minutes 分
		 * @param seconds 秒
		 * @param timezone 传入时间对应的时区，如东八区为UTC+8，则这里传入8
		 * @return UTC时间
		 * 
		 */		
		static public function getUTC(year:uint, month:uint, date:uint, hour:uint = 0, minutes:uint = 0, seconds:uint = 0, timezone:int = 0):int
		{
			var timeDifference:Number = timezone * ONE_HOUR_SECONDS;
			var temp:Date = new Date();
			temp.fullYearUTC = year;
			temp.monthUTC = month - 1;
			temp.dateUTC = date;
			temp.hoursUTC = hour;
			temp.minutesUTC = minutes;
			temp.secondsUTC = seconds;
			var time:int = int(temp.time / 1000);
			return time - timeDifference;
		}
		
		/**
		 * 格式化UTC(单位为秒)时间 
		 * @param utc 时间值
		 * @param timezone 时区，如北京为 +8,则传入8
		 * @param format 格式化的格式，分别为 A年，B月，C日，D时，E分，F秒
		 * @return 
		 * 
		 */		
		static public function formatUTC(utc:int, timezone:int = 0, format:String = "A-B-C D:E:F"):String
		{			
			var timeDifference:Number = timezone * ONE_HOUR_SECONDS;
			utc += timeDifference;
			var date:Date = new Date();
			date.time = utc * 1000;
			format = format.replace("A", date.fullYearUTC);
			format = format.replace("B", date.monthUTC + 1);
			format = format.replace("C", date.dateUTC);
			format = format.replace("D", date.hoursUTC >= 10 ? date.hoursUTC : "0" + date.hoursUTC);
			format = format.replace("E", date.minutesUTC >= 10 ? date.minutesUTC : "0" + date.minutesUTC);
			format = format.replace("F", date.secondsUTC >= 10 ? date.secondsUTC : "0" + date.secondsUTC);
			return format;
		}
		
		/**
		 * 得到UTC表达的最近一天通过了的秒数
		 */
		static public function getPastSeconds(utc:int, timezone:int = 0):int
		{
			var timeDifference:Number = timezone * ONE_HOUR_SECONDS;
			utc += timeDifference;
			var pastSeconds:int = utc % ONE_DAY_SECONDS;
			return pastSeconds;			
		}
		
		/**
		 * 得到UTC表达的最近一天通过了的小时
		 */
		static public function getPastHours(utc:int, timezone:int = 0):int
		{
			var pastSeconds:int = getPastSeconds(utc, timezone);
			var pastHours:int = (pastSeconds - pastSeconds % ONE_HOUR_SECONDS) / ONE_HOUR_SECONDS;
			return pastHours;
		}
		
		/**
		 * 得到当天00:00:00时刻的UTC
		 * @param utc
		 * @param timezone
		 * @return
		 *
		 */
		static public function getClosestZeroHour(utc:int, timezone:int = 0):int
		{
			utc -= getPastSeconds(utc, timezone);
			return utc;
		}
	}
}