//******************************************************************************
//	name:	Forklift 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Jun 09 16:22:20 GMT+0800 2006
//	description: 叉车可以在横面的画面中前后(也就是左右移动),可以把前边的箱子抬上
//		抬下.
//******************************************************************************

import flash.geom.Transform;
import flash.geom.ColorTransform;

/**
 * a forklift that move left or right, and lift box up or down.<p></p>
 * <b></b>
 * <ul>
 * <li>onLift(state, liftHeight)</li>
 * </ul>
 */
class com.wlash.games.toyota.Forklift extends MovieClip{
	//[**DEBUG**] your ought to remove it after finish this CLASS!
	//public static var tt:Function		=	import com.idescn.utils.Debug;
	
	private var _box:MovieClip			=	null;//升降板上的箱子
	private var _liftBar:MovieClip		=	null;//升降板
	private var _liftB:MovieClip		=	null;//二级支架
	private var _body:MovieClip		=	null;//车身
	private var _wheelA:MovieClip		=	null;//前轮
	private var _wheelB:MovieClip		=	null;//后轮
	private var _liftBarHeight:Number	=	null;//支架板的高度
	private var _liftLevel:Number		=	-1;//升降位置的级别
	
	private var _interID:Number		=	null;//车子发红警告危险
	private var _redStep:Number		=	20;//变为红色的加法值
	
	[Inspectable(defaultValue=10, verbose=0, type=Number)]
	/**the hightest that lift up*/
	public  var liftMax:Number			=	10;
	[Inspectable(defaultValue=.1, verbose=0, type=Number)]
	/**the max move speed*/
	public  var maxSpeed:Number		=	.1;
	
	[Inspectable(defaultValue=10, verbose=0, type=Number)]
	/**the move power of the forklift*/
	public  var movePower:Number		=	5;
	[Inspectable(defaultValue=10, verbose=0, type=Number)]
	/**the load power of the forklift*/
	public  var loadPower:Number		=	3;
	[Inspectable(defaultValue=47, verbose=0, type=Number)]
	/**the bottom lift height*/
	public  var liftAheight:Number		=	47;
	
