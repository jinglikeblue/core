package jing.utils.data
{
	/**
	 * UTC时间工具 
	 * @author Jing
	 * 
	 */	
	public class UTCUtil
	{	
		/**
		 * 获取指定日期的UTC时间 
		 * @param year 年
		 * @param month 月
		 * @param date 日
		 * @param hour 时
		 * @param minutes 分
		 * @param seconds 秒
		 * @param timezone 时区，如北京为 +8,则传入8
		 * @return 
		 * 
		 */		
		static public function getUTC(year:uint,month:uint,date:uint,hour:uint = 0,minutes:uint = 0,seconds:uint = 0,timezone:int = 0):Number
		{
			//3600000 = 60 * 60 * 1000;
			var timeDifference:Number = timezone * 3600000;
			var temp:Date = new Date();
			temp.fullYearUTC = year;
			temp.monthUTC = month - 1;
			temp.dateUTC = date;
			temp.hoursUTC = hour;
			temp.minutesUTC = minutes;
			temp.secondsUTC = seconds;
			var time:Number = temp.time - timeDifference;
			return time;
		}
		
		/**
		 * 格式化UTC时间 
		 * @param utc 时间值
		 * @param timezone 时区，如北京为 +8,则传入8
		 * @param format 格式化的格式，分别为 A年，B月，C日，D时，E分，F秒
		 * @return 
		 * 
		 */		
		static public function formatUTC(utc:Number, timezone:int = 0, format:String = "A-B-C D:E:F"):String
		{
			//3600000 = 60 * 60 * 1000;
			var timeDifference:Number = timezone * 3600000;
			utc += timeDifference;
			var date:Date = new Date();
			date.time = utc;
			format = format.replace("A",date.fullYearUTC);
			format = format.replace("B",date.monthUTC + 1);
			format = format.replace("C",date.dateUTC);
			format = format.replace("D",date.hoursUTC);
			format = format.replace("E",date.minutesUTC);
			format = format.replace("F",date.secondsUTC);
			return format;
		}
	}
}