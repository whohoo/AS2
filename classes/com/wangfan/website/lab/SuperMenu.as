//******************************************************************************
//	name:	SuperMenu 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		
//******************************************************************************


import mx.transitions.Tween;
import mx.utils.Delegate;

/**
 * 三级菜单的父类。<p></p>
 * MenuA，MenuB，MenuC三类的父类，继承着共有方法与属性。
 */
class com.wangfan.website.lab.SuperMenu extends MovieClip{
	private var _tw:Tween				=	null;
	private var _lineEndPosX:Number	=	0;
	
	private var line0:MovieClip		=	null;
	private var item_mc:MovieClip		=	null;
	
	private var _tempHeight:Number		=	0;
	private var _movingPos:Number		=	null;//展开或收起，走到哪一个子菜单的位置
	private var _initHeight:Number		=	null;//初始的高度，不包括创建的子菜单的高度
	
	private var _interStart:Number		=	null;
	private var _interShowItem:Number	=	null;
	
	/**显示的文本颜色*/
	private var _textColorArr:Array		=	[0x77675E, 0x807d76];// download | lab works 
	
	/**当前菜单的高度*/
	public  var curHeight:Number		=	null;
	/**最大的高度，由子菜单的多少决定*/
	public var maxHeight:Number		=	100;
	/**最小的高度，收起来时的高度*/
	public var minHeight:Number		=	20;
	/**长线条的长度*/
	public  var lineLength:Number		=	234;
	/**线条的颜色*/
	public  var lineColor:Number		=	0x77675E;//棕色
	/**线条的透明值*/
	public  var lineAlpha:Number		=	100;
	
	
	/**菜单的序号*/
	public  var index:Number			=	null;
	/**此菜单下子菜单的数组引用*/
	public  var subMenuArr:Array		=	null;
	/**此菜单下的当前子菜单对象*/
	public  var curMenu:MovieClip		=	null;
	
	//************************[READ|WRITE]************************************//
	
	
	/**文字的颜色 */
	function get textColor():Number{
		return 0;
	}
	
	
	//************************[READ ONLY]*************************************//
	
	private function SuperMenu(){
		super();
		subMenuArr	=	[];
		_initHeight	=	_height;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		_tw	=	new Tween(this, "_lineEndPosX",
						mx.transitions.easing.Strong.easeOut,
						0, lineLength, 1, true);
		_tw.stop();
		_tw.addListener(this);
		
		item_mc.onRelease=Delegate.create(this, onItemRelease);
	}
	
	private function onMotionChanged(tw:Tween):Void{
		if(!_visible)	tw.stop();//如果已经隐藏起来了，就不要再画线啦。
		var x:Number	=	tw.position;
		line0.lineTo(x, 0);
	}
	
	private function onItemRelease():Void{
		if(_parent.curMenu==this){
			_movingPos		=	subMenuArr.length;
			_parent.curMenu	=	null;
			onEnterFrame=collapseMenu;
		}else if(_parent.curMenu==null){
			_movingPos		=	0;
			_parent.curMenu	=	this;
			onEnterFrame=expandMenu;
		}else{
			_parent.curMenu.item_mc.onRelease();
			_movingPos		=	0;
			_parent.curMenu	=	this;
			onEnterFrame=expandMenu;
		}
		//如果子菜单为展开的，关闭
		if(curMenu!=null){
			if(curMenu.item_mc.onRelease==null){
				curMenu.onRelease();
			}else{
				curMenu.item_mc.onRelease();
			}
			//return;
		}
	}
	
	private function expandMenu():Void{
		_tempHeight	=	(((curHeight-maxHeight)*.7)+_tempHeight)*.5;
		curHeight	-=	_tempHeight;
		_parent.renderMenu();
		onExpanding();
		if(Math.abs(_tempHeight)<.1){
			_tempHeight	=	0;
			onExpandEnd();
			onEnterFrame	=	null;
		}
	}
	
	private function collapseMenu():Void{
		//_tempHeight	=	(((curHeight-minHeight)*.7)+_tempHeight)*.5;
		//不再使弹性，缓冲收起来
		_tempHeight	=	(curHeight-minHeight)*.7;
		curHeight	-=	_tempHeight;
		_parent.renderMenu();
		onCollapsing();
		if(Math.abs(_tempHeight)<.1){
			onCollapseEnd();
			onEnterFrame	=	null;
		}
	}
	//此方法在不同的子类可能被overwrite，以下方法为default方法
	private function onExpanding():Void{
		//当高度走到可显示子菜单的位置时，慢慢显示子菜单
		var len:Number	=	subMenuArr.length;
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	subMenuArr[i];
			if(mc._visible)	continue;
			if(mc._y<=curHeight+_initHeight){
				mc.show(len-i);
			}
		}
	}
	//此方法在不同的子类可能被overwrite，以下方法为default方法
	private function onCollapsing():Void{
		//当高度走到可显示子菜单的位置时，慢慢隐藏子菜单
		var len:Number	=	subMenuArr.length;
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	subMenuArr[i];
			if(!mc._visible)	continue;
			if(mc._y>=curHeight+_initHeight){
				mc.hide(len-i);
			}
		}
	}
	private function onExpandEnd():Void{
		
	}
	
	private function onCollapseEnd():Void{
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义菜单条的顺序号及名称
	* @param name
	*/
	public function setData(name:String):Void{
		//empty
	}
	
	/**
	* 当菜单展开或收合时，更新所有菜单的位置。
	*/
	public function renderMenu():Void{
		_parent.renderMenu();
	}
	
	/**
	* 把菜单显示出来。
	*/
	public function showItem():Void{
		//if(!_visible)	return;
		item_mc.moveIn();
	}
	
	/**
	* 画线条，一条短线条及一条长线条。
	* 要所有的线同时画到终点，需要用setTimeout来延迟画线的开始时间.
	* 限定在1秒内画完，按多少条线来平分，最短为.5
	* @param second 在指定的时间内画完。
	*/
	public function show(second:Number):Void{
		line0.clear();
		line0.lineStyle(.1, textColor, lineAlpha);
		line0.moveTo(0, 0);
		var time:Number	=	second*.3;
		//延迟出现，并保证所画的线条同时到达终点。
		_tw.duration		=	.3+time;
		_interStart=_global.setTimeout(_tw, "start", (1-_tw.duration)*1000, _tw.duration);
		_interShowItem=_global.setTimeout(this, "showItem", (time+.3)*1000);
		_visible	=	true;
	}
	
	/**
	* 把画的线条隐藏起来，然后对象不可见。
	*/
	public function hide():Void{//trace([item_mc,item_mc._currentframe, _visible])
		_visible	=	false;//隐藏不可见后，不要显示再执行显示时定义的延迟方法。
		clearInterval(_interShowItem);
		clearInterval(_interStart);
		line0.clear();
		item_mc.onEnterFrame	=	null;
		item_mc.gotoAndStop(1);
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
