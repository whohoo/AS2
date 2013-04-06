//******************************************************************************
//	name:	zoomImage 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Dec 13 15:30:35 2005
//	description: level 为0时是最大的倍数,
//		存在的bug,当移到最边界时,如果要缩小图片,则会出现图片脱离可显示的边界,
//		原因:始终以中心点放大与缩小图片,故图片会移动.解决方法,每缩小一次,检查
//		图片是否移出边界,或重新定义缩放中心点位置.
//******************************************************************************

import com.idescn.loader.zoomImage.*;
import com.idescn.utils.DynamicRegistration;
import mx.events.EventDispatcher;
import mx.transitions.Tween;

/**
* zoom image class.<p></p>
* 
*/
class com.idescn.loader.ZoomImage{
	
	public	var target:MovieClip		=	null;
	private var loadUrl:String			=	null;
	
	public	var curLevel:Number		=	null;
	public	var zoomLevelMax:Number	=	null;//此值为图片可见最小
	public	var initParam:Object		=	{x:null,y:null,level:null};
	
	//private var centerPos:Object		=	{};
	private var _curPosX:Number		=	0;//图片位置,假设中间点为(0,0)
	private var _curPosY:Number		=	0;//一开始时,图片为设为居中(0,0),

	
	public  var bottomImage:MovieClip	=	null;//底层图片[0]
	private var bImageTween:Tween		=	null;//底层图片放大缩小缓冲
	public  var bImageEvents:LoadTileImageEvents2	=	null;
	private var tilesLayer:MovieClip		=	null;//上层的tiles[10]
	private var curTilesLayer:MovieClip	=	null;//在tilesLayer上的tile集合,
	
	private var tilesXML:LoadTilesInfoXML	=	null;
	private var tilesLeftUpPoint:Object	=	null;//{x:0,y:0}用来检查当图片移动时是否移出了
													//原来的位置,超出就重载tiles
	private var imageNav:ImageNavigation	=	null;
	
	public	var tileSize:Number			=	100;//方块默认大小,
	public	var bImageOriginWidth:Number	=	null;//此值会被定义,当底屋图片被加载完成时.
	public	var LEFT_UP_POINT:Object		=	null;//{x:0,y:0};此值是固定的,
									//初始化此类时固定此值.在LoadBottomImageEvents类
									//中被付值.
	public	var TILES_WIDTH_NUMBER:Number	=	0;
	public	var TILES_HEIGHT_NUMBER:Number	=	0;
	public  var MIN_WIDTH:Number			=	null;//最小的宽度,也就是可视最小边界
	public  var MAX_WIDTH:Number			=	null;
	public  var MIN_HEIGHT:Number			=	null;
	public  var MAX_HEIGHT:Number			=	null;
	private var _state:Number				=	null;//0:正常显示,1:加载tile过程中,
												//2:缩小过程,3放大过程,4移动过程
												//-1表示不能加载xml数据
	private var _remark:Remark				=	null;
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
	public	var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED	=	EventDispatcher.initialize(ZoomImage.prototype);
	
	
	//******************[READ|WIDTH]******************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set curPosX(value:Number):Void{
		
