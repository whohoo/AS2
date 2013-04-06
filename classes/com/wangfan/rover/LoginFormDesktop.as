//******************************************************************************
//	name:	LoginFormDesktop 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-10-24 15:01
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.data.Form;
import com.wangfan.rover.GetPassPortDesktop;
import com.wangfan.rover.GlobalProperty;
/**
 * 用户登录程序,应用于桌面程序.<p></p>
 * 此link地址与网站上的登录不一样,多了用户的详细返回值.
 */
class com.wangfan.rover.LoginFormDesktop extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _mobileTXT:TextField	=	null;
	private var _passwordTXT:TextField	=	null;
	private var _loginBTN:Button		=	null;
	private var _registBTN:Button		=	null;
	
	private var _returnLV:LoadVars		=	null;
	private var _form:Form				=	null;
	
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";//http://rover.wangfan.com
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoginForm(this);]
	 * @param target target a movie clip
	 */
	public function LoginFormDesktop(target:MovieClip){
		this._target	=	target;
		_mobileTXT		=	target.login_mc["mobile_txt"];
		_passwordTXT	=	target.login_mc["password_txt"];
		_loginBTN		=	target.login_mc["login_btn"];
		_registBTN		=	target.login_mc["regist_btn"];//trace([_mobileTXT, _passwordTXT, _loginBTN]);
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
		_loginBTN.onRelease=Delegate.create(this, onLoginRelease);
		_registBTN.onRelease=Delegate.create(this, onRegistRelease);
		_form	=	Form.getInstance(Key.ENTER);
		_form.addItem(_mobileTXT);
		_form.addItem(_passwordTXT);
		_form.addItem(_loginBTN);
		_form.build(true);
		//_mobileTXT.text		=	"13111111111";_passwordTXT.text	=	"123456";
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
		lv.sendAndLoad(GlobalProperty.SITE_HOST+"desktopLogin.aspx", lv, "POST");
		lv.onLoad=Delegate.create(this, onReturnLoad);
		//lv.onData=Delegate.create(this, onReturnData);
		_loginBTN.enabled	=	false;
	}
	
	private function onRegistRelease():Void{
		//跳到注册
	}
	
	private function onReturnLoad(success:Boolean):Void{
		_loginBTN.enabled	=	true;
		delete _root.personInfo;
		//trace("-"+_returnLV.finalcode+"-")
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					_target._parent.hints_mc.gotoAndStop("loginError");//出错
					break;
				case "1"://TODO 注册成功
					
					_root.personInfo			=	{};
					_root.personInfo.roleNum	=	Number(_returnLV.role)-1;
					//MapTiles.curLevel			=	//6;//登录结束后直接跳到指定的点
					_root.personInfo.gameLevel	=	Number(_returnLV.gamepass);
					
					_root.personInfo.coin		=	Number(_returnLV.money);
					_root.personInfo.mobile		=	_returnLV.mobilephone;
					_root.personInfo.lockTime	=	_returnLV.lockstatus=="go" ?
												0 : Number(_returnLV.lockstatus);
					_root.personInfo.award		=	changeAward(_returnLV.award);
					_root.personInfo.realName	=	_returnLV.realname;
					
					_root.personInfo.realName		=	_returnLV.realname;
					_root.personInfo.province		=	_returnLV.province;
					_root.personInfo.address		=	_returnLV.address;
					_root.personInfo.idCard		=	_returnLV.idnum;
					_root.personInfo.roleNum		=	Number(_returnLV.role)-1;
					_root.personInfo.money			=	Number(_returnLV.money);
					_root.personInfo.finalCode		=	_returnLV.finalcode;
					_root.personInfo.career		=	_returnLV.career;
					_root.personInfo.zipCode		=	_returnLV.zipcode;
					_root.personInfo.email			=	_returnLV.email;
					_root.personInfo.age			=	_returnLV.age;
					_root.personInfo.gender		=	_returnLV.gender;
					
					_target.loginSuccess		=	true;
					_target._parent.logout_mc.gotoAndPlay(2);
					_target.play();
					
					//finalcode=0%20%20%20%20%20%20%20%20%20%20%20&award=&lockstatus=go&money=10&
					//gamepass=6&role=1&idnum=4501031978291&career=%E6%95%99%E8%82%B2&zipcode=200001&
					//address=%E6%B1%A0%E5%A1%98%E8%BE%B9&province=%E4%B8%8A%E6%B5%B7&
					//email=test9fm4f%40test%2Ecom&age=36%2D45%E5%B2%81&gender=f&
					//realname=%E7%9C%9F%E5%90%8D5ykhf&returnValue=1&onLoad=%5Btype%20Function%5D&
					//mobilephone=13111111111&checkCode=undefined&password=123456
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
	* 当登录成功后,登录窗口消失时要执行的动作
	*/
	public function loginAction():Void{
		_target._parent.mapWatch_mc.maps_mc.gotoAndPlay("online");
		_target._parent.information_mc.gotoAndPlay(2);
		//_target._parent.navi.goPassGameLevel_btn.enabled	=	
		_target._parent.navi.goPersonInfo_btn.enabled		=	true;
		_target._parent.navi.goLogin_btn.enabled			=	false;
	}
	/**
	* 当按退出退出登录时要执行的动作.
	*/
	public function logoutAction():Void{
		delete _root.personInfo;
		_target._parent.mapWatch_mc.maps_mc.gotoAndPlay("offline");
		_target._parent.information_mc.moveOut();
		//_target._parent.navi.goPassGameLevel_btn.enabled	=	
		_target._parent.navi.goPersonInfo_btn.enabled		=	false;
		_target._parent.navi.goLogin_btn.enabled			=	true;
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "LoginFormDesktop 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
