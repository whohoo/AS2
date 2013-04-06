//******************************************************************************
//	name:	PlayBall 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Aug 23 21:38:32 GMT+0800 2006
//	description: This file was created by "playTennisBall.fla" file.
//		
//******************************************************************************


import com.idescn.as3d.Vector3D;
import com.wlash.games.chevroler.Platform;
import com.wlash.games.chevroler.TennisBall2;
import com.wlash.games.chevroler.Player;
import mx.utils.Delegate;

/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.games.chevroler.PlayBall extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip			=	null;
	private var _platform:Platform			=	null;
	private var _tennisBall2:TennisBall2	=	null;
	private var _player:Player				=	null;
	private var _interPlayer:Number		=	null;//控制按键的interval
	
	private var _gravity:Number		=	.5;
	private var _friction:Number		=	.01;
	private var _elasticity:Number		=	0.9;//
	private var _speedX:Number			=	0;
	private var _speedY:Number			=	0;
	private var _speedZ:Number			=	0;
	private var _interFly:Number		=	null;
	private var _elasticityTimes:Number	=	0;//弹跳的次数
	
	private var _interTime:Number		=	null;
	private var _timerTXT:TextField	=	null;//显示时间
	private var _curTimer:Number		=	null;
	private var _shotTimesTXT:TextField	=	null;//显示发射了多少次球
	
	private var _hitTimes:Number		=	null;
	private var _curSpeed:Number		=	60;//球移动的速度
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set speedX(value:Number):Void{
		_speedX	=	value;
	}
	/**X direction of speed */
	function get speedX():Number{
		return _speedX;
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set speedY(value:Number):Void{
		_speedY	=	value;
	}
	/**Y direction of speed */
	function get speedY():Number{
		return _speedY;
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set speedZ(value:Number):Void{
		_speedZ	=	value;
	}
	/**Z direction of speed */
	function get speedZ():Number{
		return _speedZ;
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(PlayBall.prototype);
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new PlayBall(this);]
	 * @param target target a movie clip
	 */
	public function PlayBall(target:MovieClip){
		this._target	=	target;
		this._timerTXT	=	target._parent.timer_txt;
		_shotTimesTXT	=	target._parent.shotTimes_txt;
		var s:Number	=	14;
		_platform	=	new Platform(target, //   宽,   高,   长
									new Vector3D(-12*s, 0, 12*s),//leftUp
									new Vector3D(12*s, 0, 12*s),//rightUp
									new Vector3D(12*s, 0, -12*s),//rightDown
									new Vector3D(-12*s, 0, -12*s)//leftDown
									);
		Vector3D.defaultViewDist	=	300;
		//增加网球的网,实际上,在这个游戏里算是一个背面的墙.
		_platform.addNet(new Vector3D(-12*s*2, -140, 12*s+80),//leftUp
						new Vector3D(12*s*2, -140, 12*s+80),//rightUp
						new Vector3D(12*s*2, 0, 12*s+80),//rightDown
						new Vector3D(-12*s*2, 0, 12*s+80)//leftDown
						);
		//球
		_tennisBall2	=	new TennisBall2(target);
		_tennisBall2.horizontal	=	250;//此值与translatePlatform的值相等
		_tennisBall2.vertical	=	-20;
		_tennisBall2.addEventListener("onHorizontal", this);
		_tennisBall2.addEventListener("onVertical", this);
		_tennisBall2.angleX	=	14;
		
		_player		=	new Player(target, new Vector3D(0, 200, -12*s+200));
		_player.frontLine	=	160;
		_player.backLine	=	0;
		_player.leftLine	=	-12*s;
		_player.rightLine	=	12*s;
		_player.ball		=	_tennisBall2.ball;
		_player.pBallClass	=	this;
		_player.addEventListener("onHitUpBall", this);
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
		_platform.moveTo(0, 250, 160);
		_platform.rotateX(14);
		//_player.moveTo(0, 0, 0);
		//trace(_platform.getPlatformPos());
		//测试用的,画出一个平台
		//_platform.drawMC();//z:378
		_player.render();
		//_player.drawMC();//debug
		//startGame();//debug
	}
	
	//由TennisBall2产生的事件,当球碰到地板时产生此事件.
	private function onHorizontal(evtObj:Object):Void{
		//_speedX	*=	.95;
		//_speedZ	*=	.95;
		_speedY	*=	-_elasticity;
		_elasticityTimes++;
		
		if(_elasticityTimes==1){
			//clearInterval(_interFly);//debug,第一次碰到地板时
		//TODO 这里有个BUG,有时候会出一连继激活此事件,也就是球不断地在水平线以下
		}else if(_elasticityTimes==2){//在地板上弹两次,重新再发射球
			clearInterval(_interFly);
			//当球不再动的时候
			dispatchEvent({type:"onStopBall"});
			if(_interPlayer==null)	return;
			readyShotBall();//准备再次发射
			shot(_curSpeed-1);//对于本游戏,当球被击中后弹中两次地板就消失
			
		}
		
	}
	
	//由TennisBall2产生的事件,当球碰到垂直的竖墙时产生此事件.
	private function onVertical(evtObj:Object):Void{
		clearInterval(_interFly);
		readyShotBall();
		shot(_curSpeed);
	}
	//由Player产生的事件,当球被击中时产生
	private function onHitUpBall(evtObj:Object):Void{
		if(speedZ<0){//如果连续点击,有可能球会拆返回来,所以只判断球是向人这边飞的
			speedZ	*=	-(random(10)/20+.5);
			speedX	*=	(evtObj.xDir-1)*1.2;
			speedY	*=	(evtObj.yDir-1)*1;
			
			dispatchEvent({type:"onGamePassed", hitTimes:_hitTimes});
		}
	}
	

	
	//loop事件, 被shotBall函数调用
	private function flyingBall():Void{
		var radian:Number	=	Math.atan2(_speedX, _speedZ);
		_speedX		-=	_speedX*Math.sin(radian)*_friction;
		_speedZ		-=	_speedZ*Math.cos(radian)*_friction;
		_speedY		+=	_gravity;
		_tennisBall2.moveTo(_speedX, _speedY, _speedZ);
		_tennisBall2.render();
		//clearInterval(_interFly);//debug,方便调整球的发出点.
		updateAfterEvent();
	}
	
	private function onKeyDown():Void{
		if(Key.isDown(Key.UP)){
			_player.moveTo(0, 0, 4);
			_player.moveFront();
		}else if(Key.isDown(Key.DOWN)){
			_player.moveTo(0, 0, -4);
			_player.moveFront();
		}else if(Key.isDown(Key.LEFT)){
			_player.moveTo(-4, 0, 0);
			_player.moveRight();
		}else if(Key.isDown(Key.RIGHT)){
			_player.moveTo(4, 0, 0);
			_player.moveLeft();
		}else{
			_player.moveIdle();
		}
		_player.drawMC();//debug
		_player.render();
		//_tennisBall2["_ball"]	=	_player["_player"];_tennisBall2.render();
		updateAfterEvent();
	}
	
	private function onMouseDown():Void{
		_player.swingBall();
	}
	//////计时器
	private function countDownTimer(sec:Number):Void{
		clearInterval(_interTime);
		_interTime=setInterval(Delegate.create(this, countDown), 10);
		_curTimer	=	sec;
	}
	
	private function countDown():Void{
		_curTimer	+=	1;
		if(_curTimer>=10000000){//time is up.
			_curTimer	=	0;
			clearInterval(_interTime);
			_timerTXT.text	=	"0.00.000";
			//gameFault();
			return;
		}
		_timerTXT.text	=	formatTimer();
		updateAfterEvent();
		if(!(_target instanceof MovieClip)){
			stopGame();
			clearInterval(_interFly);
		}
	}
	
	private function formatTimer():String{
		var tStr:String	=	("0000000"+_curTimer).substr(-7);
		var tArr:Array		=	tStr.split("");
		tArr.splice(4, 0, ".");
		tArr.splice(2, 0, ".");
		tStr	=	tArr.join("");
		//trace(tStr)
		return tStr;
	}
	
	private function readyShotBall():Void{
		_tennisBall2.reset();
		_elasticityTimes	=	0;
		_tennisBall2.moveTo(-17, 190, 368);
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function startGame():Void{
		_elasticityTimes	=	
		_hitTimes			=	0;
		clearInterval(_interTime);//停止计时
		clearInterval(_interPlayer);//停止移动player
		clearInterval(_interFly);
		
		_player.moveReady();//player由直立到准备姿势
		
		readyShotBall();
		shot(60);//发射球
		_interPlayer=setInterval(Delegate.create(this, onKeyDown), 15);
		Mouse.addListener(this);
		countDownTimer(0);//开始计时
	}
	
	public function stopGame():Void{
		Mouse.removeListener(this);
		clearInterval(_interTime);//停止计时
		clearInterval(_interPlayer);//停止移动player
		//clearInterval(_interFly);
		_interPlayer	=	null;//用于在当球落地后判断是否再发球[onHorizontal()]
		_player.moveStandby();
	}
	
	public function shot(speed:Number):Void{
		speed	=	speed==null ? 60 : speed;//default value
		//初始三个方向的速度
		_speedX		=	random(70)/10*(random(2)==0 ? -1 : 1);//-7 - 7
		_speedZ		=	-(random(160)/10+14);//14-23
		_speedY		=	(random(50)/10+3);//向上的初速度
		
		_interFly=setInterval(Delegate.create(this, flyingBall), speed);
		_curSpeed	=	speed;
		
		_hitTimes++;//发射了多少个球
		_shotTimesTXT.text	=	_hitTimes.toString();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "PlayBall 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
