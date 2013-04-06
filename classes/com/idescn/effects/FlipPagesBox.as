//********************************************
//	class:	FlipPagesBox 1.1
// 	author:	whohoo
// 	email:	whohoo@21cn var com
// 	date:	Tue Nov 08 10:49:12 2005
//	description:	把原来FFlipPages 3.0 as1转为AS2
//********************************************

import mx.events.EventDispatcher;

[IconFile("FlipPagesBox.png")]
/**
* component for FlipPagesBox.
* <p></p>
* you could drag FlipPagesBox from component panel(Ctrl+F7) in flash to stage<br></br>
* and define properties in Parameters panel(Alt+F7).<br></br>
* <b>Parameters:</b>
* <ul>
* <li><b>active:</b> if true the flip page would active, or not. default is true</li>
* <li><b>adjustEventPage:</b> if true the flip page would event page, default is false.</li>
* <li><b>autoPage:</b> if true the flip page would automatically go to the definite frame, default is true</li>
* <li><b>multiFlip:</b> if true the flip page would allow few flip page fliping. default is false.</li>
* <li><b>pageId:</b> a identifier of movieclip linkage.</li>
* <li><b>showRearPage:</b> is show rear page?</li>
* <li><b>visiblePages:</b> number of visible pages ?</li>
* <li><b>curPage:</b> a number of current page.</li>
* <li><b>firstPage:</b> a number of first page.</li>
* <li><b>lastPage:</b> a number of first page.</li>
* <li><b>dragAccRatio:</b> drag page ratio of acceleration.</li>
* <li><b>moveAccRatio:</b> move page ratio of acceleration.</li>
* </ul>
* <p></p>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onRemovePage({page, state}): if rear page remove, state would be true, or it is null. </li>
* <li>onCreatePage({page, state}): if rear page create, state would be true, or it is null  </li>
* <li>onAdjustPage({page, range}): adjust the page when according to its position,  </li>
* <li>onSetFlipArea({page}): when set flip area </li>
* <li>onResizePage({page, width, height}): when resize page </li>
* <li>onStartFlip({page}): when start fliping</li>
* <li>onStopFlip({page}): when stop fliping</li>
* <li>onFinishFlip({page}): after finish fliping</li>
* <li>onMovePage({page}): when moving page</li>
* <li>onDragPage({page}): when draging page</li>
* </ul>
*/
class com.idescn.effects.FlipPagesBox extends MovieClip{
	/**
	* postion precision when fliping
	*/
	public	var posPrecision:Number	= 0.5;	//精确度
	
	private var _pageWidth:Number		= 0;		//pageWidth
	private var _pageHeight:Number		= 0;		//pageHeight
	private var _pageId:String			= "";		//pageId
	private var _adjustEvenPage:Boolean	= true;		//adjustEvenPage
	private var _autoPage:Boolean		= true;		//autoPage
	private var _firstPage:Number		= 0;		//firstPage
	private var _lastPage:Number		= 0;		//lastPage
	private var _curPage:Number		= 0;		//curPage
	private var _visiblePages:Number	= 1;		//visiblePages
	private var _showRearPage:Boolean	= false;	//showRearPage
	[Inspectable(name="shade", defaultValue="show:true,color:0x000000,sizeMin:10,sizeMax:30,alphaMin:60,alphaMax:50", category="Object", verbose="1" )]
	private var _shade:Object;
	[Inspectable(name="pageShadow", defaultValue="show:true,color:0x000000,sizeMin:20,sizeMax:120,alphaMin:60,alphaMax:80", category="Object", verbose="1")]
	private var _pageShadow:Object;
	[Inspectable(name="flipArea", defaultValue="leftTop:true,rightTop:true,leftBottom:true,rightBottom:true,leftTopInner:true,rightTopInner:true,leftBottomInner:true,rightBottomInner:true", category="Object", verbose="1")]
	private var _flipArea:Object;
	[Inspectable(name="flipSize", defaultValue="width:40,height:30,innerWidth:80,innerHeight:50", category="Object", verbose="1")]
	private var _flipSize:Object;
											//flipAreaSize
	private var _dragAccRatio:Number	= 0;		//dragAccRatio
	private var _moveAccRatio:Number	= 0;		//moveAccRatio
	private var _multiFlip:Boolean		= false;	//multiFlip
	private var _active:Boolean		= true;		//active
	private var _pages:Object			= {};		//list of the visible page objects
	private var _flipPages:Object		= {};		//list of the flipped page objects
	private var _flipCount:Number		= 0;		//count of the flipped pages (<0 means the flipped pages are on the left)
	private var _topPageDepth:Number	= 10000;	//depth of the topmost static page
	private var _shadowDepth:Number	= 10;		//depth of the page shadow movie clip
	private var _shadowMaskDepth:Number	= 20;	//depth of the shadow mask movie clip
	private var _faceDepth:Number		= 30;		//depth of the page face movie clip
	private var _pageMaskDepth:Number	= 40;		//depth of the page mask movie clip
	private var _rearPageDepth:Number	= 10;		//depth of the rear page movie clip
	private var _pageDepth:Number		= 20;		//depth of the page content movie clip
	private var _shadeDepth:Number		= 30;		//depth of the shade movie clip
	private var _flipAreaDepth:Number	= 40;		//depth of the flip area movie clip
	private var _pretreating:Boolean	= true;		//if it is pretreating
	
	/////////////////event
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
	public var removeEventListener:Function;
	
	private var dispatchEvent:Function;
	private static var __mixinFED =	EventDispatcher.initialize(FlipPagesBox.prototype);

	////属性存取方法
	
	function set pageWidth(value:Number):Void{
		resizePage(value);
	}
	/**the width of the page*/
	function get pageWidth():Number{
		return _pageWidth;
	}
	
