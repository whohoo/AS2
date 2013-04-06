//******************************************************************************
//	name:	OnTweenReleaseArrow
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Sep 12 13:41:15 2006
//	description: 当点击四个方向键移动背景图时,大图跟着移动
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.Map9;

class com.wangfan.rover.events.OnTweenReleaseArrow extends Object{
	static public var map9:Map9			=	null;
	static public var upDown:Number	=	0;
	static public var leftRight:Number	=	0;
	static function onMotionChanged(tw:Tween):Void{
		map9["onLoadStart"](map9["_loadMapMC"]);
	}
	
	static function onMotionFinished(tw:Tween):Void{
		map9["_heightLevel"]	+=	upDown;
		map9["_widthLevel"]		+=	leftRight;
		map9["loadMap"]();
	}
}
	