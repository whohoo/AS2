//************************************************
//	name:	OnTweenStrong
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Jan 07 23:57:37 2006
//	description: 当滑入或滑出图片时
//************************************************

import mx.transitions.Tween;

class com.wlash.QQgroup.OnTweenStrong{
	/**
	* 指向影片本身
	*/
	public static var picture:Object	=	null;
	
	/**
	* 当滑出图片完成时
	* @param tw tw为Tween
	*/
	public static function onMotionFinished(tw:Tween):Void{
		var tw1:Tween	=	new Tween(tw.obj,"blurX",
								mx.transitions.easing.None.easeOut,
								8,0,.5,true);
		if(tw.obj._x>0){
			//左下显示标题
			picture.showText(tw.obj.title,-tw.obj._width/2+10,
									tw.obj._height/2-30,"mcTxt",100);
			//右下角显示时间
			picture.showText(picture.formatDate(tw.obj.date),tw.obj._width/2-130,
									tw.obj._height/2-30,"mcDate",110);
		}else{
			tw.obj.mcLoadPic.unloadMovie();
		}
	}
}