	function set pageHeight(value:Number):Void{
		resizePage(null,value);
	}
	/**the height of the page*/
	function get pageHeight():Number{
		return _pageHeight;
	}
	
	
	[Inspectable(defaultValue="", type=String)]
	function set pageId(value:String):Void{
		if (typeof(value) != "string"){
			value = "";
		}
		if (this._pageId == value){
			return;
		}
		this._pageId	= value;
		for (var i:String in this._pages){
			this._createPageMC(this._pages[i]);
		}
	}
	/**the linkage id of the page content movie clip*/
	function get pageId():String{
		return _pageId;
	}
	
	
	[Inspectable(defaultValue=false, verbose=1, type=Boolean )]
	function set adjustEvenPage(value:Boolean):Void{
		this._adjustEvenPage	= value;
		var dx:Number			= value ? 0 : this._pageWidth;
		for (var i:String in this._pages) {
			var page			= this._pages[i];
			page.page._x		= dx * -page.side;
			if (page.rearPage != null){
				page.rearPage._x = dx * -page.side;
			}
		}
	}
	/**if adjust even page's content position*/
	function get adjustEvenPage():Boolean{
		return _adjustEvenPage;
	}
	
	
	[Inspectable(defaultValue=true, verbose=1, type=Boolean)]
	function set autoPage(value:Boolean):Void{
		if (_autoPage = value) {
			for (var i:String in _pages) {
				var page:MovieClip	= _pages[i];
				page.page.gotoAndStop(page.index + 1);
				page.rearPage.gotoAndStop(page.rearPage.index + 1);
			}
		}
	}
	/**automatically go to the definite frame when the page movie clip is created*/
	function get autoPage():Boolean{
		return _autoPage;
	}
	
	
	[Inspectable(defaultValue=0, type=Number, category="Page", name=" firstPage")]
	function set firstPage(value:Number):Void{
		setPageRange(value);
	}
	/**first page's index*/
	function get firstPage():Number{
		return _firstPage;
	}
	
	
	[Inspectable(defaultValue=1, type=Number, category="Page", name="  lastPage")]
	function set lastPage(value:Number):Void{
		setPageRange(null,value);
	}
	/**last page's index*/
	function get lastPage():Number{
		return _lastPage;
	}
	
	
	[Inspectable(defaultValue=0, type=Number, category="Page")]
	function set curPage(value:Number):Void{
		this.gotoPage(value);
	}
	/**index of the current page*/
	function get curPage():Number{
		return _curPage;
	}
	
	
	[Inspectable(defaultValue=1, verbose=1, type=Number)]
	function set visiblePages(value:Number):Void{
		var visiblePages:Number	= this._visiblePages;
		this._visiblePages	= value = value > 1 ? Math.round(value) : 1;
		if (this._pretreating || visiblePages == value){
			return;
		}
		var flipped:Number		= this._flipCount;
		var index1:Number		=	null;
		var index2:Number		=	null;
		if (visiblePages > value) {
			index1		= this._curPage - value*2 + (flipped < 0 ? flipped*2 : 0);
			index2		= this._curPage+1 + value*2 + (flipped > 0 ? flipped*2 : 0);
			for (var i:Number = value; i < visiblePages; i++, index1 -= 2, index2 += 2) {
				this._removePage(this._pages[index1]);
				this._removePage(this._pages[index2]);
			}
		} else {
			index1		= this._curPage - visiblePages*2 + (flipped < 0 ? flipped*2 : 0);
			index2		= this._curPage+1 + visiblePages*2 + (flipped > 0 ? flipped*2 : 0);
			for (var i:Number = visiblePages; i < value; i++, index1 -= 2, index2 += 2) {
				this._createPage(index1, this._topPageDepth + (index1 - this._curPage));
				this._createPage(index2, this._topPageDepth - (index2 - this._curPage));
			}
		}
	}
	/**max count of the visible pages on one side*/
	function get visiblePages():Number{
		return _visiblePages;
	}
	
	
	[Inspectable(defaultValue=false, verbose=1, type=Boolean)]
	function set showRearPage(value:Boolean):Void{
		this._showRearPage	= value;
		var rearDepth:Number		= this._rearPageDepth;
		var dx:Number				= this._adjustEvenPage ? 0 : this._pageWidth;
		for (var i in this._pages) {
			var page:MovieClip		= this._pages[i];
			var rear:MovieClip		= page.rearPage;
			if (!value && rear != null) {
				dispatchEvent({type:"onRemovePage",page:rear,state:true});
				rear.removeMovieClip();
				rear		= page.rearPage = null;
			}
			if (!value || rear != null){
				return;
			}
			var index:Number		= page.index + page.side;
			if (index < this._firstPage || index > this._firstPage){
				continue;
			}
			rear			= page.rearPage = this._pageId == ""
							? page.face.createEmptyMovieClip("RearPageMC", rearDepth)
							: page.face.attachMovie(this._pageId, "RearPageMC", rearDepth);
			rear.index		= index;
			rear._xscale	= -100;
			rear._x			= dx * -page.side;
			if (this._autoPage){
				rear.gotoAndStop(index + 1);
			}
			dispatchEvent({type:"onCreatePage", page:rear, state:true});
		}
	}
	/**if the rear page is shown (used in transparent pages)*/
	function get showRearPage():Boolean{
		return _showRearPage;
	}
	
	
	function set shade(value:Object):Void{
		_shadeSetting("_shade", value);
	}
	/**the settings of the boundary shade*/
	function get shade():Object{
		return _shade;
	}
	
	
	function set pageShadow(value:Object):Void{
		_shadeSetting("_pageShadow", value);
	}
	/**the settings of the page shadow*/
	function get pageShadow():Object{
		return _pageShadow;
	}
	
	
	function set flipArea(value:Object):Void{
		for (var i:String in this._flipArea) {
			if (value[i] != null && !isNaN(value[i])){
				this._flipArea[i] = value[i] ? true : false;
			}
		}
		for (i in this._pages){
			this._setFlipArea(this._pages[i]);
		}
	}
	/**the button areas that can respond to the flip action*/
	function get flipArea():Object{
		return _flipArea;
	}
	
	
	function set flipSize(value:Object):Void{
		setFlipSize(value);
	}
	/**the size (in percentage of the page width) of the flip areas*/
	function get flipSize():Object{
		return _flipSize;
	}
	
	
	[Inspectable(defaultValue=0.5, type=Number, category="speed")]
	function set dragAccRatio(value:Number):Void{
		this._dragAccRatio = value > 1 ? 1 : value > 0 ? Number(value) : 0;
	}
	/**the dragging accelerate ratio (0~1)*/
	function get dragAccRatio():Number{
		return _dragAccRatio;
	}
	
	
	[Inspectable(defaultValue=0.2, type=Number, category="speed")]
	function set moveAccRatio(value:Number):Void{
		this._moveAccRatio = value > 1 ? 1 : value > 0 ? Number(value) : 0;
	}
	/**the moving accelerate ratio (0~1)*/
	function get moveAccRatio():Number{
		return _moveAccRatio;
	}
	
	
	[Inspectable(defaultValue=false, verbose=1, type=Boolean)]
	function set multiFlip(value:Boolean):Void{
		this._multiFlip = value;
	}
	/**if multiple flipping is allowed*/
	function get multiFlip():Boolean{
		return _multiFlip;
	}
	
	
	[Inspectable(defaultValue=true, verbose=1, type=Boolean)]
	function set active(value:Boolean):Void{
		this._active	= value = value;
		for (var i in this._pages) {
			var page:MovieClip			= this._pages[i];
			page.faTop.enabled			= value;
			page.faBottom.enabled		= value;
			page.faTopInner.enabled		= value;
			page.faBottomInner.enabled	= value;
		}
		if (value){
			this.onMouseMove = this._onMouseMove;
		}else{
			delete this.onMouseMove;
		}
	}
	/**if the pages can response to mouse actions*/
	function get active():Boolean{
		return _active;
	}
	
