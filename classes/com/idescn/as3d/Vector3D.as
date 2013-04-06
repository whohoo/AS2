//******************************************************************************
//	name:	Vector3D 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Mar 01 14:25:49 GMT+0800 2006
//	description: 此类参考http://www.robertpenner.com/书中所写的actionscrip 1.0中
//				定义的Vector3d变化而来.
//******************************************************************************

[IconFile("Vector3D.png")]
/**
* a 3d vector class.<p>
* </p>
* create  3d class with this class, so you could render it with those method.<br>
* thanks http://www.robertpenner.com/, this class from there.
*/
class com.idescn.as3d.Vector3D extends Object{
	/**x position*/
	public var x:Number	=	null;
	/**y position*/
	public var y:Number	=	null;
	/**z position*/
	public var z:Number	=	null;
	/**the default view distance*/
	public static var defaultViewDist:Number	=	300;
	
	private var _angleX:Number	=	0;
	private var _angleY:Number	=	0;
	private var _angleZ:Number	=	0;
		
	/**@private */
	public function set angleX(value:Number):Void {
		var a:Number	=	(value + 360) % 360;
		rotateX(a - _angleX);
		_angleX	=	a;
	}
	
	/**angle Z*/
	public function get angleX():Number { return _angleX; }
	
	/**@private */
	public function set angleY(value:Number):Void {
		var a:Number	=	(value + 360) % 360;
		rotateY(a - _angleY);
		_angleY	=	a;
	}
	
	/**angle Z*/
	public function get angleY():Number { return _angleY; }
	
	/**@private */
	public function set angleZ(value:Number):Void {
		var a:Number	=	(value + 360) % 360;
		rotateZ(a - _angleZ);
		_angleZ	=	a;
	}
	
	/**angle Z*/
	public function get angleZ():Number { return _angleZ; }
	
	/**
	* create a 3d vector class.
	* @param x 0 are defalut value
	* @param y 0 are defalut value
	* @param z 0 are defalut value
	*/
	public function Vector3D(x:Number, y:Number, z:Number) {
		reset(x, y, z);
	}
	
	/******************[STATIC METHOD]******************/
	/**
	* get angle sine value.
	* @param angle 
	* @return 
	*/
	public static function sinD(angle:Number):Number {
		return Math.sin (angle * (Math.PI / 180));
	};
	
	/**
	* get angle cosine value.
	* @param angle 
	* @return 
	*/
	public static function cosD(angle:Number):Number {
		return Math.cos (angle * (Math.PI / 180));
	};
	
	/**
	* get ratio anti-cosine value.
	* @param ratio 
	* @return 
	*/
	public static function acosD(ratio:Number):Number {
		return Math.acos (ratio) * (180 / Math.PI);
	};
	
	
	/******************[PUBLIC METHOD]******************/
	/**
	* reset x, y, z value
	* @param x
	* @param y
	* @param z
	*/
	public function reset(x:Number, y:Number, z:Number) {
		this.x = x==null ? 0 : x;
		this.y = y==null ? 0 : y;
		this.z = z==null ? 0 : z;
	}
	
	/**
	* clone a new vector.
	* @return new Vector3D
	*/
	public function getClone():Vector3D {
		return new Vector3D(x, y, z);
	}
	
	/**
	* compare two class is equals
	* @param v
	* @return true of false
	*/
	public function equals(v:Vector3D):Boolean {
		return (x == v.x && y == v.y && z == v.z);
	}
	
	/**
	* plus tow class
	* @param v
	*/
	public function plus(v:Vector3D):Void {
		x += v.x;
		y += v.y;
		z += v.z;
	}
	
	/**
	* plus and get a new class.
	* @param v
	* @return 
	*/
	public function plusNew(v:Vector3D):Vector3D {
		return new Vector3D(x + v.x, y + v.y, z + v.z);
	}
	
	/**
	* tow class minus.
	* @param v
	*/
	public function minus(v:Vector3D):Void {
		x -= v.x;
		y -= v.y;
		z -= v.z;
	}
	
	/**
	* minus and get a new class.
	* @param v
	* @return
	*/
	public function minusNew(v:Vector3D):Vector3D {
		return new Vector3D(x - v.x, y - v.y, z - v.z);
	}
	
	/**
	* negate
	*/
	public function negate():Void {
		x = -x;
		y = -y;
		z = -z;
	}
	
	/**
	* ngate and get a new class.
	* @return 
	*/
	public function negateNew():Vector3D {
		return new Vector3D(-x, -y, -z);
	}
	
	/**
	* scale this vector3d
	* @param s
	*/
	public function scale(s:Number):Void {
		x *= s;
		y *= s;
		z *= s;
	}
	
	/**
	* scale and return a new class
	* @param s
	* @return 
	*/
	public function scaleNew(s:Number):Vector3D {
		return new Vector3D(x * s, y * s, z * s);
	}
	
	/**
	* get vector length.
	* @return vector length.
	*/
	public function getLength():Number {
		return Math.sqrt(x * x + y * y + z * z);
	}
	
	/**
	* set vector length.
	* @param len 
	*/
	public function setLength(len:Number):Void {
		var r:Number = getLength();
		if (r!=0) {
			scale(len / r);
		} else {
			x = len;
		}
	}
	
	/**
	* dot
	* @param v another vector class.
	* @return  
	*/
	public function dot(v:Vector3D):Number {
		return (x * v.x + y * v.y + z * v.z);
	}
	
