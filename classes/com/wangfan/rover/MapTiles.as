//******************************************************************************
//	name:	MapTiles 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Sep 12 09:48:44 GMT+0800 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import mx.utils.Delegate;
import mx.transitions.Tween;

import com.wangfan.rover.MoveMap;
import com.wangfan.rover.events2.OnTweenScaleMapTo;
import com.wangfan.rover.events2.OnTileMCLoader;

/**
 * 地图游览主程序.<p></p>
 * 通过此类,控制mouse的动作操作,如点击进入放大,然后再截入相应位置的tiles<br></br>
 * 并控制着地图上的点的移动及对应的操作.
 * <p></p>
 * 当进行加载tiles时,会根据是否已经有显示的tile来确定是否用在再次加载,而以前的
 * zoomImage项目是,当mouse移动停止时,就重构整个可显示的画面,这是没必要的.<p></p>
 * <br></br>
 * <strong>NOTE: 取消放大效果,本应再重新写过一类,但考虑到其它swf中也有调用此类,
 * 所以还是在这类中修改.</strong>
 */
class com.wangfan.rover.MapTiles extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	
	private var moveMap:MoveMap			=	null;
	private var _isStop:Boolean		=	null;//游戏是否被停止了

	private var _mapMC:MovieClip		=	null;
	private var _maskMC:MovieClip		=	null;

	private var _state:Number			=	0;//0初始,1缩略图移动过程,
											//2缩略图放大过程,3大图移动过程
											//4大图移动停止状态,5加载大图中

	private var _interSync:Number		=	null;
	///////导航条上的元件
	private var _navMC:MovieClip		=	null;
	private var _navPosMC:MovieClip	=	null;//导航条上的指定框
	private var _redPointMC:MovieClip	=	null;
	
	private var _pointMapMC:MovieClip	=	null;//包含国家点的地图

	private var _posMC:MovieClip		=	null;//跟随mouse的坐标提示框
	
	/**当前游戏到几个点(关)*/
	public static var curLevel:Number	=	0;//default,current game point.
	/**地图上16个国家点,*/
	public static var LEVEL_NANE:Array	=	["英国0", "英国1", "法国0", "法国1", 
					"瑞士0", "瑞士1", "埃及0", "埃及1", "意大利0", "意大利1", 
					"卢森堡0", "卢森堡1", "奥地利0", "奥地利1", "丹麦0", "丹麦1", 
					"芬兰0", "芬兰1", "俄罗斯0", "俄罗斯1", "缅甸0", "缅甸1", 
					"泰国0", "泰国1", "印度0", "印度1", "土耳其0", "土耳其1", 
					"日本0", "日本1", "中国0", "中国1"];
	/**唯一的实例名称*/
	public static var singlone:MapTiles			=	null;
	/**现分三个阶段开放16个国家的点，前两阶段为五个国家，最后一阶段为六个国家。
	* 出现的值范围0-3，0表示全部没开放，1表示只开放第一阶段。...
	*/
	public static var openPointLevel:Number	=	null;
	
	//////////指定时间开放的提示
	private static var finalDateLevel:Number	=	null;//当前可以显示的点,也就是
	//开放国家的时间表，如果系统时间小于此时间，不要开放此点。现定义为每周开放五个国家
	//也就是十个点。
	private static var FINAL_DATE:Array	=	[
								new Date(2006, 11, 1),
								new Date(2006, 11, 8),
								new Date(2006, 11, 15)
								];
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * you cant create instance by this, to use MapTiles.getInstance(this);
	 * @param target target a movie clip
	 */
	private function MapTiles(target:MovieClip){
		//TODO DEUBG
		//_root.__gameMapFrame	=	LEVEL_NANE[curLevel-1];
		//_root.personInfo		=	{sevTime:new Date(2006,11,26), roleNum:0};
		//curLevel				=	32;
		//END DEUBG
		
		this._target	=	target;
		if(curLevel>31){
			target.gotoAndStop("gameOver");
			return;
		}
		_mapMC			=	target.map_mc;
		_maskMC			=	target.mask_mc;
		
		_navMC			=	target.nav_mc;
		_pointMapMC		=	target.pointMap_mc;
		_posMC			=	target.pos_mc;
		
		com.idescn.utils.MCmoveInOut.initialize();
		
		moveMap	=	new MoveMap(target, _mapMC, _maskMC);
		//moveMap.addEventListener("onMousePosition", this);
		singlone	=	this;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
				
		//初始化地图上国家点
		var mcPoint:MovieClip	=	_pointMapMC.points_mc;
		var mc:MovieClip		=	null;
		for(var i:Number=0;i<LEVEL_NANE.length;i++){
			mc	=	mcPoint[LEVEL_NANE[i]];
			mc.indexNum	=	i;
			initPointEvent(mc);
			mc.light_mc._visible	=	false;//默认闪光点不可见
		}
		
		//导航图,地图上的点与_mapMC的同步
		_interSync=setInterval(Delegate.create(this, onNavPosEnterFrame), 1);
		
		getFinalDateLevel();//根据服务器上的标准时间，得到finalDateLevel的值。
		
		//mcPoint._visible	=	false;
		_isStop	=	false;
		_state	=	1;//缩略图移动过程中.缩略图始终时刻总是在移动的
		
	}
	
	
	//初始化地图上点的mouse事件.
	private function initPointEvent(mc):Void{
		mc.p_mc.onRollOver=Delegate.create(mc, onPointRollOver);
		mc.p_mc.onRollOut	=
		mc.p_mc.onReleaseOutside=Delegate.create(mc, onPointRollOut);
		mc.p_mc.onRelease=Delegate.create(mc, onPointRelease);
		//mc.p_mc.enabled	=	false;
		mc.p_mc.useHandCursor	=	false;
		mc.pClass	=	this;
	}
	//地图上的点(国家)mouse响应事件
	private function onPointRollOver():Void{
		var pClass:Object	=	this["pClass"];
		this["aimPoint_mc"].moveIn();
		pClass._posMC.aimPoint_mc._visible	=	false;
	}
	private function onPointRollOut():Void{
		var pClass:Object	=	this["pClass"];
		delete this["aimPoint_mc"].onEnterFrame;
		this["aimPoint_mc"].gotoAndStop(1);
		pClass._posMC.aimPoint_mc._visible	=	true;
	}
	private function onPointRelease():Void{
		var pClass:Object	=	this["pClass"];
		pClass.stopMove();
		
		var index:Number	=	this["indexNum"];
		pClass.getFinalDateLevel();//得到finalDateLevel的值。
		
		//trace("finalDateLevel: "+finalDateLevel)
		if(index>=finalDateLevel){
			var lastTime:Date	=	FINAL_DATE[Math.floor(finalDateLevel/8)];
			this["gotoShow"](1, "将于"+lastTime.getFullYear()+"年"+
								(lastTime.getMonth()+1)+"月"+
								lastTime.getDate()+"日零点开放");
			//return;
		}else if(index>=curLevel){
			_root.showQuestion(index);
		}else{
			var arr:Array	=	pClass.getPoint(index+1);
			this["gotoShow"](2, arr[2], "X:"+arr[0]+"\tY:"+arr[1]);
		}
	}
	
	//导航图,地图上的点与_mapMC的同步
	private function onNavPosEnterFrame():Void{
		var navPosMC:MovieClip	=	_navPosMC;//导航条上的指示方块
		var xScale:Number	=	_mapMC._xscale;
		var yScale:Number	=	_mapMC._yscale;
		navPosMC._xscale	=	10000/xScale;
		navPosMC._yscale	=	10000/yScale;
		navPosMC._x			=	-_mapMC._x/xScale*5;
		navPosMC._y			=	-_mapMC._y/yScale*5;
		
		/////地图上的点
		_pointMapMC._x		=	_mapMC._x;
		_pointMapMC._y		=	_mapMC._y;
		_pointMapMC._xscale	=	xScale;
		_pointMapMC._yscale	=	yScale;
		
		var mcPoint:MovieClip	=	_pointMapMC.points_mc;
		var mc:MovieClip		=	null;
		for(var i:Number=0;i<LEVEL_NANE.length;i++){
			mc	=	mcPoint[LEVEL_NANE[i]];
			mc._xscale	=	10000/xScale;
			mc._yscale	=	10000/yScale;
		}
		//updateAfterEvent();
		
		//////////mouse跟随,并把坐标值显示
		var xMouse	=	_target._xmouse;
		var yMouse	=	_target._ymouse;
		var posObj:Object	=	{x:xMouse, y:yMouse};
		_target.localToGlobal(posObj);
		_mapMC.globalToLocal(posObj);
		var posX:String	=	(posObj.x*100).toString();
		var posY:String	=	(posObj.y*100).toString();
		_posMC.positionX_txt.text	=	"X:"+posX.substr(0,-2)+"."+posX.substr(-2);
		_posMC.positionY_txt.text	=	"Y:"+posY.substr(0,-2)+"."+posY.substr(-2);
		//根据mouse位置定义mouse样式
		mouseStyle(xMouse, yMouse);
	}
	
	private function mouseStyle(xMouse:Number, yMouse:Number):Void{
		//如果超出mask的边界,就不要显示坐标提示框
		if(xMouse<0 || xMouse>_maskMC._width || yMouse<50 || yMouse>_maskMC._height){
			_posMC._visible	=	false;
			Mouse.show();
		}else {
			//trace([xMouse, yMouse])
			if(xMouse>740 && yMouse>390){//右下角显示mouse
				_posMC._visible	=	false;//这地方主要是有个木箱在.
				Mouse.show();
			}else{
				_posMC._x	=	xMouse;
				_posMC._y	=	yMouse;
				_posMC._visible	=	true;
				Mouse.hide();
			}
		}
	}
	///////定义导航结束.....

	private function setPointEnabled(enabled:Boolean):Void{
		var mcPoint:MovieClip	=	_pointMapMC.points_mc;
		var mc:MovieClip		=	null;
		for(var i:Number=0;i<LEVEL_NANE.length;i++){
			mc	=	mcPoint[LEVEL_NANE[i]].p_mc;
			mc.enabled	=	enabled;
		}
	}
	//根据服务器上的系统时间决定开放的点
	private function getFinalDateLevel():Void{
		var fLevel:Number	=	0;
		var opLevel:Number	=	0;
		var sevTime:Date	=	_root.personInfo.sevTime;
		var len:Number	=	FINAL_DATE.length;//3
		for(var i:Number=0;i<len;i++){
			if(sevTime<FINAL_DATE[i]){//在指定日期后
				
				break;
			}else{//在指定日期前。
				fLevel	+=	10;//增加十个城市，也就是五个国家
				opLevel	+=	1;//三个阶段中增加一个阶段。
			}
			//trace([sevTime, FINAL_DATE[i], sevTime>FINAL_DATE[i]])
		}
		//因为第次增加五个国家，而最后一轮为6个国家开放，所以必须再增加2。
		finalDateLevel	=	fLevel==30? 32 : fLevel;
		openPointLevel	=	opLevel;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 停止移动的地图,也可以说是暂停移动,对地图上的操作等
	 * @param mustStop
	 */
	public function stopMove(mustStop:Boolean):Void{
		//if(mustStop!=true){
			if(_isStop)	return;
		//}
		clearInterval(_interSync);

		moveMap.stopMove();
		_isStop			=	true;
		Mouse.show();
		_posMC._visible	=	false;
		setPointEnabled(false);
	}
	/**
	 * 开始恢复移动的地图.
	 */
	public function startMove():Void{
		if(curLevel>31)	return;
		if(!_isStop)	return;
		_posMC._visible	=	true;
		_posMC.aimPoint_mc._visible	=	true;
		moveMap.startMove();
		_isStop			=	false;
		Mouse.hide();
		setPointEnabled(true);
		clearInterval(_interSync);
		_interSync=setInterval(Delegate.create(this, onNavPosEnterFrame), 1);
	}
	
	/**
	 * 定义导航条<br></br>
	 * 在地图外部的导航条,要重新定义参数,如放大缩小键与可显示的框同步.
	 * 
	 * @param   nav 
	 */
	public function setNav(nav:MovieClip):Void{
		if(curLevel>31){
			nav._visible	=	false;
			return;
		}
		_navMC		=	nav;
		_navPosMC	=	nav.position_mc;
		_redPointMC	=	_navMC.redPoint_mc;
		
		gotoPoint(curLevel);
		onNavPosEnterFrame();
	}
	
	/**
	 * 有点的地图跳到第几帧
	 * @param index
	 */
	public function gotoPoint(index:Number):Void{
		//_pointMapMC.points_mc.gotoAndStop(LEVEL_NANE[index]);
		var mcPoint:MovieClip	=	_pointMapMC.points_mc;
		mcPoint.play();
	}
	/**
	 * 当每过一关,就要把地图上的点(国家)播放,画出行走的线条.
	 */
	public function gotoNext():Void{
		var mcPoint:MovieClip	=	_pointMapMC.points_mc;
		var mc:MovieClip		=	mcPoint[LEVEL_NANE[curLevel-1]];
		mc.passed_mc._visible	=	true;
		
		switch(curLevel){
			case 8://表示埃及1后的点结束后
				mcPoint.isPlayGame	=	true;//显示过河游戏
				break;
			case 16://表示丹麦1后的国家的点
				mcPoint.isPlayGame	=	true;//显示过河游戏
				break;
			case 24://表示印度1后的点结束后，
				mcPoint.isPlayGame	=	true;//显示过河游戏
				break;
			case 32://表示中国1后的点结束后，
				stopMove(true);
				_navMC._visible		=	false;
				_target.gotoAndPlay("gameOver");
				return;
				//break;
			
		}
		
		mcPoint.play();
		
	}
	/**
	 * 得到指定的点的座标及开启下一关密室的密码
	 * 
	 * @param   index 第几个点
	 * @return  返回一个数组,[0]表示x位置,[1]表示y位置,[2]表示密码.
	 */
	public function getPoint(index:Number):Array{
		var mc:MovieClip	=	_pointMapMC.points_mc[LEVEL_NANE[index]];
		//trace("LE: "+LEVEL_NANE[index])
		var pos:Object	=	{x:mc._x, y:mc._y};
		_pointMapMC.points_mc.localToGlobal(pos);
		_pointMapMC.globalToLocal(pos);
		return [pos.x, pos.y];
	}
	
	/**
	 * 更新导航条上当前国家指示点<br></br>
	 * 当包含点(国家)地图播放时,每到一个国家,就执行一次,用于在导航图上显示位置
	 * @param index 
	 */
	public function updateNavRedPoint(index:Number):Void{
		var mc:MovieClip		=	_pointMapMC.points_mc[LEVEL_NANE[index]];
		//导航条上的当前指示点
		var pos:Object	=	{x:mc._x, y:mc._y};
		_pointMapMC.points_mc.localToGlobal(pos);
		_pointMapMC.globalToLocal(pos);
		_redPointMC._x		=	pos.x/20;
		_redPointMC._y		=	pos.y/20;
		//地图上的闪光点
		mc.light_mc._visible	=	true;
		_pointMapMC.points_mc[LEVEL_NANE[index-1]].light_mc._visible	=	false;
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "MapTiles 2.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	/**
	 * 得到唯一的实例名称
	 * @param target 当前影片引用
	 * @return 名称为MapTiles.singlone的实例
	 */
	public static function getInstance(target:MovieClip):MapTiles{
		if(singlone==null){
			singlone	=	new MapTiles(target);
		}
		return singlone;
	}
}//end class
//This template is created by whohoo.
