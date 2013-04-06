//******************************************************************************
//	name:	MenuRoot 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 22:12:19 2006
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.website.project.MenuContentMask;
import com.wangfan.rover.MoveMap;
import com.wangfan.website.project.LoadXmlMenu;

/**
 * 在project.swf中的动态菜单（根目录）.<p></p>
 * 根据加载的XML数据生成菜单。
 */
class com.wangfan.website.project.MenuRoot extends MovieClip{
	private var _visibleHeight:Number		=	null;//可显示内容的最大高度
	private var maskYear_mc:MovieClip		=	null;
	private var year_mc:MovieClip			=	null;
	private var content_mc:MovieClip		=	null;
	private var maskContent_mc:MovieClip	=	null;
	private var list_mc:MovieClip			=	null;
	private var maskList_mc:MovieClip		=	null;
	private var whoWeAre_mc:MovieClip		=	null;
	
	//private var mcLineUp:MovieClip			=	null;//年份上方的粗线条
	//private var mcLineDown:MovieClip		=	null;//最下方的粗线条
	
	//private var _isShowLines:Boolean		=	null;//线是否已经显示？
	private var _interShowLine:Number		=	null;//出现线的间隔
	private var _curShowLineIndex:Number	=	null;//第N条出现的线.
	private var _curYear:MovieClip			=	null;
	private var _nextYear:MovieClip		=	null;//当关闭完成后，下一个打开的年份。
	private var _curItem:MovieClip			=	null;
	private var _nextItem:MovieClip		=	null;
	private var _curPic:MovieClip			=	null;
	
	private var menuItemYearID:String		=	"menu year";
	private var itemContentID:String		=	"itemContent";
	private var menuItemContentID:String	=	"itemList";
	private var menuItemPagesID:String		=	"pics page";
	private var pic_mcl:MovieClipLoader	=	null;
	
	private var _maxMaskContentHeight:Number	=	0;
	//private var _moveMap:MoveMap			=	null;
	private var _moveYear:MoveMap			=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * CANNOT Create a class BY [new MenuRoot();]
	 */
	private function MenuRoot(){
		_moveYear		=	new MoveMap(year_mc, maskYear_mc);
		_moveYear.isMoveY	=	false;//y轴方向不要移动。
		_moveYear.stopMove();
		
		_global.setTimeout(this, "init", 200);
		pic_mcl	=	new MovieClipLoader();
		pic_mcl.addListener(this);
		
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		//_isShowLines	=	false;
		
		//list mask展开或缩小的事件
		maskList_mc.addEventListener("onHeightExpanding", Delegate.create(this, onListExpanding));
		maskList_mc.addEventListener("onHeightCollapsing", Delegate.create(this, onListCollapsing));
		maskList_mc.addEventListener("onHeightExpandEnd", Delegate.create(this, onListExpandEnd));
		maskList_mc.addEventListener("onHeightCollapseEnd", Delegate.create(this, onListCollapseEnd));
		
		//content mask展开或缩小的事件
		maskContent_mc.addEventListener("onHeightExpanding", Delegate.create(this, onContentExpanding));
		maskContent_mc.addEventListener("onHeightCollapsing", Delegate.create(this, onContentCollapsing));
		maskContent_mc.addEventListener("onHeightExpandEnd", Delegate.create(this, onContentExpandEnd));
		maskContent_mc.addEventListener("onHeightCollapseEnd", Delegate.create(this, onContentCollapseEnd));
		//在外部定义的函数，使背景跟着图片扩展或收缩。
		maskContent_mc.addEventListener("onWidthExpanding", onBackgroundScale);
		maskContent_mc.addEventListener("onWidthCollapsing", onBackgroundScale);
		maskContent_mc.addEventListener("onWidthExpandEnd", onBackgroundScale);
		maskContent_mc.addEventListener("onWidthCollapseEnd", onBackgroundScale);
		
	}
	
