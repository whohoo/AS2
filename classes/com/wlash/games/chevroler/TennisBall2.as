//******************************************************************************
//	name:	Platform 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Aug 15 23:44:30 GMT+0800 2006
//	description: This file was created by "clickUpTennisBall.fla" file.
//		
//******************************************************************************


import com.idescn.as3d.Vector3D;

/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.games.chevroler.TennisBall2 extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	
	private var _ball:Vector3D			=	null;
	private var _ballShadow:Vector3D	=	null;
	private var _ballMC:MovieClip		=	null;
	private var _ballShadowMC:MovieClip	=	null;
	
	
	
	private var _horizontal:Number		=	0;
	/**平台垂直位置,也就是平台的Z轴方向位置*/
	public  var vertical:Number		=	0;
	
	public  var angleX:Number		=	0;
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set horizontal(value:Number):Void{
		_horizontal		=	value;
		_ballShadow.y	=	value;
	}
	/**平台水平位置,也就是平台的Y轴方向的位置*/
	function get horizontal():Number{
		return _horizontal;
	}
	
	
	//************************[READ ONLY]*************************************//
	/**得到此球的Vector3D对象*/
	function get ball():Vector3D{
		return _ball;
	}
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(TennisBall2.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Platform(this);]
	 * @param target target a movie clip
	 */
	public function TennisBall2(target:MovieClip){
		this._target	=	target;
		_ball			=	new Vector3D(0, 0, 0);
		_ballShadow		=	new Vector3D(0, 0, 0);
		
		_ballMC			=	target.attachMovie("tennisBall", "mcBall", 110,
															{_visible:false});
		_ballShadowMC	=	target.attachMovie("ball shadow", "mcBallShadow",
														120, {_visible:false});
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		angleX	=	0;
	}
	
	
	//***********************[PUBLIC METHOD]**********************************//
	public function reset():Void{
		_ball.reset();
		_ballShadow.x	=	0;
		_ballShadow.z	=	0;
		_ballMC._visible		=	
		_ballShadowMC._visible	=	false;
	}
	
	public function moveTo(x:Number, y:Number, z:Number):Void{
		var m:Vector3D	=	new Vector3D(x, y, z);
		_ball.plus(m);
		if(_ball.y>=_horizontal){
			dispatchEvent({type:"onHorizontal", mc:_ballMC});
		}
		//这里只判断靠近视点这一面的墙,
		
		if(_ball.z<=vertical){
			dispatchEvent({type:"onVertical", mc:_ballMC});
		}
	}
	
	public function render():Void{
		var mc:MovieClip		=	_ballMC;
		var mcShadow:MovieClip	=	_ballShadowMC;
		mc._visible			=	
		mcShadow._visible	=	true;
		var v3d:Vector3D	=	_ball.getClone();
		v3d.rotateX(angleX);//这个角度在ShotBall中定义
		
		var persp:Number	=	v3d.getPerspective();
		var v2d:Vector3D	=	v3d.persProjectNew(persp);
		mc._x	=	v2d.x;
		mc._y	=	v2d.y;
		//mc._xscale	=	
		//mc._yscale	=	persp*50;//把球的体积缩小一半
		var depth:Number	=	100000-v3d.z;
		mc.swapDepths(depth);
		
		//shadow
		//_ballShadow.x	=	v3d.x;
		//_ballShadow.z	=	v3d.z;
		var v3dShadow:Vector3D		=	_ball.getClone();
		v3dShadow.y		=	_horizontal;
		v3dShadow.rotateX(angleX);
		v2d			=	v3dShadow.persProjectNew(persp);
		
		mcShadow._x	=	v2d.x;
		mcShadow._y	=	v2d.y;
		
		mc._xscale			=	
		mc._yscale			=
		mcShadow._xscale	=	
		mcShadow._yscale	=	persp*50;//把球的体积缩小一半
		mcShadow._alpha		=	100-(v3dShadow.y-v3d.y)/2;
		mc.swapDepths(depth+10);
	}
	
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return _ball.toString();
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
/*public function rotateX(angle:Number):Void{
		var r:Number	=	angle*Math.PI/180;
		var ca:Number	=	Math.cos(r);
		var sa:Number	=	Math.sin(r);
		
		_ball.rotateX2(ca, sa);
		
	}
	
	public function rotateY(angle:Number):Void{
		var r:Number	=	angle*Math.PI/180;
		var ca:Number	=	Math.cos(r);
		var sa:Number	=	Math.sin(r);
		
		_ball.rotateY2(ca, sa);
		
	}
	
	public function rotateXY(angleX:Number, angleY:Number):Void{
		var rx:Number	=	angleX*Math.PI/180;
		var cax:Number	=	Math.cos(rx);
		var sax:Number	=	Math.sin(rx);
		var ry:Number	=	angleY*Math.PI/180;
		var cay:Number	=	Math.cos(ry);
		var say:Number	=	Math.sin(ry);

		_ball.rotateXY2(cax, sax, cay, say);
	}	
	*/