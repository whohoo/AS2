//******************************************************************************
//	name:	GetPassPortDesktop 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-10-24 15:00
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.MapTiles;
import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;
/**
 * 得到游戏用户的注册部分信息<p></p>
 * 因为转为桌面程序后,无记录session值,所以去掉此类的调用.
 */
class com.wangfan.rover.GetPassPortDesktop extends Object{
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
	public function GetPassPortDesktop(target:MovieClip){
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
					pInfo.career		=	_returnLV.career;
					pInfo.zipCode		=	_returnLV.zipcode;
					pInfo.email			=	_returnLV.email;
					pInfo.age			=	_returnLV.age;
					pInfo.gender		=	_returnLV.gender;
					
					isLoaded			=	true;
					
					//finalcode=0&money=484&gamepass=32&role=2&idnum=4501031978706&
					//career=IT%E8%A1%8C%E4%B8%9A&zipcode=200001&address=%E6%B1%A0%E5%A1%98%E8%BE%B9&
					//province=%E4%B8%8A%E6%B5%B7&email=test5d8dk%40test%2Ecom&age=%3C18%E5%B2%81&
					//gender=f&realname=%E7%9C%9F%E5%90%8D71657&returnValue=1&onLoad=%5Btype%20Function%5D&
					//checkCode=undefined
					break;
				case "255":
					//TODO 增加过场
					//trace("用户没有登录!跳到登录界面");
					
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
		return "GetPassPortDesktop 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
