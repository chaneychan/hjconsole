package com.dream.hijobs.utils 
{
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class HJHttpService extends HTTPService
	{
		public var isUse:Boolean = false;
		private var resultListeners:Array = [];
		private var faultListeners:Array = [];
		
		public function HJHttpService(rootURL:String=null, destination:String=null)
		{
			super(rootURL, destination);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(type == FaultEvent.FAULT){
				faultListeners.push(listener);
				isUse = true;
				return;
			}else if(type == ResultEvent.RESULT){
				resultListeners.push(listener);
				isUse = true;
				return;
			}
			return;
			//super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			
			if(event is ResultEvent){
				for each (var resultListener:Function in resultListeners) 
				{
					if(resultListener != null){
						resultListener(event);
					}
				}
				resultListeners = [];
				faultListeners = [];
				isUse = false;
				return true;
			}else if(event is FaultEvent){
				for each (var faultListener:Function in faultListeners) 
				{
					if(faultListener != null){
						faultListener(event);
					}
				}
				resultListeners = [];
				faultListeners = [];
				isUse = false;
				return true;
			}
			return true;
			//return super.dispatchEvent(event);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(type != ResultEvent.RESULT && type != FaultEvent.FAULT){				
				super.removeEventListener(type, listener, useCapture);
			}
			
		}
	}
}