	//*****只读属性******//
	/**list of the visible page objects*/
	function get pages():Object{
		return _pages;
	}
	/**list of the flipped page objects*/
	function get flipPages():Object{
		return _flipPages;
	}
	/**the main flipped page's index (nearest to the current page)*/
	function get flipPage():Number{
		return this._flipCount == 0 ? null : this._curPage + (this._flipCount < 0 ? -1 : 2);
	}
	/**count of the flipped pages (<0 means the flipped pages are on the left)*/
	function get flipCount():Number{
		return _flipCount;
	}
	/**if it is flipping now*/
	function get flipping():Boolean{
		return this._flipCount != 0;
	}
	
	//******************************************************************//
	/**
	* construct function.<br></br>
	* you not use new FlipPagesBox() to constrruct. you ought to drag FlipPagesBox from<br></br>
	* Component panel(Ctrl+F7) to stage.
	*/
	private function FlipPagesBox(){
		if (this.pageWidth == null){
			this.pageWidth = this._xscale * 1.2;
		}else{
			this.pageWidth	=	this._width/2;
		}
		if (this.pageHeight == null){
			this.pageHeight = this._yscale * 1.6;
		}else{
			this.pageHeight	=	this._height;
		}
		this._xscale		= 100;
		this._yscale		= 100;
		init();
	}
	
	/**
	* initialize this class
	*/
	private function init():Void{
		this._pretreating	=	false;
		var mc:MovieClip	=	this["assets_mc"];
		mc.stop();
		mc.swapDepths(1845);
		mc.removeMovieClip();
		gotoPage(_curPage, true);
	}
	
	/**
	* create a page movie clip and its rear page movie clip
	* @param page
	*/
	private function _createPageMC(page:MovieClip):Void {
		if (page.page != null) {
			dispatchEvent({type:"onRemovePage",page:page.page});
			page.page.removeMovieClip();
		}
		page.page			= _pageId == "" ? page.face.createEmptyMovieClip("PageMC", 
									this._pageDepth) : page.face.attachMovie(_pageId, 
									"PageMC", _pageDepth);
		page.page.index		= page.index;
		var dx:Number		= _adjustEvenPage ? 0 : _pageWidth;
		page.page._x		= dx * -page.side;
		if (this._autoPage){
			page.page.gotoAndStop(page.index + 1);
		}
		dispatchEvent({type:"onCreatePage", page:page.page});
		if (this._showRearPage) {
			if (page.rearPage != null){
				dispatchEvent({type:"onRemovePage",page:page.rearPage,state:true});
			}
			var index:Number	= page.index + page.side;
			if (index < this._firstPage || index > this._lastPage) return;
			page.rearPage	= this._pageId == "" ? page.face.createEmptyMovieClip("RearPageMC", _rearPageDepth)
							: page.face.attachMovie(_pageId, "RearPageMC", _rearPageDepth);
			page.rearPage.index		= index;
			page.rearPage._xscale	= -100;
			page.rearPage._x		= dx * -page.side;
			if (this._autoPage){
				page.rearPage.gotoAndStop(index + 1);
			}
			dispatchEvent({type:"onCreatePage", page:page.rearPage, state:true});
		}
	};

	/**
	* create a page object
	* @param index
	* @param depth
	* @param position
	*/
	private function _createPage(index:Number, depth:Number, position:Object):MovieClip {
		if (index < _firstPage || index > _lastPage){
			return	this;
		}
		trace("_createPage: index="+index+", depth="+depth+", mc="+this.getInstanceAtDepth(depth));
		var page:MovieClip		= this.createEmptyMovieClip("Page" + index, depth);
		page.main			= this;
		page.index			= index;
		page.side			= index % 2 == 0 ? -1 : 1;
		page.face			= page.createEmptyMovieClip("FaceMC", _faceDepth);
		page.pageMask		= page.createEmptyMovieClip("PageMaskMC", _pageMaskDepth);
		page.pageMask._xscale		= -page.side * 100;
		page.face.setMask(page.pageMask);
		_createPageMC(page);
		if (this._shade.show) {
			page.shade		= page.face.attachMovie("PageShade", "ShadeMC", _shadeDepth);
			(new Color(page.shade)).setRGB(this._shade.color);
		}
		if (this._pageShadow.show) {
			page.shadow		= page.attachMovie("PageShade", "ShadowMC", this._shadowDepth);
			(new Color(page.shadow)).setRGB(this._pageShadow.color);
			page.shadowMask	= page.createEmptyMovieClip("ShadowMask", this._shadowMaskDepth);
			page.shadowMask._xscale	= -page.side * 100;
			page.shadow.setMask(page.shadowMask);
		}
		page.position		= position;
		this._adjustPage(page);
		this._setFlipArea(page);
		this._pages[index]	= page;
		return page;
	};

