/////////////////////////////////////////////////
//	name:	Matrix 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sun Sep 04 00:15:08 2005
//	description:	
//		 当转动角度时,会被缩放,这问题!
//		 
/////////////////////////////////////////////////

class com.wlash.utils.Matrix{
	private var	e:Number	=	0;//constant	0
	private var f:Number	=	0;//constant	0
	private var g:Number	=	1;//constant	1
	private var r:Number	=	0;//angle
	
	public	var a:Number	=	0;
	public	var b:Number	=	0;
	public	var c:Number	=	null;
	public	var d:Number	=	null;
	public	var tx:Number	=	null;
	public	var ty:Number	=	null;
	
	
	
	/**
	* Creates a new Matrix object with the specified parameters.
	* @param a,b,c,d,tx,ty all are number, If you do not provide 
	* any parameters to the new Matrix() constructor it creates 
	* an "identity matrix" with the following values:
	*	 /		  \				 /		 \
	*	| a  b	tx |			| 1  0	0 |
	* 	| c  d  ty |			| 0	 1	0 |
	*	| e  f  g  |			| 0	 0	1 |
	* 	 \		  / 			 \		 /
	*/
	public function Matrix(a:Number,b:Number,c:Number,d:Number,tx:Number,
																	ty:Number){
		if(a==null){
			identity();
		}else{
			this.a	=	a;
			this.b	=	b;
			this.c	=	c;
			this.d	=	d;
			this.tx	=	tx;
			this.ty	=	ty;
			
		}
	}
	
	/**
	* get a matrix 
	* @param target
	* @return a new matrix 
	*/
	public static function getInstance(target:MovieClip):com.wlash.utils.Matrix{
		var r:Number		=	target._rotation*Math.PI/180;
		var cr:Number		=	Math.cos(r);
		var sr:Number		=	Math.sin(r);
		var	tx:Number		=	target._x;
		var ty:Number		=	target._y;
		var a:Number		=	target._xscale/100*cr;
		var b:Number		=	sr;
		var c:Number		=	-sr;
		var d:Number		=	target._yscale/100*cr;
		var m:Matrix		=	new com.wlash.utils.Matrix(a,b,c,d,tx,ty);
		m.r					=	r;
		return m;
	}
	
	////////////////[PUBLIC MODTH]////////////
	/**
	* Sets each matrix property to a value that cause a transformed 
	* movie clip or geometric construct to be identical to the original. 
	* After calling the identity() method, the resulting matrix has the 
	* following properties: a=1, b=0, c=0, d=1, tx=0, ty=0.
	*		 /		 \
	*		| 1  0	0 |
	* 		| 0	 1	0 |
	*		| 0	 0	1 |
	* 		 \		 /
	*/
	public function identity():Void{
		a	=	1;
		b	=	0;
		c	=	0;
		d	=	1;
		tx	=	0;
		ty	=	0;
		e	=	0;
		f	=	0;
		g	=	1;
		r	=	0;//angle
	}
	
	/**
	* Concatenates a matrix with the current matrix, effectively 
	* combining the geometric effects of the two. In mathematical 
	* terms, concatenating two matrices is the same as combining 
	* them using matrix multiplication.
	* @param mx mx is Matrix that wanna concat.
	*/
	public function concat(mx:Matrix):Void{
		var ma:Object	=	{};
		ma.a	= a * mx.a 	+ b * mx.c 	+ e * mx.tx;
		ma.b	= a * mx.b 	+ b * mx.d 	+ e * mx.ty;
		ma.c	= c * mx.a 	+ d * mx.c 	+ f * mx.tx;
		ma.d	= c * mx.b 	+ d * mx.d 	+ f * mx.ty;
		ma.tx	= tx * mx.a	+ ty * mx.c	+ g * mx.tx;
		ma.ty	= tx * mx.b	+ ty * mx.d	+ g * mx.ty;
		ma.e	= a * mx.e 	+ b * mx.f 	+ e * mx.g;		//0
		ma.f	= c * mx.e 	+ d * mx.f 	+ f * mx.g;		//0
		ma.g	= tx * mx.e	+ ty * mx.f	+ g * mx.g;		//1
		for(var i:String in ma){
			this[i]	=	ma[i];
		}
	}
	
	/**
	* Modifies a matrix so that the effect of its transformation is to 
	* move an object along the x and y axes.
	* 		 /		 \
	*		| 1  0	tx|
	* 		| 0	 1	ty|
	*		| 0	 0	1 |
	* 		 \		 /
	* 
	* @param tx tx is _x,
	* @param ty ty is _y;
	*/
	public function translate(tx:Number,ty:Number):Void{
		concat(new com.wlash.utils.Matrix(1,0,0,1,tx,ty));
	}
	
	/**
	* Modifies a matrix so that its effect, when applied, is to resize 
	* an image. In the resized image the location of each pixel by on 
	* the x axis will be multiplied by sx, and on the y axis it will be 
	* muiplied by sy. 
	*		 /		 \
	*		| sx 0	0 |
	* 		| 0	 xy 0 |
	*		| 0	 0	1 |
	* 		 \		 /
	* 
	* @param sx sx is _xscale
	* @param sy sy is _yscale
	*/
	public function scale(sx:Number,sy:Number):Void{
		concat(new com.wlash.utils.Matrix(sx,0,0,sy,0,0));
	}
	
