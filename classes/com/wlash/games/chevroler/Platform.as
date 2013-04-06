//******************************************************************************
//	name:	Platform 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Aug 15 23:44:30 GMT+0800 2006
//	description: This file was created by "clickUpTennisBall.fla" file.
//		23.77米(长)×10.98米(宽), 网高0.914米(中心), 1.07米(两端),柱间距是12.80米
//		前后应留有6.40米的宽地, 左右应留有3.66米的宽地.
//		球场长宽比(1:2.16),宽长比(0.462),长宽高约值(24:11:1)
//******************************************************************************


import com.idescn.as3d.Vector3D;


/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.games.chevroler.Platform extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _offset:Vector3D		=	null;
	private var _rotationX:Number		=	null;
	private var _rotationY:Number		=	null;
	private var _rotationZ:Number		=	null;
	
	private var _points:Object	=	{
								leftUp:null,
								rightUp:null,
								rightDown:null,
								leftDown:null,
								netLeftUp:null,
								netRightUp:null,
								netRightdown:null,
								netLeftDown:null
								}
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	/**offset */
	function get offset():Vector3D{
		return _offset;
	}
	
	/**rotationX */
	function get rotationX():Number{
		return _rotationX;
	}
	
	/**rotationY */
	function get rotationY():Number{
		return _rotationY;
	}
	
	/**rotationZ */
	function get rotationZ():Number{
		return _rotationZ;
	}
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Platform(this);]
	 * @param target target a movie clip
	 * @param leftUp
	 * @param rightUp
	 * @param rightDown
	 * @param leftDown
	 */
	public function Platform(target:MovieClip, leftUp:Vector3D, rightUp:Vector3D,
									rightDown:Vector3D, leftDown:Vector3D){
		this._target			=	target;
		_points.leftUp			=	leftUp;
		_points.rightUp			=	rightUp;
		_points.rightDown		=	rightDown;
		_points.leftDown		=	leftDown;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_target.createEmptyMovieClip("mcPlatForm", 0);
		_offset	=	new Vector3D(0,0,0);
		_rotationX	=	
		_rotationY	=	
		_rotationZ	=	0;
	}
	
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 增加网球的网<p></p>
	 * 这个在ShotTennisBall中当做一个网做参考<br></br>
	 * 在
	 */
	public function addNet(leftUp:Vector3D, rightUp:Vector3D, rightDown:Vector3D,
													leftDown:Vector3D):Void{
		_points.netLeftUp		=	leftUp;
		_points.netRightUp		=	rightUp;
		_points.netRightDown	=	rightDown;
		_points.netLeftDown		=	leftDown;
	}
	
	/**
	 * 增加圆圈进去,<p></p>
	 * 这个是在ShotTennisBall中增加一个目标圆圈所定义的<br></br>
	 * 当球场变化时,这圆圈也会跟着移动或转动
	 * @param   v3d 
	 * @return  返回根据球场在空间的角度与位置返回实际圆的位置
	 */
	public function addCircle(v3d:Vector3D):Object{
		_points.circle	=	v3d;
		v3d.rotateXY(_rotationX, _rotationY);
		v3d.plus(_offset);
		var presp:Number	=	v3d.getPerspective();
		var v2d:Vector3D	=	v3d.persProjectNew(presp);
		return {x:v2d.x, y:v2d.y, scale:presp*100};
	}
	/**
	 * 在X轴方向的转动
	 * 
	 * @param   angle 
	 */
	public function rotateX(angle:Number):Void{
		var r:Number	=	angle*Math.PI/180;
		var ca:Number	=	Math.cos(r);
		var sa:Number	=	Math.sin(r);
		var v3d:Vector3D	=	null;
		for(var prop:String in _points){
			v3d	=	_points[prop];
			if(v3d==null)	continue;
			v3d.rotateX2(ca, sa);
		}
		_rotationX	+=	angle;
	}
	
	/**
	 * 在Y轴方向的转动
	 * 
	 * @param   angle 
	 */
	public function rotateY(angle:Number):Void{
		var r:Number	=	angle*Math.PI/180;
		var ca:Number	=	Math.cos(r);
		var sa:Number	=	Math.sin(r);
		var v3d:Vector3D	=	null;
		for(var prop:String in _points){
			v3d	=	_points[prop];
			if(v3d==null)	continue;
			v3d.rotateY2(ca, sa);
		}
		_rotationY	+=	angle;
	}
	
	
	public function moveTo(x:Number, y:Number, z:Number):Void{
		var m:Vector3D	=	new Vector3D(x, y, z);
		var v3d:Vector3D	=	null;
		for(var prop:String in _points){
			v3d	=	_points[prop];
			if(v3d==null)	continue;
			v3d.plus(m);
		}
		_offset.plus(m);
	}
	
	public function drawMC():Void{
		var v3d:Vector3D		=	null;
		var point2D:Object		=	{};
		for(var prop:String in _points){
			v3d	=	_points[prop];
			if(v3d==null)	continue;
			point2D[prop]	=	v3d.persProjectNew();
		}

		var mc:MovieClip		=	_target.mcPlatForm;
		
		mc.clear();
		//mc.beginFill(0x009900, 80);
		mc.lineStyle(1, 0xff0000, 100);
		mc.moveTo(point2D.leftUp.x, point2D.leftUp.y);
		mc.lineTo(point2D.rightUp.x, point2D.rightUp.y);
		mc.lineTo(point2D.rightDown.x, point2D.rightDown.y);
		mc.lineTo(point2D.leftDown.x, point2D.leftDown.y);
		mc.lineTo(point2D.leftUp.x, point2D.leftUp.y);
		if(point2D.netLeftUp!=null){
			//mc.beginFill(0x000099, 60);
			mc.moveTo(point2D.netLeftUp.x, point2D.netLeftUp.y);
			mc.lineTo(point2D.netRightUp.x, point2D.netRightUp.y);
			mc.lineTo(point2D.netRightDown.x, point2D.netRightDown.y);
			mc.lineTo(point2D.netLeftDown.x, point2D.netLeftDown.y);
			mc.lineTo(point2D.netLeftUp.x, point2D.netLeftUp.y);
		}
		mc.endFill();
		
	}
	
	/**
	 * 只是一个参考人物与球在一个球场行走的类<p></p>
	 * 所以没必要把这个类绘制成2D显示在场景上
	 * 
	 */
	public function render():Void{
		//empty
	}
	
	/**
	 * get current platform 4 position of coordinate.
	 * this method is use for rebuild position in Class.
	 * @return  
	 */
	public function getPlatformPos():String{
		return	"new Vector3D("+_points.leftUp.x+", "+_points.leftUp.y+", "
						+_points.leftUp.z+"),//leftUp\r"+
				"new Vector3D("+_points.rightUp.x+", "+_points.rightUp.y+", "
						+_points.rightUp.z+"),//rightUp\r"+
				"new Vector3D("+_points.rightDown.x+", "+_points.rightDown.y+", "
						+_points.rightDown.z+"),//rightDown\r"+
				"new Vector3D("+_points.leftDown.x+", "+_points.leftDown.y+", "
						+_points.leftDown.z+")//leftDown";
	}
	
	
	
	/**
	 * get all position in this class
	 * @return 
	 */
	public function toString():String{
		var retStr:String	=	"";
		var v3d:Vector3D	=	null;
		for(var prop:String in _points){
			v3d	=	_points[prop];
			if(v3d==null)	continue;
			retStr	+=	prop+" : "+v3d+"\r";
		}
		return retStr;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
/**
	 * Enter description here
	 * 
	 * @param   angleX 
	 * @param   angleY 
	 * @return  
	 */
	/*public function rotateXY(angleX:Number, angleY:Number):Void{
		var rx:Number	=	angleX*Math.PI/180;
		var cax:Number	=	Math.cos(rx);
		var sax:Number	=	Math.sin(rx);
		var ry:Number	=	angleY*Math.PI/180;
		var cay:Number	=	Math.cos(ry);
		var say:Number	=	Math.sin(ry);
		var v3d:Vector3D	=	null;
		for(var prop:String in _points){
			v3d	=	_points[prop];
			if(v3d==null)	continue;
			v3d.rotateXY2(cax, sax, cay, say);
		}
		_rotationX	+=	angleX;
		_rotationY	+=	angleY;
	}*/