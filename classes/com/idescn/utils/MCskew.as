//******************************************************************************
//	name:	MCskew 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sun Jun 11 11:28:28 2006
//	description: 使影片具有skewX与skewY属性,
//		因为在MCskew中使用this时,是指向MCskew类,而MCskew类又不是MovieClip的子类,
//		所以new Transform(mc:MovieClip);会报错,为了当MCskew.initialze();后把skew
//		方法应用于MovieClip中,而this必须指向自己影片,故用了eval("this")指向自己,
//		且必须用一个非定义类型的变量,再用变量传给Transform
//		var seftMC	=	eval("this");
//		var trans:Transform	=	new Transform(seftMC);
//		-----------------------------
//		增加了虚构的transform变量,可以直接用this.transform阳得Transform类.
//******************************************************************************

import flash.geom.Transform;
import flash.geom.Matrix;
[IconFile("MCskew.png")]
/**
 *  a simple method to skewing movieclip. <br>
 *  <p></p>
 *  there are only one method(initialize()) you must write, if you would like.<br> 
 *  <b>NOTE: this method only for flash8 and heighter</b>
 * <pre>
 * <b>eg:</b>
 * com.idescn.utils.MCskew.initialize();//make all movieclip.
 * //or
 * com.idescn.utils.MCskew.initialize(target_mc);//only target_mc.
 * 
 *  target_mc._skewX = 30;
 *  target_mc._skewY = -10;
 *  target_mc.setSkew(-40,45);
 * </pre>
 * 
 */
class com.idescn.utils.MCskew extends Object{
	
	private var transform:Transform;
	
	/**
	 * this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * skew X of movieclip.
	 */
	public  var _skewX:Number;
	/**
	 * this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * skew Y of movieclip.
	 */
	public  var _skewY:Number;
	
	/**
	 * initiallize target(movieclip), make target had tow members(skewX,skewY)<br></br>
	 * if not point out which movieclip you wannna, it would make all movieclips<br></br>
	 * had those methods.<br></br>
	 * <b>NOTE: this method only for flash8 and heighter</b>
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
		if(o.setSkew!=null){
			return false;
		}
		var m:Object	=	_global.com.idescn.utils.MCskew.prototype;
		
		o.setSkew	=	m.setSkew;
		o.getSkew	=	m.getSkew;
		
		o.addProperty("_skewX",	m.getSkewX, o.setSkew);
		o.addProperty("_skewY",	m.getSkewY, m.setSkewY);
		//can't over-write, can't visible, but can delete
		_global.ASSetPropFlags(o, ["setSkew","getSkew"], 5);
		//can't delete, can't visible, but can over-write
		_global.ASSetPropFlags(o, ["_skewX","_skewY"], 3);
		return true;
	}
	
	/**
	 * set movieclip skew.<br></br>
	 * <b>NOTE:this method is only for flash8 and highter.</b>
	 * <pre>
	 * 	<b>eg:</b>
	 * 	 target.setSkew(30);
	 *   target.setSkew(null, 20);
	 *   target.setSkew(40,-20);
	 * </pre>
	 * 
	 * @param   skewX a angle domain -180 to 180. if did not point out, movieclip
	 * 		would not change skewX.
	 * @param   skewY a angle domain -180 to 180. if did not point out, movieclip
	 * 		would not change skewY.
	 */
	public function setSkew(skewX:Number, skewY:Number):Void{
		var trans:Transform	=	this.transform;
		var matrix:Matrix		=	trans.matrix;
		var radian:Number		=	null;
		var toRadian:Number	=	Math.PI/180;
		if(skewX!=null){
			radian		=	skewX*toRadian;
			matrix.d	=	Math.cos(radian);
			matrix.c	=	-radian;
		}
		if(skewY!=null){
			radian		=	skewY*toRadian;
			matrix.a	=	Math.cos(radian);
			matrix.b	=	radian;
		}

		trans.matrix	=	matrix;
	}
	
	/**
	 * get the movieclip skew value,<br></br>
	 * <b>NOTE: this method only for flash8 and highter.</b>
	 * <pre>
	 * <b>eg:</b>
	 *  var skew:Array = target.getSkew();
	 *  var skewX:Number = skew[0];
	 *  var skewY:Number = skew[1];
	 * </pre>
	 * 
	 * @return a array. the first of array is skewX, the sceond of array is skewY.
	 */
	public function getSkew():Array{
		var trans:Transform	=	this.transform;
		var matrix:Matrix		=	trans.matrix;
		var toAngle:Number		=	180/Math.PI;
		return [-matrix.c*toAngle, matrix.b*toAngle];
	}
	
	/**
	 * 为_skewY属性而定义.
	 * 
	 * @param   angle 
	 */
	private function setSkewY(angle:Number):Void{
		setSkew(null, angle);
	}
	/**
	 * 为_skewY属性而定义.
	 * 
	 * @return
	 */
	private function getSkewY():Number{
		return getSkew()[1];
	}
	
	/**
	 * 为_skewX属性而定义.
	 * 
	 * @return
	 */
	private function getSkewX():Number{
		return getSkew()[0];
	}
	/**
	 * a empty private CONSTRUCT FUNCTION, you can't create instance by this.
	 */
	private function MCskew(){
		
	}
}