	/**
	* Sets the values in the current matrix so it can be used to apply 
	* a rotation transformation. The rotate() method alters the a and d 
	* properties of the matrix object.
	* 		 /		 		  \
	*		| cos(q)  sin(q) 0 |
	* 		| -sin(q) cos(q) 0 |
	*		|   0	   0	 1 |
	* 		 \		 		  /
	* 
	* @param angle The rotation angle in radians.
	*/
	public function rotate(angle:Number):Void{
		var cosVal:Number	=	Math.cos (angle);
		var sinVal:Number	=	Math.sin (angle);
		concat(new com.wlash.utils.Matrix(cosVal,sinVal,-sinVal,cosVal,0,0));
		r	+=	angle;
	}
	
	/**
	* Progressively slides the image in a direction parallel to the x or y axis. 
	* The value skx acts as a multiplier controlling the sliding distance along 
	* the x axis; sky controls the sliding distance along the y axis.
	* 		 /			 		 \
	*		|   0  	  shearX	0 |
	* 		| shearY	0 		0 |
	*		|   0	    0		1 |
	* 		 \		 			 /
	* 
	* @param shearX the value is radians
	* @param shearY the value is radians
	*/
	public function shear(shearX:Number,shearY:Number):Void{
		var m:Matrix	=	new com.wlash.utils.Matrix(1,shearX,shearY,1,0,0);
		
		concat(m);
	}
	
	/**
	* Returns a new Matrix object that is a clone of this matrix, with an exact 
	* copy of the contained object.
	* @return	a new Matrix
	*/
	public function clone():Matrix{
		var m:Matrix	=	new Matrix();
		m.concat(this);
		return	m;
	}
	
	/**
	* An inverted matrix will perform the opposite trasnformation of the original 
	* martix. You can apply an inverted matrix to an object to undo the transformation 
	* performed when applying the original matrix.
	*/
	public function invert():Void{
		var ma:Object	=	{};
		/*ma.a	=	(1-b*mx.c-e*mx.tx)/a;
		ma.b	=	(0-b*mx.d-e*mx.ty)/a;
		ma.c	=	(0-c*mx.a-f*mx.tx)/d;
		ma.d	=	(1-c*mx.b-f*mx.ty)/d;
		ma.tx	=	(0-tx*mx.a-ty*mx.c)/g;
		ma.ty	=	(0-tx*mx.b-ty*mx.d)/g;
		ma.e	=	(0-b*mx.f-e*mx.g)/a;
		ma.f	=	(0-d*mx.f-f*mx.g)/c;
		ma.g	=	(1-tx*mx.e-ty*mx.f)/g;
		*/
		ma.a	=	d/(a*d-b*c);
		ma.b	=	b/(b*c-a*d);
		ma.c	=	c/(b*c-a*d);
		ma.d	=	a/(a*d-b*c);
		ma.tx	=	-(tx*ma.a+ty*ma.c);
		ma.ty	=	-(tx*ma.b+ty*ma.d);
		for(var i:String in ma){
			this[i]	=	ma[i];
		}
	}
	
	/**
	* The createBox() method includes parameters for scaling, rotation, and translation.
	* When applied to a matrix it sets the matrix's values based on those parameters. 
	* Using the createBox() lets you obtain the same matrix as you would if you were to 
	* apply the identity(), rotate(), scale(), and translate() methods in succession.
	* @param scaleX _xscale
	* @param scaleY _yscale
	* @param rotation _rotation
	* @param tx _x
	* @param ty _y
	*/
	public function createBox(scaleX:Number, scaleY:Number, rotation:Number, 
												tx:Number, ty:Number):Void{
		identity();
		scale(scaleX,scaleY);
		rotate(rotation);
		translate(tx,ty);
	}
	
	/**
	* Creates the specific style of matrix expected by the MovieClip.beginGradientFill() method. 
	* Width and height are scaled to a scaleX/scaleY pair and the tx/ty values are offset by 
	* half the width and height.
	* @param width
	* @param height
	* @param rotation
	* @param tx
	* @param ty
	* @return Object {a:200,b:0,c:0,d:0,e:200,f:0,g:100,h:100,i:1}
	*/
	public function createGradientBox(width:Number, height:Number, 
							rotation:Number, tx:Number, ty:Number) : Object{
		identity();
		scale(width/1638.4,width/1638.4);
		rotate(rotation);
		translate(width/2+tx,height/2+ty);
		return {a:width, b:b*1638.4, c:0,
				d:c*1638.4, e:height, f:0,
				g:this.tx, h:this.tx, i:1};
	}
	
	/**
	* apply this matrix to mc
	* @param target
	*/
	public function apply(target:MovieClip):Void{
		target._x			=	this.tx;
		target._y			=	this.ty;
		target._rotation	=	r * 180 / Math.PI;
		var cr:Number		=	100/Math.cos(r);
		target._xscale		=	this.a * cr;
		target._yscale		=	this.d * cr;
		
		
	}
	
	/**
	* Given a point in the pre-transform coordinate space, this method returns the coordinates of 
	* that point after the transformation occurs. Unlike the standard transformation applied using 
	* the transformPoint() method, the deltaTransformPoint() method's transformation does not consider 
	* the translation parameters tx and ty.
	* @param pt 
	* @return Point
	*/
	/*function deltaTransformPoint(pt:Point) : Point{
		
		return 
	}*/
	
	/**
	* Applies the geometric transformation represented by this Matrix object to
	* the specified point.
	* @param pt
	* @return point
	*/
	/*function transformPoint(pt:Point) : Point{
		
		return
	}*/
	
	/**
	* show the matrix value
	* @return [a=1, b=0, c=0, d=1, tx=0, ty=0]
	*/
	public function toString():String{
		return	"[a="+a+" ,b="+b+", c="+c+", d="+d+", tx="+tx+", ty="+ty+"]";
	}
}