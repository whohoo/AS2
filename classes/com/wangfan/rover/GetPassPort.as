//******************************************************************************
//	name:	GetPassPort 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Sep 22 15:58:03 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.MapTiles;
import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;
/**
 * 得到游戏用户的注册部分信息<p></p>
 * 包括final code
 */
class com.wangfan.rover.GetPassPort extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnLV:LoadVars		=	null;
	/**是否加载完成,这用于方便当mc显示过快或提交数据后反应慢的解决*/
	public  var isLoaded:Boolean		=	false;
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function GetPassPort(target:MovieClip){
		this._target	=	target;
		init();
		
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_returnLV	=	new LoadVars();
		_returnLV.checkCode	=	_root.checkCode;
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"getPassport.aspx", _returnLV, "POST");
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					
					break;
				case "1":
					var pInfo:Object	=	_root.personInfo;
					pInfo.realName		=	_returnLV.realname;
					pInfo.province		=	_returnLV.province;
					pInfo.address		=	_returnLV.address;
					pInfo.idCard		=	_returnLV.idnum;
					pInfo.roleNum		=	Number(_returnLV.role)-1;
					pInfo.money			=	Number(_returnLV.money);
					pInfo.finalCode		=	_returnLV.finalcode;
					
					isLoaded			=	true;
					
					if(_target.isShow){
						_target.passport_mc.form.updateInfo();
					}
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
		return "GetPassPort 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
