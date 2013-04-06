//******************************************************************************
//	name:	Strip3Dmap 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 11 15:35:06 GMT+0800 2006
//	description: 参照FStrip3Dmap组件修改成as2组件
//			三个dispatchEvent事件
//			dispatchEvent({type:"onResizeView", width:width, height:height, 
//								stripNum:stripNum, hiddenHeight:hiddenHeight});
//			dispatchEvent({type:"onRender"});
//			dispatchEvent({type:"onCameraChange"});
//******************************************************************************

[IconFile("Strip3Dmap.png")]

/**
* component for Strip3Dmap.
* <p></p>
* you could drag FlipPagesBox from component panel(Ctrl+F7) in flash to stage<br></br>
* and define properties in Parameters panel(Alt+F7).<br></br>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onResizeView({width, height, stripNum, hiddenHeight}):  </li>
* <li>onRender({}): if rear page create, state would be true, or it is null  </li>
* <li>onCameraChange({}): adjust the page when according to its position,  </li>
* </ul>
* <b>NOTE:</b> in flash 6, can't visible, in flash 7, there are error in below.
* flash 8 are normal.
*/
class com.idescn.effects.Strip3Dmap extends MovieClip{
	
	private var _viewWidth:Number		= 320;//viewWidth
	private var _viewHeight:Number		= 100;//viewHeight
	private var _mapId:String			= "";//mapId
	private var _stripNum:Number		= 50;//stripNum
	private var _stripMinH:Number		= 1;//stripMinH
	private var _hiddenHeight:Number	= 5;//hiddenHeight
	private var _perspDistance:Number	= 300;//perspDistance
	private var _xPos:Number			= 0;//x position of the camera
	private var _yPos:Number			= 0;//y position of the camera
	private var _zPos:Number			= 10;//z position of the camera
	private var _direction:Number		= 0;//direction (rad)
	private var _stripY:Array			= [];//y positions of the strips
	private var _pretreating:Boolean	= true;
	
