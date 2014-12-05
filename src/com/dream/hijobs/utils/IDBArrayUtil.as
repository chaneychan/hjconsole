package com.dream.hijobs.utils {
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import spark.components.Group;

	public class IDBArrayUtil {
		public function IDBArrayUtil() {
		}

		/**
		 *
		 *
		 * 只能获得可视子组件
		 * */
		public static function getALLChildByElement(_box:Group):ArrayCollection {
			var num:int=_box.numElements;
			var childs:ArrayCollection=new ArrayCollection();
			for (var i:int=0; i < num; i++) {
				childs.addItem(_box.getElementAt(i));
			}
			return childs;
		}

		/**
		 *
		 *
		 * 获得所以子组件
		 * */
		public static function getALLChild(_box:Group):ArrayCollection {
			var num:int=_box.numChildren;
			var childs:ArrayCollection=new ArrayCollection();
			for (var i:int=0; i < num; i++) {
				childs.addItem(_box.getElementAt(i));
			}
			return childs;
		}


		/**
		 * 根据给定的值搜索，并且返回最匹配的数据集，按升序排列
		 * @author chaney
		 * @param arr:数据源
		 * @param arrSearch:要搜索的字段
		 * @param param:输入的搜索值
		 * @param resultNum:返回的匹配数，默认10
		 * @param allowNoMatch:是否允许不匹配的值随着结果集返回，如果允许返回不匹配的值将排在最后，默认不允许
		 * @param isAsc:返回结果的排序规则，true:升序，false:降序，默认升序
		 * @return 搜索结果集
		 */
		public static function searchFilter(arr:ArrayCollection, arrSearch:Array, param:String, resultNum:int=10, allowNoMatch:Boolean=false, isAsc:Boolean=true):ArrayCollection {
			var result:ArrayCollection;
			var arrResult:Array=new Array();
			param=StringUtil.trim(param.toUpperCase());
			if (StringUtils.isNotBlank(param)) {
//				var time1:Date=new Date();
//				trace("循环前：" + (time1).time + "     总长度：" + arr.length);
				for each (var item:Object in arr) {
					item.matchingDegree=int.MAX_VALUE;
					for each (var fieldName:String in arrSearch) {
						var fieldValue:String=item[fieldName];
						if (StringUtils.isBlank(fieldValue)) {
							continue;
						}
						if(StringUtils.equals("goodsCode", fieldName)){
							if(StringUtils.equals(param, fieldValue.substr(0, param.length))){
								item.matchingDegree=fieldValue.length < item.matchingDegree ? fieldValue.length : item.matchingDegree;
							}
						}else{
							if (fieldValue.toString().toUpperCase().indexOf(param) != -1) {
								item.matchingDegree=fieldValue.length < item.matchingDegree ? fieldValue.length : item.matchingDegree;
							}
						}
					}
					if (allowNoMatch) {
						arrResult.push(item);
					} else if (item.matchingDegree < int.MAX_VALUE) {
						arrResult.push(item);
					}
				}
//				var time2:Date=new Date();
//				trace("循环差：" + (time2.time - time1.time) + "      ");
//				var time3:Date=new Date();
				arrResult=Utils.arrayNumSort(arrResult, "matchingDegree", !isAsc);
//				trace("排序差：" + (time3.time - time2.time) + "      ");
				if (arrResult.length > resultNum) {
					result=new ArrayCollection(arrResult.slice(0, resultNum));
				} else {
					result=new ArrayCollection(arrResult);
				}
			}
			param=null;
			arrResult=null
			return result;
		}
	}
}