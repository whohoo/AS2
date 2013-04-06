//******************************************************************************
//	name:	TrackingCode 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-11-14 11:42
//	description: 
//		
//******************************************************************************


import flash.external.ExternalInterface;
import System.capabilities;

/**
* tracking code
* @author Wally.ho
*/
class com.wlash.utils.TrackingCode extends Object{
	/**old tracking function*/
	static public var GOOGLE_ANALYTICS_TRACKER_0:String	=	"urchinTracker";
	/**new tracking function*/
	static public var GOOGLE_ANALYTICS_TRACKER_1:String	=	"PageTracker._trackPageview";
	/**
	 * current tracking function, default function is new tracking function
	 * @default GOOGLE_ANALYTICS_TRACKER_1
	 * @see GOOGLE_ANALYTICS_TRACKER_0
	 * @see GOOGLE_ANALYTICS_TRACKER_1
	 */
	static public var gAnalyticsFn:String	=	GOOGLE_ANALYTICS_TRACKER_1;
	
	/**the tracking path prefix.*/
	static public function get prefix():String { return _prefix; }
	/**@private */
	static public function set prefix(value:String):Void {
		if(value.length>0){
			if (value.indexOf("/") != 0) {
				value	=	"/" + value;
			}
			if (value.lastIndexOf('/') == value.length - 1) {
				value	=	value.substr(0, value.length - 1);
			}
		}
		_prefix	=	value;
	}
	static private var _prefix:String			=	"";
	/**other tracking way URL if tackingUrl start with 'http'*/
	static public function get trackingURL():String { return _trackingURL; }
	/**@private */
	static public function set trackingURL(value:String):Void {
		if (value.length > 0) {
			if (value.lastIndexOf('/') == value.length - 1) {
				value	=	value.substr(0, value.length - 1);
			}
		}
		_trackingURL	=	value;
	}
	static private var _trackingURL:String		=	"";
	
	/**
	 * tracking google Analytics and other tracking url if defined TrackingCode.trackingURL.
	 * 
	 * @param	value it dose not including front and end slash '/'
	 * @usage	TrackCode.tracking("Homepage"); or TrackCode.tracking("Gallery Page_create new");
	 * @return  ExternalInterface.callback
	 */
	static public function tracking(value:String) {
		var ret;
		if (value.length > 0) {
			if (value.indexOf("/") == 0) {
				value	=	value.substr(1, value.length - 1);
			}
			if (value.lastIndexOf('/') == value.length - 1) {
				value	=	value.substr(0, value.length - 1);
			}
		}
		if(capabilities.playerType=="External"){//flash IDE
			trace("javascript:PageTracker._trackPageview('" + prefix +"/" + value + "/');");
		}else if (capabilities.playerType != "StandAlone") {
			ret	=	ExternalInterface.call(gAnalyticsFn, prefix + "/" + value + "/");//Google anglytics
			if(trackingURL.indexOf('http')==0){
				//new URLLoader(new URLRequest(trackingURL + prefix + "/" + value + "/"));
				trace(trackingURL + prefix + "/" + value + "/");
				loadVariables(trackingURL + prefix + "/" + value + "/", { }, "GET");
			}
		}
		return ret;
	}
}

