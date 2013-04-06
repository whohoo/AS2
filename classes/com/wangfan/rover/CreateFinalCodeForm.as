//******************************************************************************
//	name:	CreateFinalCodeForm 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 13:59:24 GMT+0800 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.GlobalProperty;
import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;
/**
 * 游戏走到指定的关卡后,让后台生成final code.<p></p>
 * 只能生成四次final code
 * NOTE:现改为后台判断是否到生成final code的点
 */
class com.wangfan.rover.CreateFinalCodeForm extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnLV:LoadVars		=	null;
	private var _gameLevel:Number		=	null;//
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function CreateFinalCodeForm(target:MovieClip){
		this._target	=	target;
		target.stop();
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
		_returnLV.sendAndLoad(GlobalProperty.SITE_HOST+"setFinalCode.aspx", _returnLV, "POST");
		_returnLV.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0"://失败
					
					break;
				case "1"://成功
					_target.play();
					break;
				case "100"://FinalCode已经完全生成完毕
					
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
		return "CreateFinalCodeForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
