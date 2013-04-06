//******************************************************************************
//	name:	OnMovieClipLoader
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 当加载图片所执行的事件
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.Map9;

class com.wangfan.rover.events.OnMovieClipLoader extends Object{
	static public var map9:Map9			=	null;
	//static public var isZoomOut:Boolean	=	true;
	//static public var leftRight:Number	=	0;
	
	//开始加载事件,并初始定位_mapMC的开始位置.
	static function onLoadStart(mc:MovieClip):Void{
		var _mapMC:MovieClip	=	map9["_mapMC"];
		mc._x	=	
		mc._y	=	0;
	}
	
	static function onLoadProgress(mc:MovieClip, loadedBytes:Number, 
													totalBytes:Number):Void{
		//大图加载过程中....
	}
	
	static function onLoadComplete(mc:MovieClip):Void{
		//_mapMC._alpha	=	0;
		mc._alpha		=	0;
	}
	
	static function onLoadInit(mc:MovieClip):Void{
		
		var tw:Tween	=	new Tween(mc, "_alpha", 
						mx.transitions.easing.None.easeNone,
						0, 100, 2, true);
		//缩略图消失
		
		tw.addListener(com.wangfan.rover.events.OnTweenLoadInit);
		
		map9["moveMap"].map	=	mc;
		
	}
}
	