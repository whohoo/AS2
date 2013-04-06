//******************************************************************************
//	name:	FlagControl 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sun Apr 30 12:57:57 GMT+0800 2006
//	description: 此类是用于Remark类与场景中的flagList_mc进行通讯操作
//******************************************************************************

import com.idescn.utils.TextScroll;
import com.idescn.loader.zoomImage.events.FlagListScroll;

class com.idescn.loader.zoomImage.FlagControl extends Object{
	
	private var _target:MovieClip		=	null;
	private var _remark:Object			=	null;
	private var _zoomImage:Object		=	null;
	private var _itemsMC:MovieClip		=	null;
	private var _itemsBox:Array			=	null;//保存_itemsMC内所有attachMC的影片
	private var _points:Array			=	null;//保存point数据
	private var _curIndex:Number		=	0;//最上方显示item的index
	private var _visibleItemNum:Number	=	5;//默认可以看到5个items
	
	public  var flagItemID:String		=	"flag item";
	public  var itemHeight:Number		=	null;
	public  var scrollMaxNum:Number	=	null;//scroll最大的值
	public  var scrollBar:Object		=	null;
	//[DEBUG]//your can remove it before finish this CLASS!
	//public static var tt:Function		=	null;
	
	//private var _value:String		=	null;
	
	/******************[READ|WIDTH]******************/
	/*[Inspectable(defaultValue="", verbose=1, type=String)]
	function set value(value:String):Void{
		
	}
	function get value():String{
		return _value;
	}*/
	
	
	/**
	 * construction function
	 * @param target target a movie clip
	 * @param remark
	 * @param zoomImage
	 */
	public function FlagControl(target:MovieClip, remark:Object, 
															zoomImage:Object){
		this._target	=	target;
		this._remark	=	remark;
		this._zoomImage	=	zoomImage;
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_itemsMC	=	_target.flagItems_mc;
		_itemsBox	=	[];
		//引用
		_points		=	_remark["_pointsLocal"];
		//得到flag item的高度
		itemHeight	=	_itemsMC.attachMovie(flagItemID, "mcTemp", 0, 
												{_visible:false})._height+5;
		_itemsMC.mcTemp.removeMovieClip();
		_remark.addEventListener("onDropPoint", this);
		///////定义滚动条事件
		scrollBar	=	new TextScroll(_target.scroll_mc,null);
		var flScrollEvent:FlagListScroll	=	new FlagListScroll();
		flScrollEvent.flagControl	=	this;
		scrollBar.addEventListener('onScroll', flScrollEvent);
		//scrollBar.addEventListener('onPress', flScrollEvent);
		scrollBar.addEventListener('onRelease', flScrollEvent);
	}
	
	/**
	 * 定义item的操作事件
	 * 
	 * @usage   
	 * @param   mc 
	 * @return  
	 */
	private function setItemAction(mc:MovieClip):Void{
		var _this:Object	=	this;
		var btn:MovieClip	=	mc.edit_btn;
		
		btn.onRelease=function():Void{
			var mc0:MovieClip	=	this._parent;
			var btn2:MovieClip	=	mc0.del_btn;
			if(mc0.mark_txt.length<1){
				trace("mark_txt length=0");
				return;
			}
			if(this.vName=="ADD"){//把新增加的点加入列表,只出现在新添加新点时
				var point:Object	=	mc0.point;
				point.mark			=	mc0.mark_txt.text;
				_this._remark.addMark(point);
				_this._remark.writeLocal();
				
				//_global["eTrace"](point)
				_this.setInput(mc0, false);
				this.vName	=	"EDIT";
				btn2.vName	=	"DEL";
			}else if(this.vName=="YES"){//当是在编辑状态时,再按确实键就修改
				var point:Object	=	_this.endEditPoint(mc0, true);
				//_global["eTrace"](point);
				_this._remark.editMark(mc0.index, "x", point.x, "y", point.y, 
								"level", point.level, "mark", mc0.mark_txt.text);
				_this._remark.writeLocal();
				
				_this.setInput(mc0, false);
				this.vName	=	"EDIT";
				btn2.vName	=	"DEL";
			}else if(this.vName=="EDIT"){//开始编辑点
				
				_this.editPoint(mc0);
				_this.setInput(mc0, true);
				this.vName	=	"YES";
				btn2.vName	=	"NO";
			}
		}
		
		btn					=	mc.del_btn;
		btn.vName			=	"DEL";
		btn.onRelease=function():Void{
			var mc0:MovieClip	=	this._parent;
			var btn2:MovieClip	=	mc0.edit_btn;
			if(this.vName=="DEL"){
				_this._remark.delMark(mc0.index);
				_this._remark.writeLocal();
				_this.delFlagLists();
				_this._remark.showFlags(true);
			}else if(this.vName=="NO"){
				_this.setInput(mc0, false);
				this.vName	=	"DEL";
				btn2.vName	=	"EDIT";
				_this.endEditPoint(mc0, false);
			}
		}
	}
	
	/**
	 * 使对应的点可以拖动
	 * 
	 * @usage   
	 * @param   mc flag list item
	 * @return  
	 */
	private function editPoint(mc:MovieClip):Void{
		var mcPoint:MovieClip	=	_remark.flags[mc.index];
		mcPoint.gotoAndStop("move");
		//record the init position of mcPoint
		mcPoint.x		=	mcPoint._x;
		mcPoint.y		=	mcPoint._y;
		mcPoint.text	=	mc.mark_txt.text;
		
		var zoomImage:Object	=	this._zoomImage;
		zoomImage.setImageDND(false);
		mcPoint.onPress=function():Void{
			var width:Number	=	zoomImage.MIN_WIDTH/2;
			var height:Number	=	zoomImage.MIN_HEIGHT/2;
			this.startDrag(false, -width, -height, width, height);
		}
		mcPoint.onRelease=function():Void{
			this.stopDrag();
		}
		mcPoint.onReleaseOutside=mcPoint.onRelease;
	}
	
