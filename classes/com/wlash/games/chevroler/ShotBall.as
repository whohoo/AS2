//******************************************************************************
//	name:	ShotBall 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Aug 21 20:20:47 GMT+0800 2006
//	description: This file was created by "shotTennisBall.fla" file.
//		如果在十字准星选择的时间越长,则产生的偏差值越有可能变大
//		如果十字准星选择的时间越长,则圈子会变小,难度增加,(另一方法)
//******************************************************************************

import com.idescn.as3d.Vector3D;
import com.wlash.games.chevroler.Platform;
import com.wlash.games.chevroler.TennisBall2;
import com.wlash.games.chevroler.PresentBall;
import mx.utils.Delegate;

/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.games.chevroler.ShotBall extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _platform:Platform		=	null;
	private var _tennisBall2:TennisBall2	=	null;
	private var _targetCircleMC:MovieClip	=	null;
	private var _presentBall:PresentBall	=	null;
	
	private var _gravity:Number		=	.5;
	private var _friction:Number		=	.01;
	private var _elasticity:Number		=	0.9;//
	private var _speedX:Number			=	0;
	private var _speedY:Number			=	0;
	private var _speedZ:Number			=	0;
	private var _interFly:Number		=	null;
	private var _elasticityTimes:Number	=	0;//弹跳的次数
	
	private var _timerTXT:TextField	=	null;
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set shotTimes(value:Number):Void{
		_timerTXT.text	=	value.toString();
	}
	/**击球的次数 */
	function get shotTimes():Number{
		return Number(_timerTXT.text);
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(ShotBall.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ShotBall(this);]
	 * @param target target a movie clip
	 */
	public function ShotBall(target:MovieClip){
		this._target	=	target;
		_timerTXT	=	target._parent.timer_txt;
		
		var s:Number	=	13.8;//scale
		//网球场长宽高约值(24:11:1)
		//先定一个平面的球场,再通过移动与旋转,因为目标圆圈是依靠这个位置来平方
		//再通过与球场一样的移动与旋转来达到一样的位置.
		_platform	=	new Platform(target, new Vector3D(-11*s, -24*s, 0),//leftUp
											new Vector3D(11*s, -24*s, 0),//rightUp
											new Vector3D(11*s, 24*s, 0),//rightDown
											new Vector3D(-11*s, 24*s, 0));//leftDown
		//增加网球的网
		_platform.addNet(new Vector3D(-11*s, 0, -48),//leftUp
						new Vector3D(11*s, 0, -48),//rightUp
						new Vector3D(11*s, 0, 0),//rightDown
						new Vector3D(-11*s, 0, 0));//leftDown
		Vector3D.defaultViewDist	=	1200;
		//十字架准星
		_presentBall	=	new PresentBall(target._parent.presentBall_mc);
		_presentBall.addEventListener("onReady", this);
		//球
		_tennisBall2	=	new TennisBall2(target);
		_tennisBall2.horizontal	=	50;//此值与translatePlatform的值相等
		_tennisBall2.addEventListener("onHorizontal", this);
		_tennisBall2.angleX	=	19;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		translatePlatform();
		
		//测试用的,画出一个平台
		//_platform.drawMC();
		//startGame();//debug
	}
	
	//画一个指定样式的平台,
	private function translatePlatform():Void{
		_platform.rotateX(-71);
		_platform.moveTo(0, 50, 60);
	}
	
	//由PresentBall产生的事件,当定位完成时,输出的参数有
	//水平与垂直的百分比,及分别花费的时间.时间是用来影响偏差的(可选).
	private function onReady(evtObj:Object):Void{
		//percentX,percentY,timeX,timeY
		shot(evtObj);
	}
	
	//由TennisBall2产生的事件,当球碰到地板时产生此事件.
	private function onHorizontal(evtObj:Object):Void{
		//clearInterval(_interFly);
		//_speedX	*=	.95;
		//_speedZ	*=	.95;
		_speedY	*=	-_elasticity;
		_elasticityTimes++;
		if(_elasticityTimes==1){
			//clearInterval(_interFly);//debug
			if(evtObj.mc.hitTest(_targetCircleMC)){
				_targetCircleMC.play();
				dispatchEvent({type:"onGamePassed"});
			}else{
				dispatchEvent({type:"onGameFault"});
			}
		}else if(_elasticityTimes==3){
			clearInterval(_interFly);
			//当球不再动的时候
			dispatchEvent({type:"onBallStop"});
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
		if(!(_target instanceof MovieClip)){
			stopGame();
		};
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 开始游戏
	 */
	public function startGame():Void{
		var x:Number	=	random(370)-370/2;
		var y:Number	=	random(170)-170/2-270;
		var v3d:Vector3D	=	new Vector3D(x, y, 0);
		var v2d:Object	=	_platform.addCircle(v3d);
		_targetCircleMC	=	_target.attachMovie("targetCircle", "mcCircle", 10,
								{	_x:v2d.x,
									_y:v2d.y,
									_xscale:v2d.scale*2,
									_yscale:v2d.scale //大概的变形
								});
		_presentBall.startMoving();
		//把球初始在x,y,z位置
		//左右方向在球场中间位置, 0
		//前后方向为球网向后一半的位置, -200
		//球高约为70差不多相当于两个球网的高度, 140-70=70
		_tennisBall2.reset();
		_elasticityTimes	=	0;
		_tennisBall2.moveTo(0, 0, -360);
		_tennisBall2.render();
		//_presentBall.stopMoving();
		//shot();//debug
	}
	
	
	public function shot(obj:Object):Void{
		clearInterval(_interFly);
		//percentX,percentY,timeX,timeY
		//obj.percentX	=	1;
		//obj.percentY	=	1;
		//trace([obj.percentX, obj.percentY]);
		//**由于多花费更多的时间,所以有一定的随机数会出现偏差,时间越多,出现
		//**偏差的机会越大.
		var timeX:Number	=	Math.floor(obj.timeX/1000);//转为秒数
		var timeY:Number	=	Math.floor(obj.timeY/1000);//转为秒数
		if(timeX>0){//最大的偏差值为-0.025 | 0.025
			timeX	=	timeX>10 ? 10 : timeX;
			obj.percentX	+=	(0.0025-Math.random()*timeX*.005);
		}
		if(timeY>0){
			timeY	=	timeY>10 ? 10 : timeY;
			obj.percentY	+=	(0.0025-Math.random()*timeY*.005);
		}
		//**结束偏计算.
		
		_speedX		=	5.5*obj.percentX;//-5.5 - 5.5
		_speedZ		=	-5*obj.percentY+18;//14-23
		_speedY		=	-10;//trace([obj.percentX, obj.percentY]);
		_interFly=setInterval(Delegate.create(this, flyingBall), 30);
		shotTimes++;
	}
	
	public function stopGame():Void{
		clearInterval(_interFly);
		_presentBall.stopMoving();
	}
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "ShotBall 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
