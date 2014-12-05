package com.dream.hijobs.utils {
	import mx.utils.StringUtil;

	public class StringUtils {
		public static function equalsIgnoreCase(str:String, str1:String):Boolean {
			return str.toLowerCase() == str1.toLowerCase();
		}

		//ReplaceAll
		public static function StringReplaceAll(source:String, find:String, replacement:String):String {
			return source.split(find).join(replacement);
		}

		/**
		 *
		 * 根据对象属性，拿到对象上的属性值，区分大小写
		 * */
		public static function getObjectAttributeValue(_obj:Object, attributeStr:String):String {
			try {
				if (_obj == null || attributeStr == null || attributeStr == "") {
					return "";
				}
				var attributeArray:Array=attributeStr.split(".");
				var tempObj:Object=new Object();
				if (attributeArray.length > 0) {
					tempObj=_obj;
					for (var i:int=0; i < attributeArray.length; i++) {
						if (i == attributeArray.length - 1) {
							return StringUtil.trim(tempObj[attributeArray[i]]);
						}
						tempObj=tempObj[attributeArray[i]];
					}
				}
			} catch (e:Error) {
				trace("用属性拿对象的值出错.");
			}
			return "";
		}

		/**
		 * 在原有的字符串之后加入字符<br>
		 * @author chaney
		 * @param source：原有字符
		 * @param addString：需要加入的字符
		 * @param count：加入字符之后的总字符数
		 * @return 返回结果字符串
		 */
		public static function addString(source:String, addStr:String, count:int):String {
			if (source.length < count)
				return addString(source.concat(addStr), addStr, count);
			else
				return source;
		}
		
		/**
		 *@author chaney
		 */
		public static function jsonToObject(source:String):Object {
			var arr:Array=source.split(",");
			var len:uint=arr.length;
			var idx:uint;
			var obj:Object={};
			for (idx=0; idx < len; idx++) {
				var index:int=arr[idx].indexOf(":");
				if (index != -1) {
					var key:String=arr[idx].toString().substring(0, index);
					var value:String=arr[idx].toString().substring(index + 1);
					obj[key]=value;
				}
			}
			return obj
		}

		/****
		 * 在原有的字符串指定的位置插入字符
		 * @author chaney
		 * @param source：原有字符
		 * @param addString：需要加入的字符
		 * @param index 插入的位置
		 */
		public static function insertString(source:String, addStr:String, index:Number):String {
			if (source.length > 0) {
				var indexStr:String=source.substr(0, index).concat(addStr);
				source=indexStr + source.substr(index, source.length)
			} else {
				source=source.concat(addStr);
			}
			return source;
		}
		
		
		/***
		 * 查询一个数字有小数点后面有机会有效数字
		 */ 
		public static function getPointCountByNumber(str:String):int{
			if(str.indexOf(".")<0){
				return 0;
			}else{
				return str.substr(str.indexOf(".")+1,str.length).length;
			}
		}

		public static function isEmpty(str:String):Boolean {
			return str == null || str.length == 0;
		}

		public static function isNotEmpty(str:String):Boolean {
			return !isEmpty(str);
		}

		/**
		 *@author chaney
		 */
		public static function isBlank(str:String):Boolean {
			return str == null || StringUtil.trim(str) == "";
		}

		/**
		 *@author chaney
		 */
		public static function isNotBlank(str:String):Boolean {
			return !isBlank(str);
		}

		/**
		 *@author chaney
		 */
		public static function equals(str1:String, str2:String):Boolean {
			return str1 == null ? str2 == null : str1 == str2;
		}
	}
}
