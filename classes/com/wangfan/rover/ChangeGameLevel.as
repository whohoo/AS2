//******************************************************************************
//	name:	ChangeGameLevel 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 13:59:24 GMT+0800 2006
//	description: This file was created by "game.fla" file.
//		增加报重试多少次的
//******************************************************************************

import com.wangfan.rover.MapTiles;
import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;
/**
 * 游戏过关后提交后台数据库.<p></p>
 * 每次游戏过关,提交后台数据库,记录用户行程.
 */
class com.wangfan.rover.ChangeGameLevel extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnLV:LoadVars		=	null;
	private var _gameLevel:Number		=	null;//
	private var _retryTimes:Number		=	null;
	/**每到指定的点,生成一次final code*/
	//static public var FINAL_CODE_LEVEL:Array	=	[7, 15, 23, 31];
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 * @param gameLevel 暂时无用
	 * @param skip 原来计划是在main.fla中调用此类,这样此类就直接导入swf中了,而不用
	 * 			再每个问题游戏中重新发布一次.
	 */
	public function ChangeGameLevel(target:MovieClip, gameLevel:Number, skip:Boolean){
		if(skip==true)	return;
		this._target	=	target;
		_gameLevel		=	MapTiles.curLevel;//gameLevel;
		target.stop();
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_retryTimes			=	0;
		_returnLV			=	new LoadVars();
		_returnLV.checkCode	=	_root.checkCode;
		_returnLV.gamelevel	=	_gameLevel+1;
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"chgGamepass.aspx", _returnLV, "POST");
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
	}
	
	private function onReturnLoad(success:Boolean):Void{
    //_returnLV.returnValue="255"
		//trace("chgGamepass.aspx: "+_returnLV.returnValue)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					tryAgain();
					break;
				case "1":
					MapTiles.curLevel			=	
					_root.personInfo.gameLevel	=	_gameLevel+1;
					MapTiles.singlone.gotoNext();//地图上的点,画线
					getInfo();
					_target.play();
					break;
				case "255":
					//TODO 增加过场
					//trace("用户没有登录!跳到登录界面");
					_root.time_page = true;
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
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"chgGamepass.aspx", _returnLV, "POST");
	}
	
	private function onReturnData(d:String):Void{
		trace(d);
	}
	
	private function getInfo():Void{
		var arr:Array	=	MapTiles.singlone.getPoint(_gameLevel+1);
		_target.xy		=	"X:"+arr[0]+",  Y:"+arr[1];
		_target.key_number	=	"密匙:"+arr[2];
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "ChangeGameLevel 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
