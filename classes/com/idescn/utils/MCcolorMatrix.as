//******************************************************************************
//	name:	MCcolorMatrix 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Jun 28 12:04:12 GMT+0800 2006
//	description: this file was created by "MCcolorMatrix.fla" file.
//		
//******************************************************************************

import flash.geom.Matrix;
import flash.filters.ColorMatrixFilter;
import com.gskinner.geom.ColorMatrix;

[IconFile("MCcolorMatrix.png")]
/**
 * the advance color matrix for moviecilp.<p></p>
 * 
 */
class com.idescn.utils.MCcolorMatrix extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	private var filters:Array;
	
	private var __bright:Number		=	0;
	private var __contrast:Number		=	0;
	private var __saturation:Number	=	0;
	private var __hue:Number			=	0;
	
						

	//************************[READ|WRITE]************************************//
	/**brightness of the movieclip */
	public var _brightness;
	/**contras of the movieclip*/
	public var _contrast;
	/**saturatio of the movieclip*/
	public var _saturation;
	/**hue of the movieclip*/
	public var _hue;
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * a empty private CONSTRUCT FUNCTION, you can't create instance by this.
	 */
	private function MCcolorMatrix(){

	}
	
	//************************[PRIVATE METHOD]********************************//
	
	
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * initiallize target(movieclip), make target had those methods<br></br>
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
		if(o.setSaturation!=null){
			return false;
		}
		var m:Object	=	_global.com.idescn.utils.MCcolorMatrix.prototype;
		
		o.setBrightness	=	m.setBrightness;
		o.getBrightness	=	m.getBrightness;
		o.__bright		=	m.__bright;
		
		o.setContrast	=	m.setContrast;
		o.getContrast	=	m.getContrast;
		o.__contrast	=	m.__contrast;
		
		o.setSaturation	=	m.setSaturation;
		o.getSaturation	=	m.getSaturation;
		o.__saturation	=	m.__saturation;
		
		o.setHue		=	m.setHue;
		o.getHue		=	m.getHue;
		o.__hue			=	m.__hue;
		
		o.multiplyMatrix	=	m.multiplyMatrix;
		o.fixMatrix			=	m.fixMatrix;
				
		//can't over-write, can't visible, but can delete
		_global.ASSetPropFlags(o, ["setBrightness", "getBrightness",
									"setContrast", "getContrast",
									"setSaturation", "getSaturation",
									"setHue", "getHue"], 5);
									
		o.addProperty("_brightness", o.getBrightness, o.setBrightness);
		o.addProperty("_contrast", o.getContrast, o.setContrast);
		o.addProperty("_saturation", o.getSaturation, o.setSaturation);
		o.addProperty("_hue", o.getHue, o.setHue);
		//can't delete, can't visible, but can over-write
		_global.ASSetPropFlags(o, ["_brightness","_contrast",
													"_saturation","_hue"], 3);
		return true;
	}
	
	//***************brightness********************
	/**
	* set movieclip Brightness
	*/
	public function setBrightness(value:Number):Void{
		var cm:ColorMatrix = new ColorMatrix();
		__bright	=	value;
		cm.adjustColor(__bright, __contrast, __saturation, __hue);
		
		var filterArray:Array	=	this.filters;
		var len:Number		=	filterArray.length;
		var filter:Array	=	null;
		var fColor:ColorMatrixFilter	=	null;
		while(len--){
			filter	=	filterArray[len];
			if(filter instanceof ColorMatrixFilter){
				filterArray.splice(len, 1);
				break;
			}
		}
		fColor	=	new ColorMatrixFilter(cm);
		filterArray.push(fColor);
		
		this.filters = filterArray;
	}
	
	/**
	* get movieclip Brightness
	*/
	public function getBrightness():Number {
		return	this.__bright;
	};

	//*******************Contrast**********************
	/**
	* set movieclip Contrast
	*/
	public function setContrast(value:Number):Void{
		var cm:ColorMatrix = new ColorMatrix();
		__contrast	=	value;
		cm.adjustColor(__bright, __contrast, __saturation, __hue);
		
		var filterArray:Array	=	this.filters;
		var len:Number		=	filterArray.length;
		var filter:Array	=	null;
		var fColor:ColorMatrixFilter	=	null;
		while(len--){
			filter	=	filterArray[len];
			if(filter instanceof ColorMatrixFilter){
				filterArray.splice(len, 1);
				break;
			}
		}
		fColor	=	new ColorMatrixFilter(cm);
		filterArray.push(fColor);
		
		this.filters = filterArray;
	}
	
	/*
	* get movieclip Contrast
	*/
	public function getContrast():Number {
		return this.__contrast;
	};

	//*******************Saturation**********************
	/**
	* set movieclip Saturation
	*/
	public function setSaturation(value:Number):Void{
		var cm:ColorMatrix = new ColorMatrix();
		__saturation	=	value;
		cm.adjustColor(__bright, __contrast, __saturation, __hue);
		
		var filterArray:Array	=	this.filters;
		var len:Number		=	filterArray.length;
		var filter:Array	=	null;
		var fColor:ColorMatrixFilter	=	null;
		while(len--){
			filter	=	filterArray[len];
			if(filter instanceof ColorMatrixFilter){
				filterArray.splice(len, 1);
				break;
			}
		}
		fColor	=	new ColorMatrixFilter(cm);
		filterArray.push(fColor);
		
		this.filters = filterArray;
	}
	
	/**
	* get movieclip Saturation
	*/
	public function getSaturation() {
		return this.__saturation;
	};

	//*******************Hue**********************
	/**
	* set movieclip hue
	*/
	public function setHue(value:Number):Void{
		var cm:ColorMatrix = new ColorMatrix();
		__hue	=	value;
		cm.adjustColor(__bright, __contrast, __saturation, __hue);
		
		var filterArray:Array	=	this.filters;
		var len:Number		=	filterArray.length;
		var filter:Array	=	null;
		var fColor:ColorMatrixFilter	=	null;
		while(len--){
			filter	=	filterArray[len];
			if(filter instanceof ColorMatrixFilter){
				filterArray.splice(len, 1);
				break;
			}
		}
		fColor	=	new ColorMatrixFilter(cm);
		filterArray.push(fColor);
		
		this.filters = filterArray;
	}
	
	/**
	* get movieclip hue.
	*/
	public function getHue():Number {
		return this.__hue;
	};
	
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "MCcolorMatrix 2.0";
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//this template is created by whohoo.
