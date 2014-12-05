package com.dream.hijobs.utils {
	import spark.formatters.DateTimeFormatter;

	/**
	 *
	 * @author yinshuwei
	 * 日期工具类
	 */
	public class DateUtils {
		public function DateUtils() {
		}

		public static function getUpOrDownMonth(date:Date, size:int=1):Date {
			if (size == 0)
				return date;
			var month:Number=date.getMonth();
			var year:Number=date.getFullYear();
			var dateday:Number=date.getDate();
			var m:int=(int)(month);
			var y:int=(int)(year);
			var d:int=(int)(dateday);
			var ySize:int;
			var mSize:int;
			if (size < 0) {
				size=size * -1;
				ySize=size / 12;
				mSize=size % 12;
				if (mSize > m) {
					y=y - 1 - ySize;
					m=12 + m - mSize;
				} else {
					y=y - ySize;
					m=m - mSize;
				}
			} else if (size > 0) {
				ySize=size / 12;
				mSize=size % 12;
				if (mSize > (11 - m)) {
					y=y + 1 + ySize;
					m=mSize + m - 12;
				} else {
					y=y + ySize;
					m=m + mSize;
				}
			} else {
				return date;
			}

			date=setYMD(date, y, m, d);

			return date;
		}

		public static function isLeap(y:int):Boolean {
			return (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 ? true : false;
		}

		public static function setYMD(date:Date, y:int, m:int, d:int):Date {
			date.setDate(1);
			date.setFullYear(y);
			date.setMonth(m);
			var maxD:int=getMaxDateInMonth(y, m);
			date.setDate((d > maxD) ? maxD : d);
			return date;
		}

		public static function getUpOrDownDay(date:Date, size:int=1):Date {
			return new Date(date.getTime() + size * 1000 * 60 * 60 * 24);
		}

		public static function getUpOrDownWeek(date:Date, size:int=1):Date {
			return new Date(date.getTime() + size * 1000 * 60 * 60 * 24 * 7);
		}

		public static function getUpOrDownYear(date:Date, size:int=1):Date {
			date.setFullYear(date.getFullYear());
			return date;
		}

		public static function getYString(date:Date):String {
			return date.getFullYear().toString();
		}

		public static function getYMString(date:Date):String {
			var y:Number=date.getFullYear();
			var m:Number=date.getMonth();
			m=m + 1;
			if (m <= 9) {
				return y.toString() + "-0" + m.toString();
			} else {
				return y.toString() + "-" + m.toString();
			}
		}

		public static function getYMDString(date:Date):String {
			var y:Number=date.getFullYear();
			var m:Number=date.getMonth();
			var d:Number=date.getDate();
			m=m + 1;
			var dstr:String=d <= 9 ? "0" + d : d.toString();
			var mstr:String=m <= 9 ? "0" + m : m.toString();
			return y.toString() + "-" + mstr + "-" + dstr;
		}

		public static function getCnYString(date:Date):String {
			return date.getFullYear().toString() + "年";
		}

		public static function getCnYMString(date:Date):String {
			var y:Number=date.getFullYear();
			var m:Number=date.getMonth();
			m=m + 1;
			if (m <= 9) {
				return y.toString() + "年0" + m.toString() + "月";
			} else {
				return y.toString() + "年" + m.toString() + "月";
			}
		}

		public static function getCnYMDString(date:Date):String {
			var y:Number=date.getFullYear();
			var m:Number=date.getMonth();
			var d:Number=date.getDate();
			m=m + 1;
			var dstr:String=d <= 9 ? "0" + d : d.toString();
			var mstr:String=m <= 9 ? "0" + m : m.toString();
			return y.toString() + "年" + mstr + "月" + dstr + "日";
		}

		public static function getMaxDateInMonth(y:int, m:int):int {
			var maxD:int;
			switch (m + 1) {
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					maxD=31;
					break;
				case 4:
				case 6:
				case 9:
				case 11:
					maxD=30;
					break;
				case 2:
					if (isLeap(y))
						maxD=29;
					else
						maxD=28;
					break;
				default:
					maxD=1;
					break;
			}
			return maxD;
		}

		private static var formater:DateTimeFormatter=new DateTimeFormatter();

		public static function format(date:Date, fmt:String):String {
			formater.dateTimePattern=fmt;
			return formater.format(date);
		}

		public static function getDayText(day:int):String {
			return WEEK_TEXT[day];
		}

		public static function getLunarText(lunarMonth:int, lunarDate:int):String {
			if (lunarMonth == 1 && lunarDate == 1)
				return LUNAR_DATE_TEXT_FIRST;
			else if (lunarDate == 1)
				return LUNAR_MONTH_TEXT[lunarMonth - 1];
			else
				return LUNAR_DATE_TEXT[lunarDate - 1];
		}

		public static function getLunarDateText(lunarDate:int):String {
			return LUNAR_DATE_TEXT[lunarDate - 1]
		}

		public static function getLunarMonthText(lunarMonth:int):String {
			return LUNAR_MONTH_TEXT[lunarMonth - 1]
		}

		public static function greToLunarText(greYear:int, greMonth:int, greDate:int):String {
			var lunarArray:Array=greToLunarArray(greYear, greMonth, greDate);
			return getLunarText(lunarArray[1], lunarArray[2]);
		}


		/**返回某公历年月日对应的农历年月日：例如：2010, 7, 17(2011-08-17) ==> 2010,7,8,146,1340,40415,0*/
		public static function greToLunarArray(greYear:int, greMonth:int, greDate:int):Array {
			var nongDate:Array=new Array(7);
			var i:int=0;
			var temp:int=0;
			var leap:int=0;
			var offset:Number=(Number)((new Date(greYear, greMonth, greDate).time - new Date(00, 0, 31).time) / 86400000);
			nongDate[5]=offset + 40;
			nongDate[4]=14;
			for (i=1900; i < 2050 && offset > 0; i++) {
				temp=lYearDays(i);
				offset-=temp;
				nongDate[4]+=12;
			}
			if (offset < 0) {
				offset+=temp;
				i--;
				nongDate[4]-=12;
			}
			nongDate[0]=i;
			nongDate[3]=i - 1864;
			leap=leapMonth(i); //闰哪个月
			nongDate[6]=0;
			for (i=1; i < 13 && offset > 0; i++) { //闰月
				if (leap > 0 && i == (leap + 1) && nongDate[6] == 0) {
					i--;
					nongDate[6]=1;
					temp=leapDays((int)(nongDate[0]));
				} else {
					temp=monthDays((int)(nongDate[0]), i);
				}
				//解除闰月
				if (nongDate[6] == 1 && i == (leap + 1)) {
					nongDate[6]=0;
				}
				offset-=temp;
				if (nongDate[6] == 0) {
					nongDate[4]++;
				}
			}

			if (offset == 0 && leap > 0 && i == leap + 1) {
				if (nongDate[6] == 1) {
					nongDate[6]=0;
				} else {
					nongDate[6]=1;
					i--;
					nongDate[4]--;
				}
			}
			if (offset < 0) {
				offset+=temp;
				i--;
				nongDate[4]--;
			}
			nongDate[1]=i;
			nongDate[2]=offset + 1;
			return nongDate;
		}

		/*返回农历年的总天数*/
		private static function lYearDays(year:int):int {
			var i:int;
			var sum:int=348;
			for (i=0x8000; i > 0x8; i>>=1) {
				if ((LUNAR_INFO_ARRAY[year - 1900] & i) != 0)
					sum+=1;
			}
			return (sum + leapDays(year));
		}

		/*返回农历年闰月的天数*/
		private static function leapDays(lunarYear:int):int {
			if (leapMonth(lunarYear) != 0) {
				if ((LUNAR_INFO_ARRAY[lunarYear - 1900] & 0x10000) != 0) {
					return 30;
				} else {
					return 29;
				}
			} else {
				return 0;
			}
		}

		/*返回农历年闰月 1-12 , 没闰返回 0*/
		private static function leapMonth(y:int):int {
			return (int)(LUNAR_INFO_ARRAY[y - 1900] & 0xf);
		}

		/*返回农历年月的总天数*/
		private static function monthDays(y:int, m:int):int {
			if ((LUNAR_INFO_ARRAY[y - 1900] & (0x10000 >> m)) == 0) {
				return 29;
			} else {
				return 30;
			}
		}

		/**
		 * 取当月第一天
		 */
		public static function getFristDayOfMonth(currentDate:Date):Date {
			currentDate.setMonth(currentDate.getMonth(), 1); //下个月的第一天，也就是下个月1号  
			return currentDate;
		}

		/**
		 * 取当月月底
		 */
		public static function getLastDayOfMonth(currentDate:Date):Date {
			currentDate.setMonth(currentDate.getMonth() + 1, 1); //下个月的第一天，也就是下个月1号  
			currentDate.setDate(currentDate.getDate() - 1); //下个月1号之前1天，也就是本月月底  
			return currentDate;
		}

		private static const LUNAR_INFO_ARRAY:Array=[0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2, 0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, 0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950, 0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, 0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0, 0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, 0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6, 0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570, 0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5, 0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930, 0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, 0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0];

		private static const LUNAR_DATE_TEXT_FIRST:String="春节";
		private static const LUNAR_DATE_TEXT:Array=["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "廿十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十", "三十一"];

		private static const LUNAR_MONTH_TEXT:Array=["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];

		private static const WEEK_TEXT:Array=["日", "一", "二", "三", "四", "五", "六"];
	}
}