package com.dream.hijobs.utils {
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="com.artogrid.service.utils.generic.PaginatorObjUtil")]
	
	/**
	 * 最优报价查询条件，查询时只要传两个条件：pageNo(页码),pageSize(每页显示记录数)
	 * */
	public class PaginatorObjUtil {
		public function PaginatorObjUtil() {
		}
		public static const FIRST:int=1;
		public static const DEFAULT_PAGESIZE:int=10;
		
		/**
		 * 页码
		 * */
		public var pageNo:int=1;
		/**
		 * 每页显示多少条
		 * */
		public var pageSize:int;
		/**
		 * 总条数
		 * */
		public var totalRecords:int;
		
		//  public var startNum;
		//  public var endNum;


		/**
		 * 总页数
		 * */
		public var pageCount:int; 
		
		/**
		 * 前一页是否能用 
		 * */
		public var usePrevious:Boolean; 
		
		/**
		 * 后一页是否能用
		 * */
		public var useBehind:Boolean; 
		
		/**
		 * 是否分页
		 * */
		public var usePage:Boolean=true; 

		/**
		 * 返回数据集合
		 * */
		public var records:ArrayCollection=new ArrayCollection(); 
		
	
		
		
	}
}