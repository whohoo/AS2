//******************************************************************************
//	name:	GetAwardForm 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Sep 22 14:07:37 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.GlobalProperty;
import mx.utils.Delegate;

/**
 * 用户获得奖品程序.<p></p>
 * 如果用户得到奖品，把数据提交到后台记录
 */
class com.wangfan.rover.GetAwardForm extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnLV:LoadVars		=	null;
	private var _coin:Number			=	null;//
	//private var _reason:String			=	null;
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//

	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function GetAwardForm(target:MovieClip){
		this._target	=	target;
		//_coin			=	coin;//gameLevel;
		//_reason			=	reason;
		//target.stop();
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
					
					break;
				case "255":
					//trace("用户没有登录!跳到登录界面");
					_root.time_page = true;
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
	 * 提交更改用户金钱程序,当合法修改后,会立即更新到个人信息中
	 * @param coin 增减的钱数
	 * @param resaon 增减的原因
	 */
	public function change(awardID:Number):Void{
		//TODO 增加重复的判断。
		_returnLV.award		=	awardID;
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"getAward.aspx", _returnLV, "POST");
		//trace(_returnLV);
	}
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GetAwardForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
