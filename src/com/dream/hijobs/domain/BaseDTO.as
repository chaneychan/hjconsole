package com.dream.hijobs.domain
{
	import com.dream.hijobs.utils.Constants;
	
	import flash.net.URLRequestMethod;

	public class BaseDTO
	{
		public function BaseDTO()
		{
		}
		public var tk:String = Constants.token;
		public var _method:String;
	}
}