	public  var stripIncRatio:Number	= 2.5;//strip incremental ratio
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Strip3Dmap.prototype);
	
	
	/******************[READ|WIDTH]******************/
	[Inspectable(defaultValue="", type=String)]
	function set mapId(value:String):Void{
		var len:Number	=	this._stripY.length;
		if (typeof(value) != "string" || value == "") {
			if (this._mapId != "") {
				this._mapId	= "";
				if (this._pretreating) return;
				
				for (var i:Number=0;i<len;i++){
					this["MapMC" + i].ScaleLayer.PosLayer.removeMovieClip();
				}
			}
		} else {
			this._mapId		= value;
			if (this._pretreating) return;
			for (var i:Number=0;i<len;i++){
				this["MapMC"+i].ScaleLayer.attachMovie(value, "PosLayer", 0);
			}
			this.render();
		}
	}
	/**the map photo Identifier name.*/
	function get mapId():String{
		return _mapId;
	}
	
	function set viewWidth(value:Number):Void{
		resizeView(value);
	}
	/**width of view.*/
	function get viewWidth():Number{
		return _viewWidth;
	}
	
	function set viewHeight(value:Number):Void{
		resizeView(null, value);
	}
	/**height of view*/
	function get viewHeight():Number{
		return _viewHeight;
	}
	
	[Inspectable(defaultValue=50, type=Number)]
	function set stripNum(value:Number):Void{
		resizeView(null, null, value);
	}
	/**strip number*/
	function get stripNum():Number{
		return _stripNum;
	}
	
	[Inspectable(defaultValue=1, verbose=1, type=Number)]
	function set stripMinH(value:Number):Void{
		resizeView(null, null, null, value);
	}
	/**min hieght of strip*/
	function get stripMinH():Number{
		return _stripMinH;
	}
	
	[Inspectable(defaultValue=5, verbose=1, type=Number)]
	function set hiddenHeight(value:Number):Void{
		resizeView(null, null, null, null, value);
	}
	/**hidden's height*/
	function get hiddenHeight():Number{
		return _hiddenHeight;
	}
	
	[Inspectable(defaultValue=300, type=Number)]
	function set perspDistance(value:Number):Void{
		var perspDist:Number	= (this._perspDistance = Number(value)) / 98;
		var stripY:Array		= this._stripY;
		var len:Number	=	stripY.length;
		for (var i:Number=0;i<len;i++){
			this["MapMC"+i]._yscale = 2 + stripY[i]/perspDist;
		}
		this.render();
	}
	/**persp distance*/
	function get perspDistance():Number{
		return _perspDistance;
	}
	
	[Inspectable(defaultValue=0, type=Number, category="position")]
	function set xPos(value:Number):Void{
		setCamera(value);
	}
	/**position of x*/
	function get xPos():Number{
		return _xPos;
	}
	
	[Inspectable(defaultValue=0, type=Number, category="position")]
	function set yPos(value:Number):Void{
		setCamera(null, value);
	}
	/**position of y*/
	function get yPos():Number{
		return _yPos;
	}
	
	[Inspectable(defaultValue=10, type=Number, category="position")]
	function set zPos(value:Number):Void{
		setCamera(null, null, value);
	}
	/**position of z*/
	function get zPos():Number{
		return _zPos;
	}
	
	[Inspectable(defaultValue=0, type=Number)]
	function set direction(value:Number):Void{
		setCamera(null, null, null, value);
	}
	/**direction*/
	function get direction():Number{
		return _direction;
	}
	
	/**
	* construction function
	* you did construction by new Strip3Dmap for this is a component.<br></br>
	* you just drap this component to stage.
	*/
	private function Strip3Dmap(){
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	* Initializtion this class
	* 
	*/
	private function init():Void{
		var mc:MovieClip	=	this["Assets"];
		
		_pretreating	=	false;
		resizeView(this._width, this._height);
		this._xscale	=	this._yscale	=	100;
		
		mc.swapDepths(199999);
		mc.removeMovieClip();
		
	}
	
	/**
	 * 生成一个空影片,并带定义的属性
	 * 
	 * @usage  
	 * @param   mc   
	 * @param   name 
	 * @param   depth   
	 * @param   propObj 
	 * @return  
	 */
	private function createEmptyMC(mc:MovieClip, name:String, depth:Number, 
													propObj:Object):MovieClip{
		var mc0:MovieClip	=	mc.createEmptyMovieClip(name, depth);
		for(var prop:String in propObj){
			mc0[prop]	=	propObj[prop];
		}
		return	mc0;
	}
	
	/**
	 * 使attach进来的影片被定义大小的maskMC所masked
	 * 
	 * @usage   
	 * @param   maskMC 
	 * @param   target 生成指定大小的maskMC
	 * @param   index  层
	 * @param   y      位置
	 * @param   width 变形大小
	 * @param   height 
	 * @return  
	 */
	private function maskStrip(maskMC:MovieClip, target:MovieClip,
				index:Number, y:Number, width:Number, height:Number):Void{
		var mc:MovieClip	=	target.createEmptyMovieClip("MaskMC"+index, 
																	index*2+1);
		width	/=	2;
		height	+=	y;
		mc.beginFill(0x00ffff,40);
		mc.moveTo(-width, y);
		mc.lineTo(width, y);
		mc.lineTo(width, height);
		mc.lineTo(-width, height);
		mc.lineTo(-width, y);
		mc.endFill();
		maskMC.setMask(mc);
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * resize the view
	 * 
	 * @usage   
	 * @param   width        
	 * @param   height       
	 * @param   stripNum     
	 * @param   stripMinH    
	 * @param   hiddenHeight 
	 * @return  
	 */
	public function resizeView(width:Number, height:Number, stripNum:Number,
								stripMinH:Number, hiddenHeight:Number):Void {
		//trace("resizeView  "+arguments);
		
		if (arguments.length > 1) {
			if(width==null){
				width		=	_viewWidth;
			}else{
				_viewWidth	= width;
			}
			if(height==null){
				height		=	_viewHeight;
			}else{
				_viewHeight = height;
			}
			if(stripNum<1 || stripNum==null){
				stripNum	=	_stripNum;
			}else{
				_stripNum	=	stripNum;
			}
			if(stripMinH==null){
				stripMinH	=	_stripMinH;
			}else{
				_stripMinH	=	stripMinH;
			}
			if(hiddenHeight==null){
				hiddenHeight	=	_hiddenHeight;
			}else{
				_hiddenHeight	=	hiddenHeight;
			}
			
			if (this._pretreating)	return;
			var len:Number	=	this._stripY.length;
			for (var i:Number=0;i<len;i++) {
				this["MaskMC" + i].removeMovieClip();
				this["MapMC" + i].removeMovieClip();
			}
			var stripY:Array		= this._stripY = [];
			
			//calculate strip heights and y positions
			if (stripMinH * height <= 0) {
				return;
			}
			var t:Number			=	height - stripMinH * stripNum;
			if (t * height < 0){
				stripNum = int((height - t) / stripMinH);
			}
			var ratio:Number		=	this.stripIncRatio;
			//coefficient of the exponential function
			var a:Number			=	t / Math.pow(stripNum, ratio);
			var scale:Number		=	100 / this._zPos;
			var perspDist:Number	=	this._perspDistance / 98;
			var mc:MovieClip		=	null;
			var y:Number			=	0;
			var stripH:Number		=	0;
			var sy:Number			=	null;
			for (var i:Number=0; i<stripNum; i++) {
				y += stripH;
				stripH	=	stripMinH * (i+1) + a * Math.pow(i+1, ratio) - y;
				sy		=	stripY[i] = y + stripH/2 + hiddenHeight;
				//生成变形的影片
				mc	=	createEmptyMC(createEmptyMC(this, "MapMC"+i, i*2, 
								{_y:sy-hiddenHeight, _yscale:2+sy/perspDist}), 
						"ScaleLayer", 0, {_xscale:scale*sy, _yscale:scale*sy});
				//set mask
				maskStrip(mc, this, i, y, width, stripH+1);
				
			}
			
			if (this._mapId != ""){
				mapId	=	this._mapId;
			}

		} else if (width != null) {
			this._viewWidth	= width = Number(width);
			for (var i in this._stripY){
				this["MaskMC" + i]._xscale = width;
			}
		}
		dispatchEvent({type:"onResizeView", width:width, height:height, 
								stripNum:stripNum, hiddenHeight:hiddenHeight});
	};

	/**
	 * set the camera position and direction
	 * 
	 * @usage   
	 * @param   x          
	 * @param   y          
	 * @param   z          
	 * @param   direction  
	 * @param   needRender 
	 * @return  
	 */
	public function setCamera(x:Number, y:Number, z:Number, direction:Number,
													needRender:Boolean):Void {
		if (x != null && !isNaN(x)) this._xPos = Number(x);
		if (y != null && !isNaN(y)) this._yPos = Number(y);
		if (z != null && !isNaN(z)) {
			var scale:Number		= 100 / (this._zPos = Number(z));
			var stripY:Array		= this._stripY;
			for (var i in stripY) {
				var mc		= this["MapMC"+i].ScaleLayer;
				mc._xscale	=
				mc._yscale	= scale * stripY[i];
			}
		}
		if (direction != null && !isNaN(direction)){
			this._direction = Number(direction);
		}
		dispatchEvent({type:"onCameraChange"});
		if (needRender != false){
			this.render();
		}
	};

	/**
	 * render the map view
	 * 
	 * @usage   
	 * @return  
	 */
	public function render():Void {
		if (this._mapId != "") {
			var sina:Number		= Math.sin(this._direction);
			var cosa:Number		= Math.cos(this._direction);
			var rotation:Number	= -this._direction * 180/Math.PI;
			var dz:Number			= this._perspDistance * this._zPos;
			var stripY:Array		= this._stripY;
			var xPos:Number		= -this._xPos;
			var yPos:Number		= -this._yPos;
			var len:Number			=	stripY.length;
			for (var i=0;i<len;i++) {
				var mc			= this["MapMC" + i].ScaleLayer;
				var distance	= dz / stripY[i];
				mc.PosLayer._x	= xPos - sina * distance;
				mc.PosLayer._y	= yPos + cosa * distance;
				mc._rotation	= rotation;
			}
		}
		dispatchEvent({type:"onRender"});
	};
	
	/**
	* show class name
	* @return class name
	*/
	public function toString():String{
		return "Strip3Dmap 1.0";
	}
}
