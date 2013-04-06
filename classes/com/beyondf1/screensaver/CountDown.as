/*************************************
* name:		count down 1.0
* author:	whohoo
* email:	whohoo@21cn.com
* date:		Fri Jun 24 23:54:54 2005
**************************************/
import com.idescn.Datetime;
import mx.events.EventDispatcher;

class com.beyondf1.screensaver.CountDown{
	private var _serv_url:String		=	null;
	private var _curTime:Datetime		=	null;
	private var _endTime:Date			=	null;
	private var _isClientTime:Boolean	=	null;
	
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	private static var __mixinFED =	EventDispatcher.initialize(CountDown.prototype);


	function set serverURL(url:String):Void{
		_serv_url	=	url;
		getServerTime(url);
	}
	function get serverURL():String{
		return _serv_url;
	}
	///////////当前时间///////////////
	function set curTime(d:Datetime):Void{
		_curTime.stopTime();
		_curTime.setTime(d.getTime());
		_curTime.runTime();
		_curTime.addEventListener("onInterval",this);
	}
	function get curTime():Datetime{
		return _curTime;
	}
	
	function set endTime(d:Date):Void{
		_endTime	=	d;
		
	}
	function get endTime():Date{
		return _endTime;
	}
	
	/*function set isClientTime(){
		
		
	}*/
	function get isClientTime():Boolean{
		return endTime;
	}
	
	function CountDown(endTime:Date,url:String){
		_endTime		=	endTime;
		
		if(endTime==undefined){
			throw new Error("必须定义第一个终止时间参数!");
		};
		_serv_url	=	url;
		
		init();
	}
	
	function init():Void{
		if(_serv_url!=undefined){
			getServerTime(_serv_url);
		}else{
			getClientTime();
			_curTime.runTime();
			_curTime.addEventListener("onInterval",this);
		}
	}
	/*function getCurrentTime():Date{
		
		return
	}*/
	
	function getServerTime(url):Void{
		var _lv:LoadVars	=	new LoadVars();
		_lv.load(url);
		var _this:CountDown	=	this;
		_lv.onData=function(d){
			try{
				Datetime.checkDate(d)//如果是日期格式正确
				_this._curTime		=	new Datetime(d);
				_this.dispatchEvent({type:"onSetCurTime",curTime:_this._curTime,isClientTime:false});
				_this._isClientTime	=	false;
				trace("server time: "+_this._curTime);
			}catch(e){//如果时间不正确或得不到返回值,就用当地时间
				trace(e.toString());
				_this.getClientTime();
				trace("client time: "+_this._curTime);
			}finally{
				_this._curTime.runTime();
				_this._curTime.addEventListener("onInterval",_this);
			}
			
		}
	}
	
	function getClientTime():Void{
		_curTime			=	new Datetime();
		dispatchEvent({type:"onSetCurTime",curTime:_curTime,isClientTime:true});
		_isClientTime		=	true;
	}
	
	private function onInterval(eventObj:Object):Void{
		//trace(eventObj.target)
		dispatchEvent({type:"onInterval",arr:Datetime.toArray(_endTime-_curTime)});
	}
	
	function toString():String{
		return "count down."
	}
}