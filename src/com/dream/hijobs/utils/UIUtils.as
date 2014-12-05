package com.dream.hijobs.utils {
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.TextInput;

	/**
	 * 对ui进行处理的一些工具集<br>
	 * @author yinshuwei
	 *
	 */
	public class UIUtils {
		public static function getGlobalLocation(component:IVisualElement):Point {
			if (component.parent && component.parent is DisplayObjectContainer) {
				return (component.parent as DisplayObjectContainer).localToGlobal(new Point(component.x, component.y));
			}
			return new Point(0, 0);
		}

		/**
		 * 判断component是否为parent的子孙组件
		 * @param component 子组件
		 * @param parent 父组件
		 * @return 是否为子孙组件
		 *
		 */
		public static function isIn(component:Object, parent:Object):Boolean {
			if (component == null || parent == null) {
				return false;
			}
			if (component == parent) {
				return true;
			} else {
				if (component.parent == null) {
					return false;
				} else {
					return isIn(component.parent, parent);
				}
			}
		}

		/**
		 * 从子孙结点中找到第一个指定类型的组件
		 * @param ui 父组件
		 * @param type 类型
		 * @return 第一个符合要求的组件
		 *
		 */
		public static function findFirstElementByType(ui:Object, type:Class):UIComponent {
			if (ui == null) {
				return null;
			}
			if (ui is type) {
				return ui as UIComponent;
			}
			if (ui is IVisualElementContainer) {
				var ivc:IVisualElementContainer=(ui as IVisualElementContainer);
				for (var i:int=0; i < ivc.numElements; i++) {
					var result:UIComponent=findFirstElementByType(ivc.getElementAt(i), type);
					if (result != null) {
						return result;
					}
				}
			}
			return null;
		}

		/**
		 * 从子孙结点中找到第一个指定类型集的组件
		 * @param ui 父组件
		 * @param types 类型集
		 * @return 第一个符合要求的组件
		 *
		 */
		public static function findFirstElementByTypes(ui:Object, types:Array):UIComponent {
			if (ui == null) {
				return null;
			}
			for each (var type:Class in types) {
				if (ui is type) {
					return ui as UIComponent;
				}
			}
			if (ui is IVisualElementContainer) {
				var ivc:IVisualElementContainer=(ui as IVisualElementContainer);
				for (var i:int=0; i < ivc.numElements; i++) {
					var result:UIComponent=findFirstElementByTypes(ivc.getElementAt(i), types);
					if (result != null) {
						return result;
					}
				}
			}
			return null;
		}

		/**
		 * 设置组件及其子孙组件的样式
		 * @param ui 父组件
		 * @param name 样式名
		 * @param value 样式值
		 *
		 */
		private static function changeStyle(ui:Object, name:String, value:Object):void {
			if (ui == null) {
				return;
			}
			if (ui is UIComponent) {
				(ui as UIComponent).setStyle(name, value);
			}

			if (ui is IVisualElementContainer) {
				var ivc:IVisualElementContainer=(ui as IVisualElementContainer);
				for (var i:int=0; i < ivc.numElements; i++) {
					changeStyle(ivc.getElementAt(i), name, value);
				}
			}
		}

		/**
		 * 从父级容器中查询出所有子元素
		 * @param parent 要查询的对象
		 * @return 所有子元素
		 *
		 */
		public static function getAllElements(parent:IVisualElementContainer):Array {
			var result:Array=[];
			for (var i:int=0; i < parent.numElements; i++) {
				result.push(parent.getElementAt(i));
			}
			return result;
		}

		/**
		 * 设置textInput中的光标在结尾位置
		 * @param ui 要设置光标的textInput
		 * */
		public static function setTextFocusEnd(ui:TextInput):TextInput {
			ui.selectRange(ui.text.length, ui.text.length);
			return null;
		}


		/**
		 * 返回ui所在windows所在的屏幕
		 * @param ui 要计算的ui
		 * @return 所在屏幕
		 *
		 */
		public static function getCurrentScreenByUI(ui:UIComponent):Screen {
			if ((ui.systemManager != null) && (ui.systemManager.stage != null)) {
				var nativeWindow:NativeWindow=ui.systemManager.stage.nativeWindow;
				var rectangle:Rectangle=new Rectangle();
				rectangle.x=nativeWindow.x + 20;
				rectangle.y=nativeWindow.y + 20;
				rectangle.width=10;
				rectangle.height=10;
				var currentScreens:Array=Screen.getScreensForRectangle(rectangle);
				var currentScreen:Screen=null;
				if (currentScreens.length > 0) {
					currentScreen=currentScreens[0];
				} else {
					currentScreen=Screen.mainScreen;
				}
				return currentScreen;
			}
			return null;
		}
		
		public static function idbGlobalToContent(event:Event,_localX:Number,_localY:Number):Point
		{
			var pt:Point = new Point(_localX,_localY);  
			pt = event.target.localToGlobal(pt);  
			pt = (event.currentTarget as UIComponent).globalToContent(pt);    
			return pt;
		}
	}
}