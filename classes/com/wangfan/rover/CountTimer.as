//******************************************************************************
//	name:	CountTimer 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Sep 25 18:00:20 GMT+0800 2006
//	description: This file was created by "photo.fla" file.
//		
//******************************************************************************

import mx.utils.Delegate;

/**
 * 倒计时类.<p></p>
 * 主要是游戏中人物如果不幸被lock后,要重新计时到零方可以再玩游戏，
 * 增加了服务器上的时间上的运作，主要用来判断地图游戏关卡的开发时间及老虎机奖项。
 */
class com.wangfan.rover.CountTimer extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	//private static var startTime:Date		=	null;
	private static var _inter:Number		=	null;//lock用户的倒计时
	private static var _inter2:Number		=	null;//对服务器上的时间计时
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new CountTimer(this);]
	 * @param target target a movie clip
	 */
	public function CountTimer(){
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
	}
	
	
	//***********************[PUBLIC METHOD]**********************************//
	
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "CountTimer 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	/**
	 * 登录成功后，得到服务器上的时间，并按秒来运行此时间。
	 */
	public static function runningServerTime():Void{
		clearInterval(_inter2);
		_inter2=setInterval(run2, 1000);
	}
	
	private static function run2():Void{
		_root.personInfo.sevTime.setTime(_root.personInfo.sevTime.getTime()+1000);
		//trace(_root.personInfo.sevTime)
		updateAfterEvent();
	}
	
	/**
	 * 开始倒计时<p></p>
	 * 数据从personInfo开始读出,每秒减一,如果数值小于等于零后,
	 * 停止计时
	 */
	public static function startCountDown():Void{
		clearInterval(_inter);
		if(_root.personInfo.lockTime>10){//还有10秒就解冻的,就不要再计时了.
			//startTime	=	new Date();
			_inter=setInterval(run, 1000);
			writeLockTime();
		}
	}
	
	private static function run():Void{
		//trace(_root.personInfo.lockTime)
		if(--_root.personInfo.lockTime<=0){
			clearInterval(_inter);
		}
		//更新弹出的窗口
		if(_root.lockTime_mc._visible){
			_root.lockTime_mc.updateTime(_root.personInfo.lockTime);
		}
		updateAfterEvent();
	}
	
	private static function writeLockTime():Void{
		var so:SharedObject	=	SharedObject.getLocal("rover");//lockTime
		so.data.mobile		=	_root.personInfo.mobile;
		so.data.lockTime	=	_root.personInfo.lockTime;
		so.data.curTime		=	new Date();
		so.flush();
	}
	
	
}//end class
//This template is created by whohoo.