	/**
	* remove a page object
	* @param page
	*/
	private function _removePage(page:MovieClip):Void{
		if (page == null){
			return;
		}
		dispatchEvent({type:"onRemovePage", page:page.page});
		if (page.rearPage != null){
			dispatchEvent({type:"onRemovePage", page:page.rearPage, state:true});
		}
		if (this._flipPages[page.index] != null) {
			this._flipCount	+= page.side;
			//trace("_flipPages.removePage| page="+page);
			delete this._flipPages[page.index];
		}
		delete this._pages[page.index];
		page.removeMovieClip();
	};

	/**
	* adjust the page and its mask and shades according to its position
	* @param page
	*/
	private function _adjustPage(page:MovieClip):Void {
		if (page == null){
			return;
		}
		var width:Number		= this._pageWidth;
		var height:Number		= this._pageHeight;
		var side:Number		= page.side;
		var pos:Object			= page.position;
		//calculate the mask range
		var top:Number		=	null;
		var range:Object	=	{type:null,a:null,b:null,angle:null,angle2:null,length:null}; 
		if (pos == null) {
			top		= 1;
			range	= {type:1, a:width, b:width, angle:0, angle2:90, length:height};
			pos		= {x:side * width, y:0};
		} else {
			top		= pos.top;
			range	= pos.range != null ? pos.range
						: (pos.range = this._getMaskRange(-side * pos.x, 
											top > 0 ? pos.y : height-pos.y));
			pos.x	= -side * range.x;
			pos.y	= top > 0 ? range.y : height-range.y;
		}
		//adjust page face movie clip
		var tempMC:MovieClip	=	page.face;
		tempMC._x			= pos.x;
		tempMC._y			= pos.y;
		tempMC._rotation	= side * top * range.angle;
	
		page.page._y	= top > 0 ? 0 : -height;
		if (page.rearPage != null){
			page.rearPage._y = top > 0 ? 0 : -height;
		}
		//adjust shade movie clip
		var ratio:Number		= page.shadeRatio = range.type==0
						? (range.a/width < range.b/height ? range.a/width/2 : range.b/height/2)
						: (range.a/width/2 + range.b/width/2);
		var shade:MovieClip		=	page.shade;
		
		if (shade != null) {
			var shadeSet:Object	= this._shade;
			tempMC				=	shade;
			tempMC._x			= range.a * -side;
			tempMC._y			= 0;
			tempMC._rotation	= (range.angle2 - 90) * side * top;
			tempMC._xscale		= (ratio * shadeSet.sizeMax + (1-ratio) * 
										shadeSet.sizeMin) / 100 * width * side;
			tempMC._yscale		= top * range.length;
			tempMC._alpha		= ratio * shadeSet.alphaMax + (1-ratio) * shadeSet.alphaMin;

		}
		//adjust page mask movie clip
		_drawMask(page.pageMask, range.type, range.a, range.b);
		tempMC				=	page.pageMask;
		tempMC._x			= pos.x;
		tempMC._y			= pos.y;
		tempMC._rotation	= side * top * range.angle;
		tempMC._yscale		= top * 100;

		//adjust page shadow movie clip
		if (page.shadow != null) {
			if (page.position == null) {
				page.shadow._visible	= false;
			} else {
				var shadowSet:Object	=	this._pageShadow;
				tempMC				=	page.shadow;
				tempMC._visible		= true;
				tempMC._x			= (range.a - width) * side;
				tempMC._y			= top > 0 ? 0 : height;
				tempMC._rotation	= (90 - range.angle2) * side * top;
				tempMC._xscale		= (ratio * shadowSet.sizeMax + (1-ratio) * 
										shadowSet.sizeMin) / 100 * width * side;
				tempMC._yscale		= top * (range.length > width ? range.length : width);
				tempMC._alpha		= ratio * shadowSet.alphaMax + (1-ratio) * 
															shadowSet.alphaMin;

				//adjust shadow mask movie clip
				_drawMask(page.shadowMask, 13-range.type, range.a, range.b);
				tempMC				=	page.shadowMask;
				tempMC._y			= top > 0 ? 0 : height;
				tempMC._yscale		= top * 100;

			}
		}
		//adjust rear page's mask
		var rearPage:MovieClip	= this._pages[page.index + side];
		if (rearPage != null) {
			this._drawMask(rearPage.pageMask, 3-range.type, range.a, range.b);
			tempMC		=	rearPage.pageMask;
			tempMC._y			= top > 0 ? 0 : height;
			tempMC._yscale		= top * 100;
		}
		//adjust opposite page's shade
		var oppoPage:Object 	= this._pages[page.index - side];
		if (oppoPage.shade != null) {
			oppoPage.shadeRatio	= ratio;
			tempMC		=	oppoPage.shade;
			tempMC._x			= -shade._x;
			tempMC._y			= top > 0 ? 0 : height;
			tempMC._rotation	= -shade._rotation;
			tempMC._xscale		= -shade._xscale;
			tempMC._yscale		= shade._yscale;
			tempMC._alpha		= shade._alpha;

		}
		dispatchEvent({type:"onAdjustPage", page:page, range:range});
		
	};

	/**
	* get the mask range according to the right page's top corner at the specified position
	* @param x
	* @param y
	*/
	private function _getMaskRange(x:Number, y:Number):Object {
		var width:Number		= this._pageWidth;
		var height:Number		= this._pageHeight;
		//adjust x, y to be in the valid range
		var dTop:Number		= Math.sqrt(x*x + y*y);
		if (dTop > width) {
			x			*= width / dTop;
			y			*= width / dTop;
		}
		var dBottom:Number		= Math.sqrt(x*x + (y-height) * (y-height));
		var diagonal:Number	= Math.sqrt(width*width + height*height);
		if (dBottom > diagonal) {
			x			*= diagonal / dBottom;
			y			= (y-height) * diagonal / dBottom + height;
		}
		//calculate the range
		var w_x:Number				= width - x;
		var range:Object			= {x:x, y:y,b:0};
		if (w_x == 0) {
			range.type			= 0;	//corner type, 0:triangle, 1:quadrangle
			range.a				= 0;	//side width of the corner
			range.b				= 0;
			range.angle			= 0;	//page rotation angle
			range.sin			= 0;	//sin, cos of page rotation angle
			range.cos			= 1;
			range.angle2		= 45;	//shade rotation angle
			range.length		= 0;	//length of the boundary
		} else {
			range.a				= (w_x + y*y / w_x) / 2;
			range.angle			= Math.atan2(y, w_x - range.a);
			range.sin			= Math.sin(range.angle);
			range.cos			= Math.cos(range.angle);
			range.angle			*= 180/Math.PI;
			if (w_x*w_x + (y-height)*(y-height) <= height*height) {
				range.type		= 0;
				range.b			= range.a * w_x / y + range.a * 0.005;
				range.angle2	= Math.atan2(range.b, range.a) * 180/Math.PI;
				range.length	= Math.sqrt(range.a*range.a + range.b*range.b);
			} else {
				range.type		= 1;
				range.b			= range.a - height * y / w_x + (range.a + range.b) * 0.005;
				range.angle2	= Math.atan2(height, range.a - range.b) * 180/Math.PI;
				range.length	= Math.sqrt(height*height + (range.a-range.b) * (range.a-range.b));
			}
		}
		return range;
	};

