/*utf8*/
//**********************************************************************************//
//	name:	AS2Main 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Aug 24 2009 15:23:57 GMT+0800
//	description: This file was created by "as2.fla" file.
//		
//**********************************************************************************//


import com.wlash.data.LocalConn;
import mx.utils.Delegate;
[IconFile("AS2Main.png")]	
/**
 * AS2Main.
 * <p>annotate here for this class.</p>
 * 
 */
class LocalConn_as2Main extends MovieClip {
	public var result_txt:TextField;
	public var click_btn:Button;
	
	
	private var _localConn:LocalConn;
	
	
	//*************************[READ|WRITE]*************************************//
	
	
	//*************************[READ ONLY]**************************************//
	
	
	//*************************[STATIC]*****************************************//
	
	
	/**
	 * CONSTRUCTION FUNCTION.<br />
	 * Create this class BY [new AS2Main();]
	 */
	public function LocalConn_as2Main() {
		
		_init();
	}
	//*************************[PUBLIC METHOD]**********************************//
	public function test2(value):String {
		//trace([ "test2 : " + (arguments[1] instanceof Date), arguments, arguments.length]);
		//throw new Error("test");
		showMsg(value);
		if(arguments[2]){
			_localConn.call(arguments[2], null, "i form AS2 " + value);
		}
		return "i form AS2 " + value;
	}
	
	public function onResult(d):Void {
		trace( "onResult2 : " + d );
		
	}
	
	public function onStatus():Void{
		
	}
		
	//*************************[PRIVATE METHOD]*********************************//
	/**
	 * Initialize this class when be instantiated.<br />
	 */
	private function _init():Void {
		_localConn			=	new LocalConn("AS2", "AS3");
		_localConn.client	=	this;
		_localConn.test2;//define method
		_localConn.onResult;//define method
		
		click_btn.onRelease = Delegate.create(this, _onClick);
	}
	
	private function _onClick():Void {
		_localConn.call("test3", {result:'onResult', status:'onStatus'}, "[from AS2]", new Date(1992));
	}
	
	private function showMsg(value:String):Void {
		result_txt.text	=	value + "\r";
	}
	
	//*************************[STATIC METHOD]**********************************//
	
	

}//end class [com.wlash.testing.AS2Main]
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
