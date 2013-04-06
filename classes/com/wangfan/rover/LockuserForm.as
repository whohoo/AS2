//******************************************************************************
//	name:	LockuserForm 1.0
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
 * 锁定用户,如果用户玩游戏不幸中招后.<p></p>
 * 在游戏中不幸失败,被锁住游戏5小时
 * NOTE:现已改为不用再锁定用户，所以在构建方法中直接中止掉。
 */
class com.wangfan.rover.LockuserForm extends Object{
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
	public function LockuserForm(target:MovieClip){
		return; //此类已经不在使用。
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
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"lockuser.aspx", _returnLV, "POST");
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
		//trace(_returnLV)
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					
					break;
				case "1":
					_root.personInfo.lockTime	=	5*60*60;//5小时
					com.wangfan.rover.CountTimer.startCountDown();
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
		return "LockuserForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
