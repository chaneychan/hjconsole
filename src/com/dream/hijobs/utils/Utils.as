
package com.dream.hijobs.utils {
//	import com.probertson.utils.GZIPBytesEncoder;
	
	import flash.events.TimerEvent;
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectUtil;

	public class Utils {

		private static const LOCALE_DAY_ARRAY:Array=[Utils.getLocaleString('ui', 'sunday'), Utils.getLocaleString('ui', 'monday'), Utils.getLocaleString('ui', 'tuesday'), Utils.getLocaleString('ui', 'wednesday'), Utils.getLocaleString('ui', 'thursday'), Utils.getLocaleString('ui', 'friday'), Utils.getLocaleString('ui', 'saturday')];

		/**
		 * <p>由日期获得本地星期</p>
		 * <p>日期字符串要定义在 ‘ui’资源束下</p>
		 * <p>如:<br>
		 * <li>sunday = 星期日
		 * <li>monday = 星期一
		 * <li>tuesday = 星期二
		 * <li>wednesday = 星期三
		 * <li>thursday = 星期四
		 * <li>friday = 星期五
		 * <li>saturday = 星期六</p>
		 * @param date 要转换的日期
		 * @return 星期字符串
		 * */
		public static function getLocaleWeek(date:Date):String {
			return LOCALE_DAY_ARRAY[date.getDay()];
		}

		/**
		 * <li>使用指定的值替换占位符之后，获取指定资源的值作为 String。 <br>
		 * <li>此方法调用 getObject()并将结果转换为字符串。<br>
		 * <li>如果将 parameters 数组传递给此方法，则数组中包含的参数会转换成字符串，然后在返回前在字符串中按顺序替代占位符 "{0}"、"{1}" 等。<br>
		 * <li>如果未找到指定的资源，则此方法将返回 null。<br>
		 * <li>此属性可用作数据绑定的源代码。<br>
		 * @param bundleName 资源束的名称。 如：'ui'
		 * @param resourceName 资源束中资源的名称。 如:'login.account'
		 * @param parameters 替换占位符的参数的数组。在替换每个参数之前都会使用 toString() 方法将其转换为字符串。
		 * @param locale 要用于查找的特定语言环境，或者使用 null 来搜索 localeChain 中的所有语言环境。该参数是可选的，默认值为 null；应该很少需要指定该参数。
		 * @return 作为 String 的资源值，或者 null（如果未找到该值）。
		 * */
		public static function getLocaleString(bundleName:String, resourceName:String, parameters:Array=null, locale:String=null):String {
			return ResourceManager.getInstance().getString(bundleName, resourceName, parameters, locale);
		}

		/**
		 * 延迟执行动作
		 * @param runFun 要执行的内容
		 * @param delay 要延迟的毫秒数
		 * */
		public static function delayRun(runFun:Function, delay:Number):void {
			var t:Timer=new Timer(delay, 1);
			t.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
				try {
					runFun();
				} catch (e:Error) {
					trace(e.getStackTrace());
				}
			});
			t.start();
		}

		/**
		 * 分割小数，获取整数部分内容<br>
		 * 如
		 * <li>10->"10"
		 * <li>3.14->"3"
		 * <li>1.0->"1"
		 * <li>0.75->"0"
		 * @param value 要分割的小数
		 * @return 小数的整数部分，字符串类型
		 * */
		public static function getBigNumber(value:Number):String {
			if (value) {
				return getBigNumberStr(value.toString());
			}
			return "0";
		}

		public static function getBigNumberStr(str:String):String {
			if (str == null)
				return "";
			if (str.indexOf(".") == -1) {
				return str;
			} else {
				var rArr:Array=str.split(".");
				return rArr[0];
			}
		}

		/**
		 * 分割小数，获取小数部分内容<br>
		 * 如
		 * <li>10->"0"
		 * <li>3.14->"14"
		 * <li>1.05->"05"
		 * <li>0.70->"7"
		 * @param value 要分割的小数
		 * @return 小数的小数部分，字符串类型
		 * */
		public static function getSmallNumber(value:Number):String {
			if (value) {
				return getSmallNumberStr(value.toString());
			}
			return "0";
		}

		public static function getSmallNumberStr(str:String):String {
			if (str == null)
				return "";
			if (str.indexOf(".") == -1) {
				return "0";
			} else {
				var rArr:Array=str.split(".");
				return rArr[1];
			}
		}

		/**
		 * 月数转换为 *Y*M格式<br>
		 * 如12->1Y
		 * @param month 月数
		 * @return 转换后的字符串
		public static function monthToTermName(month:int):String {
			var result:String="";
			var year:Number=Number(month) / 12;
			month=month % 12;

			if (year >= 1.0) {
				result+=year + "Y";
			} else if (month > 0) {
				result+=month + "M";
			}
			if (year == 0.0 && month == 0) {
				result="0";
			}
			return result;
		}
		 * */

		/**
		 * 功能：数组排序
		 * @param array 要排序的数组
		 * @param sortFieldName 要排序的字段
		 * @isDesc 是否应按降序排序 true:降序　false:升序
		 * @return 已排序的数组
		 * */
		public static function arrayCollectionNumSort(array:ArrayCollection, sortFieldName:String, isDesc:Boolean):ArrayCollection {
			var sort:Sort=new Sort();
			var sortField:SortField=new SortField();
			sortField.name=sortFieldName;
			sortField.numeric=true;
			sortField.descending=isDesc
			sort.fields=[sortField];
			array.sort=sort;
			array.refresh();
			sort=null
			sortField=null;
			sortFieldName=null;
			return array;
		}
		
		/**
		 * 功能：数组排序
		 * @param array 要排序的数组
		 * @return 已排序的数组
		 * */
		public static function arraySortByFun(array:ArrayCollection, compareFun:Function):ArrayCollection {
			var sort:Sort=new Sort();
			var sortField:SortField=new SortField();
			sort.fields=[sortField];
			sort.compareFunction = compareFun;
			array.sort=sort;
			array.refresh();
			sort=null
			return array;
		}

		/**
		 * 功能：数组排序
		 * @param array 要排序的数组
		 * @param sortFieldName 要排序的字段
		 * @isDesc 是否应按降序排序 true:降序　false:升序
		 * @return 已排序的数组
		 * */
		public static function arrayNumSort(array:Array, sortFieldName:String, isDesc:Boolean):Array {
			if (isDesc) {
				array.sortOn(sortFieldName, Array.DESCENDING | Array.NUMERIC);
			} else {
				array.sortOn(sortFieldName, Array.NUMERIC);
			}
//			var sort:Sort=new Sort();
//			var sortField:SortField=new SortField();
//			sortField.name=sortFieldName;
//			sortField.numeric=true;
//			sortField.descending=isDesc
//			sort.fields=[sortField];
//			array.sort=sort;
//			array.refresh();
//			sort=null
//			sortField=null;
//			sortFieldName=null;
			return array;
		}

		/**
		 * 带年限的数组排序
		 * @param array(源数组), sortField(排序字段) , sortType(排序类型<"M"/"Y"> M月在前 Y年在前  默认为M)
		 * @return 返回排序后的数组
		 * */
		public static function termArraySort(array:ArrayCollection, sortField:String, sortType:String="M"):ArrayCollection {
			var termM:ArrayCollection=new ArrayCollection;
			var termY:ArrayCollection=new ArrayCollection;
			var termTemp:ArrayCollection=new ArrayCollection;
			var sort:Sort=new Sort();
			sort.fields=[new SortField(sortField)];

			for (var i:int=0; i < array.length; i++) {
				if (array[i][sortField].indexOf("M") != -1) {
					termM.addItem(array[i]);
				} else {
					termY.addItem(array[i]);
				}
			}

			for (var termmIndexI:int=0; termmIndexI < termM.length; termmIndexI++) {
				for (var termmIndexJ:int=0; termmIndexJ < termM.length; termmIndexJ++) {
					var tempi:Number=Number(termM[termmIndexI][sortField].slice(0, termM[termmIndexI][sortField].length - 1));
					var tempj:Number=Number(termM[termmIndexJ][sortField].slice(0, termM[termmIndexJ][sortField].length - 1));
					if (tempi < tempj) {
						var temp:Object=termM[termmIndexI];
						termM.removeItemAt(termmIndexI);
						termM.addItemAt(temp, termmIndexJ);
					}
				}
			}

			for (var termyIndexI:int=0; termyIndexI < termY.length; termyIndexI++) {
				for (var termyIndexJ:int=0; termyIndexJ < termY.length; termyIndexJ++) {
					var tempyi:Number=Number(termY[termyIndexI][sortField].slice(0, termY[termyIndexI][sortField].length - 1));
					var tempyj:Number=Number(termY[termyIndexJ][sortField].slice(0, termY[termyIndexJ][sortField].length - 1));
					if (tempyi < tempyj) {
						var tempy:Object=termY[termyIndexI];
						termY.removeItemAt(termyIndexI);
						termY.addItemAt(tempy, termyIndexJ);
					}
				}
			}

//			termM.sort=sort
//			termM.refresh();
//			termY.sort=sort;
//			termY.refresh();
//
//			if (sortField == "Y") {
//				for (var j:int=0; j < termY.length; j++) {
//					termTemp.addItem(termY[j]);
//				}
//				for (var k:int=0; k < termM.length; k++) {
//					termTemp.addItem(termM[k]);
//				}
//			} else {
			for (var m:int=0; m < termM.length; m++) {
				termTemp.addItem(termM[m]);
			}
			for (var n:int=0; n < termY.length; n++) {
				termTemp.addItem(termY[n]);
			}
//			}

			return termTemp;
		}

		private static var bondBankExtends:ArrayCollection=null;
		private static var bondBankAgentExtends:ArrayCollection=null;
		private static var bankExtends:ArrayCollection=null;
		private static var bankAgentExtends:ArrayCollection=null;

		/**
		 * 加载银行的扩展属性,以及属性的可选项<br>
		 * 这些内容被定义在"assets/xml/bank_extends.xml"中
		 * @param callBack 在加载完成后运行的函数 function(bankExtends:ArrayCollection):void<br>
		 * bankExtends的结构:
* <pre>
* [
* {
*  name:"企业类型", dataField:"attribute",width:80,inputWidth:80,type:"combo", datas:[
*     {code:"bank", id:1, name:"银行"},
*     {code:"insurer", id:2, name:"保险公司"},
*     {code:"stockjobber", id:"3", name:"证券公司"},
*     {code:"other", id:99, name:"其他"}
*   ]
* },{
*  name:"资金类型", dataField:"attribute1",width:80,inputWidth:80,type:"combo", datas:[
*     {code:"china", id:1, name:"中资"},
*     {code:"foreign", id:2, name:"外资"},
*     {code:"joint", id:3, name:"合资"},
*     {code:"other", id:99, name:"其他"}
*   ]
*  }
* ]
* <pre>
* */
		public static function loadBondBankExtends(callBack:Function=null):void {
			loadExtends(bondBankExtends, callBack, "bondbank_extends.xml");
		}

		public static function loadBondBankAgentExtends(callBack:Function=null):void {
			loadExtends(bondBankAgentExtends, callBack, "bondbank_agent_extends.xml");
		}

		public static function loadBankExtends(callBack:Function=null):void {
			loadExtends(bankExtends, callBack, "bank_extends.xml");
		}

		public static function loadBankAgentExtends(callBack:Function=null):void {
			loadExtends(bankAgentExtends, callBack, "bank_agent_extends.xml");
		}

		private static function loadExtends(objExtends:ArrayCollection, callBack:Function, url:String):void {
			if (objExtends == null) {
				objExtends=new ArrayCollection();

				var bankAttributes:XML=XML(ResourceFileUtils.readFile(url));
				var attributes:XMLList=bankAttributes.attribute;

				for each (var arttribute:XML in attributes) {
					var datas:ArrayCollection=new ArrayCollection();
					for each (var data:XML in arttribute.data) {
						datas.addItem({code: (data.@code.toString()), id: (data.@id.toString()), name: (data.@name.toString())});
					}
					objExtends.addItem({name: arttribute.@name.toString(), defaultValue: arttribute.@defaultValue.toString(), dataField: arttribute.@dataField.toString(), width: int(arttribute.@width.toString()), inputWidth: int(arttribute.@inputWidth.toString()), type: arttribute.@type.toString(), datas: datas});
				}
				if (callBack != null) {
					callBack(objExtends);
				}
			} else {
				if (callBack != null) {
					callBack(objExtends);
				}
			}
		}

		/**
		 * 对象克隆
		 * */
		public static function clone(obj:Object):* {
			var copier:ByteArray=new ByteArray();
			copier.writeObject(obj);
			copier.position=0;
			return copier.readObject();
		}

		private static var _numberFormatter2:NumberFormatter;

		public static function get numberFormatter2():NumberFormatter {
			if (_numberFormatter2 == null) {
				_numberFormatter2=new NumberFormatter(LocaleID.DEFAULT);
				_numberFormatter2.trailingZeros=true;
				_numberFormatter2.leadingZero=true;
				_numberFormatter2.fractionalDigits=2;
			}
			return _numberFormatter2;
		}

		/**
		 * arraylist转换成arraycollection
		 * */
		public static function arraylistToArraycollection(arrayList:ArrayList):ArrayCollection {
			if (arrayList == null) {
				return null;
			}
			var arrayCollection:ArrayCollection=new ArrayCollection;
			for (var i:int=0; i < arrayList.length; i++) {
				arrayCollection.addItem(arrayList.getItemAt(i));
			}
			return arrayCollection;
		}

