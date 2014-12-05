package com.dream.hijobs.utils
{
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;

	public class ArrayCollectionColSort
	{
		public function ArrayCollectionColSort()
		{
		}
		public static function sortGoodsUserTerm(acSort:ArrayCollection):ArrayCollection {
			if(acSort == null)
			{
				return null;
			}
			var sort:Sort=new Sort();
			var goodsUserTerm:SortField=new SortField("goodsUserTerm");
			goodsUserTerm.compareFunction=function myCompare(a:Object, b:Object):int {
				var sortInt:int=BondDataGridColSort.userTerm_compareFunc(b.bondGoods.goodsUserTerm,a.bondGoods.goodsUserTerm);
				return sortInt;
			};
			sort.fields=[goodsUserTerm];
			acSort.sort=sort;
			acSort.refresh(); //更新  
			return acSort;
		}
	}
}