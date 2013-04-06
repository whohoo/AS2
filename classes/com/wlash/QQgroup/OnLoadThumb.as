//************************************************
//	name:	OnLoadThumb 
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Jan 07 23:57:37 2006
//	description: 当加载thumb完成时动作
//************************************************

import mx.transitions.Tween;
import com.wlash.QQgroup.*;

class com.wlash.QQgroup.OnLoadThumb{
	/**
	* 指向影片本身
	*/
	public static var picture:Object	=	null;
	
	/**
	* 当小图加载完成时
	* @param target
	*/
	public static function onLoadInit(target:MovieClip):Void{
		//trace("pic: "+target._url.substr(-12));
		//trace("width: "+target._width+" height: "+target._height);
		if(target._width>target._height){
			
			target._x	=	-target._width/2;
			target._y	=	-target._height/2;
			//trace("#横# x= "+target._x+" y= "+target._y);
		}else{
			
			target._rotation	=	-90;
			target._x	=	-target._width/2;
			target._y	=	target._height/2;
			//trace("＊竖＊ x= "+target._x+" y= "+target._y);
		}
		//trace("---------------");
		fadeIn(target);
	}
	
	/**
	* fade in the thumb picture
	* @param target
	*/
	private static function fadeIn(target:MovieClip):Void{
		var target2:MovieClip	=	target._parent.getInstanceAtDepth(1);
		
		//如果已经存在的图片,则时间为1秒,否则立即显示
		var time:Number	=	target2._url.substr(-3)=="jpg" ? 1 : 0.01;
		
		var tw:Tween	=	new Tween(target2,"brightness",
										mx.transitions.easing.None.easeOut,
										0, 240, time, true);
		var twEvent:OnTweenNone	=	new OnTweenNone(target);
		tw.addListener(twEvent);
	}

}