//		private static var encoder:GZIPBytesEncoder=new GZIPBytesEncoder();

		/**
		 * @author wangqiang
		 * 功能：解压数据
		 * @param bytes需要解压的数据
		 * */
/*		public static function unGZip(bytes:ByteArray):String {
			if (bytes == null)
				return null;
			return encoder.uncompressToByteArray(bytes).toString();
		}*/

		/**
		 * @author wangqiang
		 * 功能：把vector.<>类型转换成IList类型，主要是转换后和后台交互
		 * */
		public static function vectorToList(vc:*):ArrayCollection {
			if (!vc) {
				return null;
			}
			if (vc as IList) {
				return vc;
			}
			var ac:ArrayCollection=new ArrayCollection;
			for (var i:int=0; i < vc.length; i++) {
				ac.addItem(vc[i]);
			}
			return ac;
		}

		/**
		 * 对象内部属性的复制
		 *
		 * @param dest
		 * @param orig
		 *
		 */
		public static function copyProperties(dest:Object, orig:Object):void {
			if (orig is ArrayCollection) {
				return;
			}
			var classInfo:Object=ObjectUtil.getClassInfo(orig);
			var properties:Array=classInfo.properties;
			for (var j:int=0; j < properties.length; j++) {
				var prop:*=properties[j];

				if (dest.hasOwnProperty(prop.toString())) {
					if (orig[prop] is Date) {
						dest[prop]=orig[prop];
					} else {
						var type:String=orig[prop] == null ? "null" : typeof(orig[prop]);

						if ("object" == type) {
							copyProperties(dest[prop], orig[prop]);
						} else {
							try {
								dest[prop]=orig[prop];
							} catch (e:Error) {
								trace(e.message);

							}
						}
					}
				}
			}
		}

		public static function getMachineId():String {
			var machineIdObject:SharedObject=SharedObject.getLocal("machineInfo");
			if (machineIdObject.data.machineId) {
				var machineId:String=machineIdObject.data.machineId.toString();
				if (machineId != null && machineId != "" && machineId != "null") {
					return machineId;
				}
			}
			return null;
		}

		public static function setMachineId(machineId:String):void {
			var machineIdObject:SharedObject=SharedObject.getLocal("machineInfo");
			machineIdObject.data.machineId=machineId;
		}
		
		
		public static function dateFormatFunction(item:Object, column:DataGridColumn):String {
			if (item[column.dataField] != null) {
				return DateUtils.format(new Date(item[column.dataField]), "yy-MM-dd HH:mm:ss");
			} else {
				return null;
			}
		}
	}
}