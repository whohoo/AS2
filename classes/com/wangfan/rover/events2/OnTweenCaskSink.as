//******************************************************************************
//	name:	OnTweenCaskSink
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.GoRiver;

/**
 * 当木桶因人站在上边有稍下沉时
 */
class com.wangfan.rover.events2.OnTweenCaskSink extends Object{
	static public var goRiver:GoRiver		=	null;
	
	static function onMotionChanged(tw:Tween):Void{
		var pos:Object	=	{x:tw.obj._x, y:tw.obj._y};
		tw.obj._parent.localToGlobal(pos);
		goRiver["_manMC"]._parent.globalToLocal(pos);
		goRiver["_manMC"]._y	=	pos.y;
	}
	
	static function onMotionFinished(tw:Tween):Void{
		
	}
}
