//******************************************************************************
//	name:	OnTweenLoadInit
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Sep 12 13:41:15 2006
//	description: 当大图被加载完成后,慢慢显示,结束后,再显把缩略图消失.
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.Map9;

class com.wangfan.rover.events.OnTweenLoadInit extends Object{
	static public var map9:Map9	=	null;
	
	static function onMotionFinished(tw:Tween):Void{
		map9["_mapMC"]._visible			=	false
		map9["_mosaicMapMC"].gotoAndStop(1);
		map9["_mosaicMapMC"]._visible	=	false;
		
		map9["moveMap"].startMove();
		//var tw:Tween	=	new Tween(target, "_alpha", 
		//				mx.transitions.easing.None.easeNone,
		//				100, 0, 1, true);
	}
}
	