	private function onBackgroundScale(evtObj:Object):Void{
		_parent.onBackgroundScale(evtObj);
		//launch图标跟着移动
		content_mc.mcItemContent.launchWord_mc._x	=	evtObj.width;
		//图片上方的一条线，在line2_mc内。
		content_mc.mcItemContent.line2_mc.leftLine_mc.clear();
		content_mc.mcItemContent.line2_mc.leftLine_mc.lineStyle(.1, 0x1C1815);
		content_mc.mcItemContent.line2_mc.leftLine_mc.moveTo(109, 0);
		content_mc.mcItemContent.line2_mc.leftLine_mc.lineTo(evtObj.width, 0);
		//trace(content_mc.mcItemContent.line2_mc.leftLine_mc)
	}
	//生成年份下的内容。
	private function createList(child:XMLNode):Void{
		//var len:Number	=	child.childNodes.length;
		child	=	child.firstChild;
		var mc:MovieClip	=	null;
		var distance:Number	=	6;//list之间的距离
		var mcPrev:Object	=	{_y:0, _height:distance};
		list_mc.mcItemList.removeMovieClip();
		var mcList:MovieClip	=	list_mc.createEmptyMovieClip("mcItemList", 0);
		var itemArr:Array	=	[];//保存着所有的list对象
		var i:Number		=	0;
		while(child!=null){
			mc		=	mcList.attachMovie(menuItemContentID, 
										"mcItem"+i, i*2);
			//mc.title_txt.autoSize	=	"left";
			mc.setData(child.attributes.title);//定义标题的名称。
			mc.projectUrl		=	child.attributes.url;
			//竖着排列。
			mc._y	=	mcPrev._y+mcPrev._height-distance;
			itemArr.push(mc);
			mcPrev	=	mc;
			mc.child	=	child;
			i++;
			child	=	child.nextSibling;
		}
		mcList.itemArr	=	itemArr;
		//mcList._visible	=	false;
	}
	
	private function enableItemClick(enabled:Boolean):Void{
		var mcList:MovieClip	=	list_mc.mcItemList;
		var mc:MovieClip		=	null;
		for(var prop:String in mcList){
			mc	=	mcList[prop];
			if(mc._name.indexOf("mcItem")==0){
				mc.enabled	=	enabled;
				
			}
			
		}
	}
	
	//得到可视范围的高度，这决定了一页可显示多少条award.
	private function getMaskHeight():Void{
		var pos:Object	=	{x:list_mc._x, y:list_mc._y};
		localToGlobal(pos);
		_parent._parent.globalToLocal(pos);
		_visibleHeight	=	 Stage.height-180-pos.y;
	}
	
	private function maskMaxHeight():Void{
		var mcList:MovieClip	=	list_mc["mcItemList"];
		var height:Number			=	mcList._height+10;
		if(height>_visibleHeight){
			height	=	_visibleHeight;
		}
		//maskContent_mc._height	=	height;
		_maxMaskContentHeight	=	height;
		
	}

	//当内容的list mask伸长时。
	private function onListExpanding(evtObj:Object):Void{
		var mc:MovieClip	=	maskList_mc["line"+_curShowLineIndex];
		if(mc==null)	return;
		if(mc._y<=maskList_mc._height){
			mc.moveIn();
			_curShowLineIndex++;
		}
		
	}
	
	private function onListCollapsing(evtObj:Object):Void{
		
	}
	//当list mask伸长结束时。
	private function onListExpandEnd():Void{
		
		
	}
	
	//当list mask缩小结束时。
	private function onListCollapseEnd():Void{
		_curYear	=	null;
		_nextYear.onRelease();
	}
	//////end list mask定义
	
	//当内容的content mask伸长时。
	private function onContentExpanding(evtObj:Object):Void{
		maskList_mc._y	=	
		list_mc._y		=	evtObj.height+content_mc._y;
		whoWeAre_mc._y	=	list_mc._y+list_mc._height;
	}
	
	private function onContentCollapsing(evtObj:Object):Void{
		maskList_mc._y	=	
		list_mc._y		=	evtObj.height+content_mc._y;
		whoWeAre_mc._y	=	list_mc._y+list_mc._height;
	}
	//当content mask伸长结束时。
	private function onContentExpandEnd():Void{
		
	}
	
	//当content mask缩小结束时。
	private function onContentCollapseEnd():Void{
		//fadeIn(_curItem);
		_curItem	=	null;
		content_mc.mcItemContent.removeMovieClip();
		//收完的，再打开。
		_nextItem.onRelease();
	}
	//////end content mask定义。
	
