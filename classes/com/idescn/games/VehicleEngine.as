//******************************************************************************
//	name:	VehicleEngine 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Jun 05 18:03:53 GMT+0800 2006
//	description: 由FVehicleEngine修改得来,改为AS2,并修改了部分代码.
//******************************************************************************

//import mx.utils.Delegate;
import mx.events.EventDispatcher;

/**
* vehicle Engine for games.
* <p></p>
* 
* <pre>
* var testClass:VehicleEngine	=	new VehicleEngine(vehicle_mc);
* </pre>
* <p></p>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onMove({}): when the vehicle is moved </li>
* <li>onRender({}): when the vehicle is rendered </li>
* </ul>
*/
class com.idescn.games.VehicleEngine extends Object{

	private var _vehicle:MovieClip		= null;		//vehicle
	private var _power:Number			= 0.12;		//power
	private var _turning:Number		= 0.015;		//turning
	private var _braking:Number		= 0.015;		//braking
	private var _accLoss:Number		= 0.8;		//accLoss
	private var _agility:Number		= 0.2;		//agility
	private var _hFriction:Number		= 0.6;		//hFriction
	private var _vFriction:Number		= 0.98;		//vFriction
	private var _rFriction:Number		= 0.9;		//rFriction
	private var _active:Boolean		= true;		//active
	private var _xPos:Number			= 0;		//x position
	private var _yPos:Number			= 0;		//y position
	private var _direction:Number		= 0;		//direction (rad)
	private var _interID:Number		= null;
	
	
	/**horizontal speed (pix/interval)*/
	public  var hSpeed:Number			= 0;
	/**vertical speed (pix/interval)*/
	public  var vSpeed:Number			= 0;
	/**rotating speed (rad/interval)*/
	public  var rSpeed:Number			= 0;
	/**horizontal acceleration (pix/interval)*/
	public  var hAcc:Number			= 0;
	/**vertical acceleration (pix/interval)*/
	public  var vAcc:Number			= 0;
	/**render beteew in interval*/
	public  var interval:Number		= 30;
	/////////////////event
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
	private static var __mixinFED =	EventDispatcher.initialize(VehicleEngine.prototype);
	
