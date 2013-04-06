//******************************************************************************
//	name:	DynamicRegistration 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 18 15:12:11 2006
//	description: 使影片具有根据xreg与yreg注册点来移动(_x2,_y2),缩放(_xscale2,
//				_yscale2),转动(_rotation2),及当前mouse坐标(_xmouse2,_ymouse2)只读
//******************************************************************************

// special thanks to Robert Penner (www.robertpenner.com) for providing the
// original code for this in ActionScript 1 on the FlashCoders mailing list

[IconFile("DynamicRegistration.png")]
/**
* movieclip always rotation on (0,0) when change value of movieclip._rotation<br></br>
* <p></p>
* but you could try "com.idescn.utils.DynamicRegistration.initialize()" <br></br>
* make movieclip had another properties of move, scale, rotation,<br></br>
* that _x2,_y2,_xscale2,_yscale2,_rotation2,_xmouse2,_ymouse and so on.<br></br>
* change those value of properties would rotation or sclae by a new Registration point<br></br>
* <pre>
* <b>eg:</b>
* com.idescn.utils.DynamicRegistration.initialize();//all movieclips
* //or 
* com.idescn.utils.DynamicRegistration.initialize(target_mc);//only a movieclip
* //change movieclip new registration point
* target_mc.xreg	=	30;//default 0, it would same as _xscale when _xscale2 changed
* target_mc.yreg	=	60;//ditto
*  //so you could try <b>_x2,_y2,_xscale2,_yscale2,_rotation2,</b> properties to change
* anther value, and the movieclip would change by registration point(30,60)
* </pre>
* add below properties.
* <ul>
* 	<li>xreg</li>
*	<li>yreg</li>
* 	<li>_x2</li>
*	<li>_y2</li>
* 	<li>_xsclae2</li>
*	<li>_xsclae2</li>
* 	<li>_rotation2</li>
*	<li>_xmouse2[read only]</li>
*	<li>_ymouse2[read only]</li>
* </ul>
*/
class com.idescn.utils.DynamicRegistration extends Object{
	
	private var _x:Number;
	private var _y:Number;
	private var _xscale:Number;
	private var _yscale:Number;
	private var _xmouse:Number;
	private var _ymouse:Number;
	private var _rotation:Number;
	private var localToGlobal:Function;
	private var globalToLocal:Function;
	private var _parent:MovieClip;
	
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * xreg of movieclip.*/
	public  var xreg:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * yreg of movieclip.*/
	public  var yreg:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _x2 of movieclip.*/
	public  var _x2:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _y2 of movieclip.*/
	public  var _y2:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _xscale2 of movieclip.*/
	public  var _xscale2:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _yscale2 of movieclip.*/
	public  var _yscale2:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _xmouse2 of movieclip. READ ONLY*/
	public  var _xmouse2:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _ymouse2 of movieclip. READ ONLY*/
	public  var _ymouse2:Number;
	/**this member would be added to movieclip, if MCskew.initialize().<br></br>
	 * _rotation2 of movieclip.*/
	public  var _rotation2:Number;
	
	/**
	 * initiallize target(movieclip), make target had properties of move, scale, rotation<br></br>
	 * if not point out which movieclip you wannna, it would make all movieclips<br></br>
	 * had those properties
	 * 
	 * @param   target if not movieclip or not undefined, it would regist <br></br>
	 * 		MovieClip.prototype, that means all movieclip would had those <br></br>
	 * 		properties.
	 * @return 
	 */
	public static function initialize(target:MovieClip):Boolean {
		var o	=	MovieClip.prototype;
		if(target instanceof MovieClip){
			o	=	target;
		}
		if(o.setPropRel!=null){
			return false;
		}
		var p	=	_global.com.idescn.utils.DynamicRegistration.prototype;
		
		o.xreg		=	
		o.yreg		=	0;
		
		o.setPropRel		=	p.setPropRel;
		//add moveiclip properties.
		o.addProperty("_x2", 		p.get_x2, 			p.set_x2);
		o.addProperty("_y2", 		p.get_y2, 			p.set_y2);
		o.addProperty("_xscale2", 	p.get_xscale2, 		p.set_xscale2);
		o.addProperty("_yscale2", 	p.get_yscale2, 		p.set_yscale2);
		o.addProperty("_rotation2",	p.get_rotation2,	p.set_rotation2);
		o.addProperty("_xmouse2", 	p.get_xmouse2, 		null);
		o.addProperty("_ymouse2", 	p.get_ymouse2, 		null);
		//can't delete, can't visible, but can over-write
		_global.ASSetPropFlags(o, ["xreg", "yreg", "_x2", "_y2", "_xscale2",
							"_yscale2", "_rotation2", "_xmouse2", "_ymouse2",
							"setPropRel"], 3);
		return true;
	}
	

	private function setPropRel(property:String, amount:Number):Void {
		var a:Object	=	{x:this.xreg, y:this.yreg};
		this.localToGlobal (a);
		this._parent.globalToLocal (a);
		this[property]	=	amount;
		var b:Object	=	{x:this.xreg, y:this.yreg};
		this.localToGlobal (b); 
		this._parent.globalToLocal (b);
		this._x -= b.x - a.x;
		this._y -= b.y - a.y;
	}
	
	private function get_x2():Number {
		var a:Object = {x:this.xreg, y:this.yreg};
 		this.localToGlobal(a);
		this._parent.globalToLocal(a);
 		return a.x;
	}
	
	private function set_x2(value:Number):Void {
		var a:Object = {x:this. xreg, y:this. yreg};;
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this._x += value - a.x;
	}

	private function get_y2():Number {
		var a:Object = {x:this.xreg, y:this.yreg};
 		this.localToGlobal(a);
		this._parent.globalToLocal(a);
 		return a.y;
	}
	
	private function set_y2(value:Number):Void {
		var a:Object = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this._y += value - a.y;
	}
	
	private function set_xscale2(value:Number):Void {
		this.setPropRel("_xscale", value);
	}
	
	private function get_xscale2():Number {
		return this._xscale;
	}
	
	private function set_yscale2(value:Number):Void {
		this.setPropRel("_yscale", value);
	}
	
	private function get_yscale2():Number {
		return this._yscale;
	}
	
	private function set_rotation2(value:Number):Void {
		this.setPropRel("_rotation", value);
	}
	
	private function get_rotation2():Number {
		return this._rotation;
	}
	
	private function get_xmouse2():Number {
		return this._xmouse - this.xreg;
	}
	
	private function get_ymouse2():Number {
		return this._ymouse - this.yreg;
	}

	/**
	 * a empty private CONSTRUCT FUNCTION, you can't create instance by this.
	 */
	private function DynamicRegistration() {
		
	}
}