package com.dream.hijobs.utils {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.formatters.DateFormatter;

	public class IDBLog {
		private var fielPath:String="log.txt";
		private var folderPath:String="log";
		private var file:File;
		private var input:FileStream=new FileStream();
		private var logContent:String="";
		private var dateFormatter:DateFormatter=new DateFormatter();
		private var fileDateFormatter:DateFormatter=new DateFormatter();
		private var stream:FileStream=new FileStream();
		private static var instance:IDBLog=new IDBLog;

		public function IDBLog() {
			dateFormatter.formatString="YYYY-MM-DD JJ:NN:SS QQQ";
			fileDateFormatter.formatString="YYYY-MM-DD";

		}

		public static function getInstance():IDBLog {
			return instance;
		}

		/**
		 * 创建文件
		 * */
		public function initFile():void {
			if (file == null) {
				file=File.applicationStorageDirectory.resolvePath(folderPath).resolvePath(fileDateFormatter.format(new Date) + fielPath);
				if (!file.parent.exists) {
					file.parent.createDirectory();
				}
			}
		}

		private function printLog(log:String):String {
			initFile();
			stream.open(file, FileMode.APPEND);
			log=dateFormatter.format(new Date) + " " + log + "\r\n";
			
			stream.writeUTFBytes(log);
			stream.close();
			trace(log);
			return log;
		}

		public static function log(log:String):String {
			return instance.printLog(log);
		}
	}
}