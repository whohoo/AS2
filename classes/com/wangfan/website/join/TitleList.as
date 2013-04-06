//******************************************************************************
//	name:	TitleList 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Nov 13 10:00:15 GMT+0800 2006
//	description: This file was created by "join.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wangfan.website.join.TitleList extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _maskMC:MovieClip		=	null;
	private var _detailBGMC:MovieClip	=	null;
	private var _bottomBarMC:MovieClip	=	null;
	
	private var _descriptionTXT:TextField		=	null;
	private var _requestTXT:TextField			=	null;
	private var _titleTXT:TextField			=	null;
	private var _listArr:Array			=	null;
	private var _curIndex:Number		=	null;
	
	private var _textFieldOffset:Number	=	null;//description与request之间的空间
	private var _initHeightDetailBG:Number	=	null;
	
	private var onRelease:Function		=	null;//假的,骗过
	/**延迟多少帧出现下一组。*/
	public  var delayFrame:Number		=	20;
	/**指向哪一个ITEM，当被按下时*/
	public  var curItem:MovieClip		=	null;
	/**指向下一个ITEM，当被按下时*/
	public  var nextItem:MovieClip		=	null;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new TitleList(this);]
	 * @param target target a movie clip
	 */
	public function TitleList(target:MovieClip){
		this._target	=	target;
		_maskMC			=	target._parent.mask_mc;
		_detailBGMC		=	target._parent.detailBG_mc;
		_bottomBarMC	=	target._parent.bottomBar_mc;
		_descriptionTXT	=	target._parent.description_txt;
		_requestTXT		=	target._parent.request_txt;
		_titleTXT		=	target._parent.title_txt;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_listArr	=	[];
		_descriptionTXT.autoSize	=
		_requestTXT.autoSize		=	"left";
		_textFieldOffset			=	_requestTXT._y-_descriptionTXT._y-_descriptionTXT._height;
		_initHeightDetailBG			=	_detailBGMC._height;
		
		_bottomBarMC.sendResume_mc.onRelease=Delegate.create(this, onSendResumeRelease);
		_bottomBarMC.joinUs_mc.onRelease=Delegate.create(this, onJoinUsRelease);
		
		_bottomBarMC.closeBar_mc.onRelease=Delegate.create(this, onBottomBarRelease);
		_bottomBarMC.closeBar_mc.onRollOver=Delegate.create(this, onBottomBarRollOver);
		_bottomBarMC.closeBar_mc.onRollOut=
		_bottomBarMC.closeBar_mc.onReleaseOutside=Delegate.create(this, onBottomBarRollOut);
		
		//content mask展开或缩小的事件
		_maskMC.addEventListener("onHeightExpanding", Delegate.create(this, onContentExpanding));
		_maskMC.addEventListener("onHeightCollapsing", Delegate.create(this, onContentCollapsing));
		_maskMC.addEventListener("onHeightExpandEnd", Delegate.create(this, onContentExpandEnd));
		_maskMC.addEventListener("onHeightCollapseEnd", Delegate.create(this, onContentCollapseEnd));

	}
	
	private function onContentExpanding(evtObj:Object):Void{
		_detailBGMC._height	=	evtObj.height+_initHeightDetailBG;
		_bottomBarMC._y	=	_detailBGMC._height+_detailBGMC._y;
	}
	private function onContentCollapsing(evtObj:Object):Void{
		_detailBGMC._height	=	evtObj.height+_initHeightDetailBG;
		_bottomBarMC._y	=	_detailBGMC._height+_detailBGMC._y;
	}
	private function onContentExpandEnd(evtObj:Object):Void{
		_bottomBarMC.sendResume_mc.enabled	=	
		_bottomBarMC.joinUs_mc.enabled		=	
		_bottomBarMC.closeBar_mc.enabled	=	true;
	}
	private function onContentCollapseEnd(evtObj:Object):Void{
		if(nextItem!=null){
			nextItem.onRelease();
		}
		_bottomBarMC.sendResume_mc.enabled	=	
		_bottomBarMC.joinUs_mc.enabled		=	
		_bottomBarMC.closeBar_mc.enabled	=	false;
	}
	
	private function _onShowEnterFrame():Void{
		if(_curIndex%delayFrame==0){
			var mc:MovieClip	=	null;
			mc	=	_listArr[_curIndex/delayFrame];
			if(mc==null){
				delete _target.onEnterFrame;
				//判断是否joinOutTeam_mc可否拉动
				checkCanScroll();
			}else{
				mc.moveIn();
				_target.getInstanceAtDepth(mc.getDepth()+1).moveIn();
				//trace(_target["mcSplitLine"+mc.getDepth()])
			}
			
		}
		_curIndex++;
	}
	
	private function initItemEvents(mc:MovieClip):Void{
		mc.onRelease=Delegate.create(mc, onItemRelease);
		
		mc.onRollOver=Delegate.create(mc, onItemRollOver);
		mc.onRollOut=mc.onReleaseOutside=Delegate.create(mc, onItemRollOut);
		
		//mc["background_mc"].isHover	=	30;
		mc.pClass	=	this;
	}
	
	private function onItemRelease():Void{
		var pClass:Object	=	this["pClass"];
		if(pClass.curItem==null){//没有展开
			var height:Number	=	pClass._titleTXT._height+pClass._descriptionTXT._height+
												pClass._titleTXT._y+pClass._textFieldOffset;
			pClass._titleTXT.text			=	this["title_txt"].text.substr(2);
			pClass._descriptionTXT.htmlText	=	this["description"];
			pClass._requestTXT.htmlText		=	this["request"];
			pClass._requestTXT._y	=	height;
			
			height	+=	pClass._requestTXT._height;
			pClass._maskMC.expandHeightMask(height-pClass._titleTXT._y);
			pClass._bottomBarMC.moveIn();
			pClass.curItem	=	this;
		}else if(pClass.curItem instanceof MovieClip){//已经展开了
			pClass._maskMC.collapseHeightMask();
			pClass._bottomBarMC.moveOut();
			pClass.curItem	=	null;
			pClass.nextItem	=	this;
		}else{
			
		}
		
	}
	
	private function onItemRollOver():Void{
		var bg:MovieClip	=	curItem["background_mc"];
		bg.moveIn(5);
	}
	
	private function onItemRollOut():Void{
		var bg:MovieClip	=	curItem["background_mc"];
		bg.moveOut(0);
	}
	
	private function onSendResumeRelease():Void{
		//trace("mailto:"+curItem.email)
		getURL("mailto:"+curItem.email);
	}
	private function onJoinUsRelease():Void{
		
	}
	
	private function onBottomBarRelease():Void{
		curItem.onRelease();
		nextItem	=	null;
	}
	private function onBottomBarRollOver():Void{
		fadeIn(_bottomBarMC.closeBar_mc.bar_mc);
	}
	private function onBottomBarRollOut():Void{
		fadeOut(_bottomBarMC.closeBar_mc.bar_mc);
	}
	
	private function setTitleBackgroundSize(itemList:MovieClip, width:Number):Void{
		for(var i:Number=0;i<6;i++){
			itemList["title"+i].background_mc._width	=	width;
		}
	}
	//判断是否joinOutTeam_mc可否拉动
	private function checkCanScroll():Void{
		if(_target._width>_target._parent.maskList_mc._width){
			var mc:MovieClip	=	_target._parent.joinOutTeam_mc;
			mc.moveTarget	=	_target;
			mc.xMin	=	mc._x;
			mc.xMax	=	mc._x+_target._parent.maskList_mc._width-240;//mc._width;
			mc.onPress=function():Void{
				this.startDrag(false, this.xMin, this._y, this.xMax, this._y);
				this.onMouseMove=function():Void{
					var mc0:MovieClip	=	this["moveTarget"];
					var pos:Number	=	-(this._x-this.xMin)/(this.xMax-this.xMin)*
							(mc0._width-this._parent.maskList_mc._width)+mc0.initX;
					mc0.onEnterFrame=function():Void{
						var temp:Number	=	pos-this["_x"];
						this["_x"]	+=	temp*.3;
						if(Math.abs(temp)<.1){
							delete this.onEnterFrame;
						}
					}
					
				}
			}
			mc.onRelease=mc.onReleaseOutside=function():Void{
				this.stopDrag();
				delete this.onMouseMove;
			}
			_target.initX	=	_target._x;
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 生成招聘的列表，第六个为一组。
	* @param child
	*/
	public function createList(child:XMLNode):Void{
		var len:Number	=	child.childNodes.length;
		child	=	child.firstChild;
		var index:Number		=	0;
		var offsetNum:Number	=	30;
		var mc:MovieClip		=	null;
		var mcPrev				=	{_x:0, _width:-offsetNum};
		var mcItem:MovieClip	=	null;
		var maxWidth:Number	=	null;
		while(child!=null){
			mc	=	_target.attachMovie("itemList", "mcList"+index, index*2,
							{_x:mcPrev._x+mcPrev._width+offsetNum});
			_listArr.push(mc);
			if(index!=0){//第一个的左边不会有竖线
				_target.attachMovie("splitLine", "mcSplitLine"+index, index*2+1,
						{_x:mc._x-15, _y:5});
			}
			//背景条最大的宽度。
			maxWidth	=	0;
			for(var i:Number=0;i<6;i++){
				mcItem	=	mc["title"+i];
				if(child==null){
					//mcItem.title_txt.text	=	"";
					continue;
				}
				mcItem.title_txt.autoSize	=	"left";
				mcItem.title_txt.text	=	"- "+child.attributes.title;
				mcItem.email		=	child.attributes.submit_email;
				mcItem.request		=	child.firstChild.firstChild.nodeValue.split("\r\n").join("<br/>");
				mcItem.description	=	child.firstChild.nextSibling.firstChild.nodeValue.split("\r\n").join("<br/>");;
				initItemEvents(mcItem);
				maxWidth	=	mcItem.title_txt._width>maxWidth? mcItem.title_txt._width : maxWidth;
				child	=	child.nextSibling;
			}
			setTitleBackgroundSize(mc, maxWidth+2);
			mcPrev	=	mc;
			index++;
		}
		showList();
		
	}
	
	public function showList():Void{
		_curIndex	=	0;
		_target.onEnterFrame=Delegate.create(this, _onShowEnterFrame);
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "TitleList 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	static private function fadeIn(mc:MovieClip):Void{
		//trace("hover: "+mc._name);
		
		mc.onEnterFrame=function():Void{
			this._alpha	+=	5;
			if(this._alpha>=100){
				delete this.onEnterFrame;
				//this.removeMovieClip();
			}
		}
		//当mouse快速在上方来回移动时，来回的速度快过帧率时，就会产生因上次的delete onEnterFrame
		//所以在加以下代码加以判断。
		if(mc._alpha>=100){
			delete mc.onEnterFrame;
			//this.removeMovieClip();
		}
	}
	static private function fadeOut(mc:MovieClip):Void{
		//trace("out: "+mc._name);
		
		mc.onEnterFrame=function():Void{
			this._alpha	-=	5;
			if(this._alpha<=70){
				delete this.onEnterFrame;
				//this.removeMovieClip();
			}
		}
		//当mouse快速在上方来回移动时，来回的速度快过帧率时，就会产生因上次的delete onEnterFrame
		//所以在加以下代码加以判断。
		if(mc._alpha<=70){
			delete mc.onEnterFrame;
			//this.removeMovieClip();
		}
	}
}//end class
//This template is created by whohoo.
/*
* <recruit id="1" title="Interactive Creative Designer" submit_email="luren@wangfan.com">
* 	<request>Flash 2004 MX up, Photoshop cs up, Macromedia 2004 MX up</request>
* 	<description>This is a major creative designer that was master Photoshop &amp; Flash</description>
* </recruit>
*/
