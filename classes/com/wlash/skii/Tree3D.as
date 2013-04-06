//******************************************************************************
//	name:	Tree3D 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 10 15:51:54 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "fish_sk2.fla" file.
//		
//******************************************************************************


import com.idescn.as3d.Vector3D;
import mx.transitions.Tween;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.skii.Tree3D extends MovieClip{
	
	private var _tw:Tween				=	null;
	private var distanceY:Number		=	null;
	private var distanceZ:Number		=	null;
	private var tree_mc:MovieClip;
	
	public var v3d:Vector3D				=	null;
	public var lastPoint:Vector3D		=	null;
	public var nextPoint:Vector3D		=	null;
	public var pointIndex:Number		=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 */
	public function Tree3D(){
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_tw	=	new Tween(v3d, "x",
					mx.transitions.easing.Strong.easeOut,
					v3d.x, v3d.x, 1.2, true);
		_tw.stop();
		_tw.addListener(this);
		tree_mc.gotoAndPlay(tree_mc._totalframes);
	}
	
	private function onMotionChanged(tw:Tween):Void{
		v3d.y	=	mx.transitions.easing.Strong.easeOut(tw.time, 
									lastPoint.y, distanceY, tw.duration);
		v3d.z	=	mx.transitions.easing.Strong.easeOut(tw.time, 
									lastPoint.z, distanceZ, tw.duration);
		render();
	}
	
	private function onMotionFinished(tw:Tween):Void{
		lastPoint	=	nextPoint;
		if(_parent._parent.curTree==this){
			useHandCursor	=	false;
		}else{
			//useHandCursor	=	true;
		}
		enabled		=	true;
		v3d.x	=	lastPoint.x;
		v3d.y	=	lastPoint.y;
		v3d.z	=	lastPoint.z;
		//_root.debug_txt.text	+=	v3d+"\r";
		render();
	}
	
	private function getRandom(num:Number):Number{
		return num-random(num*2);
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	public function render():Number{
		_visible	=	true;
		var v3d2:Vector3D	=	v3d.plusNew(_parent.viewPoint3D);
		var prep:Number	=	v3d2.getPerspective();
		//trace([v3d,_parent.viewPoint3D, v3d2])
		v3d2.persProject(prep);
		_x	=	v3d2.x;
		_y	=	v3d2.y;
		tree_mc.tree_mc._xscale	=	
		tree_mc.tree_mc._yscale	=	prep*100;
		//tree_mc.menu_mc._xscale	=	
		//tree_mc.menu_mc._yscale	=	10000/_xscale;
		swapDepths(Math.round(prep*1000)+10000);
		tree_mc.tree_mc._alpha	=	prep*200;
		return prep;
	}
	
	public function move2Point(point:Vector3D):Void{
		_tw.obj		=	v3d;
		_tw.begin	=	lastPoint.x;
		_tw.finish	=	point.x;
		distanceY	=	point.y-lastPoint.y;
		distanceZ	=	point.z-lastPoint.z;
		_tw.start();
		nextPoint	=	point;
		enabled		=	false;
		tree_mc.menu_mc.moveOut();
	}
	
	public function menuFollowMouse():Void{
		tree_mc.onMouseMove=function():Void{
			this.posX	=	this._xmouse;
			this.posY	=	this._ymouse;
		}
		tree_mc.isStopFollow	=	false;
		tree_mc.onEnterFrame=function():Void{
			var diffX:Number	=	this.menu_mc._x-this.posX;
			var diffY:Number	=	this.menu_mc._y-this.posY;
			this.menu_mc._x	-=	diffX*.2;
			this.menu_mc._y	-=	diffY*.2;
			if(this.isStopFollow){
				if(Math.abs(diffX)<.2){
					if(Math.abs(diffY)<.2){
						delete this.onEnterFrame;
					}
				}
			}
		}
	}
	
	public function stopMenuFollow():Void{
		tree_mc.isStopFollow	=	true;
		delete tree_mc.onMouseMove;
	}
	
	public function initShow():Void{
		var point:Vector3D	=	lastPoint.getClone();
		lastPoint.x	+=	getRandom(200);
		lastPoint.y	+=	getRandom(200);
		lastPoint.z	+=	getRandom(200);
		move2Point(point);
		
		var tw	=	new Tween(this, "_alpha",
					mx.transitions.easing.Strong.easeOut,
					0, 100, 1.5, true);
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.

//below code were remove from above.
/*

*/