	/**
	* draw mask with specified type, a, b is the side width of the corner
	* @param mask
	* @param type
	* @param a
	* @param b
	*/
	private function _drawMask(mask:MovieClip, type:Number, a:Number, b:Number):Void {
		var w:Number	= this._pageWidth;
		var h:Number	= this._pageHeight;
		mask.clear();
		mask.beginFill(0, 30);
		//mask.lineStyle(1,0xffff00,100);
		mask.moveTo(type <= 1 || type > 10 ? 0 : w, 0);
		mask.lineTo(type > 10 ? w - a : a, 0);
		switch (type) {
		case 0:		//triangle (flip page)
			mask.lineTo(0, b);
			break;
		case 1:		//quadrangle (flip page)
			mask.lineTo(b, h);
			mask.lineTo(0, h);
			break;
		case 2:		//quadrangle
			mask.lineTo(b, h);
			break;
		case 12:	//quadrangle2
			mask.lineTo(w - b, h);
			break;
		case 3:		//pentagon
			mask.lineTo(0, b);
			mask.lineTo(0, h);
			break;
		case 13:	//pentagon2
			mask.lineTo(w, b);
			mask.lineTo(w, h);
			break;
		}
		if (type > 1) {
			mask.lineTo(type < 10 ? w : -w, h);
			mask.lineTo(type < 10 ? w : -w, 0);
		}
		if (type <= 1 || type > 10) mask.lineTo(0, 0);
		mask.endFill();
	};

	/**
	* reset the flip areas in the specified page
	* @param page
	*/
	private function _setFlipArea(page:MovieClip):Void {
		var name1:Array		=	null;
		if (page.side < 0) {
			name1	= ["leftTopInner", "leftBottomInner", "leftTop", "leftBottom"];
		} else {
			name1	= ["rightTopInner", "rightBottomInner", "rightTop", "rightBottom"];
		}
		var name2:Array			= ["faTopInner", "faBottomInner", "faTop", "faBottom"];
		var width:Number		= -page.side * this._flipSize.width / 100 * this._pageWidth;
		var height:Number		= this._flipSize.height / 100 * this._pageHeight;
		var innerWidth:Number	= -page.side * this._flipSize.innerWidth / 100 * this._pageWidth;
		var innerHeight:Number	= this._flipSize.innerHeight / 100 * this._pageHeight;
		
		for (var i:Number = 0; i < 4; i++) {
			if (_flipArea[name1[i]]) {
				var fa:MovieClip		= page[name2[i]];
				if (fa == null) {
					//如果为第一页或最后一页,则按键不能使用
					var pageNum:Number	=	Number(page._name.substr(4));
					if(pageNum==Math.floor(_firstPage/2)*2 || pageNum==Math.floor(_lastPage/2)*2+1){
						continue;
					}
					fa		= page[name2[i]] = page.face.attachMovie("HotArea", 
									"FlipArea"+i, _flipAreaDepth+i,{_alpha:0});
					fa.onPress			= _faPress;
					fa.onRelease		= _faRelease;
					fa.onReleaseOutside	= _faRelease;
					fa.enabled			= _active;
				}
				fa._y		= i%2 == 0 ? 0 : _pageHeight;
				fa._xscale	= i > 1 ? width : innerWidth;
				fa._yscale	= (i%2 == 0 ? 1 : -1) * (i > 1 ? height : innerHeight);
			} else if (page[name2[i]] != null) {
				page[name2[i]].removeMovieClip();
				page[name2[i]]			= null;
			}
		}
		
		dispatchEvent({type:"onSetFlipArea",page:page});
	};

	/**
	* adjust the size of the flip areas in the specified page
	* @param page
	*/
	private function _adjustFlipSize(page:Object):Void {
		var name:Array				= ["faTopInner", "faBottomInner", "faTop", "faBottom"];
		var pageHeight:Number		= this._pageHeight;
		var width:Number			= -page.side * this._flipSize.width / 100 * this._pageWidth;
		var height:Number			= this._flipSize.height / 100 * pageHeight;
		var innerWidth:Number		= -page.side * this._flipSize.innerWidth / 100 * this._pageWidth;
		var innerHeight:Number		= this._flipSize.innerHeight / 100 * pageHeight;
		for (var i:Number = 0; i < 4; i++) {
			var fa			= page[name[i]];
			if (fa == null) continue;
			fa._y			= (i%2 == 0 ? 0 : pageHeight) - (page.position.top < 0 ? pageHeight : 0);
			fa._xscale		= i > 1 ? width : innerWidth;
			fa._yscale		= (i%2 == 0 ? 1 : -1) * (i > 1 ? height : innerHeight);
		}
	};

	/**
	* onPress event handler of flip areas
	*/
	private function _faPress():Void {
		this._parent._parent.main.startFlip(this._parent._parent.index,
			{FlipArea0:"topInner", FlipArea1:"bottomInner", FlipArea2:"top", FlipArea3:"bottom"}[this._name]);
			
	};

	//onPress event handler of flip areas
	private function _faRelease():Void {
		this._parent._parent.main.stopFlip(this._parent._parent.index);
	};

	/**
	* onMouseMove event handler
	*/
	private function _onMouseMove():Void {
		var mx:Number	= this._xmouse;
		var my:Number	= this._ymouse;
		for (var i:String in this._flipPages) {
			var pos:Object			= this._pages[i].position;
			if (pos.trackMouse) {
				pos.aimX	= mx;
				pos.aimY	= my;
			}
		}
	};

