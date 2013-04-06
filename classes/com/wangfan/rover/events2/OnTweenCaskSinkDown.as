//******************************************************************************
//	name:	OnTweenCaskSinkDown
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sun Oct 08 15:06:01 2006
//	description: 
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.GoRiver;
import mx.utils.Delegate;
/**
 * 木桶周期性的下沉与上浮.<p></p>
 * 并判断如果有人正好跳到上方的处理方法
 */
class com.wangfan.rover.events2.OnTweenCaskSinkDown extends Object{
	static public var goRiver:GoRiver	=	null;
	private var _inter:Number			=	null;
	private var _interTime:Array		=	null;
	private var _tw:Tween				=	null;
	private var _target:MovieClip		=	null;
	/**当桶浮起来后，必须停止下沉*/
	public  var mustStop:Boolean		=	null;
	
	/**
	 * 构造函数
	 * 
	 */
	public function OnTweenCaskSinkDown(target:MovieClip){
		_target		=	target;
		_interTime	=	[random(3)+2, random(3)+2];
		target.onTweenCaskSinkDown	=	this;
	}
	
	/**上或下的方向,0:向上移动,1:向下移动*/
	public  var dir:Number				=	1;
	
	private function onMotionChanged(tw:Tween):Void{
		if(tw.getPosition()>100){//在这位置,波浪不可见
			tw.obj._parent._parent.wave_mc._visible	=	false;
		}else{
			tw.obj._parent._parent.wave_mc._visible	=	true;
		}
		var mc:MovieClip	=	tw.obj._parent._parent;
		if(goRiver["_state"]==1){//如果人物已经站到木桶的位置了
			var mc:MovieClip	=	tw.obj._parent._parent;
			if(goRiver["_curCask"]==mc){
				if(dir==1){//开始向下沉
					//当前人消失,换成站在木桶上喊救命的人
					goRiver["_manMC"]._visible			=	false;
					//喊救命的人物出现
					mc.body.cask_mc.helpMan_mc._visible	=	true;
					//TODO: 游戏时间被冻结5小时
					goRiver["_state"]	=	2;
					goRiver.caskEnabled(false);
				}
			}
		}
	}
	
	private function onMotionFinished(tw:Tween):Void{
		if(goRiver["_state"]==2){//游戏失败而结束
			goRiver.stopGame(false);
			return;
		}
		_inter=_global.setTimeout(Delegate.create(this, onTimeout), 
													_interTime[dir]*1000, tw);
		var mc:MovieClip	=	tw.obj._parent._parent;// means cask0~~caskXX
		if(dir==0){//表示桶正常浮在水面上
			mc.isSinking	=	false;
			mc.enabled		=	true;
			if(mustStop){
				stopSink();
			}
		}else{//表示桶在上浮或下沉或沉到水低中
			mc.isSinking	=	true;
			mc.enabled		=	false;
		}
	}
	
	private function onTimeout(tw:Tween):Void{
		dir	=	++dir%2;//改变方向
		if(dir==1){//开始向下沉
			var mc:MovieClip	=	tw.obj._parent._parent;
			if(goRiver["_curCask"]==mc){
				//当前人消失,换成站在木桶上喊救命的人
				goRiver["_manMC"]._visible			=	false;
				//喊救命的人物出现
				mc.body.cask_mc.helpMan_mc._visible	=	true;
			}
		}
		tw.yoyo();
	}
	
	/**
	 * 重新开始计时沉或浮,
	 * 只有停止状态下方可以再启动
	 */ 
	public function startSink():Void{
		mustStop	=	false;
		if(_inter==null){
			onMotionFinished(_tw);
		}
	}
	
	/**
	 * 暂停沉或浮,
	 * 只有桶在水面上方可以停止
	 */ 
	public function stopSink():Void{
		if(!_tw.obj._parent._parent.isSinking){
			clearInterval(_inter);
			_inter	=	null;
		}
	}
}
	