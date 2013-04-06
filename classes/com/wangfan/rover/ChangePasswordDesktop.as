//******************************************************************************
//	name:	ChangePasswordDesktop 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-10-24 15:00
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.data.Form;
import com.wangfan.rover.GlobalProperty;
/**
 * 用户修改密码<p></p>
 * 
 */
class com.wangfan.rover.ChangePasswordDesktop extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip			=	null;
	private var _oldPasswordTXT:TextField	=	null;
	private var _passwordTXT:TextField		=	null;
	private var _password2TXT:TextField		=	null;
	private var	_submitBTN:Button			=	null;
	
	private var _returnLV:LoadVars			=	null;
	private var _form:Form					=	null;
	
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function ChangePasswordDesktop(target:MovieClip){
		this._target	=	target;
		_oldPasswordTXT	=	target.oldPassword_txt;
		_passwordTXT	=	target.password_txt;
		_password2TXT	=	target.password2_txt;
		_submitBTN		=	target.submit_btn;
		init();
		
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_form	=	Form.getInstance(Key.ENTER);
		_form.addItem(_oldPasswordTXT);
		_form.addItem(_passwordTXT);
		_form.addItem(_password2TXT);
		_form.addItem(_submitBTN);
		_form.build(true);
		Form.hintText	=	_target.hints_txt;
		
		_returnLV		=	new LoadVars();
		_returnLV.checkCode	=	_root.checkCode;
		
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
		_submitBTN.onRelease=Delegate.create(this, onSubmitRelease);
	}
	
	private function onSubmitRelease():Void{
		if(_oldPasswordTXT.length<6){
			Form.showHint("密码长度不能小于6位.");
			Selection.setFocus(_oldPasswordTXT);
			return;
		}else if(_passwordTXT.length<6){
			Form.showHint("密码长度不能小于6位.");
			Selection.setFocus(_passwordTXT);
			return;
		}else if(_passwordTXT.text!=_password2TXT.text){
			Form.showHint("密码前后不一致.");
			Selection.setFocus(_password2TXT);
			return;
		}
		_returnLV.mobilephone	=	_root.personInfo.mobile;
		_returnLV.old_pass		=	_oldPasswordTXT.text;
		_returnLV.new_pass		=	_passwordTXT.text;
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"chgPassword.aspx", _returnLV, "POST");
		_submitBTN.enabled	=	false;
		Form.showHint("正在提交.");
	}
	private function onReturnLoad(success:Boolean):Void{
		_submitBTN.enabled	=	true;
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					Form.showHint("修改失败.");
					break;
				case "1":
					Form.showHint("修改成功.");
					_target.isBack	=	true;
					_target.gotoAndStop(1);
					break;
				case "100":
					Form.showHint("系统错误.");
					break;
				case "255":
					//TODO 增加过场
					//trace("用户没有登录!跳到登录界面");
					//应无此返回值,因为增加了登录手机号这一选项
					//_target._parent.close_btn.onRelease();
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
		return "ChangePasswordDesktop 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
