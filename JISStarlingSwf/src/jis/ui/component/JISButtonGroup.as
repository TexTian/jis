package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	/**
	 * JISButton集合管理，该集合管理的按钮同一时间只能选择一个<br>
	 * 用法：初始化传入JISButton集合或者是通过setBtnList设置集合<br>
	 * 当设置集合或者是选中按钮的时候会抛出CLICK_BTN事件和调用selectHandler函数
	 * @author jiessie 2013-11-20
	 */
	public class JISButtonGroup extends JISUIManager
	{
		/** 点击了管理列表中的按钮 */
		public static const CLICK_BTN:String = "CLICK_BTN";
		
		private var btnList:Array = [];
		//当前选择按钮
		private var currSelectBtn:JISButton;
		/** 选中回调函数 */
		private var selectHandler:Function;
		
		public function JISButtonGroup(list:Array = null)
		{
			if(list)
			{
				setBtnList(list);
			}
		}
		
		protected override function init():void
		{
			var container:DisplayObjectContainer = this.display as DisplayObjectContainer;
			var btnList:Array = [];
			//所有movieClip中的成员都做为按钮进行管理
			for(var i:int = 0;i<container.numChildren;i++)
			{
				var display:DisplayObject = container.getChildAt(i);
				if(display is SwfMovieClip)
				{
					btnList.push(new JISButton(display as SwfMovieClip));
				}
			}
			setBtnList(btnList);
		}
		
		/** 设置按钮列表，按钮必须是LButton或者他的子类 */
		public function setBtnList(list:*):void
		{
			if(this.btnList)
			{
				for each(var oldBtn:JISButton in this.btnList)
				{
					oldBtn.removeEventListener(JISButton.BOTTON_CLICK,onBtnClickHandler);
				}
			}
			
			this.btnList = [];
			
			for each(var btn:JISButton in list)
			{
				btn.addEventListener(JISButton.BOTTON_CLICK,onBtnClickHandler);
				this.btnList.push(btn);
			}
			setSelectBtn(btnList[0])
		}
		
		/** 在原来的基础上追加按钮列表 */
		public function incBtnList(list:Array):void
		{
			for each(var btn:JISButton in list)
			{
				btn.addEventListener(JISButton.BOTTON_CLICK,onBtnClickHandler);
				this.btnList.push(btn);
			}
		}
		
		private function onBtnClickHandler(e:Event):void
		{
			setSelectBtn(e.currentTarget as JISButton);
		}
		
		/** 获取当前选中按钮 */
		public function getCurrentSelectBtn():JISButton
		{
			return this.currSelectBtn;
		}
		
		/** 设置选中按钮回调函数，在选中按钮的时候将会调用该函数，并传入选中的按钮 */
		public function setSelectBtnHandler(handler:Function):void
		{
			selectHandler = handler;
		}
		
//		/** 会与列表中的显示对象的name进行比较 */
//		public function setSelectBtnForName(name:String):void
//		{
//			for each(var btn:JISButton in this.btnList)
//			{
//				if(btn.getMovieChlip().name == name)
//				{
//					setSelectBtn(btn);
//					return;
//				}
//			}
//		}
		
		/** 设置选中按钮 */
		public function setSelectBtn(btn:JISButton):void
		{
			if(currSelectBtn == btn) return;
			if(currSelectBtn)
			{
				currSelectBtn.setSelected(false);
			}
			currSelectBtn = btn;
			//将当前按钮设为不可点击
			currSelectBtn.setSelected(true);
			this.dispatchEvent(new Event(CLICK_BTN));
			if(selectHandler != null)
			{
				selectHandler.call(null,currSelectBtn);
			}
		}
		
		public override function dispose():void
		{
			for each(var oldBtn:JISButton in this.btnList)
			{
				oldBtn.removeEventListener(JISButton.BOTTON_CLICK,onBtnClickHandler);
			}
			btnList = null;
			currSelectBtn = null;
			selectHandler = null;
			super.dispose();
		}
	}
}