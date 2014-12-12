package com.dream.hijobs.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class HijobsEvent extends Event
	{
		public var data:Object;  
		public static const dis:EventDispatcher = new EventDispatcher(); 
		
		public static const IMAGEVIEW_DELETE:String = "imageview_delete";
		
		public function HijobsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false ,_date:Object = null)
		{
			super(type, bubbles, cancelable);
			this.data = _date;  
		}
	}
}