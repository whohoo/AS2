//******************************************************************************
//	name:	SendMailForm 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 27 14:25:54 GMT+0800 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************

import mx.utils.Delegate;
import com.wangfan.data.Form;
import com.wangfan.rover.GlobalProperty;
/**
 * 邮件转发程序.<p></p>
 * 用户首先必须先登录，方可以发送邮件
 */
class com.wangfan.rover.SendMailForm extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _emailTXT:TextField	=	null;
	private var _realNameTXT:TextField	=	null;
	private var _wordsTXT:TextField	=	null;
	private var _sendBTN:Button		=	null;
	
	private var _returnLV:LoadVars		=	null;
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SendMailForm(this);]
	 * @param target target a movie clip
	 */
	public function SendMailForm(target:MovieClip){
		this._target	=	target;
		_emailTXT		=	target.email_txt;
		_realNameTXT	=	target.realName_txt;
		_wordsTXT		=	target.words_txt;
		_sendBTN		=	target.send_btn;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_returnLV	=	new LoadVars();
		_sendBTN.onRelease=Delegate.create(this, onSendRelease);
		Selection.setFocus(_emailTXT);
	}
	
	private function onSendRelease():Void{
		if(!Form.checkEmail(_emailTXT.text)){
			Selection.setFocus(_emailTXT);
			return;
		}
		_returnLV.checkCode	=	_root.checkCode;
		_returnLV.emaillist	=	_emailTXT.text;
		_returnLV.username	=	_realNameTXT.text;
		_returnLV.content	=	_wordsTXT.text;
		
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"sendfriend.aspx", _returnLV, "POST");
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					
					break;
				case "1"://发送成功。
					_root.boxplay	=	"空";
					_target.onMouseUp();
					break;
				case "255":
					//TODO 增加过场
					//trace("用户没有登录!跳到登录界面");
					_root.page	=	"登录";
					_root.gotoAndPlay("gotomap");
					break;
			}
		}
		
		
	}

	private function onReturnData(d:String):Void{
		trace(d);
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "SendMailForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
