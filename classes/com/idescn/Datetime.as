/*************************************
* name:		Datetime 1.0.1
* author:	whohoo
* email:	whohoo@21cn.com
* date:		Sun Jun 26 00:41:20 2005
**************************************/

import mx.events.EventDispatcher;

/**
* extends Data class.
* <p>
* </p>
* 
*/
class com.idescn.Datetime extends Date {
	
	private static var ARGUMENTS	=	["FullYear","Month","Date","Hours",
											"Minutes","Seconds","Milliseconds"];
	private var _interval:Number	=	1000;
	private var _inter:Number		=	null;
	
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
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	private static var __mixinFED =	EventDispatcher.initialize(Datetime.prototype);
	
	static function checkDate(str:String,format:String):Void{
		var d:Number	=	null;
		var arg:Array	=	Datetime._parseDatetime(str,format);
		var _date:Date	=	new Date(arg[0],arg[1],arg[2],arg[3],arg[4],arg[5],arg[6],arg[7]);
		var i:Number	=	arg.length;
		while(i--){
			d	=	_date["get"+Datetime.ARGUMENTS[i]]();
			if(arg[i]!=d){
				throw new Error(ARGUMENTS[i]+": "+arg[i]+" not equal "+d);
			}
		}
		
	}
	
	private static function _parseDatetime(str:String,format:String):Array{
		var datetime:Array	=	str.split(" ",19);
		var date:Array		=	datetime[0].split("-",10);
		var time:Array		=	datetime[1].split(":",12);
		return Datetime._toNumber([].concat(date,time));
	}
	
	private static function _toNumber(arg:Array):Array{
		var i:Number	=	arg.length;
		var arr:Array	=	[];
		while(i--){
			if(arg[i]==undefined)	continue;
			arr[i]	=	Number(arg[i]);
		};
		return	arr;
	}
	
	/**
	 * second to array remain.
	 * 
	 * @usage   
	 * @param   ms 
	 * @return  [day, hour, minnute, second]
	 */
	public static function toArray(ms:Number):Array{
		var func:Function	=	ms<0 ? Math.ceil : Math.floor;
		
		var d:Number	=	func(ms/86400000);//24*60*60*1000
		var d0:Number	=	ms%86400000;
	
		var h:Number	=	func(d0/3600000);//60*60*1000
		var h0:Number	=	d0%3600000;
	
		var m:Number	=	func(h0/60000);//60*1000
		var m0:Number	=	h0%60000;
	
		var s:Number	=	func(m0/1000);//1000
		var s0:Number	=	m0%1000;
		
		return [d,h,m,s,s0];
	}
	
	function set interval(i:Number):Void{
		_interval	=	i;
		runTime();
	}
	/** the interval between.*/
	function get interval():Number{
		return _interval;
	}
	
	/**
	 * con
	 * 
	 * @usage   
	 * @return  
	 */
	public function Datetime(){
		var arg:Array	=	arguments;
		
		if(typeof arguments[0] == "string"){
			arg	=	Datetime._parseDatetime(arg[0]);
			_isNumber(arg);
			super(arg[0],arg[1]-1,arg[2],arg[3],arg[4],arg[5],arg[6],arg[7]);
		}else{
			_isNumber(arg);
			super(arg[0],arg[1],arg[2],arg[3],arg[4],arg[5],arg[6],arg[7]);
		}
		
	}
	
	/**
	 * start runing time.
	 * 
	 */
	public function runTime():Void{
		stopTime();
		dispatchEvent({type:"onInterval"});
		_inter=setInterval(function(_this:Datetime):Void{
				_this.setTime(_this.getTime()+_this._interval);
				_this.dispatchEvent({type:"onInterval"});
				updateAfterEvent();
			},_interval,this);
	}
	
	/**
	 * stop runing time
	 */
	public function stopTime():Void{
		clearInterval(_inter);
	}
	
	/**
	 * check is number?
	 * 
	 * @param   arg 
	 */
	private  function _isNumber(arg:Array):Void{
		var i:Number	=	arg.length;
		while(i--){
			if(typeof arg[i] != "number" && !(arg[i] instanceof Number)){
				throw new Error("WRONG: ("+arg[i]+") is not a Number at "+Datetime.ARGUMENTS[i]);
			}else if(isNaN(arg[i])){
				throw new Error("WRONG: (Number.NaN) at "+Datetime.ARGUMENTS[i]);
			}
		}
	}
	
	
}
/*
	1.0.1 add dispatchEvent({type:"onInterval"}); when runTime 
*/