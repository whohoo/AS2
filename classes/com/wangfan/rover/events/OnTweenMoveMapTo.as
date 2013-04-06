//******************************************************************************
//	name:	OnTweenMoveMapTo
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 当点击导航条后移动地图后,放大图片
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.Map9;

class com.wangfan.rover.events.OnTweenMoveMapTo extends Object{
	static public var map9:Map9		=	null;
	static public var xReg:Number	=	0;
	static public var yReg:Number	=	0;
	//static public var xRegLast:Number	=	0;
	//static public var yRegLast:Number	=	0;
	static public var isThumb:Boolean	=	null;
	
	
	
	static function onMotionChanged(tw:Tween):Void{
		if(isThumb){//小图中的平移
			
		}else{//大图中的平移
			var mc:MovieClip	=	map9["_loadMapMC"];
			var mc2:Object		=	tw.obj;
			//mc._alpha	=	30
			mc._x	=	(mc2._x+mc2.xreg*5);
			mc._y	=	(mc2._y+mc2.yreg*5);
			//trace([mc2._x, mc2._y, mc._x, mc._y]);
		}
	}
	
	static function onMotionFinished(tw:Tween):Void{
		var mc2:Object		=	tw.obj;
		if(isThumb){//小图移动结束,然后放大小图到大图
			map9["scaleMapTo"](xReg, yReg);
			
			//mc2.xreg	=	xReg*5;
			//mc2.yreg	=	yReg*5;
		}else{//大图移动结束
			map9["_loadMapMC"].removeMovieClip();
			map9["_state"]	=	4;//
			map9["showMosaic"]();
			mc2.xreg	=	xReg/5;
			mc2.yreg	=	yReg/5;
			//trace("OnTweenMoveMapTo: "+[xReg, yReg])
		}
		
	}
}
	