	/**
	 * 结束对应的点可以拖动,得到point的数值
	 * 
	 * @usage   
	 * @param   mc flag list item
	 * @param   isYes 如果为真,返回mcPoint的值,如果为假,返回null
	 * @return  {x,y,level}
	 */
	private function endEditPoint(mc:MovieClip, isYes:Boolean):Object{
		var mcPoint:MovieClip	=	_remark.flags[mc.index];
		mcPoint.gotoAndStop("normal");
		_zoomImage.setImageDND(true);
		if(isYes){
			return _remark.getCurrentPoint(mcPoint, mcPoint._x, mcPoint._y);
		}else{//还原来原来的数据
			mcPoint._x			=	mcPoint.x;
			mcPoint._y			=	mcPoint.y;
			mc.mark_txt.text	=	mcPoint.text;
			mcPoint.x	=	mcPoint.y	=	mcPoint.text	=	undefined;
			return null;
		}
	}
	
	/**
	 * 定义文本框是否为显示状态或输入状态
	 * 
	 * @usage   
	 * @param   mc      
	 * @param   enabled 
	 * @return  
	 */
	private function setInput(mc:MovieClip, enabled:Boolean):Void{
		var mc_txt:TextField	=	mc.mark_txt;
		if(enabled){/////输入文本框
			mc_txt.type			=	"input";
			mc_txt.border		=	true;
			mc_txt.selectable	=	true;
			//mc.edit_btn.vName	=	"ADD";
			mc_txt.text			=	mc_txt.text.split("\r")[0];
			Selection.setFocus(mc_txt._target);
		}else{//////显示文本框
			mc_txt.type			=	"dynamic";
			mc_txt.border		=	false;
			mc_txt.selectable	=	false;
			//mc.edit_btn.vName	=	"EDIT";
			var point:Object	=	_remark.points[mc.index];
			
			var nowDate:Date	=	point.date;
			mc.mark_txt.text	=	point.mark+"\r"+
				nowDate.getFullYear()+"-"+(nowDate.getMonth()+1)+"-"+
				nowDate.getDate()+" "+nowDate.getHours()+":"+nowDate.getMinutes();
		}
	}
	
	/**
	 * 删除所有的列表,当有一个项目被删除时
	 * 
	 * @usage   
	 * @return  
	 */
	private function delFlagLists():Void{
		var len:Number	=	_itemsBox.length;
		for(var i:Number=0;i<len;i++){
			_itemsBox[i].removeMovieClip();
		}
		_itemsBox	=	[];
		_points		=	_remark["_pointsLocal"];
	}
	
	/**
	 * 根据index的值来定义mc的位置,如果数值超过_visibleItemNum定义的值,就最多显示
	 * _visibleItemNum多个item,最下方显示最新的.
	 * 
	 * @usage   
	 * @param   mc    
	 * @param   index 
	 * @return  
	 */
	private function setItemPosition(mc:MovieClip, index:Number):Void{
		scrollMaxNum	=	index-_visibleItemNum+1;
		if(scrollMaxNum>0){
			_curIndex				=	index-_visibleItemNum;
			var mc0:MovieClip		=	null;
			//把第一个itemMC删除
			_itemsBox.shift().removeMovieClip();
			index	=	_visibleItemNum-1;
			//把余下的几个往上移
			for(var i:Number=0;i<index;i++){
				mc0		=	_itemsBox[i];
				mc0._x	=	2;
				mc0._y	=	i*itemHeight;
			}
			
		}
		mc._x	=	2;
		mc._y	=	index*itemHeight;
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * 当把flag添加时,在Remark类中发生的事件,
	 * 
	 * @usage   
	 * @param   eventObj {piont, index, isInput}
	 * @return  
	 */
	public function onDropPoint(eventObj:Object):Void{
		var i:Number		=	eventObj.index;
		
		var mc:MovieClip	=	_itemsMC.attachMovie(flagItemID, "mcItem"+i, i);
		setItemPosition(mc, i);
		_itemsBox.push(mc);
		
		mc.point	=	eventObj.point;
		mc.index	=	i;
		setItemAction(mc);
		//eventObj.isInput表示是否为可输入文本,也就是定义是显示框还是输入框
		setInput(mc, eventObj.isInput);
		//定义按键显示的名称
		if(eventObj.isInput){
			mc.edit_btn.vName	=	"ADD";
		}else{
			mc.edit_btn.vName	=	"EDIT";
		}
	}
	
	/**
	 * 显示items,如果数量超过可显示的最大值,这主要运用于scroll
	 * 
	 * @usage   
	 * @param   index 
	 * @return  
	 */
	public function showItems(index:Number):Void{
		if(index==_curIndex || index<0 || index>scrollMaxNum){
			return;
		}
		_curIndex	=	index;
		
		var mc0:MovieClip	=	null;
		for(var i:Number=0;i<_visibleItemNum;i++){
			mc0			=	_itemsBox[i];
			mc0.index	=	i+index;
			setInput(mc0, false);
		}
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "FlagControl 1.0";
	}
}
