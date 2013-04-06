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
class com.wlash.games.chevroler.TennisBall extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	
	private var _balls:Array			=	null;
	private var _ballMC:Array			=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Platform(this);]
	 * @param target target a movie clip
	 */
	public function TennisBall(target:MovieClip, ballMC:Array){
		this._target	=	target;
		
		_ballMC			=	ballMC;//引用指向ClickUpBall中的ball mc
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_balls		=	[];
	}
	
	
	//***********************[PUBLIC METHOD]**********************************//
	public function reset():Void{
		_balls	=	[];
	}
	
	public function addBall(mc:MovieClip):Void{
		_balls.push(new Vector3D(mc._x, mc._y, 0));
	}
	
	public function rotateX(angle:Number):Void{
		var r:Number	=	angle*Math.PI/180;
		var ca:Number	=	Math.cos(r);
		var sa:Number	=	Math.sin(r);
		
		var len:Number	=	_balls.length;
		for(var i:Number=0;i<len;i++){
			_balls[i].rotateX2(ca, sa);
		}
	}
	
	public function rotateY(angle:Number):Void{
		var r:Number	=	angle*Math.PI/180;
		var ca:Number	=	Math.cos(r);
		var sa:Number	=	Math.sin(r);
		
		var len:Number	=	_balls.length;
		for(var i:Number=0;i<len;i++){
			_balls[i].rotateY2(ca, sa);
		}
	}
	
	public function rotateXY(angleX:Number, angleY:Number):Void{
		var rx:Number	=	angleX*Math.PI/180;
		var cax:Number	=	Math.cos(rx);
		var sax:Number	=	Math.sin(rx);
		var ry:Number	=	angleY*Math.PI/180;
		var cay:Number	=	Math.cos(ry);
		var say:Number	=	Math.sin(ry);
		
		var len:Number	=	_balls.length;
		for(var i:Number=0;i<len;i++){
			_balls[i].rotateXY2(cax, sax, cay, say);
		}
	}
	
	public function moveTo(x:Number, y:Number, z:Number):Void{
		var m:Vector3D	=	new Vector3D(x, y, z);
		var len:Number	=	_balls.length;
		for(var i:Number=0;i<len;i++){
			_balls[i].plus(m);
		}
	}
	
	public function render():Void{
		var len:Number		=	_balls.length;
		var mc:MovieClip	=	null;
		var v3d:Vector3D	=	null;
		var v3d2:Vector3D	=	null;
		for(var i:Number=0;i<len;i++){
			mc		=	_ballMC[i];
			v3d		=	_balls[i];
			var persp:Number	=	v3d.getPerspective();
			v3d2	=	v3d.persProjectNew(persp);
			mc._x	=	v3d2.x;
			mc._y	=	v3d2.y;
			mc._xscale	=	
			mc._yscale	=	persp*100;
			mc.swapDepths(10000-v3d.z);
		}
		
	}
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "balls size: "+_balls.length;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