	/**
	* adjust position according to the neighbour pages
	* @param page
	*/
	private function _adjustPagePos(page:MovieClip):Void {
		var pos:Object			= page.position;
		if (pos == null){
			return;
		};
		var range:Object		= this._getMaskRange(-page.side*pos.x, 
									pos.top>0 ? pos.y : this._pageHeight-pos.y);
		var innerRange:Object	= this._flipPages[page.index + 2*page.side].position.range;
		var outterRange:Object	= this._flipPages[page.index - 2*page.side].position.range;
		var a:Number			= range.a;
		var b:Number			= range.b;
		var type:Number		= range.type;
		if (innerRange != null) {
			if (a > innerRange.a){
				a = innerRange.a;
			}
			if (type > innerRange.type) {
				type	= innerRange.type;
				b		= innerRange.b;
			} else if (type == innerRange.type && b > innerRange.b) {
				b		= innerRange.b;
			}
		}
		if (outterRange != null) {
			if (a < outterRange.a) a = outterRange.a;
			if (type < outterRange.type) {
				type	= outterRange.type;
				b		= outterRange.b;
			} else if (type == outterRange.type && b < outterRange.b) {
				b		= outterRange.b;
			}
		}
		if (a == range.a && b == range.b && type == range.type) {
			pos.range	= range;
		} else {
			var angle:Number	= (type == 0 ? Math.atan2(b, a) : 
									Math.atan2(this._pageHeight, a - b)) * 2;
			pos.range	= this._getMaskRange(this._pageWidth - a * 
									(1-Math.cos(angle)), a * Math.sin(angle));
		}
		_adjustPage(page);
	};

	/**
	* set the settings of boundary shade or page shadow
	* @param name
	* @param value
	*/
	private function _shadeSetting(name:String, value:Object):Void {
		var mcName:Object		= {_shade:"shade", _pageShadow:"shadow"}[name];
		var setting		= this[name];
		if (value.show != null) setting.show = value.show ? true : false;
		if (value.color != null) setting.color = parseInt(value.color) & 0xffffff;
		var rangeName	= {sizeMin:0, sizeMax:1, alphaMin:2, alphaMax:3};
		for (var i:String in rangeName) {
			if (value[i] != null) setting[i] = value[i] > 0 ? Number(value[i]) : 0;
		}
		var width:Number		= this._pageWidth;
		for (var i:String in this._pages) {
			var page	= this._pages[i];
			var mc		= page[mcName];
			if (!setting.show && mc != null) {
				mc.removeMovieClip();
				mc		= page[mcName] = null;
			}
			if (!setting.show) return;
			if (mc == null) {
				mc		= name == "_shade"
						? (page.shade = page.face.attachMovie("PageShade", "ShadeMC", this._shadeDepth))
						: (page.shadow = page.attachMovie("PageShade", "ShadowMC", this._shadowDepth));
			}
			(new Color(mc)).setRGB(setting.color);
			if (name == "_shadow") {
				mc._visible		= page.position != null;
				if (page.position == null) continue;
			}
			var ratio:Number	= page.shadeRatio;
			mc._xscale	= (ratio * setting.sizeMax + (1-ratio) * setting.sizeMin) / 100 * width * page.side;
			mc._alpha	= ratio * setting.alphaMax + (1-ratio) * setting.alphaMin;
		}
	};
	
	
	/**
	* resize the page
	* @param width
	* @param height
	*/
	public function resizePage(width:Number, height:Number):Void {
		if (width != null && !isNaN(width)){
			this._pageWidth = Number(width);
		}
		if (height != null && !isNaN(height)){
			this._pageHeight = Number(height);
		}
		var width:Number	= this._pageWidth;
		var height:Number	= this._pageHeight;
		var dx:Number		= this._adjustEvenPage ? 0 : width;
		for (var i:String in this._pages) {
			if (this._flipPages[i] != null) continue;
			var page:MovieClip		= this._pages[i];
			page.page._x	= dx * -page.side;
			if (page.rearPage != null){
				page.rearPage._x = dx * -page.side;
			}
			this._adjustPage(page);
			this._adjustFlipSize(page);
			
			dispatchEvent({type:"onResizePage",page:page,width:height,height:height});
		}
		for (var i:String in this._flipPages){
			var page:MovieClip		= this._pages[i];
			page.page._x	= dx * -page.side;
			if (page.rearPage != null){
				page.rearPage._x = dx * -page.side;
			}
			var pos:Object			= page.position;
			if (pos.top < 0) {
				page.page._y		= -height;
				page.rearPage._y	= -height;
			}
			if (pos.trackMouse == null) {
				pos.aimX	= width * (pos.x < 0 ? -1 : 1);
				pos.aimY	= pos.top > 0 ? 0 : height;
			}
			this._adjustPagePos(page);
			this._adjustFlipSize(page);
			dispatchEvent({type:"onResizePage",page:page,width:height,height:height});
		}
	};

	/**
	* set the sizes of the flip areas
	* @param width if width is object, it would ignore other parameters
	* @param height
	* @param innerWidth
	* @param innerHeight
	*/
	public function setFlipSize(width:Object, height:Number, innerWidth:Number,
													innerHeight:Number):Void {
		var flipSize:Object	= typeof(width) == "object" ? width
						: {width:width, height:height, innerWidth:innerWidth, innerHeight:innerHeight};
		for (var i:String in this._flipSize) {
			if (flipSize[i] != null && !isNaN(flipSize[i])) this._flipSize[i] = Number(flipSize[i]);
		}
		for (var i:String in this._pages){
			this._adjustFlipSize(this._pages[i]);
		}
	};

