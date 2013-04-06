//******************************************************************************
//	name:	Map9 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Sep 12 09:48:44 GMT+0800 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************


import com.wangfan.rover.MoveMap;
import mx.utils.Delegate;
import mx.transitions.Tween;

import com.wangfan.rover.events.OnMovieClipLoader;
//import com.wangfan.rover.events.OnTweenReleaseArrow;
import com.wangfan.rover.events.OnTweenLoadInit;
import com.wangfan.rover.events.OnTweenThumbScale;
import com.wangfan.rover.events.OnTweenMoveMapTo;
import com.wangfan.rover.events.OnMCLmoveMapTo;

/**
 * 原来是把大图切成9大块.<p></p>
 * 去到哪个区,就加载哪一块,
 * NOTE:此类不再在rover中使用.
 */
class com.wangfan.rover.Map9 extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	
	private var moveMap:MoveMap			=	null;
	private var _loadMapMC:MovieClip	=	null;
	private var _mosaicMapMC:MovieClip	=	null;
	private var _mapMC:MovieClip		=	null;
	private var _maskMC:MovieClip		=	null;
	
	private var _mcl:MovieClipLoader	=	null;
	private var _twX:Tween				=	null;
	private var _twY:Tween				=	null;
	
	private var _widthLevel:Number		=	null;
	private var _heightLevel:Number	=	null;
	
	private var _arrowUpMC:MovieClip		=	null;
	private var _arrowDownMC:MovieClip		=	null;
	private var _arrowLeftMC:MovieClip		=	null;
	private var _arrowRightMC:MovieClip	=	null;
	
	private var _state:Number			=	0;//0初始,1缩略图移动过程,
											//2缩略图放大过程,4放大显示精确大图
											//5精确大图移动过程中
	
	private var _navMC:MovieClip		=	null;
	private var _curNavMC:MovieClip	=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Map9(this);]
	 * @param target target a movie clip
	 */
	public function Map9(target:MovieClip){
		this._target	=	target;
		_loadMapMC		=	target.loadMap_mc;
		_mosaicMapMC	=	target.mosaicMap_mc;
		_mapMC			=	target.map_mc;
		_maskMC			=	target.mask_mc;
		_arrowUpMC		=	target.arrowUp_mc;
		_arrowDownMC	=	target.arrowDown_mc;
		_arrowLeftMC	=	target.arrowLeft_mc;
		_arrowRightMC	=	target.arrowRight_mc;
		_navMC			=	target.nav_mc;
		
		com.idescn.utils.DynamicRegistration.initialize();
		com.idescn.utils.MCmoveInOut.initialize();
		
		moveMap	=	new MoveMap(target, _mapMC, _maskMC);
		moveMap.addEventListener("onBound", this);
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_mcl	=	new MovieClipLoader();
		_twX	=	new Tween(_mapMC, "_xscale2", 
						mx.transitions.easing.Strong.easeOut,
						100, 100, 1, true);
		_twX.stop();
		_twY	=	new Tween(_mapMC, "_yscale2", 
						mx.transitions.easing.Strong.easeOut,
						100, 100, 1, true);
		_twY.stop();
		_twY.addListener(OnTweenThumbScale);
		_mcl.addListener(OnMovieClipLoader);
		_mapMC.onRelease=Delegate.create(this, onMapRelease);
		_mapMC.useHandCursor	=	false;
		_arrowUpMC.onRelease=Delegate.create(this, onArrowUpRelease);
		_arrowDownMC.onRelease=Delegate.create(this, onArrowDownRelease);
		_arrowLeftMC.onRelease=Delegate.create(this, onArrowLeftRelease);
		_arrowRightMC.onRelease=Delegate.create(this, onArrowRightRelease);
		
		OnMovieClipLoader.map9		=
		//OnTweenReleaseArrow.map9	=	
		OnTweenLoadInit.map9		=	
		OnTweenThumbScale.map9		=	
		OnTweenMoveMapTo.map9		=	
		OnMCLmoveMapTo.map9			=	this;
		//初始化导航条
		//initNav();
		_state	=	1;
	}
	
	private function onMapRelease():Void{
		moveMap.stopMove();
		var pos:Object		=	moveMap.getMousePos();
		//trace([pos.x, pos.y])
		var width:Number	=	_mapMC._width/3;
		var height:Number	=	_mapMC._height/3;
		var wLevel:Number	=	Math.floor(pos.x/width);
		var hLevel:Number	=	Math.floor(pos.y/height);
		_navMC["nav"+wLevel+"_"+hLevel+"_btn"].onRelease();
	}
	//四个方向键事件
	private function onArrowUpRelease():Void{
		var wLevel:Number	=	_curNavMC.w;
		var hLevel:Number	=	_curNavMC.h-1;
		_navMC["nav"+wLevel+"_"+hLevel+"_btn"].onRelease();
	}
	private function onArrowDownRelease():Void{
		var wLevel:Number	=	_curNavMC.w;
		var hLevel:Number	=	_curNavMC.h+1;
		_navMC["nav"+wLevel+"_"+hLevel+"_btn"].onRelease();
	}
	private function onArrowLeftRelease():Void{
		var wLevel:Number	=	_curNavMC.w-1;
		var hLevel:Number	=	_curNavMC.h;
		_navMC["nav"+wLevel+"_"+hLevel+"_btn"].onRelease();
	}
	private function onArrowRightRelease():Void{
		var wLevel:Number	=	_curNavMC.w+1;
		var hLevel:Number	=	_curNavMC.h;
		_navMC["nav"+wLevel+"_"+hLevel+"_btn"].onRelease();
	}
	
	////////定义导航事件
	private function initNav():Void{
		_navMC.zoomOut_btn.onRelease=Delegate.create(this, zoomOut);
		_navMC.zoomIn_btn.onRelease=Delegate.create(this, zoomIn);
		
		var mc:MovieClip	=	null;
		for(var w:Number=0;w<3;w++){
			for(var h:Number=0;h<3;h++){
				mc	=	_navMC["nav"+w+"_"+h+"_btn"];
				mc.onRelease=Delegate.create(mc, onNavBtnRelease);
				mc.onRollOver=Delegate.create(mc, onNavBtnRollOver);
				mc.onRollOut	=
				mc.onReleaseOutside=Delegate.create(mc, onNavBtnRollOut);
				mc.pClass	=	this;
				mc.w	=	w;
				mc.h	=	h;
				mc.gotoAndStop("light");
			}
		}
	}
	//所有的都暗,除了当前的
	private function darkNav():Void{
		var mc:MovieClip	=	null;
		for(var w:Number=0;w<3;w++){
			for(var h:Number=0;h<3;h++){
				mc	=	_navMC["nav"+w+"_"+h+"_btn"];
				if(mc==_curNavMC){
					mc.moveIn();
					mc.enabled	=	false;
				}else{
					mc.moveOut();
					mc.enabled	=	true;
				}
			}
		}
	}
	//所有的都亮
	private function lightNav():Void{
		var mc:MovieClip	=	null;
		for(var w:Number=0;w<3;w++){
			for(var h:Number=0;h<3;h++){
				mc	=	_navMC["nav"+w+"_"+h+"_btn"];
				mc.moveIn();
				mc.enabled	=	true;
			}
		}
	}
	//导航上的mouse事件
	private function onNavBtnRelease():Void{
		var pClass:Object	=	this["pClass"];
		
		pClass["_curNavMC"]		=	eval(this);
		pClass["moveMapTo"](this["w"], this["h"]);
	}
	
	private function onNavBtnRollOver():Void{
		var pClass:Object	=	this["pClass"];
		if(pClass["_state"]<4)	return;//只在大图状态下方可以
		var curNavMC:MovieClip	=	pClass["_curNavMC"];
		
		curNavMC.moveOut();
		eval(this).moveIn();
		
	}
	
	private function onNavBtnRollOut():Void{
		var pClass:Object	=	this["pClass"];
		if(pClass["_state"]<4)	return;
		var curNavMC:MovieClip	=	pClass["_curNavMC"];
		curNavMC.moveIn();
		eval(this).moveOut();
		
	}
	///////定义导航结束.....
	
	//当是小图情况下
	private function moveMapTo(wLevel:Number, hLevel:Number):Void{
		var isThumb:Boolean	=	null;
		switch(_state){
			//case 0:
			//	break;
			case 1:
			case 2:
				isThumb	=	true;
				break;
			case 3:
				return;
			case 4:
			case 5:
				_mapMC._visible	=	true;
				//设置导航图显示状态
				darkNav();
				isThumb	=	false;
				break;
			default:
				trace("moveMapTo , _state: "+_state);
		}
		
		moveMap.stopMove();
		//九块区域左上角对齐
		var width:Number	=	_mapMC._width/3;
		var height:Number	=	_mapMC._height/3;
		var posX:Number	=	wLevel*width;
		var posY:Number	=	hLevel*height;
		if(isThumb){
			if(wLevel==2){//因为可显示的区域比缩略的三分之一还要大,
				posX	-=	_maskMC._width-width;
			}
			scaleMapTo(posX, posY);
		}else{
			_mapMC._x	=	_loadMapMC._x-_mapMC.xreg*5;
			_mapMC._y	=	_loadMapMC._y-_mapMC.yreg*5;
		
		//trace("posX, posY: "+[posX, posY]);
		//trace("_mapMC.xreg, _mapMC.yreg: "+[_mapMC.xreg, _mapMC.yreg]);
		//trace([_mapMC._x, _mapMC._y]);
		var twX:Tween	=	new Tween(_mapMC, "_x", 
						mx.transitions.easing.Strong.easeIn,
						_mapMC._x, -posX, 1.5, true);
		var twY:Tween	=	new Tween(_mapMC, "_y", 
						mx.transitions.easing.Strong.easeIn,
						_mapMC._y, -posY, 1.5, true);
		OnTweenMoveMapTo.xReg		=	posX;
		OnTweenMoveMapTo.yReg		=	posY;
		OnTweenMoveMapTo.isThumb	=	isThumb;
		twY.addListener(OnTweenMoveMapTo);
		}
		//加载mosaic图片
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.addListener(OnMCLmoveMapTo);
		OnMCLmoveMapTo.isLoaded		=	false;
		//在移动的过程中就开始利用时间加载mosaic图片,当图片放大完成时才显示mosaic
		mcl.loadClip("maps/Mosaic_map"+wLevel+"_"+hLevel+".jpg", 
												_mosaicMapMC.mosaicLoad_mc);
		_widthLevel		=	wLevel;
		_heightLevel	=	hLevel;
		
		_state	=	2;//移动过程中...
	}
	
	//在移动图片完成后,开始放大图片
	private function scaleMapTo(xreg:Number, yreg:Number):Void{
		_mapMC.xreg	=	xreg;
		_mapMC.yreg	=	yreg;
		
		_twX.begin	=	_mapMC._xscale;
		_twX.finish	=	500;
		_twX.start();
		_twY.begin	=	_mapMC._yscale;
		_twY.finish	=	500;
		_twY.start();
		//表示现在的状态是把缩略图放大
		OnTweenThumbScale.isZoomOut	=	true;
		//设置导航图显示状态
		darkNav();
		_state	=	3;//缩放过程中...
	}
	
	//MoveMap mouse 移到边界事件
	private function onBound(evtObj:Object):Void{
		if(_state<4)		return;//在缩略图状态,忽略mouse移动到边界事件
		
		var boundNum:Number	=	evtObj.state;
		var leftRight:Number	=	boundNum & (1<<0 | 1<<1);
		var upDown:Number		=	boundNum>>2;
		//trace([boundNum, leftRight.toString(2), upDown.toString(2)])
		//trace(["hLevel:"+_heightLevel, "wLevel:"+_widthLevel]);
		if(leftRight==1){//左
			if(_widthLevel!=0){
				_arrowLeftMC.moveIn();
			}
		}else if(leftRight==2){//右
			if(_widthLevel!=2){
				_arrowRightMC.moveIn();
			}
		}else{//中间
			_arrowLeftMC.moveOut();
			_arrowRightMC.moveOut();
		}
		
		if(upDown==1){//上
			if(_heightLevel!=0){
				_arrowUpMC.moveIn();
			}
		}else if(upDown==2){//下
			if(_heightLevel!=2){
				_arrowDownMC.moveIn();
			}
		}else{//中间
			_arrowUpMC.moveOut();
			_arrowDownMC.moveOut();
		}
	}
	
	//如果mosaic图也加载完成了,就开始显示此图
	private function showMosaic():Void{
		_mosaicMapMC._visible	=	true;
		if(OnMCLmoveMapTo.isLoaded){
			if(_state==4){
				//奇怪的问题!!如果是播放到结束,mask就没有效果
				_mosaicMapMC.moveIn(9, Delegate.create(this, loadMap));
			}
		}
	}
	
	private function onShowMosaic():Void{
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 加载大图
	 */
	public function loadMap():Void{
		_mcl.loadClip("maps/map"+_widthLevel+"_"+_heightLevel+".swf", _loadMapMC);
	}
	
	/**
	 * 返回缩略图的浏览方式
	 */
	public function zoomOut():Void{
		if(_state<4)	return;//不在显示大图时
		moveMap.stopMove();
		
		_mapMC._visible		=	true;
		var width:Number	=	_mapMC._width/3;
		var height:Number	=	_mapMC._height/3;
		//_mapMC.xreg	=	(_widthLevel*width+width/2)/5;
		//_mapMC.yreg	=	(_heightLevel*height+height/2)/5;
		//trace([_mapMC.xreg, _mapMC.yreg])
		_twX.begin	=	_mapMC._xscale;
		_twX.finish	=	100;
		_twX.start();
		_twY.begin	=	_mapMC._yscale;
		_twY.finish	=	100;
		_twY.start();
		//表示现在的状态是把缩略图缩小
		OnTweenThumbScale.isZoomOut	=	false;
		_loadMapMC._visible			=	false;
		
		_arrowUpMC.moveOut();
		_arrowRightMC.moveOut();
		lightNav();
		_state	=	3;//缩小过程中

	}
	/**
	 * 放大图片
	 */
	public function zoomIn():Void{
		if(_state>2)	return;//在放大过程或放大的状态不可以再放大
		_curNavMC.onRelease();
	}
	/**
	 * 设定导航条
	 * @param nav
	 */
	public function setNav(nav:MovieClip):Void{
		_navMC	=	nav;
		initNav();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "Map9 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
