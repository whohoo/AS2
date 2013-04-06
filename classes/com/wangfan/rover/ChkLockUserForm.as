//******************************************************************************
//	name:	ChkLockUserForm 1.0
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
 * 用户查检自己是否被锁定不可玩游戏?<p></p>
 * 如果用户玩过河游戏不幸中招了.就会被停止游戏5小时,
 * 但现已把用户被冻结时间显示在登录,而不必在通过此类来查找.
 */
class com.wangfan.rover.ChkLockUserForm extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnLV:LoadVars		=	null;
	
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function ChkLockUserForm(target:MovieClip){
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
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"chkLockUser.aspx", _returnLV, "POST");
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
		//trace(_returnLV)
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "go":
					
					break;
				case "stop":
					trace("remainSecond: "+_returnLV.remainSecond);
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
		return "ChkLockUserForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
