//************************************************
//	name:	OnTweenNone
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Jan 07 23:57:37 2006
//	description: 当加载完成小图,原来的小图消失后
//************************************************

import mx.transitions.Tween;

class com.wlash.QQgroup.OnTweenNone{
	/**
	* 指向影片本身
	*/
	public static var picture:Object	=	null;
	
	/**
	* 另一影片
	*/
	private var target:Object	=	null;
	
	/**
	* 构造函数
	* @param target 另一影片,正要显示的图片,
	*/
	public function OnTweenNone(target:MovieClip){
		this.target			=	target;
		target.brightness	=	240;
	}
	
	/**
	* 当亮度变为正常时
	* @param tw tw为Tween
	*/
	public function onMotionFinished(tw:Tween):Void{
		var tw1:Tween	=	new Tween(target,"brightness",
								mx.transitions.easing.None.easeIn,
								240,0,1,true);
		var pic:MovieClip	=	tw.obj._parent;//包括前后两个图片的上级的图片						
		//设置小图的mouse事件
		//picture.setButtonEvents(tw.obj._parent);
		pic._visible	=	true;
		pic.enabled		=	true;
		tw.obj.swapDepths(target);
		//trace(tw.obj.getDepth())
		tw.obj.unloadMovie();
		
	}
}