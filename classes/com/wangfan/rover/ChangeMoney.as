//******************************************************************************
//	name:	ChangeMoney 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Sep 22 14:07:37 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.GlobalProperty;
import mx.utils.Delegate;

/**
 * 用户金钱修改程序.<p></p>
 * 不同的事件解放不同的修改代码,
 * 如玩老虎机,投身就会-2,得奖就可以得到4或8的奖励
 */
class com.wangfan.rover.ChangeMoney extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnLV:LoadVars		=	null;
	private var _coin:Number			=	null;//
	//private var _reason:String			=	null;
	private var _retryTimes:Number		=	null;
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function ChangeMoney(target:MovieClip){
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
					tryAgain()
					break;
				case "1":
					//trace([typeof _returnLV.coin, _returnLV.coin])
					
					_root.personInfo.coin	+=	_coin;
					_target.updateCoin();
					break;
				case "255":
					//TODO 增加过场
					//trace("用户没有登录!跳到登录界面");
					_root.page	=	"登录";
					_root.gotoAndPlay("gotomap");
					break;
			}
		}else{
			tryAgain();
		}
		
		
	}
	//只执行三次,包括第一次的提交
	private function tryAgain():Void{
		if(++_retryTimes>=3)	return;
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"chgMoney.aspx", _returnLV, "POST");
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
	public function change(coin:Number, reason:String):Void{
		_coin				=	
		_returnLV.money		=	coin;
		_returnLV.desc		=	reason;
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"chgMoney.aspx", _returnLV, "POST");
	}
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "ChangeMoney 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
