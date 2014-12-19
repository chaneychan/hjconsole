package com.dream.hijobs.component
{
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;
	
	public class BaseTitleWindow extends TitleWindow{
		public function BaseTitleWindow(){
			super();
			addEventListener(CloseEvent.CLOSE,function(event:CloseEvent):void{
				PopUpManager.removePopUp(event.target as TitleWindow);  
			});
		}
		
		protected function close():void{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
	}
}