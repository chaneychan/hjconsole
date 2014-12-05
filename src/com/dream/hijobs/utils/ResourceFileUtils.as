package com.dream.hijobs.utils {

	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	/**
	 * 应用资源文件的工具集〈br>
	 * 操作的文件在用户目录下，由操作系统决定
	 * @author yinshuwei
	 *
	 */
	public class ResourceFileUtils {
		private static const FOLDER_PATH:String="config";
		private static const VERSION_FILE:String="version.txt";
		private static const PROPERTIES_FILE:String="properties_{0}.txt";
		private static const LIST_FILE:String="list_{0}.txt";
		private static var versionFile:File;
		private static var resourceLevelMap:Object=0;
		
	

		/**
		 * 检查版本号是否一致，比较对象是最新app文件下的版本号与之前保存到version.txt下的版本号<br>
		 * 如果一致不做操作，否则拷贝资源文件并更新版本文件<br>
		 * 版本文件不存在时当不一致处理
		 */
		public static function checkFile():void {
			var appXML:XML=NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace=appXML.namespace();
			var versionCurr:String=appXML.ns::versionNumber;
			
			var versionOld:String;
			
			versionFile=File.applicationStorageDirectory.resolvePath(VERSION_FILE);
			if (versionFile.exists) {
				var stream:FileStream=new FileStream();
				stream.open(versionFile, FileMode.READ);
				versionOld=stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				if (versionCurr != versionOld) {
					moveFiles(versionCurr);
				}
			} else {
				moveFiles(versionCurr);
			}
		}
		
		
		/**
		 * 首先删除version.txt，并且将最新的版本号写入version.txt。<br>
		 * 再次将安装目录下的文件全部copy到存储目录。
		 */	
		private static function moveFiles(versionCurr:String):void {
			if (File.applicationStorageDirectory.resolvePath(FOLDER_PATH).exists) {
				File.applicationStorageDirectory.resolvePath(FOLDER_PATH).deleteDirectory(true);
			}
			if (versionFile.exists) {
				versionFile.deleteFile();
			}
			var stream:FileStream=new FileStream();
			stream.open(versionFile, FileMode.WRITE);
			stream.writeUTFBytes(versionCurr);
			stream.close();
			localDirToUserDir();
		}

		/**
		 *安装目录下的资源文件目录拷贝到用户目录下
		 */
		private static function localDirToUserDir():void {
			copySubFiles(File.applicationDirectory.resolvePath(FOLDER_PATH), File.applicationStorageDirectory.resolvePath(FOLDER_PATH));
		}

		/**
		 * 拷贝目录下的所有子文件到另一个目录下
		 * @param src 拷贝的源目录
		 * @param dest 拷贝的目标目录
		 */
		private static function copySubFiles(src:File, dest:File):void {
			if (!src.exists) {
				return;
			}
			var subs:Array=src.getDirectoryListing();
			if (!dest.exists) {
				dest.createDirectory();
			}
			for each (var file:File in subs) {
				var destSub:File=dest.resolvePath(file.name);
				if (file.isDirectory) {
					copySubFiles(file, destSub);
				} else {
					var input:FileStream=new FileStream();
					var output:FileStream=new FileStream();
					input.open(file, FileMode.READ);
					output.open(destSub, FileMode.WRITE);
					output.writeUTFBytes(input.readUTFBytes(input.bytesAvailable));
					input.close();
					output.close();
				}
			}
		}

		/**
		 * 读取用户资源目录下的文件<br>
		 * 如果文件不存在就读取安装目录
		 * @param filePath 读取的文件名，不需要资源文件的目录<br>
		 * 如 “assets/xml/config.xml”应写为"config.xml"<br>
		 * 		“assets/xml/data/data1.xml”应写为"data/data.xml"
		 * @return 文件内容的字符
		 */
		public static function readFile(filePath:String):String {
			var input:FileStream;
			var content:String="";
			var file:File=File.applicationStorageDirectory.resolvePath(FOLDER_PATH).resolvePath(filePath);
			if (!file.exists) {
				var srcFile:File=File.applicationDirectory.resolvePath(FOLDER_PATH).resolvePath(filePath);
				if (srcFile.exists) {
					if (!file.parent.exists) {
						file.parent.createDirectory();
					}
					input=new FileStream();
					var output:FileStream=new FileStream();
					input.open(srcFile, FileMode.READ);
					output.open(file, FileMode.WRITE);
					output.writeUTFBytes(input.readUTFBytes(input.bytesAvailable));
					input.close();
					output.close();
				}
			}
			if (file.exists) {
				input=new FileStream();
				input.open(file, FileMode.READ);
				content=input.readUTFBytes(input.bytesAvailable);
				input.close();
			}
			return content;
		}

		/**
		 * 写入内容到用户资源目录下的文件中
		 * @param filePath 读取的文件名，不需要资源文件的目录<br>
		 * 如 “assets/xml/config.xml”应写为"config.xml"<br>
		 * 		“assets/xml/data/data1.xml”应写为"data/data.xml"
		 * @param content 要写入的字符串内容
		 */
		public static function writeFile(filePath:String, content:String):void {
			var file:File=File.applicationStorageDirectory.resolvePath(FOLDER_PATH).resolvePath(filePath);
			if (!file.parent.exists) {
				file.parent.createDirectory();
			}
			var output:FileStream=new FileStream();
			output.open(file, FileMode.WRITE);
			output.writeUTFBytes(content);
			output.close();
		}

		/**
		 * 读取资源文件，转为一个key-value映射
		 * @param filePath 资源文件路径
		 * @return key-value映射
		 *
		 */
		public static function readProperties(resourceName:String):Object {
			var o:Object={};
//			var fp:String=StringUtil.substitute(PROPERTIES_FILE, resourceName);
			var content:String=readFile(StringUtil.substitute(PROPERTIES_FILE, resourceName));
			var lines:Array=content.split("\n");
			for each (var line:String in lines) {
				var index:int;
				if ((index=line.indexOf("=")) != -1) {
					var key:String=StringUtil.trim(line.substr(0, index));
					var value:String=StringUtil.trim(line.substr(index + 1));
					if (key != "") {
						o[key]=value;
					}
				}
			}
			return o;
		}

		/**
		 *
		 * @param resourceName
		 * @param propertieName
		 * @param propertieValue
		 * @return
		 *
		 */
		public static function appendProperty(resourceName:String, propertyName:String, propertyValue:String):void {
			var o:Object=readProperties(resourceName);
			o[propertyName]=propertyValue;
			writeProperties(resourceName, o);
		}

		/**
		 *
		 * @param resourceName
		 * @param obj
		 *
		 */
		public static function writeProperties(resourceName:String, obj:Object):void {
			var objInfo:Object=ObjectUtil.getClassInfo(obj);
			var fieldName:Array=objInfo["properties"] as Array;
			var fileContent:String="";
			for each (var q:QName in fieldName) {
				fileContent+=(q.localName + " = " + obj[q.localName] + "\n");
			}
			writeFile(StringUtil.substitute(PROPERTIES_FILE, resourceName), fileContent);
		}

		/**
		 * 跟据集合名来读取集合内容
		 * @param listName 集合名
		 * @return 集合结果
		 *
		 */
		public static function readList(listName:String):Array {
			var resultTemp:Array=readFile(StringUtil.substitute(LIST_FILE, listName)).split(",");
			var result:Array=[];
			for each (var item:String in resultTemp) {
				item=StringUtil.trim(item);
				if (item != "") {
					result.push(item);
				}
			}
			return result;
		}

		/**
		 * 将集合内容写入对应的集合中
		 * @param listName 集合名
		 * @param items 要写入的集合内容
		 *
		 */
		public static function writeList(listName:String, items:Array):void {
			writeFile(StringUtil.substitute(LIST_FILE, listName), items.join(","));
		}

		/**
		 * 向集合尾部添加单项内容
		 * @param listName 集合名
		 * @param item 要添加的项
		 *
		 */
		public static function appendItemToList(listName:String, item:String):void {
			var content:String=readFile(StringUtil.substitute(LIST_FILE, listName));
			if (StringUtil.trim(content) != "") {
				writeFile(StringUtil.substitute(LIST_FILE, listName), content + "," + item);
			} else {
				writeFile(StringUtil.substitute(LIST_FILE, listName), item);
			}
		}

		/**
		 * 向集合尾部添加多项内容
		 * @param listName 集合名
		 * @param item 要添加的项
		 *
		 */
		public static function appendItemsToList(listName:String, items:Array):void {
			var content:String=readFile(StringUtil.substitute(LIST_FILE, listName));
			if (StringUtil.trim(content) != "") {
				writeFile(StringUtil.substitute(LIST_FILE, listName), content + "," + items.join(","));
			} else {
				writeFile(StringUtil.substitute(LIST_FILE, listName), items.join(","));
			}
		}
	}
}