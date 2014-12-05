package com.dream.hijobs.utils {

	public class IDBNumberFormatter {
		private var _formatString:String;
		public static const ROUND_DOWN:int=0;
		public static const ROUND:int=1;
		public static const ROUND_UP:int=2;

		/**
		 *
		 * 00.00####
		 * 0为必有
		 * #为可有
		 * **/
		public function IDBNumberFormatter(str:String) {
			_formatString=str;
		}

		public function get formatString():String {
			return _formatString;
		}

		public function set formatString(value:String):void {
			_formatString=value;
		}

		private function getUsableNumberString(value:Number, roundType:int):String {
			var index:int=_formatString.indexOf(".");
			if (index != -1) {
				var l:int = _formatString.length-index -1;
				var n:Number = 1;
				for (var i:int = 0; i < l; i++) 
				{
					n*=10;
				}
				value*=n;
				
				if (roundType == ROUND) {
					value = Math.round(value);
				} else if (roundType == ROUND_UP) {
					value = Math.round(value+0.4);
				}else{
					value = Math.round(value-0.5);
				}
				value/=n;
			}

			return value.toString();
			
		}

		public function format(value:Number, roundType:int=ROUND):String {
			var valueString:String=getUsableNumberString(value, roundType);
			if (_formatString) {
				var formatIndex:int=_formatString.indexOf(".");
				var valueIndex:int=valueString.indexOf(".");
				
				if(formatIndex==-1){
					formatIndex = _formatString.length;
				}
				
				if(valueIndex==-1){
					valueIndex = valueString.length;
				}
				
				var enadd1:Boolean=true;
				//小数
				var enadd2:Boolean=true;
				var result:String=".";

				for (var i:int=1; (enadd1 || enadd2); i++) {

					var fc1:String="";
					if (formatIndex - i > -1 && formatIndex - i < formatString.length) {
						fc1=formatString.charAt(formatIndex - i);
					}
					var vc1:String="";
					if (valueIndex - i > -1 && valueIndex - i < valueString.length) {
						vc1=valueString.charAt(valueIndex - i)
					}

					if (fc1 == "" && vc1 == "") {
						enadd1=false;
					}
					if (enadd1) {
						if (fc1 == "0") {
							if (vc1 == "") {
								vc1="0";
							}
						} else if (fc1 == "") {
							vc1="";
						}
						result=vc1 + result;
					}

					var fc2:String="";
					if (formatIndex + i > -1 && formatIndex + i < formatString.length) {
						fc2=formatString.charAt(formatIndex + i);
					}
					var vc2:String="";
					if (valueIndex + i > -1 && valueIndex - i < valueString.length) {
						vc2=valueString.charAt(valueIndex + i)
					}

					if (fc2 == "" && vc2 == "") {
						enadd2=false;
					}
					if (enadd2) {
						if (fc2 == "0") {
							if (vc2 == "") {
								vc2="0";
							}
						} else if (fc2 == "") {
							vc2="";
						}
						result=result + vc2;
					}
				}
				if (result.indexOf(".") == result.length - 1) {
					result=result.substr(0, result.length - 1);
				}
				if (result == "") {
					result="0";
				}
				return result;

			}

			return valueString;
		}
		
		
		/**
		 * 
		 * 
		 *四舍五入从要保留的小数后下以为开始算起最后以为算起
		 * */
		public static function ToFixedByLast(value:Number, digits:uint = 0):String	
		{
			var str:String ="";
			if(value<0)
			{
				str= (value*-1).toString();
			}else
			{
				str= value.toString();
			}
			
			var index:int = str.indexOf(".");
			
			var strInt:String = str;
			
			var strDec:String = "";
			
			if(index>0)	
			{
				strInt = str.substr(0, index);
				
				strDec = str.substr(index+1, digits);
			}
			
			while(strDec.length < digits)	
			{	
				strDec += "0";
				
			}
			
			var integer:int = int(strInt+strDec);
								
			if(index>0)				
			{				
				var nums:Array = new Array();				
				var dec:String = str.substr(index+1+digits);//取舍小数部分				
				for(var i:int=0;i<dec.length;i++)					
				{					
					nums.push(int(dec.charAt(i)));//拆分每个数字					
				}				
				var n1:int;				
				var n2:int;				
				while(nums.length>1)					
				{					
					n1 = nums.pop();					
					if(n1>4)						
					{						
						n2 = nums[nums.length-1]+1;						
						nums[nums.length-1] = n2;						
					}					
				}				
				if(nums.length && nums[nums.length-1]>4)
					
					integer++;				
			}									
			str = integer.toString();			
			if(digits==0)				
				return verificationNumber(value,str);		
			
			while(str.length<strInt.length+strDec.length)				
			{				
				str = "0"+str;
				
			}			
			return verificationNumber(value,str.substr(0, str.length-digits) + "."+ str.substr(str.length-digits));	
		}
		
		
		/**
		 * 
		 * 
		 *四舍五入从要保留的小数后下以为开始算起
		 * */
		public  static function ToFixedByNext(value:Number, digits:uint = 0):String	
		{
			var str:String ="";
			if(value<0)
			{
				str= (value*-1).toString();
			}else
			{
				str= value.toString();
			}
			
			var index:int = str.indexOf(".");
			
			var strInt:String = str;
			
			var strDec:String = "";
			var i:int=0;
			if(index>0)	
			{
				strInt=str.split(".")[0];
				strDec=str.split(".")[1];
				
				strDec = strDec.substr(0, digits+1);
				while(strDec.length < digits+1)	
				{	
					strDec += "0";
				}
			}else
			{
				if(digits>0)
				{
					for(i=0;i<digits;i++)
					{
						strDec += "0";
					}
					return verificationNumber(value,strInt+"."+strDec);
				}else if(digits==0)
				{
					return verificationNumber(value,strInt);
				}
				for(i=0;i<digits+1;i++)
				{
					strDec += "0";
				}
			}
					
			var tempStr:String=strInt+strDec;
			
			
			var n1:int;	
			var nums:Array = new Array();							
			for(i=0;i<tempStr.length;i++)					
			{					
				nums.push(int(tempStr.charAt(i)));//拆分每个数字					
			}				
			n1 = nums.pop();
			var numsStartLens:int=nums.length;
			if(n1>4)
			{
				nums[nums.length-1]=nums[nums.length-1]+1;
				if(nums[nums.length-1]>=10)
				{
					nums=verificationLastNumber(nums);
				}
				//update for chaney
				if(nums.length>numsStartLens)
					index+=1;
			}
			str="";
			for(i=0;i<nums.length;i++)
			{				
				str=str+nums[i];								
			}	
			if(digits==0)
			{
				return verificationNumber(value,str.substr(0, index));
			}else
			{
				return verificationNumber(value,str.substr(0, index) + "."+ str.substr(index));
			}
		}
		
		public static function verificationNumber(_originalStr:Number,targetString:String):String
		{
			if(_originalStr<0)
			{
				targetString="-"+targetString;
			}
			return targetString;
		}
		
		public static function verificationLastNumber(targetArray:Array):Array
		{
			for(var i:int=targetArray.length-1;i>=0;i--)
			{
				if(targetArray[i]<10)
				{
					break;
				}
				if(i==0 && targetArray[i]>=10)
				{
					targetArray[i]=0;
					targetArray.unshift(1);
					break;
				}else if(targetArray[i]>=10)
				{
					targetArray[i]=0;
					targetArray[i-1]=targetArray[i-1]+1;
				}
			}	
			return targetArray;
		}

	}
}