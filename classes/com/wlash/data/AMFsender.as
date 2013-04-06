//******************************************************************************
//	name:	AMFsender 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Jun 16 2008 11:04:17 GMT+0800
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


/**
 * dispatch event when default result occur.
 * @eventType 
 /*
[Event(name = "defaultResult", type = "")]
/**
 * dispatch event when error status occur.
 * @eventType 
 /*
[Event(name = "errorStatus", type = "")]

[IconFile("AMFsender.png")]
/**
 * AMFsender.
 * <p>AMF提交或接收数据.</p>
 * 
 */
class com.wlash.data.AMFsender extends Object {
	
	public var remoteClass:String;
	public var responder:Object;
	
	public var netConn:NetConnection;
	
	private var _gatewayUrl:String;
	//************************[READ|WRITE]************************************//
	public function set gatewayUrl(value:String):Void {
		_gatewayUrl	=	value;
	}
	/**远程服务网关地址*/
	public function get gatewayUrl():String { return _gatewayUrl; }
	//************************[READ ONLY]*************************************//
	/**缺省的网关地址*/
	public var DEFAULT_GATEWAY:String	=	"/gateway.php";
	
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(AMFsender.prototype);
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new AMFsender();]
	 * @param remoteClass 定义远程服务器类的名称
	 * @param gateUrl [可选]网关的地址,如果没定义,就用缺省的地址.
	 * @param responder [可选]缺省的返回值调用Responder,如没定义此,则会广播
	 * AMFResponderEvent.DEFAULT_RESULT与AMFResponderEvent.ERROR_STATUS事件.
	 */
	public function AMFsender(remoteClass:String, gateUrl:String, responder:Object) {
		this.remoteClass	=	remoteClass;
		this.gatewayUrl		=	gateUrl;
		this.responder		=	responder;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 */
	private function init():Void {
		netConn	=	new NetConnection();
		connect();
	}
	
	////////only for test() function
	private function onTestResult(e):Void {
		trace("return VALUE: "+e+" | "+remoteClass + ".test()");
	}
	private function onTestStatus(e):Void {
		trace(remoteClass + ".test() | server STATUS:");
		traceObject(e);
	}
	/**
	 * 列出网络服务状态,如果连接有问题,可以通过此调用,这函数只在在NetStatusEvent中info属性
	 * @param	info
	 */
	public function traceNetStatus(info:Object):Void {
		trace("[BEGIN NetStatus:]");
		if (info.level == "error") {
			trace("NetStatus | code: "+info.code+", desc: "+info.description+", details: "+info.details);
		}else {
			var traceStr:String		=	"";
			for (var prop:String in info) {
				traceStr	+=	prop + ": " + info[prop]+", ";
			}
			trace("NetStatus | ..."+traceStr);
		}
		trace("[END].");
	}
	
	/**
	 * 列出netConnection的信息, 如:
	 * client, connected, defaultObjectEncoding, objectEncoding, uri, proxyType, connectedProxyType, usingTLS
	 */
	public function traceNetConnectionInfo():Void {
		trace("[BEGIN NetConnectionInfo:]");
		trace("client: "+netConn.client);
		trace("connected: "+netConn.connected);
		trace("defaultObjectEncoding: "+NetConnection.defaultObjectEncoding);
		trace("objectEncoding: "+netConn.objectEncoding);
		trace("uri: "+netConn.uri);
		trace("proxyType: " + netConn.proxyType);
		if(netConn.connected){//必须连接 NetConnection 对象。
			trace("connectedProxyType: "+netConn.connectedProxyType);
			trace("usingTLS: " + netConn.usingTLS);
		}
		trace("[END].");
	}
	
	/**
	 * default onResult
	 * 当没指定responder时会被调用,
	 * @param	e
	 */
	public function onResult(obj):Void {
		dispatchEvent( { type:"defaultResult", obj:obj } );
		//trace(AMFsender.prototype.dispatchEvent);
	}
	
	/**
	 * default onStatus
	 * 当没指定responder时会被调用,
	 * @param	e
	 */
	public function onStatus(obj):Void {
		dispatchEvent({type:"errorStatus", obj:obj});
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 调用远程服务器上的函数,
	 * @param	remoteFunction 远程函数名
	 * @param	respond 返回值[可选] 如果没有指定,则选择responder,如果responder也没定义,则调用默认的responder
	 * @param	...args 传递的参数[可选],因参数经传递后,后台语言变成Array而不是原来定义等原因,所以这里的参数不能超过五个.
	 */
	public function call(remoteFunction:String, respond:Object):Void {
		if (respond==null) respond	=	this.responder;
		if (respond==null) respond	=	this;
		var args:Array				=	arguments.slice(2);
		switch (args.length) {
			case 0:
				netConn.call(remoteClass + "." + remoteFunction, respond);
			break;
			case 1:
				netConn.call(remoteClass + "." + remoteFunction, respond, args[0]);
			break;
			case 2:
				netConn.call(remoteClass + "." + remoteFunction, respond, args[0], args[1]);
			break;
			case 3:
				netConn.call(remoteClass + "." + remoteFunction, respond, args[0], args[1], args[2]);
			break;
			case 4:
				netConn.call(remoteClass + "." + remoteFunction, respond, args[0], args[1], args[2], args[3]);
			break;
			case 5:
				netConn.call(remoteClass + "." + remoteFunction, respond, args[0], args[1], args[2], args[3], args[4]);
			break;
		}
	}

	/**
	 * 连接服务器,如果没有指定参数,则连接gateway,如果gateway为空值,则连接缺省值"/gateway"
	 * @param	url
	 */
	public function connect(url:String):Void {
		var conUrl:String;
		if (url!=null) {
			_gatewayUrl		=	
			conUrl			=	url;
		}else if (_gatewayUrl!=null) {
			conUrl			=	_gatewayUrl;
		}else {
			conUrl			=	DEFAULT_GATEWAY;
		}
		netConn.connect(conUrl);
	}
	
	/**
	 * 测试远程服务器函数test()
	 * @param	...args
	 */
	public function test():Void {
		var args:Array	=	arguments;
		netConn.call(remoteClass + ".test", {onResult:onTestResult, onStatus:onTestStatus}, args);
		trace("Calling func: "+remoteClass + ".test("+args+")");
	}
	
	
	
	//***********************[STATIC METHOD]**********************************//
	/**
	 * 把对象列出来
	 * @param	obj
	 */
	static public function traceObject(obj:Object):Void {
		for (var prop:String in obj) {
			trace(prop + ": " + obj[prop]);
		}
	}
}

//This template is created by whohoo. ver 1.1.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="0", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;

*/
