//******************************************************************************
//	name:	OnTweenThumbScale
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Sep 12 13:41:15 2006
//	description: 当缩略图缩放后要执行的事件.
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.Map9;

class com.wangfan.rover.events.OnTweenThumbScale extends Object{
	static public var map9:Map9			=	null;
	static public var isZoomOut:Boolean	=	true;
	//static public var leftRight:Number	=	0;
	
	static function onMotionChanged(tw:Tween):Void{
		if(isZoomOut){//放大过程中...
			
		}else{//缩小过程中...
			var mc	=	tw.obj;
			var maskWidth:Number	=	map9["_maskMC"]._width;
			if(mc._width+mc._x<maskWidth){
				mc._x	=	maskWidth-mc._width;
			}
		}
		//var mc	=	tw.obj;
		//trace([mc._x, mc._y])
	}
	
	static function onMotionFinished(tw:Tween):Void{
		map9["_mapMC"]._xscale2		=	
		map9["_mapMC"]._yscale2		=	tw.finish;
		if(isZoomOut){//放大结束后
			map9["_state"]	=	4;//放大状态
			map9["showMosaic"]();
		}else{//缩小结束后
			map9["_loadMapMC"].removeMovieClip();
			var moveMap	=	map9["moveMap"];
			moveMap.map	=	map9["_mapMC"];
			moveMap.startMove();
			map9["_mapMC"].enabled	=	true;
			map9["_state"]		=	1;//恢复为正常状态
		}
	}
}
	