	/**
	* cross and get a new class
	* @param v another vector class.
	* @return 
	*/
	public function cross(v:Vector3D):Vector3D {
		var cx:Number = y * v.z - z * v.y;
		var cy:Number = z * v.x - x * v.z;
		var cz:Number = x * v.y - y * v.x;
		return new Vector3D(cx, cy, cz);
	}
	
	/**
	* the angle of tow class.
	* @param v
	* @return angle
	*/
	public function angleBetween(v:Vector3D):Number {
		//var dp:Number		=	dot(v);
		//var cosAngle:Number	=	dp / (getLength() * v.getLength());
		return acosD(dot(v)/(getLength() * v.getLength()));
	}
	
	/**
	* get perspective
	* @param viewDist
	* @return 
	*/
	public function getPerspective(viewDist:Number):Number {
		if (viewDist == undefined) {
			viewDist = defaultViewDist;
		}
		return viewDist / (z + viewDist);
	}
	
	/**
	* 
	* translate 3d to 2d in screen.
	* @param p perspective value, the default are 300/(z+300).
	*/
	public function persProject(p:Number):Void {
		if (p == undefined) {
			p = getPerspective();
		}
		x *= p;
		y *= p;
		z = 0;
	}
	
	/**
	* translate 3d to2d in screen and return a new Vector3D
	* @param p perspective value, the default are 300/(z+300).
	* @return vector3D.
	*/
	public function persProjectNew(p:Number):Vector3D {
		if (p == undefined) {
			p = getPerspective();
		}
		return new Vector3D(p * x, p * y, 0);
	}
	
	/////////////角度的转动//////////////////////
	/**
	* rotate by X axis.
	* @param angle
	*/
	public function rotateX(angle:Number):Void {
		var ca:Number = cosD(angle);
		var sa:Number = sinD(angle);
		rotateX2(ca,sa);
	}
	
	/**
	* rotate by X axis.
	* @param ca
	* @param sa
	*/
	public function rotateX2(ca:Number, sa:Number):Void {
		var tempY:Number = y * ca - z * sa;
		var tempZ:Number = y * sa + z * ca;
		y = tempY;
		z = tempZ;
	}
	
	/**
	* rotate by Y axis.
	* @param angle
	*/
	public function rotateY(angle:Number):Void {
		var ca:Number = cosD(angle);
		var sa:Number = sinD(angle);
		rotateY2(ca,sa);
	}
	
	/**
	* rotate by Y axis.
	* @param ca
	* @param sa
	*/
	public function rotateY2(ca:Number, sa:Number):Void {
		var tempX:Number = x * ca + z * sa;
		var tempZ:Number = x * -sa + z * ca;
		x = tempX;
		z = tempZ;
	}
	/**
	* rotate by Z axis.
	* @param angle
	*/
	public function rotateZ(angle:Number):Void {
		var ca:Number = cosD(angle);
		var sa:Number = sinD(angle);
		rotateZ2(ca,sa);
	}
	
	/**
	* rotate by Z axis.
	* @param ca
	* @param sa
	*/
	public function rotateZ2(ca:Number, sa:Number):Void {
		var tempX:Number = x * ca - y * sa;
		var tempY:Number = x * sa + y * ca;
		x = tempX;
		y = tempY;
	}
	
	/**
	* rotate by XY axis.
	* @param a X axis
	* @param b Y axis
	*/
	public function rotateXY(a:Number, b:Number):Void {
		var ca:Number	= cosD(a);
		var sa:Number	= sinD(a);
		var cb:Number	= cosD(b);
		var sb:Number	= sinD(b);
		rotateXY2(ca,sa,cb,sb);
	}
	
	/**
	* rotate by XY axis.
	* @param ca X axis cosine
	* @param sa X axis sine
	* @param cb Y axis cosine
	* @param sb Y axis sine
	*/
	public function rotateXY2(ca:Number, sa:Number, cb:Number, sb:Number):Void {
		//绕x轴旋转
		var rz:Number = y * sa + z * ca;
		y = y * ca - z * sa;
		//绕y轴旋转
		z = x * -sb + rz * cb;
		x = x * cb + rz * sb;
	}
	
	/**
	* rotate by XYZ  axis.
	* @param a X axis
	* @param b Y axis
	* @param c Z axis
	*/
	public function rotateXYZ(a:Number, b:Number, c:Number):Void {
		
		var ca:Number = cosD(a);
		var sa:Number = sinD(a);
		var cb:Number = cosD(b);
		var sb:Number = sinD(b);
		var cc:Number = cosD(c);
		var sc:Number = sinD(c);
		
		rotateXYZ2(ca, sa, cb, sb, cc, sc);
	}
	
	/**
	* rotate by XYZ  axis.
	* @param ca X axis cosine
	* @param sa X axis sine
	* @param cb Y axis cosine
	* @param sb Y axis sine
	* @param cc Z axis cosine
	* @param sc Z axis sine
	*/
	public function rotateXYZ2(ca:Number,sa:Number,cb:Number,sb:Number,
												cc:Number,sc:Number):Void {
		//绕x轴
		var ry:Number = y * ca - z * sa;
		var rz:Number = y * sa + z * ca;
		//绕y轴
		var rx:Number = x * cb + rz * sb;
		z = x * -sb + rz * cb;
		//绕z轴
		x = rx * cc - ry * sc;
		y = rx * sc + ry * cc;
	}
	
	/**
	* show class name
	* @return class value
	*/
	public function toString():String{
		return "[" 	+ Math.round(x * 1000) / 1000 + ","
					+ Math.round(y * 1000) / 1000 + ","
					+ Math.round(z * 1000) / 1000 + "]";
	}
}