	/////////loading pic events
	private function onLoadProgress(target_mc:MovieClip, loadedBytes:Number, 
														totalBytes:Number):Void{
		var loadingTXT:TextField	=	target_mc._parent.loading_txt;
		loadingTXT.text	=	"Loading "+Math.round(loadedBytes/totalBytes*100)+" ......";
	}
	private function onLoadComplete(target_mc:MovieClip):Void{
		target_mc._alpha	=	0;
		var loadingTXT:TextField	=	target_mc._parent.loading_txt;
		loadingTXT.text	=	"";
	}
	//////当图片加载完成时
	private function onLoadInit(target_mc:MovieClip):Void{
		//maskContent_mc._height	=	0;
		var mc:MovieClip	=	content_mc.mcItemContent;
		//whoWeAre_mc._y		=	
		//表示网站已经上线的标志
		mc.launchWord_mc._y	=
		//分页图片的icon放在此影片内
		mc.picPages_mc._y	=	
		//分页图片当前页指示头
		mc.pageArrow_mc._y	=	
		//分页图片的结束标志位置。
		mc.lineEnd_mc._y	=	target_mc._y+target_mc._height+8;
		mc.lineEnd_mc._x	=	mc.picPages_mc._x+mc.picPages_mc._width;
		
		//open_icon的位置在图片高度的中间.
		target_mc._parent.open_icon._y	=	target_mc._height/2+target_mc._y;
		
		maskContent_mc.expandHeightMask(content_mc._height+5);
		
		//定义mouse放在图片上方时，进行横向的伸缩。
		target_mc.onRollOver=function():Void{
			var pClass	=	this["pClass"];
			pClass.maskContent_mc.expandWidthMask(this._width);
			this._parent.open_icon.moveIn();

		}
		target_mc.onRollOut=target_mc.onReleaseOutside=function():Void{
			var pClass	=	this["pClass"];
			pClass.maskContent_mc.collapseWidthMask();
			this._parent.open_icon.moveOut();
		}
		target_mc.pClass		=	this;
		target_mc.useHandCursor	=	false;
		//慢慢显示被加载的图片
		target_mc.onEnterFrame=function():Void{
			this._alpha	+=	20;
			if(this._alpha>=100){
				delete this.onEnterFrame;
			}
		}
		
	}
	//在list中隐藏当前显示的item
	private function hideCurItem(item:MovieClip):Void{
		var itemArr:Array	=	list_mc.mcItemList.itemArr;
		var mc:MovieClip	=	null;
		var distance:Number	=	6;//list之间的距离
		var mcPrev			=	{_y:0, _height:distance};
		var len:Number		=	itemArr.length;
		for(var i:Number=0;i<len;i++){
			mc	=	itemArr[i];
			if(mc==item){
				mc._visible	=	false;
				
			}else{
				mc._visible	=	true;
				//竖着排列。
				mc._y	=	mcPrev._y+mcPrev._height-distance;
				mcPrev	=	mc;
			}
			
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 生成菜单。
	* @param child
	*/
	public function createMenu(child:XMLNode):Void{
		getMaskHeight();
		//横向的年份得奖条。
		//var len:Number	=	child.childNodes.length;
		child	=	child.firstChild;
		var mc:MovieClip	=	null;
		var mcPrev:Object	=	{_x:0, _width:0};
		
		var i:Number		=	0;
		while(child!=null){
			mc		=	year_mc.attachMovie(menuItemYearID, "menuYearBar"+i, 2*i);
			mc._x	=	mcPrev._x+mcPrev._width;
			mc.year_mc.year_txt.text	=	child.nodeName;
			
			mc.index	=	i;
			//生成年份下的内容。
			mc.child	=	child;
			mcPrev	=	mc;
			i++;
			child	=	child.nextSibling;
		}
		mc.line_mc._visible	=	false;//最右边的竖线不可见。
		//trace(year_mc["menuYearBar0"].year_mc.onRelease)
		_global.setTimeout(year_mc["menuYearBar0"].year_mc, "onRelease", 500);
		//如果超过可显示范围，移动年份。
		if(year_mc._width>maskYear_mc._width){
			_moveYear.maskMC	=	maskYear_mc;
			_moveYear.map		=	year_mc;
			_moveYear.isMoveX	=	true;
			_moveYear.startMove();
		}
	}
	
	/**
	 * 显示某年份下的project
	 * 
	 * @param   year 
	 */
	public function showProjectList(year:MovieClip):Void{
		
		if(_curYear==year)	return;
		if(_curYear!=null){
			maskList_mc.collapseHeightMask();
			_nextYear	=	year;//当关闭完成后，下一个打开的年份。
			//TODO 把原来的显示的图片收起来。
			
			if(_curItem!=null){
				_curItem.onRelease();
			}
			return;
		}
		_curYear	=	year;
		
		createList(year._parent.child);
		maskList_mc._height	=	0;
		maskMaxHeight();
		maskList_mc.expandHeightMask(_maxMaskContentHeight);
		//把某年份下第一个项目显示出来。
		if(_curItem!=null){
			_curItem.onRelease();
			//强制打开的是第一项内容。
			_nextItem	=	list_mc.mcItemList.mcItem0;
		}else{
			list_mc.mcItemList.mcItem0.onRelease();
		}
	}
	
	/**
	 * 显示某年份下的某一项目的具体内容。
	 * 
	 * @param   item 
	 */
	public function showProjectDetail(item:MovieClip):Void{
		
		if(_curItem==item){
			maskContent_mc.collapseHeightMask();
			hideCurItem(null);//item list下的按钮不可以见。
			_nextItem	=	null;
			return;
		}else if(_curItem!=null){
			maskContent_mc.collapseHeightMask();
			_nextItem	=	item;//当关闭完成后，下一个打开的年份。
			return;
		}
		_curItem	=	item;
		hideCurItem(item);//item list下的按钮不可以见。
		//content_mc.mcItemContent
		var mc:MovieClip	=	content_mc.attachMovie(itemContentID, "mcItemContent", 0);
		//显示年份后两位加斜线再加标题。
		mc.title_txt.text	=	_curYear.year_txt.text.substr(-2)+" / "+item.title_txt.text;
		//关闭显示当前打开的页面.
		mc.close_btn.onRelease=Delegate.create(item, item.onRelease);
		
		mc.description_txt.autoSize	=	"left";
		//把两个换行符转为一个
		mc.description_txt.htmlText	=	item.child.firstChild.firstChild.nodeValue.split("\r\n").join("\r");
		mc.worker_txt.text	=	item.child.attributes.worker;
		mc.worker_txt._y	=	mc.description_txt._y+mc.description_txt._height+5;
		mc.line2_mc._y		=	mc.worker_txt._y-3;
		mc.pic_mc._y		=	mc.worker_txt._y+mc.worker_txt._height;
		
		var child:XMLNode		=	item.child.firstChild.nextSibling;
		var i:Number			=	0;
		var mcPage:MovieClip	=	null;
		_curPic					=	null;//因为重新构建了菜单，所以把_curPic置空。
		//多张图片的分页
		while(child!=null){
			mcPage	=	mc.picPages_mc.attachMovie(menuItemPagesID, "mcPages"+i, i,
							{_x:i*15});
			mcPage.picUrl	=	child.attributes.url;
			mcPage.onRelease=function():Void{
				var pClass	=	this["pClass"];
				if(pClass._curPic==this)	return;
				
				//TODO 当加截第二张图片的过场。
				pClass.pic_mcl.loadClip(LoadXmlMenu.WEB_SITE+this["picUrl"], mc.pic_mc);
				fadeOut(pClass._curPic);
				fadeIn(this);
				mc.pageArrow_mc._x	=	this["_x"];
				mc.loading_txt._y	=	mc.worker_txt._y+mc.worker_txt._height+5;
				pClass._curPic	=	this;
				//trace([LoadXmlMenu.WEB_SITE+this["picUrl"], mc]);
			}
			mcPage.onRollOver=function():Void{
				var pClass	=	this["pClass"];
				if(pClass._curPic==this)	return;
				
				fadeIn(this);
			}
			mcPage.onRollOut=mcPage.onReleaseOutside=function():Void{
				var pClass	=	this["pClass"];
				if(pClass._curPic==this)	return;
				
				fadeOut(this);
			}
			
			mcPage._alpha	=	50;
			mcPage.pClass	=	this;
			i++;
			child	=	child.nextSibling;
		}
		mc.picPages_mc.mcPages0.onRelease();
		maskContent_mc.expandHeightMask(content_mc._height);
		//一开始根据mask的宽来定义背景与launch的位置。
		onBackgroundScale({width:maskContent_mc._width});
		//trace(LoadXmlMenu.WEB_SITE+item.child.childNodes[1].attributes.url)
		if(item.projectUrl=="none"){
			delete mc.launchWord_mc.onRelease;
			mc.launchWord_mc._alpha	=	35;
		}else{
			mc.launchWord_mc._alpha	=	100;
			mc.launchWord_mc.onRelease=function():Void{
				//trace(item.projectUrl);
				getURL(item.projectUrl, "projectUrl");
				
			}
		}
	}
	//***********************[STATIC METHOD]**********************************//
	static private function fadeIn(mc:MovieClip):Void{
		//trace("hover: "+mc._name);
		
		mc.onEnterFrame=function():Void{
			this._alpha	+=	10;
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
			this._alpha	-=	10;
			if(this._alpha<=50){
				delete this.onEnterFrame;
				//this.removeMovieClip();
			}
		}
		//当mouse快速在上方来回移动时，来回的速度快过帧率时，就会产生因上次的delete onEnterFrame
		//所以在加以下代码加以判断。
		if(mc._alpha<=50){
			delete mc.onEnterFrame;
			//this.removeMovieClip();
		}
	}
}//end class
//This template is created by whohoo.