	//**the max level of lift*/
	public  var maxLiftLevel:Number	=	5;//default value
	/**if active false, the forklift would not move*/
	public  var active:Boolean			=	false;
	
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br>
	* add a listener for a particular event<br>
	* parameters event the name of the event ("click", "change", etc)<br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br>
	* remove a listener for a particular event<br>
	* parameters event the name of the event ("click", "change", etc)<br>
	* parameters handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Forklift.prototype);
	
	//***************************[READ|WIDTH]*********************************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set liftLevel(value:Number):Void{
		if(value==_liftLevel)	return;
		_liftLevel	=	value;
		dispatchEvent({type:"onLift", state:value, liftHeight:_liftBar._y});
	}
	/**level of lift*/
	function get liftLevel():Number{
		return _liftLevel;
	}
	
	
	
	//***************************[READ ONLY]**********************************//
	/**korklift body */
	function get body():MovieClip{
		return _body;
	}
	/**korklift liftBar */
	function get liftBar():MovieClip{
		return _liftBar;
	}
	
	/**korklift box */
	function get box():MovieClip{
		return _box;
	}
	
	/**
	 * construction function.<br></br>
	 * 
	 * @param forklift forklift a movie clip
	 */
	private function Forklift(){
		init();
	}
	
	/*
	* 变红后再变回正常
	*/
	private function runRed():Void{
		var tran:Transform			=	this.transform;
		var colTran:ColorTransform	=	tran.colorTransform;
		if(colTran.redOffset>=260 ){
			_redStep	=	-Math.abs(_redStep);
		}else if(colTran.redOffset<=0){//不能用*=-1,因为下一组变化有可能又会成为-1的
			_redStep	=	Math.abs(_redStep);
		}
		colTran.redOffset 	+=	_redStep;
		//trace([this._name, colTran.redOffset])
		tran.colorTransform	=	colTran;
		this.transform		=	tran;
	}
	
	/*
	* 变回正常
	*/
	private function runNormal():Void{
		var tran:Transform			=	this.transform;
		var colTran:ColorTransform	=	tran.colorTransform;
		colTran.redOffset 	-=	_redStep;
		if(colTran.redOffset<=0){
			colTran.redOffset	=	0;
			clearInterval(_interID);
		}
		tran.colorTransform	=	colTran;
		this.transform		=	tran;
	}
	
	/*
	* 变成死灰色
	*/
	private function runDeath():Void{
		this["setSaturation"](-100);
		//if(this["getSaturation"]<=100){
			//colTran.redOffset	=	0;
			clearInterval(_interID);
		//}
		
	}
	
	//***************************[PRIVATE METHOD]*****************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_liftBar		=	this["liftBar_mc"];
		_body			=	this["body_mc"];
		_liftB			=	this["liftB_mc"];
		_wheelA			=	this["wheelA_mc"];
		_wheelB			=	this["wheelB_mc"];
		_liftBarHeight	=	-_liftBar.getBounds().yMin;
	}
	
	//***************************[PUBLIC METHOD]******************************//
	/**
	 * move ahead if value are positive number, or not
	 * 
	 * @param   d 
	 */
	public function move(d:Number):Void{
		if(!active)		return;
		//因为箱子的重量导致减少车的速度
		this._x		+=	(d*movePower-_box.weight);
		//速度不一样时轮子转速也不一样.
		var dr:Number	=	d*50;
		_wheelA._rotation	=	
		_wheelB._rotation	+=	dr;
	}
	
	/**
	 * lift up if value are positive number, or not
	 * 
	 * @param   d 
	 */
	public function lift(d:Number):Void{
		if(!active)		return;
		//升降的距离
		var liftHeight:Number	=	_liftBar._y-d*loadPower+_box.weight;
		
		//只能升到最高的高度,或降到最低点
		if(liftHeight>0){
			liftHeight	=	0;
			liftLevel	=	0;
		}else if(liftHeight<liftMax){
			liftHeight	=	liftMax;
			liftLevel	=	maxLiftLevel+1;
		}else{
			var maxLevel:Number	=	maxLiftLevel;
			var liftM:Number		=	liftMax;
			var i:Number	=	maxLevel;
			//按maxLiftLevel定义的等分来化分级别,最高为maxLiftLevel,最低为1
			while(i--){
				if(liftHeight<liftM*i/maxLevel){
					liftLevel	=	i+1;
					break;
				}
			}
		}
		//移到指定的位置
		liftTo(liftHeight);
	}
	
	/**
	 * lift up or down to position.
	 * 
	 * @param   position
	 */
	public function liftTo(position:Number):Void{
		_liftBar._y		=	position;
		if(_liftBarHeight-position>liftAheight){
			//抬升的高度大于底层支架的高度,则二级支架显示出来.
			_liftB._y	=	_liftBar._y-_liftBarHeight;
		}
	}
	
	/**
	 * put box to the lift bar
	 * 
	 * @param   boxID 
	 * @return  box
	 */
	public function addBox(boxID:String):MovieClip{
		_box	=	_liftBar.attachMovie(boxID, "mcBox", 10);
		return _box;
	}
	
	/*
	 * warnning, and the forklift would turn red.
	 * @param isActivie
	 */
	public function warnning(isActive:Boolean):Void{
		clearInterval(_interID);
		if(isActive){
			_interID=setInterval(this, "runRed", 30);
		}else{
			if(this.transform.colorTransform.redOffset==0)	return;
			_redStep	=	Math.abs(_redStep);
			_interID=setInterval(this, "runNormal", 30);
		}
	}
	
	/*
	* the forklift would gray and can't move
	*/
	public function death():Void{
		clearInterval(_interID);
		_interID=setInterval(this, "runDeath", 30);
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "Forklift 1.0";
	}
	
	//***************************[STATIC METHOD]******************************//
	
	
}
