//******************************************************************************
//	name:	ClickUpBall 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Aug 15 23:24:52 GMT+0800 2006
//	description: This file was created by "clickUpTennisBall.fla" file.
//		一个3D的场景上有N个球,要在指定的时间内把所有的
//		的球全部弹起来就算胜.
//******************************************************************************

import mx.utils.Delegate;
import com.idescn.as3d.Vector3D;
import com.wlash.games.chevroler.Platform;
import com.wlash.games.chevroler.TennisBall;

/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.games.chevroler.ClickUpBall extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	
	private var _platform:Platform		=	null;
	private var _tennisBall:TennisBall	=	null;
	private var _balls:Array			=	null;
	private var _amountBalls:Number	=	null;
	private var _curTimer:Number		=	null;
	private var _interTime:Number		=	null;
	//private var _interFade:Number		=	null;
	private var _curFadeBallNum:Number	=	0;
	
	private var _timerTXT:TextField	=	null;
	
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(ClickUpBall.prototype);
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ClickUpBall(this);]
	 * @param target target a movie clip
	 */
	public function ClickUpBall(target:MovieClip){
		this._target	=	target;
		_platform	=	new Platform(target, new Vector3D(-150, -300, 0),//leftUp
											new Vector3D(150, -300, 0),//rightUp
											new Vector3D(150, 300, 0),//rightDown
											new Vector3D(-150, 300, 0));//leftDown
		_timerTXT	=	target._parent.timer_txt;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
		Vector3D.defaultViewDist	=	350;
		_amountBalls	=	5;
		_balls	=	new Array(5);//初始有五个球
		_tennisBall	=	new TennisBall(_target, _balls);
		translatePlatform();
		
		//测试用的,画出一个平台
		//_platform.drawMC();
	}
	
	//画一个指定样式的平台,
	private function translatePlatform():Void{
		_platform.rotateX(90);
		_platform.moveTo(0, 70, 100);
		_platform.rotateY(5);
	}
	
	private function translateBalls():Void{
		_tennisBall.rotateX(90);
		_tennisBall.moveTo(0, 70, 100);
		_tennisBall.rotateY(5);
	}
	
	private function setBallPlace(mc:MovieClip):Void{
		mc._x	=	random(300)-150;
		mc._y	=	random(400)-200;
		//如果两球有接触,重新再放置
		if(checkTouch(mc)){
			setBallPlace(mc);
		}
	}
	//查看球是否在平面上有重叠,如果有,重新再分配位置
	private function checkTouch(mc:MovieClip):Boolean{
		var len:Number	=	_balls.length;
		for(var i:Number=0;i<len;i++){
			if(_balls[i].hitTest(mc)){
				return true;
			}
		}
		return false;
	}
	
	private function setClickEvent(mc:MovieClip):Void{
		mc.onPress=Delegate.create(mc, onBallRelease);
		mc.clickUpBall	=	this;
	}
	
	private function onBallRelease():Void{
		this["play"]();
		this["clickUpBall"].checkSpring(this);
	}
	
	//查看是否所有的球都有弹起来
	private function checkSpring(selfBall:MovieClip):Void{
		var len:Number		=	_balls.length;
		var mc:MovieClip	=	null;
		var isSpring:Boolean	=	true;
		for(var i:Number=0;i<len;i++){
			mc	=	_balls[i];
			if(mc==selfBall)	continue;
			
			if(mc._currentframe==1){
				isSpring	=	false;
				break;
			}
		}
		
		if(isSpring){//所有的球全弹起来了.
			gameSuccess();
		}
	}
	
	private function countDownTimer(sec:Number):Void{
		clearInterval(_interTime);
		_interTime=setInterval(Delegate.create(this, countDown), 1);
		_curTimer	=	sec;
	}
	
	private function countDown():Void{
		_curTimer	-=	.001;
		if(_curTimer<=0){//time is up.
			_curTimer	=	0;
			clearInterval(_interTime);
			_timerTXT.text	=	"0.000";
			gameFault();
			return;
		}
		_timerTXT.text	=	(_curTimer.toString()+"000").substr(0, 5);
		if(!(_target instanceof MovieClip)){
			stopGame();
		}
	}
	
	//when time out, game fault.
	private function gameFault():Void{
		disableClickBalls();
		dispatchEvent({type:"onGameFault", ballsNum:_balls.length});
	}
	
	private function gameSuccess():Void{
		clearInterval(_interTime);
		disableClickBalls();
		dispatchEvent({type:"onGamePassed", ballsNum:_balls.length});
		_amountBalls++;
	}
	
	private function disableClickBalls():Void{
		var len:Number	=	_balls.length;
		for(var i:Number=0;i<len;i++){
			_balls[i].enabled	=	false;
		}
	}
	
	
	private function fadeInBall():Void{
		var mc:MovieClip	=	_balls[_curFadeBallNum++];
		if(mc!=null){
			mc.onEnterFrame=Delegate.create(mc, onBallEnterFrame);
			mc.pClass	=	this;
		}else{//所有的球显示结束
			countDownTimer(2);//倒计时
		}
	}
	
	private function onBallEnterFrame():Void{
		this["_alpha"]	+=	10;
		if(this["_alpha"]>=100){
			delete this["onEnterFrame"];
			this["pClass"].fadeInBall();
		}
	}
	//消失所有的球
	private function fadeOutBall():Void{
		var mc:MovieClip	=	_balls[_curFadeBallNum++];
		if(mc!=null){
			mc.onEnterFrame=Delegate.create(mc, onBallEnterFrame2);
			mc.pClass	=	this;
		}else{//所有的球显示结束
			dispatchEvent({type:"onFadeOutBalls"});
		}
	}
	
	private function onBallEnterFrame2():Void{
		this["_alpha"]	-=	20;
		if(this["_alpha"]<=0){
			delete this["onEnterFrame"];
			this["pClass"].fadeOutBall();
		}
	}
	/**
	 * 在平台上生产num个球
	 * @param num
	 */
	private function createBalls(num:Number):Void{
		var mc:MovieClip	=	null;

		for(var i:Number=0;i<num;i++){//因为0 depth已经被一个测试的平台占用了.
			mc	=	_target.attachMovie("ball", "mcBall"+i, i+1);
			setBallPlace(mc);
			_balls[i]	=	mc;
			_tennisBall.addBall(mc);
			setClickEvent(mc);
			mc._alpha	=	0;
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	/**
	 * 开始游戏,
	 */
	public function startGame():Void{
		reset();
		createBalls(_amountBalls);//生成多少个球
		translateBalls();
		_tennisBall.render();
		fadeInBalls();
	}
	
	public function stopGame():Void{
		clearInterval(_interTime);
	}
	
	//慢慢显示所有的球
	public function fadeInBalls():Void{
		//clearInterval(_interFade);
		_curFadeBallNum	=	0;
		fadeInBall();
		//_interFade	=	setInterval(Delegate.create(this, fadeInBall), 500);
	}
	
	//慢慢消失所有的球
	public function fadeOutBalls():Void{
		//clearInterval(_interFade);
		_curFadeBallNum	=	0;
		fadeOutBall();
		//_interFade	=	setInterval(Delegate.create(this, fadeInBall), 500);
	}
	
	/**
	 * reset 数据,当再次定义球的位置时
	 */
	public function reset():Void{
		var len:Number		=	_balls.length;
		var mc:Object		=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	_balls.pop();
			mc.removeMovieClip();
		}
		_tennisBall.reset();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "ClickUpBall 1.0";
	}
	
	/*
	//debug.....
	private function onTargetMouseDown():Void{
		translatePlatform();
		_platform.drawMC();
		
		_tennisBall.render();
	}
	
	private function onTargetMouseUp():Void{
		
	}*/
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
