package com.dream.hijobs.utils {
	import mx.core.IFactory;

	public class IDBCachePoolTool {
		private var _factory:IFactory;
		private var usedObjects:Array=[];
		private var unusedObjects:Array=[];

		public function IDBCachePoolTool(factory:IFactory) {
			_factory=factory;
		}

		public function getObject():* {
			var result:*;
			if (unusedObjects.length > 0) {
				result=unusedObjects.pop();
			} else {
				result=_factory.newInstance();
			}
			usedObjects.push(result);
			return result;
		}

		public function releaseObject(object:*):void {
			var index:int=usedObjects.indexOf(object);
			if (index != -1) {
				unusedObjects.push(usedObjects[index]);
				usedObjects.splice(index, 1)
			}
		}

		public function getUsedObjects():Array {
			return usedObjects;
		}

	}
}