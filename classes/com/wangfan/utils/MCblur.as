//******************************************************************************
//	name:	MCblur 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Sep 25 16:06:05 2006
//	description: 
//******************************************************************************

import flash.filters.BlurFilter;

[IconFile("MCblur.png")]
/**
 *  make a movieclip playing to end frame by frame, or playing to frist frame by
 *  frame. 
 *  <p></p>
 * <b>NOTE: those method only for flash8 above.</b>
 *  there are only one method(initialize()) you must write, if you would like<br> 
 *  MovieClip.moveIn() or MovieClip.moveOut() methods. 
 * <pre>
 * <b>eg:</b>
 * com.idescn.utils.MCblur.initialize();//make all movieclip.
 * //or
 * com.idescn.utils.MCblur.initialize(target_mc);//only target_mc.
 * 
 *	//target_mc.stop();
 * target_mc.blurX	=	50;//0-255
 *
 * target_mc.blurY	=	100;//0-255
 *
 * target_mc.blurQuality	=	3;//0-15
 * </pre>
 * 
 */
class com.wangfan.utils.MCblur extends Object{
	
	public  var filters:Array	=	null;
	

	/**
	 * initiallize target(movieclip), make target had tow methods(setBlurX,getBlurX<br></br>
	 * setBlurY,getBlurY,setBlurQuality,getBlurQuality) and members(blurX, blurY,<br></br>
	 * blurQuality)
	 * if not point out which movieclip you wannna, it would make all movieclips<br></br>
	 * had those methods
	 * 
	 * @param   target if not movieclip or not undefined, it would regist <br></br>
	 * 		MovieClip.prototype, that means all movieclip would had those <br></br>
	 * 		methods.
	 * @return
	 */
	public static function initialize(target:MovieClip):Boolean{
		
		var o	=	MovieClip.prototype;
		if(target instanceof MovieClip){
			o	=	target;
		}
		if(o.setBlurQuality!=null){
			return false;
		}
		var m:Object	=	_global.com.wangfan.utils.MCblur.prototype;
		
		o.setBlurX	=	m.setBlurX;
		o.getBlurX	=	m.getBlurX;
		o.setBlurY	=	m.setBlurY;
		o.getBlurY	=	m.getBlurY;
		o.setBlurQuality	=	m.setBlurQuality;
		o.getBlurQuality	=	m.getBlurQuality;
		
		//can't over-write, can't visible, but can delete
		_global.ASSetPropFlags(o, ["setBlurX","getBlurX",
									"setBlurX","getBlurX",
									"setBlurQuality", "getBlurQuality"], 5);
									
		o.addProperty("blurX", o.getBlurX, o.setBlurX);
		o.addProperty("blurY", o.getBlurY, o.setBlurY);
		o.addProperty("blurQuality", o.getBlurQuality, o.setBlurQuality);
		//can't delete, can't visible, but can over-write
		_global.ASSetPropFlags(o, ["blurX", "blurY", "blurQuality"], 3);
		return true;
	}
	
	/**
	 * a empty private CONSTRUCT FUNCTION, you can't create instance by this.
	 */
	private function MCblur(){
		
	}
	
	/**
	 * set movieclicp had a blur X
	 * 
	 * @param   value a blur X value
	 */
	public function setBlurX(value:Number):Void{
		//数值必为正数或零
		//if(value<0)		throw new Error("["+value+"] value must >=0.");
		
		var filterArray:Array = this.filters;
		var len:Number = filterArray.length;
		var fBlur:BlurFilter = null;
		while (len--) {	//查找是否设置过blur效果
			fBlur = filterArray[len];
			if (fBlur instanceof BlurFilter) {
				break;
			}
		}
		
		if (fBlur == null) {//如果没有blur效果,新建一个
			fBlur = new BlurFilter(value, 0, 1);
			filterArray.push(fBlur);
			this.filters = filterArray;
		} else {//如果已经有效果,直接修改值
			fBlur.blurX = value;
			this.filters = filterArray;
		}
	}
	/**
	 * get movieclicp had a blur X
	 * 
	 * @return a blur Y value
	 */
	public function getBlurX():Number {
		var filterArray:Array = this.filters;
		var len:Number = filterArray.length;
		while (len--) {	//查找是否设置过blur效果
			if (filterArray[len] instanceof BlurFilter) {
				return (filterArray[len].blurX);//找到效果,返回效果值
			}
		}
		//如果没有blur效果,返回null
		return null;
	};
	/**
	 * set movieclicp had a blur Y
	 * 
	 * @param   value a blur Y value
	 */
	public function setBlurY(value:Number):Void {
		//数值必为正数或零
		//if(value<0)		throw new Error("["+value+"] value must >=0.");
		
		var filterArray:Array = this.filters;
		var len:Number = filterArray.length;
		var fBlur:BlurFilter = null;
		while (len--) {	//查找是否设置过blur效果
			fBlur = filterArray[len];
			if (fBlur instanceof BlurFilter) {
				break;
			}
		}
		if (fBlur == null) {//如果没有blur效果,新建一个
			fBlur = new BlurFilter(0, value, 1);
			filterArray.push(fBlur);
			this.filters = filterArray;
		} else {//如果已经有效果,直接修改值
			fBlur.blurY = value;
			this.filters = filterArray;
		}
	};
	/**
	 * get movieclicp had a blur Y
	 * 
	 * @return a blur Y value
	 */
	public function getBlurY():Number {
		var filterArray:Array = this.filters;
		var len:Number = filterArray.length;
		while (len--) {	//查找是否设置过blur效果
			if (filterArray[len] instanceof BlurFilter) {
				return (filterArray[len].blurY);//找到效果,返回效果值
			}
		}
		//如果没有blur效果,返回null
		return null;
	};
	/**
	 * set movieclicp had a blur quality
	 * 
	 * @param   value a blur quality
	 */
	public function setBlurQuality(value:Number):Void {
		//数值必为在0-15之间
		//if(value<0 || value>15)		throw new Error("["+value+"] value must >=0 & <=15.");
		
		var filterArray:Array = this.filters;
		var len:Number = filterArray.length;
		var fBlur:BlurFilter = null;
		while (len--) {	//查找是否设置过blur效果
			fBlur = filterArray[len];
			if (fBlur instanceof BlurFilter) {
				break;
			}
		}
		if (fBlur == null) {//如果没有blur效果,新建一个
			fBlur = new BlurFilter(0, 0, value);
			filterArray.push(fBlur);
			this.filters = filterArray;
		} else {//如果已经有效果,直接修改值
			fBlur.quality = value;
			this.filters = filterArray;
		}
	};
	/**
	 * get movieclicp had a blur quality
	 * 
	 * @return   value a blur quality
	 */
	public function getBlurQuality():Number {
		var filterArray = this.filters;
		var len = filterArray.length;
		while (len--) {	//查找是否设置过blur效果
			if (filterArray[len] instanceof BlurFilter) {
				return (filterArray[len].quality);//找到效果,返回效果值
			}
		}
		//如果没有blur效果,返回null
		return null;
	};
}