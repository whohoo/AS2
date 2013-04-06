
//******************************************************************************
//	name:	Real3DScene 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	
//	description: This file was created by FlashDevelop.
//		
//******************************************************************************



/**
 * annotate here for this class.<p></p>
 * 
 */
class com.idescn.games.Real3DScene extends MovieClip {
	private var _needRender:Object;
	private var _needDepthSort:Boolean	=	false;
	private var _perspDistance:Number	=	300;
	private var _viewDistMin:Number		=	50;
	private var _viewDistMax:Number		=	5000;
	
	private var _sightLeft:Number		=	-200;
	private var _sightTop:Number		=	-100;
	private var _sightRight:Number		=	200;
	private var _sightBottom:Number		=	100;
	
	private var _xPos:Number			=	0;
	private var _yPos:Number			=	0;
	private var _zPos:Number			=	0;
	private var _direction:Number		=	0;
	
	private var _hideOutSight:Boolean	=	true;
	private var _autoDepthSort:Boolean	=	true;
	
	private var _objects:Object			=	{};
	private var _updating:Boolean		=	false;
	
	private var CameraMC:MovieClip;
	
	public  var defaultDepth:Number		=	1000000;
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue="300" type="Number")]
	public function set perspDistance(value:Object):Void {
		this._perspDistance	= Number(value);
		var objests			= this._objects;
		for (var i in objects) {
			if (objects[i].position.scrX != null) objects[i].position.scrX = null;
		}
		this._needRender	= "all";
		this.render();
	}
	/**the view distance range in which the objects are shown*/
	public function get perspDistance():Object {
		return this._perspDistance;
	}
	
	[Inspectable(defaultValue="min:50,max:5000" type="Object")]
	public function set viewDistance(value:Object):Void {
		if (!(value instanceof Object)) return;
		if (value.min > 0) this._viewDistMin = Number(value.min);
		if (value.max > this._viewDistMin) this._viewDistMax = Number(value.max);
		this._needRender	= "all";
		this.render();
		this._needDepthSort	= true;
		if (this._autoDepthSort) this.depthSort();
	}
	/**the view distance range in which the objects are shown*/
	public function get viewDistance():Object {
		return { min:this._viewDistMin, max:this._viewDistMax };
	}
	
	[Inspectable(defaultValue="left:-200,top:-100,right:200,bottom:100" type="Object")]
	public function set sightRange(value:Object):Void {
		if (!(value instanceof Object)) return;
		if (value.left != null) this._sightLeft = Number(value.left);
		if (value.top != null) this._sightTop = Number(value.top);
		if (value.right != null) this._sightRight = Number(value.right);
		if (value.bottom != null) this._sightBottom = Number(value.bottom);
		this._needRender	= "all";
		this.render();
		this._needDepthSort	= true;
		if (this._autoDepthSort) this.depthSort();
	}
	/**the sight range in which the objects are shown*/
	public function get sightRange():Object {
		return {left:this._sightLeft, top:this._sightTop, right:this._sightRight, bottom:this._sightBottom};
	}
	
	[Inspectable(defaultValue="x:0,y:0,z:0" type="Object")]
	public function set position(value:Object):Void {
		this.setCamera(value.x, value.y, value.z);
	}
	/**position of the camera*/
	public function get position():Object {
		return { x:this._xPos, y:this._yPos, z:this._zPos };
	}
	
	/**@private */
	public function set xPos(value:Number):Void {
		this.setCamera(value, null, null);
	}
	/**x position of the camera */
	public function get xPos():Number {
		return _xPos;
	}
	
	/**@private */
	public function set yPos(value:Number):Void {
		this.setCamera(null, value, null);
	}
	/**y position of the camera */
	public function get yPos():Number {
		return _yPos;
	}	
	
	/**@private */
	public function set zPos(value:Number):Void {
		this.setCamera(null, null, value);
	}
	/**z position of the camera */
	public function get zPos():Number {
		return _zPos;
	}
	
	[Inspectable(defaultValue="0" type="Number")]
	/**@private */
	public function set direction(value:Number):Void {
		this.setCamera(null, null, null, value);
	}
	/**direction of the camera */
	public function get direction():Number {
		return _direction;
	}
	
	[Inspectable(defaultValue="true" type="Boolean")]
	public function set hideOutSight(value:Boolean):Void {
		this._hideOutSight	= value ? true : false;
		this._needRender	= "all";
		this.render();
		this._needDepthSort	= true;
		if (this._autoDepthSort) this.depthSort();
	}
	/**hide the objects that are out of sight range*/
	public function get hideOutSight():Boolean {
		return _hideOutSight;
	}
	
	[Inspectable(defaultValue="true" type="Boolean")]
	public function set autoDepthSort(value:Boolean):Void {
		if (this._autoDepthSort = value ? true : false) this.depthSort();
	}
	/**automatically sort depths of the objects */
	public function get autoDepthSort():Boolean {
		return _autoDepthSort;
	}
	//************************[READ ONLY]*************************************//
	/**the objects in the scene */
	public function get objects():Object {
		return _objects;
	}
	/**if it is currently updating */
	public function get updating():Boolean {
		return _updating;
	}
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Real3DScene.prototype);
	
	/**
	 * Construction function.<br></br>
	 * 
	 */
	public function Real3DScene() {
		this.createEmptyMovieClip("CameraMC", 0);
		var mc:MovieClip	=	this["Assets"];
		mc.swapDepths(CameraMC);
		mc.removeMovieClip();
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void {
		
	}
	
	//pretreating
	private function onPretreat(para) {
		if (para.direction != null) para.direction *= Math.PI / 180;
	};

	//initialization
	private function onInit() {
		this.endUpdate();
	};

	//create an unused object name
	private function _createName(type) {
		var name;
		do name = type + random(0xffffff);
		while (this._objects[name] != null);
		return name;
	};

	//assign position
	private function _assignPos(obj:Object, prop:String, position:Object):Void {
		if (typeof(position) == "string") {
			var objects:Object		= this._objects;
			while (true) {
				var pos		= objects[position].position;
				if (typeof(pos) != "string") break;
				position	= pos;
			}
			obj[prop]		= position;
			objects[position].listeners[obj.name]	= obj;
		} else {
			obj[prop]		= {x:Number(position.x), y:Number(position.y), z:Number(position.z),
								relX:null, relY:null, relZ:null, scale:null, scrX:null, scrY:null};
			if (obj.type == "point") obj.listeners = {};
		}
	};

	//get the screen position of a point
	private function _getScrPos(point:Object):Object {
		if (typeof(point) == "string") point = this._objects[point].position;
		if (point == null) return;
		if (point.relX == null) {
			var p:Object	= {x:point.x, y:point.y};
			this.localToGlobal(p);
			this.CameraMC.globalToLocal(p);
			point.relX	= p.x;
			point.relY	= -p.y;
			point.relZ	= this._zPos - point.z;
			point.scrX	= null;
		}
		
		if (point.relY < this._viewDistMin || point.relY > this._viewDistMax) return;
		
		if (point.scrX == null) {
			point.scale	= this._perspDistance / point.relY;
			point.scrX	= point.relX * point.scale;
			point.scrY	= point.relZ * point.scale;
		}
		
		if (point.scrX < this._sightLeft || point.scrX > this._sightRight) return;
		if (point.scrY < this._sightTop || point.scrY > this._sightBottom) return;
		
		return point;
	};
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * set the camera position and direction
	 * 
	 * @param	x
	 * @param	y
	 * @param	z
	 * @param	direction
	 */
	public function setCamera(x:Number, y:Number, z:Number, direction:Number):Void {
		if (x != null && !isNaN(x)) this.CameraMC._x = this._xPos = Number(x);
		if (y != null && !isNaN(y)) this.CameraMC._y = this._yPos = Number(y);
		if (z != null && !isNaN(z)) this._zPos = Number(z);
		if (direction != null && !isNaN(direction)) {
			this.CameraMC._rotation	= (this._direction = Number(direction)) * 180/Math.PI;
		}
		//this.handleEvent("onCameraChange");
		dispatchEvent({type:"onCameraChange"});
		var objects			= this._objects;
		for (var i in objects) {
			if (objects[i].position.relX != null) objects[i].position.relX = null;
		}
		this._needRender	= "all";
		this.render();
		this._needDepthSort	= true;
		if (this._autoDepthSort) this.depthSort();
	};

	/**
	 * move the camera
	 * 
	 * @param	offsetX
	 * @param	offsetY
	 * @param	offsetZ
	 * @param	offsetDir
	 */
	public function moveCamera(offsetX:Number, offsetY:Number, offsetZ:Number, offsetDir:Number):Void {
		if (offsetX != null && !isNaN(offsetX)) offsetX = this._xPos + Number(offsetX);
		if (offsetY != null && !isNaN(offsetY)) offsetY = this._yPos + Number(offsetY);
		if (offsetZ != null && !isNaN(offsetZ)) offsetZ = this._xPos + Number(offsetZ);
		if (offsetDir != null && !isNaN(offsetDir)) offsetDir = this._direction + Number(offsetDir);
		this.setCamera(offsetX, offsetY, offsetZ, offsetDir);
	};

	/**
	 * add an object into the scene, if name not given, it will create one automatically
	 * 
	 * @param	name
	 * @param	type
	 * @param	mc
	 * @param	position
	 * @param	show
	 */
	public function addObject(name:String, type:String, mc:MovieClip, position:Object, show:Boolean):String {
		if (this._objects[name] != null) return;
		var obj			= {
			name		: name,
			type		: String(type).toLowerCase(),
			mc			: mc,
			show		: show==false ? false : true
		};
		if (name == null) name = obj.name = this._createName(obj.type);

		//deal different object types
		switch (obj.type) {
			case "point":
				this._assignPos(obj, "position", position);
				break;
			case "line":
				//break;
			case "triangle":
				//break;
			default:
				return;
		}

		if (typeof(mc) == "movieclip") {
			obj.offset	= {x:0, y:0};
			this.localToGlobal(obj.offset);
			mc._parent.globalToLocal(obj.offset);
		} else if (mc != null) {
			obj.mc = this.attachMovie(mc.toString(), "Obj_"+name, this.defaultDepth++);
		}
		this._objects[name]	= obj;
		//this.handleEvent("onAddObject", obj);
		dispatchEvent({type:"onAddObject", obj:obj});
		if (obj.mc != null) {
			this.render(name);
			this._needDepthSort	= true;
			if (this._autoDepthSort) this.depthSort();
		}
		return name;
	};

	/**
	 * remove an object
	 * @param	obj
	 */
	public function removeObject(obj:Object):Void {
		obj		= this._objects[obj];
		if (obj == null) return;
		//this.handleEvent("onRemoveObject", obj);
		dispatchEvent({type:"onRemoveObject", obj:obj});
		if (obj.mc != null) obj.mc.removeMovieClip();
		delete this._objects[obj];
		delete this._needRender[obj];
	};

	/**
	 * remove all objects
	 */
	public function removeAllObjects():Void {
		for (var i in this._objects) {
			var obj			= this._objects[i];
			//this.handleEvent("onRemoveObject", obj);
			dispatchEvent({type:"onRemoveObject", obj:obj});
			obj.mc.removeMovieClip();
		}
		this._objects		= {};
		this._needRender	= {};
	};

	/**
	 * show objects
	 */
	public function showObject():Void {
		for (var i:String in arguments) {
			var obj:Object	= this._objects[arguments[i]];
			if (obj == null) continue;
			obj.show		= true;
			this._needRender[obj.name]	= obj;
		}
		this.render();
	};

	/**
	 * hide objects
	 */
	public function hideObject():Void {
		for (var i in arguments) {
			var obj			= this._objects[arguments[i]];
			if (obj == null) continue;
			obj.mc._visible	=
			obj.show		= false;
		}
	};

	/**
	 * check if an object is shown
	 * @param	obj
	 * @return
	 */
	public function objectShown(obj:Object):Boolean {
		return this._objects[obj].show;
	};

	/**
	 * get object movie clip
	 * @param	obj
	 * @return
	 */
	public function objectMC(obj:Object):MovieClip {
		return this._objects[obj].mc;
	};

	/**
	 * get object position
	 * @param	obj
	 * @return
	 */
	public function objectPos(obj:Object):Object {
		obj				= this._objects[obj];
		if (obj == null) return;
		var pos			= obj.type == "point" ? obj.position : obj["postion"+obj.index];
		return typeof(pos) == "string" ? this._objects[pos].position : pos;
	};

	/**
	 * move object
	 * @param	obj
	 * @param	relPos
	 */
	public function moveObjec(obj:Object, relPos):Void {
		obj				= this._objects[obj];
		if (obj == null) return;
		var position	= obj.position;
	};

	/**
	 * begin update objects
	 */
	public function beginUpdate():Void {
		this._updating	= true;
	};

	/**
	 * end update and render objects
	 */
	public function endUpdate():Void {
		this._updating	= false;
		this.render();
		if (this._autoDepthSort) this.depthSort();
	};

	/**
	 * render some objects
	 */
	public function render():Void {
		var needRender		= this._needRender;
		var objects			= this._objects;
		if (needRender != "all") {
			for (var i:String in arguments) {
				needRender[arguments[i]] = objects[arguments[i]];
			}
		}
		if (this._updating) return;
		if (needRender != "all") objects = needRender;
		this._needRender	= {};

		for (i in objects) {
			var obj			= objects[i];
			if (!obj.show) continue;
			var mc			= obj.mc;
			if (mc == null) continue;
			//tt(obj)
			switch (obj.type) {
			case "point":
				var scrPos	= this._getScrPos(obj.position);
				if (scrPos == null) {
					if (mc._visible) mc._visible = false;
				} else {
					if (!mc._visible) mc._visible = true;
					if (mc._parent == this) {
						mc._x		= scrPos.scrX;
						mc._y		= scrPos.scrY;
					} else {
						mc._x		= scrPos.scrX + obj.offset.x;
						mc._y		= scrPos.scrY + obj.offset.y;
					}
					mc._xscale		=
					mc._yscale		= scrPos.scale * 100;
				}
				//this.handleEvent("onRenderObject", obj);
				dispatchEvent({type:"onRenderObject", obj:obj});
				break;
			}
		}
		//this.handleEvent("onRender");
		dispatchEvent({type:"onRender"});
	};

	/**
	 * Sort depths of the objects
	 */
	public function depthSort() {
		this._needDepthSort	= false;
	};
	
	
	/**
	 * show this class
	 * 
	 */
	public function toString():String {
		return "[Real3DScene]";
	}
	//***********************[STATIC METHOD]**********************************//
		
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.