	/**
	* start to flip the page att the specified index by the certain corner
	* @param index
	* @param corner
	* @param aimX
	* @param aimY
	* @return Boolean
	*/
	public function startFlip(index:Number, corner:String, aimX:Number, aimY:Number):Boolean {
		//validate page
		index			= 		Math.round(index);
		var pages:Object		= this._pages;
		var page:MovieClip		= pages[index];
		if (page == null){
			return false;
		}
		var side:Number		= page.side;
		if (side < 0 ? index <= this._firstPage : index >= this._lastPage){
			return false;
		}
		var corner0:Number		= {top:1, bottom:-1, topInner:2, bottomInner:-2}[corner];
		if (corner0 == null){
			corner0 = 1;
		};
		//create new flipped page
		var width:Number		= this._pageWidth;
		var height:Number		= this._pageHeight;
		var curPage:Number		= this._curPage;
		var flipped:Number		= this._flipCount;
		var topDepth:Number	= this._topPageDepth;
		
		var i:Number	=	null;
		var f:Number	=	null;
		var top:Number	=	null;
		var n:Number	=	null;
		var m:Number	=	null;
		//trace("startFlip| flipped: "+flipped+", index: "+index);
		if (flipped != 0) {
			//there's flipped pages
			var s:Number		= flipped < 0 ? -1 : 1;
			if (index < curPage + (s<0 ? flipped*2 : 0) || index > curPage+1 + (s<0 ? 0 : flipped*2)){
				return false;
			}
			f		= curPage + (s<0 ? 0 : 1);
			top		= pages[f + s].position.top;
			if (corner0 != top * (side == s ? 1 : 2)){
				return false;
			}
			if (index == f + flipped*2) {
				//flip the outter corner page
				if (!this._multiFlip){
					return false;
				}
				flipped			= this._flipCount = flipped + s;
				n				= (this._visiblePages + flipped * s - 1) * 2;
				this._createPage(f + n * s, topDepth-n - (s<0 ? 0 : 1));
				page			= this._createPage(f-s + flipped*2, topDepth + flipped*s,
								  {x:width*s, y:top>0 ? 0 : height, top:top});
			} else if (index == f - s) {
				//flip the opposite page
				if (!this._multiFlip){
					return false;
				}
				f			= (this._curPage -= 2*s) + (s<0 ? 0 : 1);
				flipped					= this._flipCount = flipped + s;
				n			= (this._visiblePages - 1) * 2;
				m			= flipped * s * 2;
				this._createPage(f, 0);
				for (i = n+m; i >= 0; i -= 2){
					pages[f + i*s].swapDepths(topDepth-i - (s<0 ? 0 : 1));
				}
				for (i= m; i >= 2; i -= 2){
					pages[f + (i-1)*s].swapDepths(topDepth + i/2);
				}
				this._createPage(f - (1+n)*s, 0);
				for (i = 0; i <= n; i += 2){
					pages[f - (i+1)*s].swapDepths(topDepth-i - (s<0 ? 1 : 0));
				}
				page			= pages[f + s];
				page.position	= {x:-width*s, y:top>0 ? 0 : height, top:top};
				this._adjustPage(page);
			} else if (side == s) {
				//flip the flipped page
				page			= pages[index + s];
			}
		} else {
			//there's no flipped page
			listPages(_pages);
			//trace("index: "+index+", cPage: "+curPage);
			if (index < curPage || index > curPage+1){
				return false;
			}
			f		= curPage + (side<0 ? 0 : 1);
			n		= this._visiblePages * 2;
			if (Math.abs(corner0) == 1) {
				//flip at outter corner
				flipped			= this._flipCount = side;
				this._createPage(f + n * side, topDepth - n - (side<0 ? 0 : 1));
				page			= this._createPage(f + side, topDepth + 1,
								  {x:width*side, y:corner0 > 0 ? 0 : height, top:corner0});
				//_global["eTrace"](page);
			} else {
				//flip at inner corner
				flipped			= this._flipCount = -side;
				for (i = n; i >= 2; i -= 2){
					pages[f - (i-1)*side].swapDepths(topDepth-i - (side<0 ? 1 : 0));
				}
				f				= (this._curPage += 2*side) + (side<0 ? 0 : 1);
				this._createPage(f - side, topDepth + (side<0 ? -1 : 0));
				page.swapDepths(topDepth + 1);
				page.position	= {x:width*side, y:corner0 > 0 ? 0 : height, top:corner0/2};
				this._adjustPage(page);
				this._createPage(f + (n - 2) * side, 0);
				for (var i = 0; i <= n - 2; i += 2){
					pages[f + i*side].swapDepths(topDepth-i - (side<0 ? 0 : 1));
				}
			}
		}
		listPages(_pages);
		//set flipped page
		this._adjustFlipSize(page);
		var pos:Object			= page.position;
		pos.trackMouse	= aimX == null;
		pos.aimX		= aimX == null ? this._xmouse : Number(aimX);
		pos.aimY		= aimX == null ? this._ymouse : Number(aimY);
		this._flipPages[page.index]	= page;
		//this.handleEvent("onStartFlip", page);
		dispatchEvent({type:"onStartFlip",page:page});
		return true;
	};

	/**
	* stop a flipped page, if index is null, all flipped page will be stoped, 
	* side can be 'left' or 'right'
	* @param index
	* @param finish
	* @param side
	* @return true or false
	*/
	public function stopFlip(index:Number, finish:Boolean, side:String):Boolean {
		var flipped:Number			= this._flipCount;
		if (flipped == 0){
			return false;
		}
		//stop all flipped pages
		if (index == null) {
			if (finish) {
				while (this._flipCount != 0) {
					for (var i:String in this._flipPages){
						this.stopFlip(Number(i), true);
					}
				}
			} else {
				for (var i:String in this._flipPages){
					this.stopFlip(Number(i));
				}
			}
			return true;
		}
		//set the aim position
		index		= Math.round(index);
		index		-= flipped < 0 ? (index%2 == 0 ? 1 : 0) : (index%2 == 0 ? 0 : -1);
		var page:MovieClip	= this._flipPages[index];
		var pos:Object		= page.position;
		if (pos == null){
			return false;
		}
		
		var side0:Number	=	null;
		if (pos.trackMouse != null) {
			pos.trackMouse		= null;
			side0				= {left:-1, right:1}[side];
			pos.aimX			= this._pageWidth * (side0 != null ? side0 :
															pos.x < 0 ? -1 : 1);
			pos.aimY			= pos.top > 0 ? 0 : this._pageHeight;
		}
		if (!finish) {
			dispatchEvent({type:"onStopFlip",page:page});
			return true;
		}
		//finish flipping
		side0	= page.side;
		var n:Number		= this._visiblePages * 2;
		if (pos.aimX * side0 > 0 && index == this._curPage + (side0 > 0 ? -1 : 2)) {
			//flip to the face side
			
			var pages:Object			= this._pages;
			var topDepth:Number		= this._topPageDepth;
			var m:Number				= flipped * -side0 * 2;
			this._removePage(pages[String(index + side0)]);
			this._removePage(pages[String(index + n*side0)]);
			
			for (var k:Number = n-2; k >= 0; k -= 2){
				pages[(index + k*side0)].swapDepths(topDepth-k - (side0>0 ? 1 : 0));
			}
			
			for (k = 2; k < n + m; k += 2) {
				pages[(index + (1-k)*side0)].swapDepths(topDepth-k + (side0>0 ? 2 : 1));
			}
			for (k= 2; k < m; k += 2){
				pages[(index - k*side0)].swapDepths(topDepth + k/2);
			}
			
			this._curPage		-= 2 * side0;
			this._flipCount	+= side0;
			//trace("_flipPages.removePageByIndex| index="+index);
			delete this._flipPages[String(index)];
			page.position		= null;
			this._adjustPage(page);
			this._adjustFlipSize(page);
			dispatchEvent({type:"onFinishFlip",page:page});
		} else if (pos.aimX * side0< 0 && index == this._curPage + (side0 > 0 ? 1 : 0) + flipped*2) {
			//flip to the corner side
			
			this._removePage(page);
			this._removePage(this._pages[index - (n - 1) * side0]);
			this._adjustPage(this._pages[index + side0]);
			dispatchEvent({type:"onFinishFlip",page:page});
		} else {
			return false;
		}
		
		return true;
	};

