package com.dream.hijobs.utils {
	import mx.utils.ObjectUtil;

	public class BondDataGridColSort {
		
		
		
		public function BondDataGridColSort() {
		}

		public static function userTerm_compareFunc(goodsUserTermA:String, goodsUserTermB:String):int {

			if (goodsUserTermA == goodsUserTermB) {
				return 0;
			} else if (goodsUserTermA == null || goodsUserTermA == "") {
				return -1;
			} else if (goodsUserTermB == null || goodsUserTermB == "") {
				return 1;
			}
			var daysA:Number=getTermDaysByStr(goodsUserTermA.split("+")[0]);
			var daysB:Number=getTermDaysByStr(goodsUserTermB.split("+")[0]);

			if (daysA > daysB) {
				return -1;
			} else if (daysB > daysA) {
				return 1;
			} else {
				return 0;
			}
		}

		/**
		 * 参数1.2Y,53D
		 * */
		public static function getTermDaysByStr(_dayStr:String):Number {
			if (_dayStr == "") {
				return 0;
			}
			var isYear:Boolean=_dayStr.indexOf("Y") >= 0;
			var isDay:Boolean=_dayStr.indexOf("D") >= 0;
			try {
				if (isDay) {
					return Number(_dayStr.substring(0, _dayStr.indexOf("D")));
				} else if (isYear) {
					return Number(_dayStr.substring(0, _dayStr.indexOf("Y"))) * 365;
				} else {
					return 0;
				}
			} catch (e:Error) {
				trace("日期转化为day时候出错！");

			}
			return 0;
		}
		
		public static function id_compareFunc(itemA:Object, itemB:Object):int
		{
			try
			{ 
				if(itemA==itemB)
				{
					return 0;
				}else if(itemA.id>itemB.id)
				{
					return -1;
				}else
				{
					return 1;
				}
			}catch(err:Error)
			{
				
			}
			itemA=null;
			itemB=null;
			return 0;
		}

		/**
		 *
		 * goodsGode排序
		 * */
		public static function goodsGode_compareFunc(goodsCodeA:String, goodsCodeB:String):int {
			if (goodsCodeA == goodsCodeB) {
				return 0;
			} else if (goodsCodeA == null || goodsCodeA == "" || isNaN(Number(goodsCodeA))) {
				return 1;
			} else if (goodsCodeB == null || goodsCodeB == "" || isNaN(Number(goodsCodeB))) {
				return -1;
			}
			try {
				var numA:int=int(goodsCodeA);
				var numB:int=int(goodsCodeB);
				if (numA > numB) {
					return -1;
				} else if (numB > numA) {
					return 1;
				} else {
					return 0;
				}
			} catch (e:Error) {
				trace("转化goodscodetoint出错");
			}
			return 0;
		}


		private static var strcompart:String="abcdefghijklmnopkrstuvwxyz+ -0123456789";

		/**
		 * 自定义评级排序
		 * 从小到大排序
		 * 0位置不变
		 * 1位置放前面
		 * -1位置放后面
		 * */
		public static function goodLevel_compareFunc(goodLeavelA:String, goodLeavelB:String):int {


			if (goodLeavelA == goodLeavelB) {
				return 0;
			} else if (goodLeavelA == null || goodLeavelA == "") {
				return 1;
			} else if (goodLeavelB == null || goodLeavelB == "") {
				return -1;
			}

			var len:int=goodLeavelA.length > goodLeavelB.length ? goodLeavelA.length : goodLeavelB.length;
			for (var i:int=0; i < len; i++) {
				var a:String=" ";
				var b:String=" ";
				if (goodLeavelA.length >= i + 1) {
					a=goodLeavelA.charAt(i).toLocaleLowerCase();
				}
				if (goodLeavelB.length >= i + 1) {
					b=goodLeavelB.charAt(i).toLocaleLowerCase();
				}
				if (i == len - 1) {
					if (a == b) {
						return 0;
					} else {
						return compareCharNew(a, b);
					}
				} else {
					if (a == b) {
						continue;
					} else {
						return compareCharNew(a, b);
					}
				}

			}
			return 0;
		}

		/**
		 * 比对2个字符大小
		 * */
		private static function compareCharNew(strA:String, strB:String):int {
			var indexA:int=strcompart.indexOf(strA);
			var indexB:int=strcompart.indexOf(strB);
			if (indexA > indexB) {
				return 1;
			} else if (indexB > indexA) {
				return -1;
			} else {
				return 0;
			}
		}

		public static function price_compareFunc(priceA:String, priceB:String):int {
			if (priceA == priceB) {
				return 0;
			} else if (priceA == null || priceA == "" || isNaN(Number(priceA))) {
				if (priceA == null || priceA == "") {
					return 1;
				} else if ((priceA == "Bid" || priceA == "Ofr") && (priceB == null || priceB == "")) {
					return -1;
				} else {
					return 1;
				}
			} else if (priceB == null || priceB == "" || isNaN(Number(priceB))) {
				if (priceB == null || priceB == "") {
					return -1;
				} else if ((priceB == "Bid" || priceB == "Ofr") && (priceA == null || priceA == "")) {

					return 1;
				} else {
					return -1;
				}

			} else if (Number(priceA) > Number(priceB)) {
				return -1;
			} else if (Number(priceB) > Number(priceA)) {
				return 1;
			} else {
				return 0;
			}
		}

		public static function price_compareFuncByOrder(priceA:String, priceB:String, isAsec:Boolean):int {
			var aIsNull:Boolean=(priceA == "--");
			var aIsBidOrOfr:Boolean=(priceA == "Bid" || priceA == "Ofr");
			var bIsNull:Boolean=(priceB == "--");
			var bIsBidOrOfr:Boolean=(priceB == "Bid" || priceB == "Ofr");
			if (aIsNull && bIsNull) {
				return 0;
			}
			if (aIsNull && bIsBidOrOfr) {
				return 1;
			}
			if (aIsNull && ((!bIsNull) && (!bIsBidOrOfr))) {
				return 1;
			}

			if (aIsBidOrOfr && bIsNull) {
				return -1;
			}
			if (aIsBidOrOfr && bIsBidOrOfr) {
				return 0;
			}
			if (aIsBidOrOfr && ((!bIsNull) && (!bIsBidOrOfr))) {
				return 1;
			}

			if (((!aIsNull) && (!aIsBidOrOfr)) && bIsNull) {
				return -1;
			}
			if (((!aIsNull) && (!aIsBidOrOfr)) && bIsBidOrOfr) {
				return -1;
			}
			if (((!aIsNull) && (!aIsBidOrOfr)) && ((!bIsNull) && (!bIsBidOrOfr))) {
				if (isAsec) {
					return ObjectUtil.numericCompare(Number(priceA), Number(priceB));
				} else {
					return ObjectUtil.numericCompare(Number(priceA), Number(priceB)) * -1;

				}
			}

			return 0;
		}

		public static function volume_compareFuncByOrder(priceA:String, priceB:String, isAsec:Boolean):int {
			var aIsNull:Boolean=(priceA == null || priceA == "" || priceA == "0");
			var bIsNull:Boolean=(priceB == null || priceB == "" || priceB == "0");
			if (aIsNull && bIsNull) {
				return 0;
			}
			if (aIsNull && !bIsNull) {
				return 1;
			}

			if (!aIsNull && bIsNull) {
				return -1;
			}
			if (!aIsNull && !bIsNull) {
				if(priceA.indexOf("+") !=-1)
				{
					var arrA:Array = priceA.split("+");
			/*		var priceAAll:Number = 0;
					for each(var num:String  in arrA)
					{
						priceAAll+= Number(num);
					}
					priceA = priceAAll.toString();*/
					priceA = arrA[0].toString();
				}
				
				if(priceB.indexOf("+") !=-1)
				{
					var arrB:Array = priceB.split("+");
				/*	var priceBAll:Number = 0;
					for each(var numb:String  in arrB)
					{
						priceBAll+= Number(numb);
					}
					priceB = priceBAll.toString();*/
					priceB = arrB[0].toString();
				}
				if (isAsec) {
					return ObjectUtil.numericCompare(Number(priceA), Number(priceB));
				} else {
					return ObjectUtil.numericCompare(Number(priceA), Number(priceB)) * -1;
				}
			}

			return 0;
		}

		
		

	}
}