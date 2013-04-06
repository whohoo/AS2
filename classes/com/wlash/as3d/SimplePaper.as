/*utf8*/
//**********************************************************************************//
//	name:	Paper 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Dec 22 2009 15:25:25 GMT+0800
//	description: This file was created by "coverFlip2.fla" file.
//				
//**********************************************************************************//


//[com.wlash.as3d.SimplePaper]

import flash.display.BitmapData;
import com.idescn.as3d.Vector3D;
import flash.geom.Rectangle;
import com.wlash.as3d.DistortImage;
/**
 * Paper.
 * <p>annotate here for this class.</p>
 * 
 */
class com.wlash.as3d.SimplePaper extends MovieClip {
	
	
	public var v3d:Vector3D;
	public var setpX:Number	=	2;
	public var setpY:Number	=	2;
	public var image_mc:MovieClip;
	
	public var viewDist:Number	=	800;
	
	private var p0:Vector3D;//left up
	private var p1:Vector3D;//right up
	private var p2:Vector3D;//right down
	private var p3:Vector3D;//left down
	
	private var bmp:BitmapData;
	private var disImage:DistortImage;
	private var container:MovieClip;
	
	private var _imageMc:MovieClip;
	
	//*************************[READ|WRITE]*************************************//
	/**@private */
	public function set angleX(value:Number):Void {
		v3d.angleX	=	value;
		for (var i:Number = 0; i < 4; i++) {
			var p:Vector3D	=	this["p" + i];
			p.angleX	=	value;
		}
		render();
	}
	
	/**Annotation*/
	public function get angleX():Number { return v3d.angleX; }
	
	/**@private */
	public function set angleY(value:Number):Void {
		v3d.angleY	=	value;
		for (var i:Number = 0; i < 4; i++) {
			var p:Vector3D	=	this["p" + i];
			p.angleY	=	value;
		}
		render();
	}
	
	/**Annotation*/
	public function get angleY():Number { return v3d.angleY; }
	
	/**@private */
	public function set angleZ(value:Number):Void {
		v3d.angleZ	=	value;
		for (var i:Number = 0; i < 4; i++) {
			var p:Vector3D	=	this["p" + i];
			p.angleZ	=	value;
		}
		render();
	}
	
	/**Annotation*/
	public function get angleZ():Number { return v3d.angleZ; }
	
	/**@private */
	public function set x3(value:Number):Void {
		var v:Vector3D	=	new Vector3D(value-v3d.x, 0, 0);
		v3d.x	=	value;
		for (var i:Number = 0; i < 4; i++) {
			var p:Vector3D	=	this["p" + i];
			p.plus(v);
		}
		render();
	}
	
	/**Annotation*/
	public function get x3():Number { return v3d.x; }
	
	/**@private */
	public function set y3(value:Number):Void {
		var v:Vector3D	=	new Vector3D(0, value-v3d.y, 0);
		v3d.y	=	value;
		for (var i:Number = 0; i < 4; i++) {
			var p:Vector3D	=	this["p" + i];
			p.plus(v);
		}
		render();
	}
	
	/**Annotation*/
	public function get y3():Number { return v3d.y; }
	
	/**@private */
	public function set z3(value:Number):Void {
		var v:Vector3D	=	new Vector3D(0, 0, value-v3d.z);
		v3d.z	=	value;
		for (var i:Number = 0; i < 4; i++) {
			var p:Vector3D	=	this["p" + i];
			p.plus(v);
		}
		render();
	}
	
	/**Annotation*/
	public function get z3():Number { return v3d.z; }
	//*************************[READ ONLY]**************************************//
	
	
	//*************************[STATIC]*****************************************//
	
	
	/**
	 * CONSTRUCTION FUNCTION.<br />
	 * Create this class BY [new Paper();]
	 */
	public function SimplePaper() {
		_imageMc	=	image_mc;
		_imageMc._visible	=	false;
		_init();
	}
	
	
	//*************************[PUBLIC METHOD]**********************************//
	public function updateBitmap():Void {
		if (disImage.texture) {
			disImage.texture.dispose();
		}
		bmp	=	new BitmapData(_imageMc._width, _imageMc._height, true, 0xffffff);
		bmp.draw(_imageMc);
		disImage.target	=	bmp;
		disImage.initialize(setpX, setpY);
	}
	
	public function render():Void {
		var pp0:Vector3D	=	getPresProjectVector3D(p0);
		var pp1:Vector3D	=	getPresProjectVector3D(p1);
		var pp2:Vector3D	=	getPresProjectVector3D(p2);
		var pp3:Vector3D	=	getPresProjectVector3D(p3);

		disImage.setTransform(pp0.x, pp0.y, 
							pp1.x, pp1.y, 
							pp2.x, pp2.y, 
							pp3.x, pp3.y);
	}
	
	
	private function getPresProjectVector3D(v:Vector3D):Vector3D {
		var pp:Vector3D	=	v.getClone();
		var prep:Number	=	pp.getPerspective(viewDist);
		pp.persProject(prep);
		return pp;
	}
	
	private function initVector3D():Void {
		var w2:Number	=	_imageMc._width * .5;
		var h2:Number	=	_imageMc._height * .5;
		p0	=	new Vector3D(-w2, -h2, 0);
		p1	=	new Vector3D(w2, -h2, 0);
		p2	=	new Vector3D(w2, h2, 0);
		p3	=	new Vector3D(-w2, h2, 0);
		//trace(p0, p1, p2, p3);
	}
	
	//*************************[PRIVATE METHOD]*********************************//
	/**
	 * Initialize this class when be instantiated.<br />
	 */
	private function _init():Void {
		v3d	=	new Vector3D();
		initVector3D();
		
		container	=	createEmptyMovieClip("container_mc", 0);
		container._x	=	_imageMc._width * .5;
		container._y	=	_imageMc._height * .5;
		
		disImage	=	new DistortImage();
		disImage.container	=	container;
		
		updateBitmap();
		
		render();
	}
	//*************************[STATIC METHOD]**********************************//
	
	
}
//end class [com.wlash.as3d.Paper]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="1", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;


*/
