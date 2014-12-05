package com.dream.hijobs.domain
{
	public class CompanyDTO extends BaseDTO
	{
		public function CompanyDTO()
		{
			super();
		}
		
		public var id:Number=0;
		
		public var fullName:String;
		
		public var mobile:String;
		
		public var tel:String;
		
		public var status:int;
		
		public var address:String;
		
		public var size:String;
		
		public var nature:String;
		
		public var industry:String;
		
		public var profile:String;
		
		public var imageUrls:String;
		
		public var latitude:Number=0;
		
		public var longitude:Number=0;
		
		public var geohash:String;
		
		public var isDel:Boolean;
	}
}