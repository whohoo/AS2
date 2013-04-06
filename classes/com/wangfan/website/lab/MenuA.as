//******************************************************************************
//	name:	MenuA 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		
//******************************************************************************


import mx.transitions.Tween;
import mx.utils.Delegate;
import com.wangfan.website.lab.SuperMenu;

/**
 * 动态菜单的最高层菜单项.<p></p>
 * 设置数据，及画线出现。
 */
class com.wangfan.website.lab.MenuA extends SuperMenu{
	//多一条比较短的线
	private var line1:MovieClip		=	null;
	/**长短线条的比例*/
	private var lengthRate:Number		=	.08;
	//************************[READ|WRITE]************************************//
	
	/**文字的颜色 */
	function get textColor():Number{
		var tColor:Number	=	null;
		if(item_mc.name_mc.name_txt.text=="DOWNLOAD"){
			tColor	=	_textColorArr[0];
		}else{
			tColor	=	_textColorArr[1];
		}
		return tColor;
	}
	
	//************************[READ ONLY]*************************************//
	
	//private function MenuA(){
	//	super();
	//}
	
	//************************[PRIVATE METHOD]********************************//
		
	private function onMotionChanged(tw:Tween):Void{
		var x:Number	=	tw.position;
		line1.lineTo(x*lengthRate, 0);
		line0.lineTo(x, 0);
	}
	
	private function onItemRelease():Void{
		if(_parent.curMenu==this){
			_movingPos		=	subMenuArr.length;
			_parent.curMenu	=	null;
			onEnterFrame=collapseMenu;
		}else{
			if(_parent.curMenu!=null){//原来的菜单关闭
				_parent.curMenu.item_mc.onRelease();
			}
			_movingPos		=	0;
			_parent.curMenu	=	this;
			onEnterFrame=expandMenu;
			_parent.isAutoExpand	=	true;
			
			//把原来的内容给删除
			//_parent._parent.loadContent_mc._visible	=	false;
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
	//overwrite
	private function onExpandEnd():Void{
		if(_parent.isAutoExpand){
			this["mcSubMenu0"].item_mc.onRelease();
		}
	}
	//overwrite
	private function onCollapseEnd():Void{
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义菜单条的顺序号及名称
	* @param name
	*/
	public function setData(name:String):Void{
		item_mc.no_mc.no_txt.text		=	("0"+(index+1)).substr(-2);
		item_mc.name_mc.name_txt.text	=	name;
		//item_mc.no_mc.no_txt.textColor	=
		//item_mc.name_mc.name_txt.textColor	=	textColor;
	}
	
	/**
	* 画线条，一条短线条及一条长线条。
	* 要所有的线同时画到终点，需要用setTimeout来延迟画线的开始时间.
	* 限定在1秒内画完，按多少条线来平分，最短为.5
	* @param second 在指定的时间内画完。
	*/
	public function show(second:Number):Void{
		line0.clear();
		line1.clear();
		line0.lineStyle(.1, lineColor, lineAlpha);
		line1.lineStyle(.1, lineColor, lineAlpha);
		line0.moveTo(0, 0);
		line1.moveTo(0, 0);
		
		var time:Number	=	second*.3;
		_tw.duration		=	.3+time;
		_interStart=_global.setTimeout(_tw, "start", (1-_tw.duration)*1000, _tw.duration);
		_interShowItem=_global.setTimeout(this, "showItem", (time+.3)*1000);
		_visible	=	true;
	}
	
	/**
	* 把画的线条隐藏起来，然后对象不可见。
	* NOTE:在顶层菜单中，此方法不会被调用。
	*/
	public function hide():Void{
		_visible	=	false;
		clearInterval(_interShowItem);
		clearInterval(_interStart);
		item_mc.onEnterFrame	=	null;
		line0.clear();
		line1.clear();
		item_mc.gotoAndStop(1);
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
