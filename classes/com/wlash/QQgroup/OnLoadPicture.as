//************************************************
//	name:	OnLoadPicture 
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Jan 07 23:57:37 2006
//	description: 当加载picture完成时动作,及定义了
//			大小图片的mouse事件
//************************************************

import flash.filters.*;

class com.wlash.QQgroup.OnLoadPicture{
	/**
	* 指向影片本身
	*/
	public static var picture:Object	=	null;
	
	/**
	* 当大图加载完成时
	* @param target
	*/
	public static function onLoadInit(target:MovieClip):Void{
		target._x	=	-target._width/2;
		target._y	=	-target._height/2;
		picture.drawFrame(target._width+20,target._height+20);
		picture.slipTo(picture.stageWidth/2);//右滑出
		setPictureEvents(target._parent);
	}
	
	/**
	* 定义picture的事件
	* @param target
	*/
	private static function setPictureEvents(bPicture:MovieClip):Void{
		var scope:Object	=	picture;
		bPicture.onRollOver=function():Void{
			
		}
		
		bPicture.onRollOut=bPicture.onReleaseOutside=function():Void{
			
		}
		
		bPicture.onRelease=function():Void{
			scope.slipTo(-(scope.stageWidth-800)/2-500);
			scope.enabledPictureBox(true);
			scope.setAutoSwitch(3000);//设置自动开始
		}
		bPicture.useHandCursor	=	false;
	}
	
	/**
	* 定义pic thumb的事件
	* @param target
	*/
	public static function setButtonEvents(target:MovieClip):Void{
		var filter:DropShadowFilter = new DropShadowFilter(10, 45, 0x000000, 
										.8, 10, 10, 1, 3, false, false, false);
		var filterArray:Array	=	[filter];
		target.filters	=	filterArray;
		var scope:Object	=	picture;
		target.onRollOver=function():Void{
			var filterArray:Array	=	this.filters;
			filterArray[0].blurX	=	15;
			filterArray[0].blurY	=	15;
			filterArray[0].distance	=	15;
			this.filters	=	filterArray;
			this._x	-=	1;
			this._y	-=	1;
		}
		target.onRollOut=target.onReleaseOutside=function():Void{
			var filterArray:Array	=	this.filters;
			filterArray[0].blurX	=	10;
			filterArray[0].blurY	=	10;
			filterArray[0].distance	=	10;
			this.filters	=	filterArray;
			this._x	+=	1;
			this._y	+=	1;
		}
		target.onRelease=function():Void{//点击小图加载大图
			scope.loadPicture(this);
			scope.enabledPictureBox(false);
			
		}
	}
}