//******************************************************************************
//	name:	GoBridgeMan 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 19:59:39 GMT+0800 2006
//	description: This file was created by "goBridge.fla" file.
//		direction的值有点乱！！
//******************************************************************************

import mx.utils.Delegate;
import com.wangfan.rover.GoBridge;
/**
 * 过桥的人物<p/>
 * 每个人有不现的最高速度，还有当前速度，及过完桥所要的时间<br></br>
 * 以领头大哥的速度为最高速度，跟随的后边的速度不能超过前方那位。<br></br>
 * 如果没有跟随小弟，还是以大哥的速度为最高速度。
 * 走得慢的走在前边（当大哥）。<p></p>
 * 人物有三个不同的状态，根据实际情况来决定。
 * 
 */
class com.wangfan.rover.GoBridgeMan extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _state:Number			=	0;//0，空闲，
											//1，行走
											//2，拿灯走
	private var _direction:Number		=	1;
	private var _maxSpeed:Number		=	null;//
	private var _spendTime:Number		=	0;//当前已走桥时间
	private var _totalTime:Number		=	null;//走完桥所要的时间
	private var _percentLength:Number	=	null;//根据总时间来划分桥的每一块的长度
	private var _leftStopPoint:Number	=	null;
	private var _rightStopPoint:Number	=	null;
	private var _interWalk:Number		=	null;
	private var _initPosY:Number		=	null;
	private var _secondMan2:GoBridgeMan	=	null;//secondMan的一个copy,应用于pause()方法中
	/**跟行人的速度*/
	public  var curSpeed:Number			=	null;
	/**是否为带头大哥*/
	public  var isLeader:Boolean		=	false;
	/**是否为跟随小弟*/
	public  var secondMan:GoBridgeMan	=	null;
	/**左边立柱位置*/
	public static var LEFT_LAMP_POS:Number		=	330;
	/**右边立柱位置*/
	public static var RIGHT_LAMP_POS:Number		=	700;
	/**桥的长度*/
	public static var BRIDGE_LENGTH:Number		=	RIGHT_LAMP_POS-LEFT_LAMP_POS;
	/**桥的中心点*/
	public static var CENTER_POINT:Number		=	515;//桥的中心点
	/**指向GoBridge类*/
	public static var goBridge:GoBridge		=	null;
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 * @param maxSpeed
	 * @param spendTime
	 */
	public function GoBridgeMan(target:MovieClip, maxSpeed:Number, 
											totalTime:Number){
		this._target		=	target;
		this._maxSpeed		=	maxSpeed;
		this._totalTime		=	totalTime;
		
		_initPosY			=	target._y;
		_rightStopPoint		=	target._x;
		_leftStopPoint		=	_rightStopPoint-(_rightStopPoint - CENTER_POINT)*2;
		_percentLength		=	BRIDGE_LENGTH/_totalTime;
		target.goBridgeMan	=	this;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_target.onRelease=Delegate.create(this, onManRelease);
		goWaiting();
	}
	
	private function onManRelease():Void{
		var index:Number	=	Number(_target._name.substr(3));
		_target._parent["face"+index].onRelease();
	}
	
	//core
	private function walking():Void{
		_target._x	+=	curSpeed*_direction;
		//因为桥中心的下沉，所以要加人也要相应的下沉
		moveLittleDown();
		//根据位置来判断动作
		//TODO 人物走走停停的动作没完成。
		changeAction();
	}
	
	//根据位置来判断动作
	private function changeAction():Void{
		if(_direction==1){//从左往右走
			if(_target._x>=_rightStopPoint){
				_target._xscale	*=	-1;
				_target._x	=	_rightStopPoint;
				goWaiting();
				goBridge.setPosition(this);
			}
			
			if(isLeader){
				if(_target._x>=RIGHT_LAMP_POS){//把灯放下
					if(_state==2){
						goBridge.lampMC._visible	=	true;
						goBridge.lampMC._x			=	RIGHT_LAMP_POS;
						goBridge.lampMC._xscale		=	100;
						_target.gotoAndStop("不拿手电走路");
						_state	=	1;
					}
				}else if(_target._x>=LEFT_LAMP_POS){//把灯拿起来
					if(_state==1){
						goBridge.lampMC._visible	=	false;
						_target.gotoAndStop("拿着手电走路");
						_state	=	2;
					}
				}
				
				//判断是否跟随着慢速的人
				if(secondMan!=null){
					if(secondMan["_state"]==0){
						if(_target._x - _target._width > secondMan._target._x){
							secondMan.followMan(this);
							_secondMan2	=	secondMan;
							secondMan	=	null;
						}
					}
				}
			}
		}else if(_direction==-1){//从右往左走
			if(_target._x<_leftStopPoint){
				_target._xscale	*=	-1;
				_target._x	=	_leftStopPoint;
				goWaiting();
				goBridge.setPosition(this);
			}
			
			if(isLeader){
				if(_target._x<=LEFT_LAMP_POS){//把灯放下
				
					if(_state==2){
						goBridge.lampMC._visible	=	true;
						goBridge.lampMC._x			=	LEFT_LAMP_POS;
						goBridge.lampMC._xscale		=	-100;
						_target.gotoAndStop("不拿手电走路");
						_state	=	1;
					}
				}else if(_target._x<=RIGHT_LAMP_POS){//把灯拿起来
					if(_state==1){	
						goBridge.lampMC._visible	=	false;
						_target.gotoAndStop("拿着手电走路");
						_state	=	2;
					}
				}
				//判断是否跟随着慢速的人
				if(secondMan!=null){
					if(secondMan["_state"]==0){
						if(_target._x + _target._width < secondMan._target._x){
							secondMan.followMan(this);
							_secondMan2	=	secondMan;
							secondMan	=	null;
						}
					}
				}
			}
		}
	}
	//因为桥中心的下沉，所以要加人也要相应的下沉
	private function moveLittleDown():Void{
		if(_target._x<RIGHT_LAMP_POS+20){
			if(_target._x>LEFT_LAMP_POS-20){//在桥中间
				var posX:Number	=	Math.abs(_target._x - CENTER_POINT);
				_target._y	=	_initPosY +(10 - posX*.1);
				//根据走完桥所要的时间来决定时钟的跳动
				moveTimer();
			}else{
				_target._y	=	_initPosY;
			}
		}else{
			_target._y	=	_initPosY;
		}
	}
	//根据走完桥所要的时间来决定时钟的跳动
	private function moveTimer():Void{
		if(!isLeader)	return;
		if(_spendTime>=_totalTime)	return;
		var posX:Number	=	null;
		if(_direction==1){//从左到右
			posX	=	_percentLength*(_spendTime+1)+LEFT_LAMP_POS;
			if(_target._x>=posX){
				_spendTime++;
				goBridge.timer--;
			}
		}else if(_direction==-1){//从右到左
			posX	=	_percentLength*(_totalTime-_spendTime-1)+LEFT_LAMP_POS;
			if(_target._x<=posX){
				_spendTime++;
				goBridge.timer--;
			}
		}
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 人物进入等候状态,
	*/
	public function goWaiting():Void{
		clearInterval(_interWalk);
		_target.gotoAndStop("无聊动作");
		_spendTime	=	0;
		isLeader	=	false;
		_secondMan2	=	
		secondMan	=	null;
		curSpeed	=	0;
		_state		=	0;//等候
		
	}
	/**
	* 定义此人跟随着前边走得慢的人.
	* @param	man 带头的大哥
	*/
	public function followMan(man:GoBridgeMan):Void{
		clearInterval(_interWalk);
		isLeader	=	false;
		curSpeed	=	man.curSpeed;
		_direction		*=	-1;
		_target.gotoAndStop("不拿手电走路");
		_interWalk	=	setInterval(Delegate.create(this, walking), 30);
		_state		=	1;//行走
	}
	/**
	* 行走,不带灯.在还没到桥时的行走
	*/
	public function goWithoutLamp():Void{
		clearInterval(_interWalk);
		curSpeed		=	_maxSpeed;
		_direction		*=	-1;
		_target.gotoAndStop("不拿手电走路");
		_interWalk	=	setInterval(Delegate.create(this, walking), 30);
		_state		=	1;//行走
	}
	/**
	* 行走,带灯,走在前方,且是在桥上时
	*/
	public function goWithLamp():Void{
		if(_state!=0)	return;
		curSpeed		=	_maxSpeed;
		_direction		*=	-1;
		_target.gotoAndStop("拿着手电走路");
		clearInterval(_interWalk);
		_interWalk	=	setInterval(Delegate.create(this, walking), 30);
		_state		=	2;//拿灯行走
	}
	/**
	* 游戏重新开始.
	*/
	public function reset():Void{
		clearInterval(_interWalk);
		_target._x	=	_rightStopPoint;
		_target._y	=	_initPosY;
		_target._xscale	=	100;
		_direction	=	1;
		goWaiting();
	}
	/**
	* 如果人物有小动作,会停止行走,
	* @param isPause 当为true时停止,false继续行走
	*/
	public function pause(isPause):Void{
		if(isPause){
			curSpeed				=	
			_secondMan2.curSpeed	=	0;
			_secondMan2["_target"].gotoAndStop("无聊动作");
		}else{
			curSpeed				=	
			_secondMan2.curSpeed	=	_maxSpeed;
			_secondMan2["_target"].gotoAndStop("不拿手电走路");
		}
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GoBridge ["+[_target._name, curSpeed, _maxSpeed]+"]";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
