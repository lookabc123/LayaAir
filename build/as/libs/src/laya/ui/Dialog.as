package laya.ui {
	import laya.ui.View;
	import laya.ui.DialogManager;
	import laya.ui.UIComponent;
	import laya.events.Event;
	import laya.utils.Handler;

	/*
	 * <code>Dialog</code> 组件是一个弹出对话框，实现对话框弹出，拖动，模式窗口功能。
	 * 可以通过UIConfig设置弹出框背景透明度，模式窗口点击边缘是否关闭等
	 * 通过设置zOrder属性，可以更改弹出的层次
	 * 通过设置popupEffect和closeEffect可以设置弹出效果和关闭效果，如果不想有任何弹出关闭效果，可以设置前述属性为空
	 * @example <caption>以下示例代码，创建了一个 <code>Dialog</code> 实例。</caption>
	 * @example Laya.init(640, 800);//设置游戏画布宽高、渲染模式
	 * @example import Dialog = laya.ui.Dialog;
	 */
	public class Dialog extends laya.ui.View {

		/*
		 * 对话框内的某个按钮命名为close，点击此按钮则会关闭
		 */
		public static var CLOSE:String;

		/*
		 * 对话框内的某个按钮命名为cancel，点击此按钮则会关闭
		 */
		public static var CANCEL:String;

		/*
		 * 对话框内的某个按钮命名为sure，点击此按钮则会关闭
		 */
		public static var SURE:String;

		/*
		 * 对话框内的某个按钮命名为no，点击此按钮则会关闭
		 */
		public static var NO:String;

		/*
		 * 对话框内的某个按钮命名为yes，点击此按钮则会关闭
		 */
		public static var YES:String;

		/*
		 * 对话框内的某个按钮命名为ok，点击此按钮则会关闭
		 */
		public static var OK:String;

		/*
		 * @private 表示对话框管理器。
		 */
		private static var _manager:*;

		/*
		 * 对话框管理容器，所有的对话框都在该容器内，并且受管理器管理，可以自定义自己的管理器，来更改窗口管理的流程。
		 * 任意对话框打开和关闭，都会触发管理类的open和close事件
		 */
		public static var manager:DialogManager;

		/*
		 * 对话框被关闭时会触发的回调函数处理器。
		 * <p>回调函数参数为用户点击的按钮名字name:String。</p>
		 */
		public var closeHandler:Handler;

		/*
		 * 弹出对话框效果，可以设置一个效果代替默认的弹出效果，如果不想有任何效果，可以赋值为null
		 * 全局默认弹出效果可以通过manager.popupEffect修改
		 */
		public var popupEffect:Handler;

		/*
		 * 关闭对话框效果，可以设置一个效果代替默认的关闭效果，如果不想有任何效果，可以赋值为null
		 * 全局默认关闭效果可以通过manager.closeEffect修改
		 */
		public var closeEffect:Handler;

		/*
		 * 组名称
		 */
		public var group:String;

		/*
		 * 是否是模式窗口
		 */
		public var isModal:Boolean;

		/*
		 * 是否显示弹出效果
		 */
		public var isShowEffect:Boolean;

		/*
		 * 指定对话框是否居中弹。<p>如果值为true，则居中弹出，否则，则根据对象坐标显示，默认为true。</p>
		 */
		public var isPopupCenter:Boolean;

		/*
		 * 关闭类型，点击name为"close"，"cancel"，"sure"，"no"，"yes"，"no"的按钮时，会自动记录点击按钮的名称
		 */
		public var closeType:String;

		/*
		 * @private 
		 */
		private var _dragArea:*;

		public function Dialog(){}

		/*
		 * @private 提取拖拽区域
		 */
		protected function _dealDragArea():void{}

		/*
		 * 用来指定对话框的拖拽区域。默认值为"0,0,0,0"。
		 * <p><b>格式：</b>构成一个矩形所需的 x,y,width,heith 值，用逗号连接为字符串。
		 * 例如："0,0,100,200"。</p>
		 * @see #includeExamplesSummary 请参考示例
		 */
		public var dragArea:String;

		/*
		 * @private 
		 */
		private var _onMouseDown:*;

		/*
		 * @private 处理默认点击事件
		 */
		protected function _onClick(e:Event):void{}

		/*
		 * @inheritDoc 
		 * @override 
		 */
		override public function open(closeOther:Boolean = null,param:* = null):void{}

		/*
		 * 关闭对话框。
		 * @param type 关闭的原因，会传递给onClosed函数
		 * @override 
		 */
		override public function close(type:String = null):void{}

		/*
		 * @inheritDoc 
		 * @override 
		 */
		override public function destroy(destroyChild:Boolean = null):void{}

		/*
		 * 显示对话框（以非模式窗口方式显示）。
		 * @param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
		 * @param showEffect 是否显示弹出效果
		 */
		public function show(closeOther:Boolean = null,showEffect:Boolean = null):void{}

		/*
		 * 显示对话框（以模式窗口方式显示）。
		 * @param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
		 * @param showEffect 是否显示弹出效果
		 */
		public function popup(closeOther:Boolean = null,showEffect:Boolean = null):void{}

		/*
		 * @private 
		 */
		protected function _open(modal:Boolean,closeOther:Boolean,showEffect:Boolean):void{}

		/*
		 * 弹出框的显示状态；如果弹框处于显示中，则为true，否则为false;
		 */
		public function get isPopup():Boolean{
				return null;
		}

		/*
		 * 设置锁定界面，在界面未准备好前显示锁定界面，准备完毕后则移除锁定层，如果为空则什么都不显示
		 * @param view 锁定界面内容
		 */
		public static function setLockView(view:UIComponent):void{}

		/*
		 * 锁定所有层，显示加载条信息，防止下面内容被点击
		 */
		public static function lock(value:Boolean):void{}

		/*
		 * 关闭所有对话框。
		 */
		public static function closeAll():void{}

		/*
		 * 根据组获取对话框集合
		 * @param group 组名称
		 * @return 对话框数组
		 */
		public static function getDialogsByGroup(group:String):Array{
			return null;
		}

		/*
		 * 根据组关闭所有弹出框
		 * @param group 需要关闭的组名称
		 */
		public static function closeByGroup(group:String):Array{
			return null;
		}
	}

}