	/**
	 * set flipped page's aim position, if not given, it will be set to 
	 * track mouse
	 * @usage   
	 * @param   index 
	 * @param   aimX  
	 * @param   aimY  
	 * @return  true or false
	 */
	public function setAimPos(index:Number, aimX:Number, aimY:Number):Boolean {
		var page		= this._flipPages[int(index)];
		if (page == null){
			return false;
		}
		var pos:Object			= page.position;
		pos.trackMouse	= aimX == null;
		pos.aimX		= aimX == null ? this._xmouse : Number(aimX);
		pos.aimY		= aimX == null ? this._ymouse : Number(aimY);
		return true;
	};

	/**
	 * onEnterFrame event handler
	 */
	public function onEnterFrame():Void {
		var moveAcc:Number			= this._moveAccRatio;
		var dragAcc:Number			= this._dragAccRatio;
		for (var i:String in this._flipPages) {
			//trace([i, _flipPages[i]]);
			var page:MovieClip		= this._pages[i];
			var pos:Object			= page.position;
			
			if (pos.trackMouse == null) {
				if (moveAcc == 0){
					continue;
				}
				pos.x		+= (pos.aimX - pos.x) * moveAcc;
				if (pos.range.angle < 0 && pos.x * page.side < 0) {
					pos.y	+= (pos.aimY - pos.y) * moveAcc * 2;
				} else {
					pos.y	+= (pos.aimY - pos.y) * moveAcc;
				}
				this._adjustPagePos(page);
				dispatchEvent({type:"onMovePage",page:page,x:pos.x,y:pos.y});
				var dx:Number		= pos.aimX - pos.x;
				var dy:Number		= pos.aimY - pos.y;
				if (Math.sqrt(dx*dx + dy*dy) <= Math.abs(this.posPrecision)){
					this.stopFlip(Number(i), true);
				}
			} else {
				if (dragAcc == 0){
					continue;
				}
				pos.x		+= (pos.aimX - pos.x) * dragAcc;
				pos.y		+= (pos.aimY - pos.y) * dragAcc;
				this._adjustPagePos(page);
				dispatchEvent({type:"onDragPage",page:page,x:pos.x,y:pos.y});
			}
		}
	};

	/**
	 * goto the specified page
	 * 
	 * @param   index        
	 * @param   rebuildPages 
	 * @return  if goto page would return true, or index is null or isn't number.
	 */
	public function gotoPage(index:Number, rebuildPages:Boolean):Boolean {
		if (index == null || isNaN(index)){
			return false;
		}
		index		= Math.floor(int(index)/2) * 2;
		if (index < Math.floor(this._firstPage/2) * 2){
			index = Math.floor(this._firstPage/2) * 2;
		}
		if (index > Math.floor(this._lastPage/2) * 2){
			index = Math.floor(this._lastPage/2) * 2;
		}
		
		if (this._pretreating) {
			this._curPage		= index;
		} else if (rebuildPages) {
			for (var prop:String in this._pages){
				this._removePage(this._pages[prop]);
			}
			var visiblePages:Number	= this._visiblePages;
			var topDepth:Number		= this._topPageDepth;
			for (var i:Number = 0, j = index; i < visiblePages; i++, j-=2){
				this._createPage(j, topDepth - i*2);
			}
			for (var i:Number = 0, j = index+1; i < visiblePages; i++, j+=2){
				this._createPage(j, topDepth - i*2 - 1);
			}
			this._curPage		= index;
		} else {
			this.stopFlip(null, true);
			var curPage:Number			= this._curPage;
			this._curPage		= index;
			if (index == curPage){
				return true;
			}
			var pages:Object			= {};
			for (var prop:String in this._pages) {
				var j:Number	= Number(prop) - curPage + index;
				pages[j]		= this._pages[prop];
				pages[j].index	= j;
				pages[j]._name	= "Page" + j;
			}
			this._pages			= pages;
		}
		return true;
	};

	/**
	* set the index range of the pages
	* @param first
	* @param last
	*/
	public function setPageRange(first:Number, last:Number):Void {
		first	= first != null && !isNaN(first) ? (_firstPage = int(first)) : _firstPage;
		last	= last != null && !isNaN(last) ? (_lastPage = int(last)) : _lastPage;
		if (last < first) {
			var t	= first;
			first	= _firstPage = last;
			last	= _lastPage = t;
		}
		gotoPage(_curPage, true);
	};
	
	static public function listPages(obj:Object):Void {
		var str:String	=	"";
		var i:Number	=	0;
		var page;
		for (var prop:String in obj) {
			page	=	obj[prop];
			str		+=	i + ") [page=" +page+", index="+prop+", depth="+page.getDepth()+", side="+page.side+ "]\r";
			i++;
		}
		trace(str);
	}
}