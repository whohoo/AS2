//******************************************************************************
//	name:	MCskew2 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sun Jun 11 11:28:28 2006
//	description: 使影片具有skewX与skewY属性,
//		1.影片必须是两无缩放的影片且,里边的影片影片名必为mcSkew,
//		2.两影片的对齐方式一样,如左上角对齐,或中间对齐等.
//		如target_mc.mcSkew;你可以skew影片target_mc
//******************************************************************************


/**
 *  a simple method to skewing movieclip. <br>
 *  <p></p>
 *  there are only one method(initialize()) you must write, if you would like.<br> 
 *  <strong>NOTE:mcSkew must be embed target_mc, and both are same algin.</strong><br>
 * </br>
 * if you publish flash8, i recomand you import com.idescn.utils.MCskew;
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
class com.idescn.utils.MCskew2 extends Object{
	
	private var mcSkew:MovieClip;
	private var _x:Number;
	private var _y:Number;
	private var _yscale:Number;
	private var _rotation:Number;
	private var _width:Number;
	private var _height:Number;
	
	private var _skewX2:Number;
	private var _skewY2:Number;
	
	private static var SQRT2:Number	=	null;
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
	 * 
	 * @param   target if not movieclip or not undefined, it would regist <br></br>
	 * 		MovieClip.prototype, that means all movieclip would had those <br></br>
	 * 		methods.
	 */
	public static function initialize(target:MovieClip):Void{
		var o	=	MovieClip.prototype;
		if(target instanceof MovieClip){
			o	=	target;
		}
		var m:Object	=	_global.com.idescn.utils.MCskew2.prototype;
		SQRT2		=	Math.sqrt(2)/200;
		
		o.setSkew	=	m.setSkew;
		o.getSkew	=	m.getSkew;
		o._skewX2	=	0;
		o._skewY2	=	0;
		
		o.addProperty("_skewX",	m.getSkewX, o.setSkew);
		o.addProperty("_skewY",	m.getSkewY, m.setSkewY);
		//can't over-write, can't visible, but can delete
		_global.ASSetPropFlags(o, ["setSkew","getSkew"], 5);
		//can't delete, can't visible, but can over-write
		_global.ASSetPropFlags(o, ["_skewX","_skewY"], 3);
		//can't delete, can't visible, can't over-write
		_global.ASSetPropFlags(o, ["_skewX2","_skewY2"], 7);
	}
	
	/**
	 * set movieclip skew.<br></br>
	 * 
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
		//记录skew的值
		skewX==null ? skewX = this._skewX2 : this._skewX2 = skewX;
		skewY==null ? skewY = this._skewY2 : this._skewY2 = skewY;
		
		//定义三个点
		var toRadian:Number	=	Math.PI/180;
		var radianX:Number		=	-skewX*toRadian;
		var radianY:Number		=	skewY*toRadian;
		
		var pt0:Object	=	{x:this._x, y:this._y};
		var ptH:Object	=	{x:this._height*Math.sin(radianX)+pt0.x, 
							y:this._height*Math.cos(radianX)+pt0.y};
		var ptW:Object	=	{x:this._width*Math.cos(radianY)+pt0.x, 
							y:this._width*Math.sin(radianY)+pt0.y};
	
		var mc:MovieClip	=	this.mcSkew;
		var mcW:Number		=	mc._width;
		var mcH:Number		=	mc._height;
		
		
		var angleP2:Number	=	Math.atan2(ptW.y-pt0.y, ptW.x-pt0.x);
		var angleP1:Number	=	Math.atan2(ptH.y-pt0.y, ptH.x-pt0.x);
		var dAngle:Number	=	(angleP1-angleP2)/2;
		var arm:Number		=	SQRT2/Math.cos(dAngle);
		
		// original a 100x100 model, now use 1x1 model
		this._rotation		=	(angleP1-dAngle)/toRadian;
		mc._rotation		=	-45;
		this._yscale 		=	100*Math.tan(dAngle);
		mc._xscale			=	distance(ptW, pt0)/arm/mcW;
		mc._yscale			=	distance(ptH, pt0)/arm/mcH;
	}
	
	/**
	 * get the movieclip skew value,<br></br>
	 * 
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
		return [-this._skewX2, this._skewY2];
	}
	
	/**
	* 得到两点的长度
	*/
	private static function distance(pt1:Object, pt2:Object):Number{
		var dy:Number	=	pt2.y-pt1.y;
		var dx:Number	=	pt2.x-pt1.x;
		return Math.sqrt(dy*dy+dx*dx);
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
	private function MCskew2(){
		
	}
}