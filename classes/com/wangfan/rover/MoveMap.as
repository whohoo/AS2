//******************************************************************************
//	name:	MoveMap 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Sep 11 16:33:31 GMT+0800 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
[IconFile("MoveMap.png")]
/**
 * 使图片(地图)在指定的mask下移动<p></p>
 * 当mouse在mask左上角时,大图片的左上角与mask的左上角重合,
 * 当mouse在mask右下角时,大图片的右下角与mask的右下角重合.<p></p>
 * 所有的影片必须左上角对齐,map_mc,mask_mc,及包含两影片的影片.<br/>
 * <pre>
 * 使用:
 * moveMap = new com.wangfan.rover.MoveMap(this, map_mc, mask_mc);

 * 方法:
 * moveMap.startMove();
 * moveMap.stopMove();
 * moveMap.getMousePos();//得到鼠标位置

 * 属性:
 * moveMap.xMove=true;//水平方向的移动.
 * moveMap.xMove=true;//垂直方向的移动.
 * moveMap.boundWidth=160;//响应边界的宽度值.
 * moveMap.boundHeight=100;//响应边边界的高度值.
 * moveMap.coeff=0.1;//缓冲移动的系数
 * moveMap.map=map_mc;//重新再定义内容的大小
 * 
 * 广播onBound(state)事件
 * state参数如下:
 * 0 0 0 0
 * 下上右左
 * </pre>
 */
class com.wangfan.rover.MoveMap extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _mapMC:MovieClip		=	null;
	private var _maskMC:MovieClip		=	null;
	
	private var _maskWidth:Number		=	0;
	private var _maskHeight:Number		=	0;
	
	private var _mapWidth:Number		=	0;
	private var _mapHeight:Number		=	0;
	
	private var _diffWidth:Number		=	0;
	private var _diffHeight:Number		=	0;
	
	private var goPosX:Number			=	0;
	private var goPosY:Number			=	0;
	private var _boundState:Number		=	0;
	private var _isMouseMove:Boolean	=	false;
	/**自定义响应边界的宽度*/
	public  var boundWidth:Number		=	160;
	/**自定义响应边界的高度*/
	public  var boundHeight:Number		=	100;
	/**缓冲移动的系数*/
	public  var coeff:Number			=	0.1;
	/**水平方向的移动*/
	public  var xMove:Boolean			=	true;
	/**垂直方向的移动*/
	public  var yMove:Boolean			=	true;
	
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=MovieClip)]
	function set map(value:MovieClip):Void{
		_mapMC			=	value;
		_mapWidth		=	value._width;
		_mapHeight		=	value._height;
		_diffWidth		=	_mapWidth-_maskWidth;
		_diffHeight		=	_mapHeight-_maskHeight;
		xMove	=	_diffWidth>0;
		yMove	=	_diffHeight>0;
	}
	/**在当中被移动的地图 */
	function get map():MovieClip{
		return _mapMC;
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set boundState(value:Number):Void{
		if(value==_boundState)	return;
		_boundState	=	value;
		dispatchEvent({type:"onBound", state:_boundState});
	}
	/**得到当前移出边界的状态 */
	function get boundState():Number{
		return _boundState;
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(MoveMap.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new MoveMap(this);]
	 * @param target target a movie clip
	 * @param map the map
	 * @param mapMask the mask
	 */
	public function MoveMap(target:MovieClip, map:MovieClip, mapMask:MovieClip){
		this._target	=	target;

		_maskWidth		=	mapMask._width;
		_maskHeight		=	mapMask._height;
		
		this.map		=	map;
		_maskMC			=	mapMask;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{

		startMove();
	}
	
	private function onMouseMove():Void{
		_isMouseMove		=	true;
		
		var posX:Number	=	_maskMC._xmouse;
		var posY:Number	=	_maskMC._ymouse;
		//边界判断
		if(posX<0){
			posX	=	0;
		}else if(posX>_maskWidth){
			posX	=	_maskWidth;
		}
		
		if(posY<0){
			posY	=	0;
		}else if(posY>_maskHeight){
			posY	=	_maskHeight;
		}
		checkBound(posX, posY);
		//移动到的位置
		goPosX	=	-posX*_diffWidth/_maskWidth;
		goPosY	=	-posY*_diffHeight/_maskHeight;
		
	}
	
	private function onMapEnterFrame():Void{
		if(!_isMouseMove)	return;
		if(xMove){
			_mapMC._x	+=	((goPosX-_mapMC._x)*coeff);
		}
		if(yMove){
			_mapMC._y	+=	((goPosY-_mapMC._y)*coeff);
		}

	}
	
	private function checkBound(posX:Number, posY:Number):Void{
		var bState		=	0;
		if(posX<boundWidth){//左
			bState	=	1;
			
		}else if(posX>_maskWidth-boundWidth){//右
			bState	=	2;
			
		}
		
		if(posY<boundHeight){//上
			bState	|=	4;
			
		}else if(posY>_maskHeight-boundHeight){//下
			bState	|=	8;
			
		}
		boundState	=	bState;
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 开始移动,响应mouse事件
	 * 
	 */
	public function startMove():Void{
		_mapMC.onEnterFrame=Delegate.create(this, onMapEnterFrame);
		onMapEnterFrame();
		Mouse.addListener(this);
	}
	
	/**
	 * 停止移动
	 */
	public function stopMove():Void{
		_mapMC.onEnterFrame	=	null;
		Mouse.removeListener(this);
		_isMouseMove	=	false;
	}
	/**
	 * 得到当前mouse在地图上的相对位置
	 * @return {x, y}
	 */
	public function getMousePos():Object{
		return {x:_mapMC._xmouse, y:_mapMC._ymouse};
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "MoveMap 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.

