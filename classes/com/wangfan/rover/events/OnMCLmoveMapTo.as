//******************************************************************************
//	name:	OnMCLmoveMapTo
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 当加载图片所执行的事件
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.Map9;

class com.wangfan.rover.events.OnMCLmoveMapTo extends Object{
	static public var map9:Map9			=	null;
	static public var isLoaded:Boolean	=	false;
	
	//开始加载事件,并初始定位_mapMC的开始位置.
	static function onLoadStart(mc:MovieClip):Void{
		
	}
	
	static function onLoadProgress(mc:MovieClip, loadedBytes:Number, 
													totalBytes:Number):Void{
		//加载过程中....
	}
	
	static function onLoadComplete(mc:MovieClip):Void{
		//mc._visible	=	false;
		
	}
	
	static function onLoadInit(mc:MovieClip):Void{
		isLoaded	=	true;
		map9["showMosaic"]();
	}
}
	