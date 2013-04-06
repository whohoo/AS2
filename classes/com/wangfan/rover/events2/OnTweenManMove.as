//******************************************************************************
//	name:	OnTweenManMove
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.GoRiver;

/**
 * 过河游戏,当人移动时产生的动作.
 */
class com.wangfan.rover.events2.OnTweenManMove extends Object{
	static public var goRiver:GoRiver		=	null;
	
	static function onMotionChanged(tw:Tween):Void{
		goRiver.renderMan();
	}
	
	static function onMotionFinished(tw:Tween):Void{
		goRiver["_state"]		=	1;//站稳在桶上
		goRiver["sinkCask"](_root.personInfo.coin);
		goRiver.onMotionDone();
	}
}
	