//******************************************************************************
//	name:	ForkliftEngine 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Jun 05 22:35:55 2006
//	description: 叉车可以原地打转,并修改操作键,
//		前进的车,按下键,直接刹车,车停后,再按下键为倒车,
//		倒退的车,按上键,直接刹车,车停后,再按上键为前边.
//		限制车速的最高时速.
//******************************************************************************

import com.idescn.games.VehicleEngine;
/*
* only for Forklift Engine.
* <p></p>
* 
*/
class com.wlash.games.ForkliftEngine extends VehicleEngine{
	
	private var _braking:Number		= 0.08;		//braking,减小刹车的距离.
	private var _agility:Number		= 0.4;		//agility,提高灵敏度
	private var _hFriction:Number		= 0.8;		//hFriction,表示不会侧滑
	private var _rFriction:Number		= 0.9;		//rFriction
	
	
	private var _state:Number			=	0;
	private var _isReleaseOnce:Boolean	=	true;
	/**max accelerate*/
	public  var maxAcc:Number			=	0.05;
	/***/
	public  var accLevel:Number		=	1;
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set state(value:Number):Void{
		if(value==_state)	return;
		_state	=	value;
		dispatchEvent({type:"onState", state:_state});
		
	}
	/**y speed of vehicle */
	function get state():Number{
		return _state;
	}
	
	/**
	 * construction function
	 * @param forklift forklift a movie clip
	 */
	public function ForkliftEngine(forklift:MovieClip){
		super(forklift);
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		Key.addListener(this);
	}
	
	private function onKeyUp():Void{
		_isReleaseOnce	=	true;
	}
	
	/**
	 * check state;
	 * 
	 */
	private function checkState():Void{
		var power:Number	=	_power;
		var vState:Number	=	0;
		var hState:Number	=	0;
		if(vSpeed>power){
			vState	=	1;//前进0001:1
		}else if(vSpeed<-power){
			vState	=	1<<1;//后退0010:2
		}
		
		if(hSpeed>power){
			hState	=	1<<2;//左转0100:4
		}else if(hSpeed<-power){
			hState	=	1<<3;//右转1000:8
		}
		
		if((state	=	vState+hState)==0){
			reset();//完全停下来.
		}
	}
	
	private function checkSpeed():Void{
		vAcc	=	vAcc>maxAcc ? maxAcc : (vAcc<-maxAcc ? -maxAcc : vAcc);
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * the default drving controller
	 * 
	 */
	public function driveControl():Void {
		if (Key.isDown(Key.UP)){
			var vState	=	_state & 3;//0011
			if(vState==0){//当车停下来后
				if(_isReleaseOnce){//如果在停车状态下松开键,再按向上键,则前进.
					accelerate(accLevel);
				}
			}else if(vState==1){//前进中...
				accelerate(accLevel);
			}else if(vState==2){//倒退中...
				_isReleaseOnce	=	false;
				brake(1);
			}
		}
		if (Key.isDown(Key.DOWN)){
			var vState	=	_state & 3;//0011
			if(vState==0){//当车停下来后
				if(_isReleaseOnce){//如果在停车状态下松开键,再按向下键,则倒车.
					accelerate(-.8*accLevel);
				}
			}else if(vState==1){//前进中...
				_isReleaseOnce	=	false;
				brake(1);
			}else if(vState==2){//倒退中...
				accelerate(-.8*accLevel);
			}
			
		}
		if (Key.isDown(Key.LEFT)){
			var vState	=	_state & 3;//0011
			if(vState==0){//当车停下来后
				if(_isReleaseOnce){//如果在停车状态下松开键,再按向左键键,则原地左转圈.
					direction	-=	.08;
				}
			}else{
				_isReleaseOnce	=	false;
				turn(-1);
			}
		}
		if (Key.isDown(Key.RIGHT)){
			var vState	=	_state & 3;//0011
			if(vState==0){//当车停下来后
				if(_isReleaseOnce){//如果在停车状态下松开键,再按向右键键,则原地右转圈.
					direction	+=	.08;
				}
			}else{
				_isReleaseOnce	=	false;
				turn(1);
			}
		}
		
		run();
		render();
		checkSpeed();
		checkState();
		updateAfterEvent();
	};
	
}