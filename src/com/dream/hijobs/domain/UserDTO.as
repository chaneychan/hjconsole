package com.dream.hijobs.domain
{
	public class UserDTO extends BaseDTO
	{
		public function UserDTO()
		{
		}
		public var id:Number=0;
		
		public var pwd:String;
		
		public var email:String;
		
		public var mobile:String;
		
		public var devType:int;
		
		public var devId:String;
		
		public var appVer:String;
		
		public var latitude:Number=0;
		
		public var longitude:Number=0;
		
		public var geohash:String;
		
		public var lastLogin:Date;
		
		public var gender:int;
		
		public var birthday:Date;
		
		public var name:String;
		
		public var nick:String;
		
		public var avatar:String;
		
		public var positions:String;
		
		public var hukou:String;
		
		public var residence:String;
		
		public var expSal:String;
		
		public var edu:String;
		
		public var openId:String;
		
		public var openType:int;
		
		public var isDel:Boolean;
		
		public var gmtModified:Date;
		
		public var gmtCreated:Date;

	}
}