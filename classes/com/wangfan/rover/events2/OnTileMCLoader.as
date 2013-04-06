//******************************************************************************
//	name:	OnTileMCLoader
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 13 10:33:00 2006
//	description: 当加载图片所执行的事件
//		
//******************************************************************************

import mx.transitions.Tween;
import com.wangfan.rover.MapTiles;
/**
 * 当MapTiles类通过MovieClipLoader加载小tile后的事件
 */
class com.wangfan.rover.events2.OnTileMCLoader extends Object{
	static public var map9:MapTiles			=	null;
	//static public var isZoomOut:Boolean	=	true;
	//static public var leftRight:Number	=	0;
	
	//开始加载事件,并初始定位_mapMC的开始位置.
	static function onLoadStart(mc:MovieClip):Void{
		
	}
	
	static function onLoadProgress(mc:MovieClip, loadedBytes:Number, 
													totalBytes:Number):Void{
		//加载过程中....
	}
	
	static function onLoadComplete(mc:MovieClip):Void{
		mc._alpha	=	20;
	}
	
	static function onLoadInit(mc:MovieClip):Void{
		var tilesBox:Array	=	map9["_tilesBox"];
		tilesBox.splice(0,1);
		//trace("tilesBox length: "+tilesBox.length)
		if(tilesBox.length==0){//加载完成
			//map9["_state"]	=	4;
			//map9["mouseMoveEvent"](true);
		}else{
			map9["loadTile"]();
		}
		//渐变出现
		mc.onEnterFrame=function():Void{
			this._alpha	+=	20;
			if(this._alpha>=100){
				delete this.onEnterFrame;
			}
		}
	}
	
	static function onLoadError(mc:MovieClip, errorCode:String):Void{
		//trace("errorCode: "+errorCode)
		var tilesBox:Array	=	map9["_tilesBox"];
		tilesBox.splice(0,1);
		
		if(tilesBox.length==0){//加载完成
			map9["_state"]	=	4;
			map9["mouseMoveEvent"](true);
		}else{
			map9["loadTile"]();
		}
	}
}
	