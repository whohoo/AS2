//******************************************************************************
//	name:	MenuC 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 11:07:07 2006
//	description: 
//		
//******************************************************************************


import mx.transitions.Tween;
import mx.utils.Delegate;
import com.wangfan.website.lab.SuperMenu;
import com.wangfan.website.lab.LoadXmlMenu;
/**
 * 动态菜单的第二层菜单项.<p></p>
 * 设置数据，及画线出现。
 */
class com.wangfan.website.lab.MenuC extends SuperMenu{
	private var swfUrl:String			=	null;
	private var issueDate:String		=	null;
	/**此菜单下子菜单的对象引用*/
	public  var subContent:MovieClip	=	null;
	
	//************************[READ|WRITE]************************************//
	/**文字的颜色 */
	function get textColor():Number{
		var tColor:Number	=	null;
		if(_parent._parent.item_mc.name_mc.name_txt.text=="DOWNLOAD"){
			tColor	=	_textColorArr[0];
		}else{
			tColor	=	_textColorArr[1];
		}
		return tColor;
	}
	
	//************************[READ ONLY]*************************************//
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(MenuC.prototype);
	
	private function MenuC(){
		super();
		lineAlpha	=	50;
		//删除原来点击item_mc的事件
		//delete item_mc.onRelease;
		//重新定义整个点击事件，包括附在上边影片的整个响应事件
		//onReleaseOutside=onRollOut;
	}
	//************************[PRIVATE METHOD]********************************//
	//重新定义整个点击事件，包括附在上边影片的整个响应事件
	private function onItemRelease():Void{
		if(_parent.curMenu==this){
			onEnterFrame=collapseMenu;
			_parent.curMenu	=	null;
			return;
		}else if(_parent.curMenu==null){
			_parent.curMenu	=	this;
			onEnterFrame=expandMenu;
		}else{
			_parent.curMenu.onEnterFrame=_parent.curMenu.collapseMenu;
			_parent.curMenu	=	this;
			onEnterFrame=expandMenu;
		}
		dispatchEvent({type:"onClick", swfUrl:swfUrl, issueDate:issueDate});
	}
	//TODO 当从上边往下滑时，会乱跳。
	private function onItemRollOver():Void{
		if(_parent.curMenu==this){
			return;
		}else if(_parent.curMenu==null){
			onEnterFrame=expandMenu;
		}else{
			_parent.curMenu.onEnterFrame=_parent.curMenu.collapseMenu;
			onEnterFrame=expandMenu;
			//enabled	=	false;
		}
		
	}
	
	private function onItemRollOut():Void{
		if(_parent.curMenu==this){
			return;
		}else if(_parent.curMenu==null){
			onEnterFrame=collapseMenu;
		}else{
			_parent.curMenu.onEnterFrame=_parent.curMenu.expandMenu;
			onEnterFrame=collapseMenu;
			//enabled	=	false;
		}
	}
	
	//此方法在不同的子类可能被overwrite，以下方法为default方法
	private function onExpanding():Void{
		//mask的高度决定可视的范围
		subContent.mask_mc._height	=	curHeight;
	}
	//此方法在不同的子类可能被overwrite，以下方法为default方法
	private function onCollapsing():Void{
		//mask的高度决定可视的范围
		subContent.mask_mc._height	=	curHeight;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义菜单条的顺序号及名称
	* @param name
	*/
	public function setData(child:XMLNode):Void{
		
		swfUrl		=	LoadXmlMenu.WEB_SITE+child.attributes.swf_file;
		issueDate	=	child.attributes.issue_date;
		
		var txt:TextField	=	item_mc.name_mc.name_txt;
		txt.text	=	child.attributes.series;
		//var fmt:TextFormat	=	txt.getTextFormat();
		//fmt.color	=	textColor;
		//txt.setTextFormat(fmt);
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
