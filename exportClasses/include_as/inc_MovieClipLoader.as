//******************************************************************************
//	name:	MovieClipLoader 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2009-6-24 15:33
//	description: 只使用了#initclip来重定义MovieClipLoader类，而没必要重定义另一个
//				类再初始化.
//				增加了是否使用平滑加载jpg,png等图片，只对图片起作用，对swf会转为bmp
//				1.1增加了对是否覆盖onLoadInit方法的判断，但只限于调用loadClip方法前
//				是否覆盖的判断。
//******************************************************************************

#initclip 1
if (!MovieClipLoader["isInit"]) {
	//关于不把__bmpDepth属性加到MovieClip.prototype当中，一是不拉架MovieClip类的属性，二是一般一个mcl类只加载一个swf
	//如果要共用一个mcl加载多个swf，则加载swf的容器的结构应是一样的，所以__bmpDepth的值也会一样。
	var o:Object	=	MovieClipLoader.prototype;
	o.__bmpDepth		=	-1;
	o.__isSmoothing		=	false;
	o.__pixelSnapping	=	"Auto";
	o.__loadClip__		=	o.loadClip;
	o.__unloadClip__	=	o.unloadClip;
	//o.__addListener__	=	o.addListener;
	//
	//o.addListener = function(listener:Object):Void {
		//this.__addListener__(listener);
		//
	//}
	
	o.loadClip = function(url:String, target:Object, isSmoothing:Boolean, pixelSnapping:String):Void {
		this.__isSmoothing		=	isSmoothing == true;
		this.__pixelSnapping	=	(pixelSnapping != "Always" || pixelSnapping != "Never") ? "Auto" : pixelSnapping;
		this.__loadClip__(url, target);
		if (this.onLoadInit != MovieClipLoader.prototype.onLoadInit && isSmoothing) {
			isSmoothing	=	false;
			throw new Error("DON'T try override MovieClipLoader.onLoadInit method, when load a smoothing image.");
		}
	}
	
	o.unloadClip = function(target:Object):Void {
		if (this.__isSmoothing) {
			target.createEmptyMovieClip("coverBmp", __bmpDepth).removeMovieClip();
		}else {
			this.__unloadClip__(target);
		}
	}
	
	o.onLoadInit = function(mc:MovieClip):Void {
		if (this.__isSmoothing) {
			var bmp	=	new flash.display.BitmapData(mc._width, mc._height, true, 0x0);
			bmp.draw(mc);
			this.__unloadClip__(mc);
			this.__bmpDepth	=	mc.getNextHighestDepth();
			_global.setTimeout(mc, "attachBitmap", 1, bmp, this.__bmpDepth, this.__pixelSnapping, true );
			//mc.attachBitmap(bmp, 1, "auto", true);//doesn't work, i don't know why??!!
		}
	}
	
	//can't delete, can't visible, but can over-write
	_global.ASSetPropFlags(o, ["__bmpDepth", "__isSmoothing", "__pixelSnapping", "__loadClip__", 
					"__unloadClip__"], 3);
					
	//can't over-write, can't visible, but can delete
	_global.ASSetPropFlags(MovieClipLoader, [ "isInit"], 5);
	_global.ASSetPropFlags(o, [ "__loadClip__", "__unloadClip__", "onLoadInit"], 5);
	
	delete o;
	MovieClipLoader["isInit"]	=	true;
	trace("MovieClipLoader initialize. [v1.1]\r"+
		  "rewrite MovieCLipLoader.loadClip method, add new params to load bitmap and make image smoothing.\r" +
		  "MovieCLipLoader.loadClip(url:String, target:Object, isSmoothing:Boolean, pixelSnapping:String):\r" +
		  "  url:				image url.\r"+
		  "  target:			movieclip path.\r"+
		  "  isSmoothing:		[optinal] default value is \"false\".\r"+
		  "  pixelSnapping:	[optinal] default value is \"Auto\". acceptable value are \"auto\", \"Always\" and \"Never\".\r");
}
#endinitclip