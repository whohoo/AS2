import mx.utils.Delegate;
/*utf8*/
//**********************************************************************************//
//	name:	LocalConn 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Aug 24 2009 15:22:54 GMT+0800
//	description: This file was created by "as2.fla" file.
//		
//**********************************************************************************//

//[com.wlash.data.LocalConn]

	
[IconFile("LocalConn.png")]	
/**
 * LocalConn.
 * <p>annotate here for this class.</p>
 * 
 */
class com.wlash.data.LocalConn extends LocalConnection {
	
	private var _connName:String;
	
	public var client:Object;
	//*************************[READ|WRITE]*************************************//
	
	
	//*************************[READ ONLY]**************************************//
	
	
	//*************************[STATIC]*****************************************//
	
	
	/**
	 * CONSTRUCTION FUNCTION.<br />
	 * Create this class BY [new LocalConn();]
	 */
	public function LocalConn(connName:String, listenerName:String) {
		client		=	this;
		_connName	=	connName;
		if (listenerName) {
			connect(listenerName);
		}
		
		_init();
	}
	//*************************[PUBLIC METHOD]**********************************//
	public function call(methodName:String, respond:Object):Void { 
		var args:Array	=	arguments.slice(2);
		var fnName:String;
		if (respond instanceof String) {
			fnName	=	String(respond);
			if(typeof (client[fnName])=="function"){
				args.push(respond);
			}else {
				throw new Error("function : " + fnName + "can't found in " + client);
			}
		}else if(respond instanceof Object){
			if (typeof(client[respond['result']]) == "function") {
				args.push(respond['result']);
			}
			if (typeof(client[respond['status']]) == "function") {
				args.push(respond['status']);
			}
		}
		var isSuccess:Boolean;
		switch (args.length) {
			case 0:
				isSuccess	=	send(_connName, methodName);
			break;
			case 1:
				isSuccess	=	send(_connName, methodName, args[0]);
			break;
			case 2:
				isSuccess	=	send(_connName, methodName, args[0], args[1]);
			break;
			case 3:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2]);
			break;
			case 4:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3]);
			break;
			case 5:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3], args[4]);
			break;
			case 6:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5]);
			break;
			case 7:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
			break;
			case 8:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
			break;
			case 9:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
			break;
			case 10:
				isSuccess	=	send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
			break;
			default:
				throw new Error("args length exceed 10, current value is "+args.length);
		}
		if (!isSuccess) {
			throw new Error("call method["+methodName+"] error! connection name: '"+_connName+"'.");
		}
	}
	
	public function defineMethod(fnName:String, obj:Object, fn:Function):Void {
		this[fnName]	=	Delegate.create(obj, fn);
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String {
		return "LocalConn 1.0";
	}

	
	//*************************[PRIVATE METHOD]*********************************//
	/**
	 * Initialize this class when be instantiated.<br />
	 */
	private function _init():Void {
		
	}
	
	private function __resolve(name:String):Void {
		//trace( ["__resolve : " + name , typeof arguments[0]]);
		var f:Function	=	client[arguments[0] != null ? arguments[0] : name];
		this[name]	=	Delegate.create(client, f);
	}
	
	//*************************[STATIC METHOD]**********************************//
	
	

}//end class [com.wlash.data.LocalConn]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]



*/
