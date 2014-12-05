package com.dream.hijobs.utils  {

	import flash.net.URLRequestMethod;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	/**
	 * http请求响应类
	 */
	public class HttpConnection {

		private static var connectionPool:Array=new Array; //连接池
		private static var connectionPoolLength:int; //当前连接池大小
		private static var increment:int=10; //连接池增量
		private static var connectionTimeOut:int=30; //连接超时数（秒）

		private static function createConnectionPool():void {
			for (var i:int=0; i < increment; i++) {
				connectionPool.push(createHttpService());
			}
			connectionPoolLength=connectionPool.length;
		}

		private static function createHttpService():HJHttpService {
			var httpService:HJHttpService=new HJHttpService();
			httpService.showBusyCursor=true;
			httpService.requestTimeout=connectionTimeOut;
			httpService.resultFormat="text";
			httpService.isUse=false;
			return httpService;
		}

		private static function getHttpService():HJHttpService {
			for each (var connection:HJHttpService in connectionPool) {
				if (!connection.isUse) {
					return connection;
				}
			}
			createConnectionPool();
			return getHttpService();
		}


		/**
		 * 发送请求
		 **/
		public static function request(url:String, reqParam:Object, responseHandler:Function, method:String = URLRequestMethod.GET,faultHandler:Function=null):void {
			var httpConnection:HJHttpService=getHttpService();
			httpConnection.url=Constants.prefixUrl + url;
			httpConnection.method=method;
			if (reqParam == null) {
				reqParam={};
			}
			reqParam["tk"]=Constants.token;
			httpConnection.send(reqParam);
			httpConnection.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void {
				if (responseHandler != null) {
					responseHandler(JSON.parse(event.result as String));
				}
			});
			httpConnection.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void {
				trace(event);
				if (faultHandler != null)
					faultHandler();
			});
		}
	}
}