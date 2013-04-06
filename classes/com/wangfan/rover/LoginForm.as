//******************************************************************************
//	name:	LoginForm 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 20 16:44:40 GMT+0800 2006
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.data.Form;
import com.wangfan.rover.MapTiles;
import com.wangfan.rover.GlobalProperty;

/**
 * 用户登录程序.<p></p>
 * 成功登录后,返回用户的基本程序.
 */
class com.wangfan.rover.LoginForm extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _mobileTXT:TextField	=	null;
	private var _passwordTXT:TextField	=	null;
	private var _loginBTN:Button		=	null;
	
	private var _returnLV:LoadVars		=	null;
	private var _form:Form				=	null;
	
	//static public var SITE_HOST:String	=	"http://61.152.93.107/process/";//http://rover.wangfan.com
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoginForm(this);]
	 * @param target target a movie clip
	 */
	public function LoginForm(target:MovieClip){
		this._target	=	target;
		_mobileTXT		=	target["mobile_txt"];
		_passwordTXT	=	target["password_txt"];
		_loginBTN		=	target["login_btn"];
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_loginBTN.onRelease=Delegate.create(this, onLoginRelease);
		_form	=	Form.getInstance(Key.ENTER);
		_form.addItem(_mobileTXT);
		_form.addItem(_passwordTXT);
		_form.addItem(_loginBTN);
		_form.build(true);
	}
	
	private function onLoginRelease():Void{
		if(_mobileTXT.length<0){
			
		}else if(_passwordTXT.length<6){
			
		}
		
		var lv:LoadVars	=	_form.getLoadVars();
		_returnLV			=	lv;
		lv.checkCode		=	_root.checkCode;
		lv.mobilephone		=	lv.mobile;
		delete lv.mobile;
		lv.sendAndLoad(GlobalProperty.SITE_HOST+"login.aspx", lv, "POST");
		
		lv.onLoad=Delegate.create(this, onReturnLoad);
		//lv.onData=Delegate.create(this, onReturnData);
		_loginBTN.enabled	=	false;
	}
	
	private function onReturnLoad(success:Boolean):Void{
		_loginBTN.enabled	=	true;
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					_target._parent.login_name = "失败";
					_target.play();
					break;
				case "1"://TODO 注册成功
					_root.personInfo.roleNum	=	Number(_returnLV.role)-1;
					MapTiles.curLevel			=	//登录结束后直接跳到指定的点
					_root.personInfo.gameLevel	=	Number(_returnLV.gamepass);
					
					_root.personInfo.coin		=	Number(_returnLV.money);
					_root.personInfo.mobile		=	_returnLV.mobilephone;
					_root.personInfo.lockTime	=	_returnLV.lockstatus=="go" ?
												0 : Number(_returnLV.lockstatus);
					//_root.personInfo.award		=	changeAward(_returnLV.award);
					_root.personInfo.realName	=	_returnLV.realname;
					//add by V2, 老虎机得奖的统计，及用户登录时，服务器的时间。
					_root.personInfo.award	=	[changeAward(_returnLV.award),//曾经得过的奖品，此内容不再使用。
											_returnLV.award1count,//老虎机第一个奖项
											_returnLV.award2count,//老虎机第二个奖项
											_returnLV.award3count,//老虎机第三个奖项
											_returnLV.award4count//老虎机第四个奖项
												]
					
					var nowStr:Array	=	_returnLV.lastlogin.split(" ");//2006-11-13 15:00:09
					var nowDate:Array	=	nowStr[0].split("-");
					var nowTime:Array	=	nowStr[1].split(":");
					_root.personInfo.sevTime	=	new Date(nowDate[0], nowDate[1]-1, nowDate[2],
														nowTime[0], nowTime[1], nowTime[2]);
					//TODO debug
					_root.personInfo.sevTime	=	new Date();//DEBUG ONLY!
					//trace(_root.personInfo.sevTime)
					com.wangfan.rover.CountTimer.runningServerTime();
					//com.wangfan.rover.CountTimer.startCountDown();
					_target._parent.login_name	=	"登录成功";
					_target.play();
					//new com.wangfan.rover.LockuserForm(_target);
					//new com.wangfan.rover.ChkLockUserForm(_target);
					break;
				default:
					
			}
		}else{
			
		}
		
	}
	
	private function onReturnData(d:String):Void{
		trace(d);
	}
	
	private function changeAward(award:String):Array{
		var retArr:Array	=	[];
		var awardArr:Array	=	award.split(",");
		var len:Number		=	awardArr.length;
		var awardID:Number	=	null;
		for(var i:Number=0;i<len;i++){
			awardID	=	Number(awardArr[i]);
			if(retArr[awardID]==undefined){
				retArr[awardID]	=	1;
			}else{
				retArr[awardID]++;
			}
		}
		return retArr;
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "LoginForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
