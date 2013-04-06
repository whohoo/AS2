//******************************************************************************
//	name:	OnTweenScaleMapTo
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 当点击导航条后移动地图后,放大图片
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.MapTiles;

class com.wangfan.rover.events2.OnTweenScaleMapTo extends Object{
	static public var map9:MapTiles		=	null;
	
	static function onMotionChanged(tw:Tween):Void{
		var mapMC:MovieClip	=	map9["_mapMC"];
		var pos:Object			=	null;
		if(tw.finish==500){//放大过程
			//pos	=	{x:458, y:237};//中心点
			//map9["_maskMC"].globalToLocal(pos);
			//mapMC.localToGlobal(pos);
			
		}else{//缩小过程
			pos	=	map9["inBound"](mapMC._x, mapMC._y);
			mapMC._x	=	pos.x;
			mapMC._y	=	pos.y;
		}
		//trace([navPosMC._xscale,navPosMC._y])
	}
	
	static function onMotionFinished(tw:Tween):Void{
		var pScale:Number	=	tw.finish;//最终scale得到的值
		map9["_mapMC"]._xscale2		=	
		map9["_mapMC"]._yscale2		=	pScale;
		if(pScale==500){//放大
			map9["startLoadTile"]();
		}else{
			map9["moveMap"].startMove();
			map9["_mapMC"].enabled	=	true;
		}
	}
}
	