	/******************[READ|WIDTH]******************/
	[Inspectable(defaultValue="", verbose=1, type=MovieClip)]
	function set vehicle(value:MovieClip):Void{
		_vehicle		= value;
		if (_vehicle != null) {
			setPosition(_vehicle._x, _vehicle._y, _vehicle._rotation * Math.PI/180);
		}
		active	=	_active;
	}
	/**the vehicle movie clip*/
	function get vehicle():MovieClip{
		return _vehicle;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set power(value:Number):Void{
		_power = value > 0 ? value : 0;
	}
	/**engine power (pix/interval)*/
	function get power():Number{
		return _power;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set turning(value:Number):Void{
		_turning = value > 0 ? value : 0;
	}
	/**turning force (rad/interval)*/
	function get turning():Number{
		return _turning;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set braking(value:Number):Void{
		_braking = value > 0 ? value > 1 ? 1 : value : 0;
	}
	/**braking coefficient (0~1)*/
	function get braking():Number{
		return _braking;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set accLoss(value:Number):Void{
		_accLoss = value > 0 ? value > 1 ? 1 : value : 0;
	}
	/**acceleration loss coefficient (0~1)*/
	function get accLoss():Number{
		return _accLoss;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set agility(value:Number):Void{
		_agility = value > 0 ? (value > 1 ? 1 : value) : 0;
	}
	/**turning agility coefficient (0~1)*/
	function get agility():Number{
		return _agility;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set hFriction(value:Number):Void{
		_hFriction = value > 0 ? (value > 1 ? 1 : value) : 0;
	}
	/**horizontal friction coefficient (0~1)*/
	function get hFriction():Number{
		return _hFriction;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set vFriction(value:Number):Void{
		_vFriction = value > 0 ? (value > 1 ? 1 : value) : 0;
	}
	/**vertical friction coefficient (0~1)*/
	function get vFriction():Number{
		return _vFriction;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set rFriction(value:Number):Void{
		_rFriction = value > 0 ? (value > 1 ? 1 : value) : 0;
	}
	/**rotating friction coefficient (0~1)*/
	function get rFriction():Number{
		return _rFriction;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Boolean)]
	function set active(value:Boolean):Void{
		if (_active = value) {
			clearInterval(_interID);
			_interID=setInterval(this, "driveControl", interval);
		} else {
			clearInterval(_interID);
		}
	}
	/**if the engine is running*/
	function get active():Boolean{
		return _active;
	}
		
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set xPos(value:Number):Void{
		setPosition(value);
	}
	/**x position of vehicle */
	function get xPos():Number{
		return _xPos;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set yPos(value:Number):Void{
		setPosition(null, value);
	}
	/**y position of vehicle */
	function get yPos():Number{
		return _yPos;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set direction(value:Number):Void{
		setPosition(null, null, value);
	}
	/**direction of vehicle */
	function get direction():Number{
		return _direction;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set xSpeed(value:Number):Void{
		setSpeedXY(value);
	}
	/**x speed of vehicle */
	function get xSpeed():Number{
		return Math.cos(_direction) * hSpeed + Math.sin(_direction) * vSpeed;
	}
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set ySpeed(value:Number):Void{
		setSpeedXY(null, value);
	}
	/**y speed of vehicle */
	function get ySpeed():Number{
		return Math.sin(_direction) * hSpeed - Math.cos(_direction) * vSpeed;
	}
	
	//*******[READ ONLY]**********//
	/**the angle between speed direction and body direction (rad)*/
	function get yaw():Number{
		return rSpeed * Math.atan(vSpeed * _agility);
	}
	
	/**the absolute total speed*/
	function get totalSpeed():Number{
		return Math.sqrt(hSpeed*hSpeed + vSpeed*vSpeed);
	}
	
	/**the direction of the total speed*/
	function get speedDir():Number{
		return _direction + Math.atan2(hSpeed, vSpeed);
	}
	
	/**
	 * construction function
	 * @param target target a movie clip
	 */
	public function VehicleEngine(target:MovieClip){
		vehicle		=	target;
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
	}
	
	
	/******************[PUBLIC METHOD]******************/
	//PUBLIC METHODS
	/**
	 * reset engine's speed and acceleration
	 * 
	 */
	public function reset():Void {
		hSpeed	=	vSpeed	=	rSpeed	=	hAcc	=	vAcc	= 0;
	};

	/**
	 * set current position
	 * 
	 * @param   x          
	 * @param   y          
	 * @param   direction  
	 * @param   needRender 
	 */
	public function setPosition(x:Number, y:Number, direction:Number, 
													needRender:Boolean):Void {
		if (x != null){
			_xPos = x;
		}
		if (y != null){
			_yPos = y;
		}
		if (direction != null){
			_direction = direction;
		}
		if (needRender != false){
			render();
		}
	};

	/**
	 * set x and y speed
	 * 
	 * @param   xSpeed 
	 * @param   ySpeed 
	 */
	public function setSpeedXY(xSpeed:Number, ySpeed:Number):Void {
		xSpeed	= xSpeed == null ? this.xSpeed : xSpeed;
		ySpeed	= ySpeed == null ? this.ySpeed : ySpeed;
		hSpeed	= Math.cos(_direction) * xSpeed + Math.sin(_direction) * ySpeed;
		vSpeed	= Math.sin(_direction) * xSpeed - Math.cos(_direction) * ySpeed;
	};

	/**
	 * increase or decrease the vertical speed by a specified rate of power
	 * @param   rate 
	 */
	public function accelerate(rate:Number):Void {
		//trace("rate: "+rate)
		vAcc	+= _power * (rate!=null ? rate : 1);
		
	};

	/**
	 * decrease the vertical speed by a specified rate of braking coefficient
	 * 
	 * @param   rate 
	 */
	public function brake(rate:Number):Void {
		vAcc	-= Math.pow(_braking, rate>0 ? 1/rate : 1) * vSpeed;
		
	};


/**
	 * brake when vertical speed is positive or reverse when it is negative
	 * 
	 * @param   brakeRate   
	 * @param   reverseRate 
	 */
	public function brakeReverse(brakeRate:Number, reverseRate:Number):Void {
		vSpeed > _power*10 ? brake(brakeRate) : accelerate(reverseRate==null ? -1 : -reverseRate);
	};

	/**
	 * turn by a specified rate of turning force
	 * 
	 * @param   rate 
	 */
	public function turn(rate:Number):Void {
		rSpeed	+= _turning * (rate!=null ? rate : 1);
		
	};

	/**
	 * run the vehicle
	 */
	public function run():Void {
		rSpeed			*=	_rFriction;
		var yaw:Number	=	this.yaw;
		_direction		+=	yaw;
		
		var yawSin:Number		= Math.sin(yaw);
		var yawCos:Number		= Math.cos(yaw);
		var yawLoss:Number		= 1 - Math.abs(yawSin) * (1 - _agility);
		var hSpd:Number		= (hSpeed + hAcc) * yawLoss;
		var vSpd:Number		= (vSpeed + vAcc) * yawLoss;
		hSpeed	= (yawCos * hSpd - yawSin * vSpd) * _hFriction;
		vSpeed	= (yawSin * hSpd + yawCos * vSpd) * _vFriction;
		
		_xPos	+= xSpeed;
		_yPos	+= ySpeed;
		vAcc	*= _accLoss;
		hAcc	*= _accLoss;
		
		dispatchEvent({type:"onMove"});
	};

	/**
	 * refresh the target's appearence
	 */
	public function render():Void {
		if (_vehicle == null) return;
		_vehicle._x		= _xPos;
		_vehicle._y		= _yPos;
		_vehicle._rotation	= _direction * 180 / Math.PI;
		
		dispatchEvent({type:"onRender"});
	};

	/**
	 * the default drving controller
	 * 
	 */
	public function driveControl():Void {
		if (Key.isDown(Key.UP)){
			accelerate(1);
		}
		if (Key.isDown(Key.DOWN)){
			brakeReverse(1, 0.5);
		}
		if (Key.isDown(Key.LEFT)){
			turn(-1);
		}
		if (Key.isDown(Key.RIGHT)){
			turn(1);
		}
		run();
		render();
		updateAfterEvent();

	};
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "VehicleEngine [xSpeed: "+xSpeed+", ySpeed:"+ySpeed+"]";
	}
}