		//dispatchEvent({type:"onState", state:value});
		_curPosX	=	value;
	}
	/**current x position */
	function get curPosX():Number{
		return _curPosX;
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set curPosY(value:Number):Void{
		
		//dispatchEvent({type:"onState", state:value});
		_curPosY	=	value;
	}
	/**current y position */
	function get curPosY():Number{
		return _curPosY;
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set state(value:Number):Void{
		if(value==_state)	return;
		dispatchEvent({type:"onState", state:value});
		_state	=	value;
	}
	/**
	* 0:normal,
	* 1:loading tiles,
	* 2:zooming in,
	* 3:zooming out,
	* 4:moving
	* -1:can't load xml data
	*/
	function get state():Number{
		return _state;
	}
	
	
	/**
	* contruct function.
	* @param target    a blank movieclip that all tiles are show here.
	* @param loadUrl   the path of url.
	* @param initParam [optional] a initialize parameters, {x,y,level}
	*/
	public function ZoomImage(target:MovieClip,loadUrl:String,initParam:Object){
		if(!(target instanceof MovieClip)){
			throw new Error("must define a movie clip.");
		}else if(typeof(loadUrl)!="string"){
			throw new Error("must define a string.");
		}else if(initParam!=null){
			this.initParam	=	initParam;
		}
		
		this.target			=	target;
		this.loadUrl		=	loadUrl;
		//bImageEvents		=	new LoadBottomImageEvents(this);
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	* initialize
	*/
	private function init():Void{
		bottomImage	=	target.createEmptyMovieClip("mcBottomImage",0);
		tilesLayer	=	target.createEmptyMovieClip("mcTilesLayer",10);
		tilesXML	=	new LoadTilesInfoXML(loadUrl+"tilesInfo.xml", this);
	}

	/**
	 * load tiles one by one, when one load finish, the second would start load.
	 */
	private function loadTiles2():Void{
		var tempLayer:MovieClip	=	curTilesLayer;//临时指向curTilesLayer
		var tDepth:Number		=	tilesLayer.getNextHighestDepth();
		var tLayer:MovieClip	=	tilesLayer.createEmptyMovieClip("mcTiles"+
										tDepth, tDepth);//不同的缩放的tile放在这,
														//最新的放在最上层
		var point:Object	=	tilesLeftUpPoint	=	getFirstTilePoint();
		
		bImageEvents.init();
		bImageEvents.tLayer	=	tLayer;
		bImageEvents.point	=	point;
		///当一个加载完成后再加载另一个
		loadTile2(tLayer, point.x, point.y, false);
		
	}
	
	/**
	* load tile to (bottomImage._x+xPos,bottomImage._y+yPos);
	* @param tLayer tile layer, all tiles load it.
	* @param xPos
	* @param yPos
	* @param isLast if true, indicate the last tile are loaded.
	* @return tile read to load tile.
	*/
	private function loadTile2(tLayer:MovieClip,xPos:Number,yPos:Number,
													isLast:Boolean):MovieClip{
		//if(xPos<0 || yPos<0)	return;
		var x:Number		=	xPos/tileSize;
		var y:Number		=	yPos/tileSize;
		var tile:MovieClip	=	null;
		var depth:Number	=	tLayer.getNextHighestDepth();
		tile	=	tLayer.createEmptyMovieClip("mcTile_"+x+"_"+y, depth);
		tile._x	=	bottomImage._x+xPos;
		tile._y	=	bottomImage._y+yPos;
		
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.loadClip(loadUrl+curLevel+"/"+x+"_"+y+".jpg", tile);
		mcl.addListener(bImageEvents);
		return tile;
	}
	
	/**
	* get left-up tile(first) xPos & yPos in scale bottom image
	* @return object eg: {x:0,y:0}
	*/
	private function getFirstTilePoint():Object{
		var leftUpPoint:Object	=	{x:LEFT_UP_POINT.x, y:LEFT_UP_POINT.y};
		bottomImage.globalToLocal(leftUpPoint);
		
		var pScale:Number	=	bottomImage._xscale/100;
		var x:Number	=	leftUpPoint.x*pScale;
		var y:Number	=	leftUpPoint.y*pScale;
		
		var x1:Number	=	Math.floor(x/tileSize);
		var y1:Number	=	Math.floor(y/tileSize);
		
		return	{x:x1*tileSize, y:y1*tileSize};
	}
	
	/**
	* zoom in or out curTilesLayer image
	* @param scale 
	*/
	private function zoomTilesImage(scale:Number):Void{
		scale	+=	1;
		curTilesLayer._xscale=curTilesLayer._yscale	=	scale*curTilesLayer._xscale;
		if(!bImageEvents.loadingFinish){//如果还在加载中,刚当前加载层也要随着
									//背景层进行缩放
			var tLayer:MovieClip	=	bImageEvents.tLayer;
			tLayer._xscale=tLayer._yscale	=	scale*tLayer._yscale;
		}
	}
	
	/**
	* zoom in or out bottom image
	* @param aimWidth the width that scale to
	* @param aimHeight
	* @param isTween is tween?
	*/
	private function zoomBottomImage(aimWidth:Number, aimHeight:Number,
														isTween:Boolean):Void{
		var aimScale:Number	=	aimWidth/bImageOriginWidth*100;
		var biMC:MovieClip		=	bottomImage;
		if(!isTween){//直接跳到指定的级别,无缩放过程.
			biMC._yscale2		=	aimScale;
			var scale:Number	=	(biMC._yscale-biMC._xscale)/biMC._xscale;
			biMC._xscale2		=	aimScale;
			zoomTilesImage(scale);
			
			loadTiles();//reload tiles
			updatePosition();
			dispatchEvent({type:"onScale", scale:scale, x:_curPosX, y:_curPosY, 
														updateImageNav:true});
		}else{
			var _this:Object		=	this;
			bImageTween.begin		=	bottomImage._yscale;
			bImageTween.finish		=	aimScale;
			bImageTween.start();
		}
		_remark.removeFlags();//不要显示flags,当loadTiles加载完成时再显示
	}
	
	/**
	* move curTilesLayer image
	* @param x
	* @param y
	*/
	private function moveTilesImage(x:Number,y:Number):Void{
		curTilesLayer._x	+=	x;
		curTilesLayer._y	+=	y;
		if(!bImageEvents.loadingFinish){//如果还在加载中,刚当前加载层也要随着
									//背景层进行移动
			bImageEvents.tLayer._x	+=	x;
			bImageEvents.tLayer._y	+=	y;
		}
		updatePosition();
	}
	
	/**
	* move bottom image
	* @param x
	* @param y
	* @param isUpdateImageNav 如果为真,更新导航块,否则导航块忽略
	*/
	private function moveBottomImage(x:Number,y:Number,
												isUpdateImageNav:Boolean):Void{
		var bImageCenterPos:Object	=	{x:target._x, y:target._y};//the value is fix

		//限制图片移出可显示的框
		var bLeft:Number	=	-MIN_WIDTH/2;
		var bRight:Number	=	-bLeft-bottomImage._width;
		var bTop:Number	=	-MIN_HEIGHT/2;
		var bBottom:Number	=	-bTop-bottomImage._height;
		
		var tempX:Number	=	bottomImage._x+x;
		var tempY:Number	=	bottomImage._y+y;
		if(tempX>bLeft){
			x	=	bLeft-bottomImage._x;
		}
		if(tempX<bRight){
			x	=	bRight-bottomImage._x;
		}
		if(tempY>bTop){
			y	=	bTop-bottomImage._y;
		}
		if(tempY<bBottom){
			y	=	bBottom-bottomImage._y;
		}
		
		bottomImage._x	+=	x;
		bottomImage._y	+=	y;
		moveTilesImage(x, y);
		bottomImage.globalToLocal(bImageCenterPos);
		bottomImage.setRegistration(bImageCenterPos.x, bImageCenterPos.y);
		
		dispatchEvent({type:"onMove",x:_curPosX,y:_curPosY,
						width:bottomImage._width,height:bottomImage._height,
						updateImageNav:isUpdateImageNav});
		_remark.removeFlags();//不要显示flags,当loadTiles加载完成时再显示
	}
	
	/**
	* update position.
	* 
	*/
	private function updatePosition():Void{
		_curPosX	=	bottomImage._x + bottomImage._width/2;
		_curPosY	=	bottomImage._y + bottomImage._height/2;
	}
	
	/**
	* load bottom image (background)<br></br>
	* 
	* this method would be implemented by LoadTilesInfoXML class, when after
	* loaded XML data.
	* @param fileName wanna loading tile file name.
	* @param width
	* @param height
	*/
	private function loadBottomImage(fileName:String, width:Number, 
														height:Number):Void{
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		var url:String	=	loadUrl+fileName;
		mcl.loadClip(url, bottomImage);
		var bImageEvents:LoadBottomImageEvents	=	new LoadBottomImageEvents(this);
		bImageEvents.bWidth		=	width;
		bImageEvents.bHeight	=	height;
		mcl.addListener(bImageEvents);
		
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * initialize members, when bottom image loaded.<br></br>
	 * would be implemented by LoadBottomImageEvents.
	 * 
	 */
	public function initOnLoaded():Void{
		bImageTween	=	new Tween(bottomImage, "_yscale2",
								mx.transitions.easing.Strong.easeOut,
								100, 100, .8, true);
		bImageTween.stop();
		bImageTween.addListener(new BottomImageTweenEvents(this));
		/////定义当加载一个tile时完成的事件
		bImageEvents		=	new LoadTileImageEvents2(this);
		bImageEvents.tileSize	=	tileSize;
		bImageEvents.wLen	=	TILES_WIDTH_NUMBER+1;
		bImageEvents.hLen	=	TILES_HEIGHT_NUMBER+1;
		//可标注位置,用loadUrl区分不同图片
		_remark		=	new Remark(this, loadUrl);
		//定义可拖放的小flag
		_remark.setDNDFlag(target._parent.flag_mc);
		//定义可操作的flagList
		//不应这样设置,但如果写在外部,要写多写好几行代码,故暂时这样写
		_remark.setFlagControl(target._parent.flagList_mc);
		//读取保存的数据
		_remark.readLocal();
		
		_remark.addEventListener("onAddPoint", imageNav);
	}
	/**
	 * implement method of loadTiles1 or loadTiles2.<br></br>
	 * in fact, it is implement loadTiles1(); 
	 */
	public function loadTiles():Void{
		state	=	1;//表示正在加载tile过程...
		loadTiles2();
	}
	
	
	/////////////////////zoom///////////////
	/**
	* zoom in a level this image
	*/
	public function zoomIn():Void{
		zoom2Level(curLevel-1, false);
	}
	/**
	* zoom in a level this image
	*/
	public function zoomOut():Void{
		zoom2Level(curLevel+1, false);
	}
	
	/**
	* zoom  number level this image
	* @param vLevel 0<vLevel<zoomLevelMax
	* @param isTween 
	*/
	public function zoom2Level(vLevel:Number, isTween:Boolean):Void{
		if(vLevel>zoomLevelMax || vLevel<0 || vLevel==curLevel)		return;

		state	=	vLevel>curLevel ? 3 : 2;//3表示放大tile过程.2表示缩小过程
		curLevel	=	vLevel;
		
		zoomBottomImage(tilesXML.getImageProp(vLevel,"width"), 
							tilesXML.getImageProp(vLevel,"height"), isTween);
	}
	
	////////////////move/////////////////////////////
	/**
	* move image to position (x,y)
	* 此座标是从左上角(0,0)开始算起的.
	* 把(x,y)位置移动显示在正中间.
	* @param x
	* @param y
	* @param vLevel 在指定的级别上的座标,如果没有指定,或超出范围,
	* 则为当级别
	*/
	public function moveImageTo(x:Number,y:Number,vLevel:Number):Void{
		var x1:Number	=	null;
		var y1:Number	=	null;
		var width:Number	=	bottomImage._width;
		var height:Number	=	bottomImage._height;
		if(vLevel>zoomLevelMax || vLevel<0 || vLevel==null){
			//如果没指定level,则默认是当前层下的坐标
			x1	=	width/2 - x;
			y1	=	height/2 - y;
		}else{
			//指定层下的宽与高值.
			var cWidth:Number	=	tilesXML.getImageProp(vLevel,"width");
			var cHeight:Number	=	tilesXML.getImageProp(vLevel,"height");
			x1	=	width/2 - (x/cWidth) * width;
			y1	=	height/2 - (y/cHeight) * height;
		}
		
		moveImage(x1-_curPosX, y1-_curPosY, true)
	}
	
	/**
	* move image, 
	* 在当前级别上,相对于当前位置的移动,
	* @param x
	* @param y
	*/
	public function moveImage(x:Number,y:Number):Void{
		state	=	4;//表示移动图片状态
		
		moveBottomImage(x, y, true);
		
		var point:Object	=	getFirstTilePoint();
		if(tilesLeftUpPoint.x!=point.x || getFirstTilePoint.y!=point.y){
			loadTiles();
		}
	}
	
	/**
	* render bottom image positon and refresh tiles
	* [x,y]为图片的坐标
	* @param x
	* @param y
	* **此方法暂无使用**
	*/
	public function render(x:Number, y:Number):Void{
		_curPosX	=	x;
		_curPosY	=	y;
		var bImageCenterPos:Object	=	{x:target._x, y:target._y};//the value is fix
		bottomImage._x	=	x - bottomImage._width/2;
		bottomImage._y	=	y - bottomImage._height/2;
		bottomImage.globalToLocal(bImageCenterPos);
		bottomImage.setRegistration(bImageCenterPos.x, bImageCenterPos.y);
		loadTiles(curLevel);
	}
	
	/**
	* set image drag and drop enabled or not
	* @param enalbed
	*/
	public function setImageDND(enabled:Boolean):Void{
		if(!enabled){
			delete target.onPress;
			delete target.onRelease;
			delete target.onReleaseOutside;
			delete target.onMouseMove;
		}else{
			var _this:Object	=	this;//this class.
			target.onPress=function(){
				var pos:Object	=	{x:this._xmouse - _this._curPosX,
										y:this._ymouse - _this._curPosY};
				_this.state	=	4;//表示移动图片状态
				this.onMouseMove=function(){
					
					_this.moveBottomImage(this._xmouse - _this._curPosX-pos.x, 
										this._ymouse-_this._curPosY-pos.y, true);
					updateAfterEvent();
				}
			}
			target.onRelease=target.onReleaseOutside=function(){
				this.onMouseMove	=	null;
				_this.loadTiles(_this.curLevel);
			}
		}
	}
	
	/**
	* set navigate image box
	* @param mc that show the navigate image, if mc not MovieClip, navigate
	* would invisible.
	*/
	public function setImageNav(mc:MovieClip):Void{
		if(!mc instanceof MovieClip){//不显示导航图
			removeEventListener("onMove",imageNav);
			removeEventListener("onScale",imageNav);
		}else{
			if(imageNav==null){
				imageNav	=	new ImageNavigation(mc, loadUrl+
													"navigateImage.jpg",this);
			}
			addEventListener("onMove",imageNav);
			addEventListener("onScale",imageNav);
		}
	}
	
	/**
	 * 得到bottom image 缩放的值
	 * 
	 * @usage   
	 * @param   level 
	 * @return  
	 */
	public function getBImageScale(level:Number):Number{
		var width:Number	=	tilesXML.getImageProp(level, "width");
		return width*bottomImage._xscale/bottomImage._width;
	}
	
	
	/**
	* set mask size,
	* set mask事件在LoadBottomImageEvents类中定义
	* 暂时用不上.
	* @param scale
	*/
	public function setMaskSize(scale:Number){
		var mask:MovieClip	=	target.mcMaskImage;
		mask._xscale=mask._yscale	=	scale;
	}
	
	/**
	* 显示名称
	*/
	public function toString():String{
		return "ZoomImage 1.0";
	}
	
	/*
	* 把在tilesLayer内的座标点转为在bottomImage的座标点
	* 此方法主要是在LoadTileImageEvents中被调用.
	* @param point
	* @return new point eg:{x:0,y:0}
	
	public function tPoint2bPoint(point:Object):Object{
		curTilesLayer.localToGlobal(point);
		bottomImage.globalToLocal(point);
		return point;
		//return {x:point.x,	y:point.y};
	}
	*/
}

		/*
			biMC.onEnterFrame=function(){
				this._yscale2	+=	(aimScale-this._yscale)*.3;
				//得到bottom image影片缩放的程度,
				var scale:Number	=	(this._yscale-this._xscale)/this._xscale;
				//tileslayer随着影片缩放
				_this.zoomTilesImage(scale);
				this._xscale2	=	this._yscale;
				
				_this.updatePosition();
				_this.dispatchEvent({type:"onScale", scale:scale,
								updateImageNav:true});
								
				if(Math.abs(aimScale-this._yscale)<.1){//stop scale.
					this._width		=	aimWidth;
					this._height	=	aimHeight;
					_this.loadTiles(_this.curLevel);//reload tiles
					delete this.onEnterFrame;
				}
			}
			*/
				
	/**
	* load all tiles that can show in visible
	* 10毫秒加载一个tile.
	
	private function loadTiles1():Void{
		var tDepth:Number		=	tilesLayer.getNextHighestDepth();
		var tLayer:MovieClip	=	tilesLayer.createEmptyMovieClip("mcTiles"+
										tDepth, tDepth);//不同的缩放的tile放在这,
														//最新的放在最上层
		var point:Object	=	tilesLeftUpPoint	=	getFirstTilePoint();
		var wLen:Number	=	TILES_WIDTH_NUMBER+1;
		var hLen:Number	=	TILES_HEIGHT_NUMBER+1;
		var isLast:Boolean	=	false;
		var wCount:Number	=	0;
		var hCount:Number	=	0;
		
		var interID:Number	=	setInterval(function(_this:Object){
					var tileSize:Number	=	_this.tileSize;
					
					_this.loadTile1(tLayer, point.x+wCount*tileSize,
										point.y+hCount*tileSize, isLast);
					wCount++;
					if(wCount==wLen){
						hCount++;
						if(hCount==hLen){
							_this.curTilesLayer.removeMovieClip();//release the old tiles
							_this.curTilesLayer	=	tLayer;
							clearInterval(interID);
							_this.state	=	0;//表示正常显示状态
							return;
						}else{
							wCount	=	0;
						}
					}
					updateAfterEvent();
				},10,this);
	}
	*/
	
	/**
	* load tile to (bottomImage._x+xPos,bottomImage._y+yPos);
	* @param tLayer tile layer, all tiles load it.
	* @param xPos
	* @param yPos
	* @param isLast 如果是最后一tile就增加当完成时的事件(LoadTileImageEvents)
	* @return tile
	
	private function loadTile1(tLayer:MovieClip,xPos:Number,yPos:Number,
													isLast:Boolean):MovieClip{
		if(xPos<0 || yPos<0)	return;
		var x:Number		=	xPos/tileSize;
		var y:Number		=	yPos/tileSize;
		var tile:MovieClip	=	null;
		var depth:Number	=	tLayer.getNextHighestDepth();
		tile	=	tLayer.createEmptyMovieClip("mcTile_"+x+"_"+y, depth);
		tile._x	=	bottomImage._x+xPos;
		tile._y	=	bottomImage._y+yPos;
		
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.loadClip(loadUrl+curLevel+"/"+x+"_"+y+".jpg", tile);
		mcl.addListener(new LoadTileImageEvents(this));
		//tile.mcl	=	mcl;
		//if(isLast){
		//	var tEvents:LoadTileImageEvents	=	new LoadTileImageEvents(this);
		//	mcl.addListener(tEvents);
		//}
		//tile.loadMovie(loadUrl+curLevel+"/"+x+"_"+y+".jpg");
		return tile;
	}
	
		*/	
			