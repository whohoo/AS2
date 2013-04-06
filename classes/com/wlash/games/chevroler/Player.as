//******************************************************************************
//	name:	Player 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Aug 24 21:20:24 GMT+0800 2006
//	description: This file was created by "playTennisBall.fla" file.
//		一个长方体
//******************************************************************************

import com.idescn.as3d.Vector3D;
import com.wlash.games.chevroler.IObject3D;
import com.wlash.games.chevroler.PlayBall
/**
 * 这是游戏中动作员动作的类.<p></p>
 * 在这类中,你可以找到控制人物,左右前后移动
 * 并控制相应的playerMC人物影片的移动
 * <br></br>
 * 
 */
class com.wlash.games.chevroler.Player extends Object implements IObject3D{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	/**长文体的八个点, 测试时使用*/
	private var _points:Object	=	{
								frontLeftUp:null,//前左上角
								frontRightUp:null,//
								frontRightDown:null,
								frontLeftDown:null,
								backLeftUp:null,//后左上角
								backRightUp:null,
								backRightDown:null,
								backLeftDown:null
								};
	
	
	private var _player:Vector3D	=	null;
	/**人物在X轴上的转动的角度*/
	public  var angleX:Number		=	14;
	/**指向调用此类的PlayBall类*/
	public  var pBallClass:PlayBall	=	null;
	/**人物的影片*/
	public  var playerMC:MovieClip	=	null;
	/**脚离地面的高度, 无用*/
	public  var legLength:Number	=	0;
	/**用于指定身体前后距离 测试时使用*/
	public  var bodyThick:Number	=	60;
	/**用于指定身体高 测试时使用*/
	public  var bodyHeight:Number	=	100;
	/**用于指定身体宽 测试时使用*/
	public  var bodyWidth:Number	=	80;
	/**只能前行到此线*/
	public  var frontLine:Number	=	0;
	/**只能后退到此线*/
	public  var backLine:Number	=	0;
	/**只能左行到此线*/
	public  var leftLine:Number	=	0;
	/**只能右行到此线*/
	public  var rightLine:Number	=	0;
	/**TennisBall的Vector3D对象, 用于判断球是否在人的范围内*/
	public  var ball:Vector3D		=	null;
	//************************[READ|WRITE]************************************//
	
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Player.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Player(this);]
	 * @param target target a movie clip
	 * @param player 人物初始位置的Vector3D类
	 */
	public function Player(target:MovieClip, player:Vector3D){
		this._target	=	target;
		this._player	=	player;
		playerMC		=	target.attachMovie("playerMan", "mcPlayer", 3,
										{_visible:false});
		playerMC.playerClass	=	this;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		//playerMC._visible	=	true;
		playerMC.gotoAndStop("GO");
		_target.createEmptyMovieClip("mcPlayerFrame", 2);
		createPlayer();
	}
	
	//以_player为中心生成一个长方体.测试使用,
	private function createPlayer():Void{
		var v3d:Vector3D		=	null;
		var bodyThick2:Number	=	bodyThick/2;
		var bodyHeight2:Number	=	bodyHeight/2;
		var bodyWidth2:Number	=	bodyWidth/2;
		for(var prop:String in _points){
			v3d		=	_points[prop]	=	_player.getClone();
			switch(prop){
				case "frontLeftUp":
					v3d.plus(new Vector3D(-bodyWidth2, -bodyHeight2, bodyThick2));
					break;
				case "frontRightUp":
					v3d.plus(new Vector3D(bodyWidth2, -bodyHeight2, bodyThick2));
					break;
				case "frontRightDown":
					v3d.plus(new Vector3D(bodyWidth2, bodyHeight2, bodyThick2));
					break;
				case "frontLeftDown":
					v3d.plus(new Vector3D(-bodyWidth2, bodyHeight2, bodyThick2));
					break;
				
				case "backLeftUp":
					v3d.plus(new Vector3D(-bodyWidth2, -bodyHeight2, -bodyThick2));
					break;
				case "backRightUp":
					v3d.plus(new Vector3D(bodyWidth2, -bodyHeight2, -bodyThick2));
					break;
				case "backRightDown":
					v3d.plus(new Vector3D(bodyWidth2, bodyHeight2, -bodyThick2));
					break;
				case "backLeftDown":
					v3d.plus(new Vector3D(-bodyWidth2, bodyHeight2, -bodyThick2));
					break;
			}
			
		}
		
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	public function moveTo(x:Number, y:Number, z:Number):Void{
		var m:Vector3D		=	new Vector3D(x, y, z);
		var v3d:Vector3D	=	null;
		v3d	=	_player;
		//人物行走的限制
		if(v3d.z+m.z>=frontLine){
			return;
		}else if(v3d.z+m.z<=backLine){
			return;
		}
		if(v3d.x+m.x<=leftLine){
			return;
		}else if(v3d.x+m.x>=rightLine){
			return;
		}
		v3d.plus(m);
		
	}
	/**
	 * 人物左移姿势
	 */
	public function moveLeft():Void{
		var lastStatus:String	=	playerMC.status;
		var lastDir:String		=	playerMC.direction;
		playerMC.status		=	"RUN";
		playerMC.direction	=	"_L";
		if(lastDir!="_L"){
			playerMC.gotoAndPlay("RUN_START_L");
		}
	}
	/**
	 * 人物右移姿势
	 */
	public function moveRight():Void{
		var lastStatus:String	=	playerMC.status;
		var lastDir:String		=	playerMC.direction;
		playerMC.status		=	"RUN";
		playerMC.direction	=	"_R";
		if(lastDir!="_R"){
			playerMC.gotoAndPlay("RUN_START_R");
		}
	}
	/**
	 * 人物前后移姿势
	 */
	public function moveFront():Void{
		var lastStatus:String	=	playerMC.status;
		var lastDir:String		=	playerMC.direction;
		playerMC.status		=	"RUN";
		playerMC.direction	=	"";
		if(lastDir!=""){
			playerMC.gotoAndPlay("RUN_START");
		}
	}
	/**
	 * 人物返回从走动过程姿势转到准备姿势
	 */
	public function moveIdle():Void{
		var lastStatus:String	=	playerMC.status;
		var lastDir:String		=	playerMC.direction;
		playerMC.status	=	"IDLE";
		playerMC.direction	=	null;
		if(lastStatus=="RUN"){
			playerMC.gotoAndPlay("RUN_END"+lastDir);
		}
	}
	/**
	 * 人物从站立转回准备姿势
	 */
	public function moveReady():Void{
		playerMC.status		=	null;
		playerMC.direction	=	null;
		playerMC.gotoAndPlay("GO");
	}
	
	/**
	 * 人物返回站立姿势
	 */
	public function moveStandby():Void{
		playerMC.status		=	null;
		playerMC.direction	=	null;
		playerMC.gotoAndPlay("GOIDLE");
	}
	
	/**
	 * 根据球与人的位置,来判断球相对于人的位置是在哪个方位<p></p>
	 * 这里假设dir为checkBall()返回的方向数值
	 * //trace(("00000"+dir.toString(2)).substr(-6));
	 * //trace([dir>>0&3, dir>>2&3, dir>>4&3]);//前后,左右,上下
	 * //0与2表示在里边,1与3表示在外边
	 * @reutrn 方向的数值
	 */
	public function checkBall():Number{
		var v3d:Vector3D		=	_player;
		var bodyThick2:Number	=	bodyThick/2;
		var bodyHeight2:Number	=	bodyHeight/2;
		var bodyWidth2:Number	=	bodyWidth/2;
		var dir:Number			=	0;//方向
		//两位二进制表示方向[AB][AB][AB]
		//如果球在正数方向,A位数为0,如果球在负数方向,A位数为1
		//如果球在身体内,B位数为0,在体外B位数值为1
		//
		//前后
		if(v3d.z<=ball.z){//球还在player的前边
			//dir	|=	1;//00 00 00
			if(v3d.z+bodyThick2<=ball.z){
				dir	|=	1;
			}
		}else{
			dir	|=	1<<1;//00 00 ?0
			if(v3d.z-bodyThick2>=ball.z){
				dir	|=	1;
			}
		}
		//左右
		if(v3d.x<=ball.x){//球在player的右边
			//dir	|=	1<<3;//00 0? 00
			if(v3d.x+bodyWidth2<=ball.x){
				dir	|=	1<<2;
			}
		}else{
			dir |=	1<<3;//00 ?0 00
			if(v3d.x-bodyWidth2>=ball.x){
				dir	|=	1<<2;
			}
		}
		//上下
		//这个判断可选.
		if(v3d.y<=ball.y){//球在player的下边
			//dir	|=	1<<6;//0? 00 00
			if(v3d.y+bodyHeight2<=ball.y){
				dir |=	1<<4;
			}
		}else{
			dir |=	1<<5;//?0 00 00
			if(v3d.y-bodyHeight2>=ball.y){
				dir |=	1<<4;
			}
		}
		//trace(("00000"+dir.toString(2)).substr(-6));
		//trace([dir>>0&3, dir>>2&3, dir>>4&3]);//前后,左右,上下
		//0与2表示在里边,1与3表示在外边
		return dir;
	}
	
	/**
	 * 挥拍<p></p>
	 * 控制playerMC挥拍的动作
	 * 
	 */
	public function swingBall():Void{
		var dir:Number		=	checkBall();
		//var zDir:Number	=	dir>>0&3;
		var xDir:Number	=	dir>>2&3;
		//var yDir:Number	=	dir>>4&3;
		
		if(xDir<=1){//右边球
			playerMC.gotoAndPlay("SWING_B");
		}else{//左边球
			playerMC.gotoAndPlay("SWING_F");
		}
	}
	
	/**
	 * 击球<p></p>
	 * 如果击中球则广播onHitUpBall({zDir, yDir, xDir})事件
	 */
	public function hitBall():Void{
		var dir:Number		=	checkBall();
		var zDir:Number	=	dir>>0&3;
		var xDir:Number	=	dir>>2&3;
		var yDir:Number	=	dir>>4&3;
		//trace([xDir, yDir, zDir]);
		if(zDir==0){//球在前方
			//trace("zDir: "+zDir);
			if(yDir%2==0){
				//trace("yDir: "+yDir);
				if(xDir==0){//球在右
					//trace("xDir_left : "+xDir);
					//pBallClass.speedZ	*=	-1;
					dispatchEvent({type:"onHitUpBall", zDir:zDir, 
														yDir:yDir, xDir:xDir});
				}else if(xDir==2){//球在左边
					//trace("xDir_right : "+xDir);
					//pBallClass.speedZ	*=	-1;
					dispatchEvent({type:"onHitUpBall", zDir:zDir, 
														yDir:yDir, xDir:xDir});
				}
			}
		}
	}
	
	public function render():Void{
		var mc:MovieClip		=	playerMC;
		mc._visible		=	true;
		
		var v3d:Vector3D		=	_player.getClone();
		v3d.rotateX(angleX);
		var persp:Number	=	v3d.getPerspective();
		var v2d:Vector3D	=	v3d.persProjectNew(persp);
		mc._x	=	v2d.x;
		mc._y	=	v2d.y;
		mc._xscale	=	
		mc._yscale	=	persp*30;
		
		var depth:Number	=	100000-v3d.z;
		mc.swapDepths(depth);
		
	}
	
	public function drawMC():Void{
		createPlayer();
		var v3d:Vector3D		=	null;
		var point2D:Object		=	{};
		for(var prop:String in _points){
			v3d	=	_points[prop];
			v3d.rotateX(14);
			point2D[prop]	=	v3d.persProjectNew();
		}

		var mc:MovieClip	=	_target.mcPlayerFrame;
		
		mc.clear();
		
		//mc.beginFill(0x990000, 40);//前方
		mc.moveTo(point2D.frontLeftUp.x, point2D.frontLeftUp.y);
		mc.lineTo(point2D.frontRightUp.x, point2D.frontRightUp.y);
		mc.lineTo(point2D.frontRightDown.x, point2D.frontRightDown.y);
		mc.lineTo(point2D.frontLeftDown.x, point2D.frontLeftDown.y);
		mc.lineTo(point2D.frontLeftUp.x, point2D.frontLeftUp.y);
		
		
		//mc.beginFill(0x006699, 40);//背后
		mc.moveTo(point2D.backLeftUp.x, point2D.backLeftUp.y);
		mc.lineTo(point2D.backRightUp.x, point2D.backRightUp.y);
		mc.lineTo(point2D.backRightDown.x, point2D.backRightDown.y);
		mc.lineTo(point2D.backLeftDown.x, point2D.backLeftDown.y);
		mc.lineTo(point2D.backLeftUp.x, point2D.backLeftUp.y);
		
		mc.lineStyle(1, 0xffffff, 100);
		mc.beginFill(null, null);//顶
		mc.moveTo(point2D.frontLeftUp.x, point2D.frontLeftUp.y);
		mc.lineTo(point2D.backLeftUp.x, point2D.backLeftUp.y);
		mc.lineTo(point2D.backRightUp.x, point2D.backRightUp.y);
		mc.lineTo(point2D.frontRightUp.x, point2D.frontRightUp.y);
		mc.lineTo(point2D.frontLeftUp.x, point2D.frontLeftUp.y);
		
		mc.beginFill(null, null);//底
		mc.moveTo(point2D.frontLeftDown.x, point2D.frontLeftDown.y);
		mc.lineTo(point2D.backLeftDown.x, point2D.backLeftDown.y);
		mc.lineTo(point2D.backRightDown.x, point2D.backRightDown.y);
		mc.lineTo(point2D.frontRightDown.x, point2D.frontRightDown.y);
		mc.lineTo(point2D.frontLeftDown.x, point2D.frontLeftDown.y);
		mc.endFill();
		
	}
	
	public function toString():String{
		return _player.toString();
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
/*
		//控制人物行走的动作
		var isLeftRight:Boolean	=	true;
		var lastStatus:String	=	playerMC.status;
		var lastDir:String		=	playerMC.direction;
		playerMC.status		=	null;
		playerMC.direction	=	null;
		if(x>0){//右移
			playerMC.status	=	"RUN";
			playerMC.direction	=	"_R";
			if(lastDir!="_R"){
				playerMC.gotoAndPlay("RUN_START_R");
			}
		}else if(x<0){//左移
			playerMC.status	=	"RUN";
			playerMC.direction	=	"_L";
			if(lastDir!="_L"){
				playerMC.gotoAndPlay("RUN_START_L");
			}
		}else{
			isLeftRight	=	false;
		}
		
		if(isLeftRight)	return;//左右行走后不可再上下行走
		
		if(z>0){//前移
			playerMC.status	=	"RUN";
			playerMC.direction	=	"";
			if(lastDir!=""){
				playerMC.gotoAndPlay("RUN_START");
			}
		}else if(z<0){//后移
			playerMC.status	=	"RUN";
			playerMC.direction	=	"";
			if(lastDir!=""){
				playerMC.gotoAndPlay("RUN_START");
			}
		}else{//idle
			if(lastStatus=="RUN"){
				playerMC.gotoAndPlay("RUN_END"+lastDir);
			}
		}*/