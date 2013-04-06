//******************************************************************************
//	name:	GetGamePassCountFormDesktop 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-10-24 15:00
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;
/**
 * 得到游戏统计数据--桌面程序.<p></p>
 * 
 */
class com.wangfan.rover.GetGamePassCountFormDesktop extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnXML:XML			=	null;
	
	private var _refreshSecond:Number	=	0;//自动更新的时间
	/**表示是否加载完成*/
	public  var isLoaded:Boolean		=	false;
	/**16个国家名称*/
	public  var cArr:Array				=	null;
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new ChangeGameLevel(this);]
	 * @param target target a movie clip
	 */
	public function GetGamePassCountFormDesktop(target:MovieClip){
		this._target	=	target;
		
		init();
		//test();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_returnXML	=	new XML();
		_returnXML.ignoreWhite	=	true;
		refresh();
		_returnXML.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
		cArr	=	["英国",  "法国",  "瑞士",  "埃及",  "意大利",  
					"卢森堡",  "奥地利",  "丹麦", "芬兰",  "俄罗斯",  "缅甸", 
					"泰国",  "印度",  "土耳其", "日本",  "中国"];
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//_root.trace_txt.text	=	_returnXML;
		if(success){
			if(_returnXML.toString().indexOf("returnValue=255")>0){
				//跳到登录,
				//现这一要求已经去除
			}else if(_returnXML.status=="0"){
				var hintsMC:MovieClip	=	_target._parent.hints_mc;
				if(hintsMC.msg_mc.isStop==true){//如果提示框出现等待加载数据,
													//现加载完成后就关掉此窗口.
					hintsMC.msg_mc.gotoAndPlay("fadeit");
				}
				isLoaded	=	true;
			}
		}
	}

	private function onReturnData(d:String):Void{
		trace(d);
	}
	
	private function formatNum(num:Number):String{
		var numStr:String	=	String(num);
		if(numStr.length>3){
			numStr	=	numStr.substr(0, -3)+","+numStr.substr(-3);
		}
		return numStr;
	}
	
	//定义表格下方显示的文本
	private function setTableIntro(curLevel:Number, forwardNum:Number):Void{
		var posArr:Array		=	[];
		var introStr:String		=	"";
		posArr.push(introStr.length);
		var txt:TextField	=	_target.intro_mc.intro_txt;
		var fmt:TextFormat	=	txt.getTextFormat();
		if(_root.personInfo.gameLevel==null){//没有登录
			introStr	+=	"现有";
			posArr.push(introStr.length);
			introStr	+=	String(forwardNum);
			posArr.push(introStr.length);
			introStr	+=	"人正在游戏中.";
			posArr.push(introStr.length);
			
			txt.text			=	introStr;
			
			fmt.color			=	0xF23502;
			txt.setTextFormat(posArr[1], posArr[2], fmt);
		}else{//登录过的
			var missionNum:Number	=	_root.personInfo.gameLevel%2+1;
			var cLeft:Number		=	cArr.length-curLevel-1;//剩余的国家数
			var mLeft:Number		=	cArr.length*2-_root.personInfo.gameLevel-1;//剩余的任务

			introStr	+=	"您已经完成了";
			posArr.push(introStr.length);
			introStr	+=	cArr[curLevel];
			posArr.push(introStr.length);
			introStr	+=	"的第";
			posArr.push(introStr.length);
			introStr	+=	String(missionNum);
			posArr.push(introStr.length);
			introStr	+=	"个任务,前方还有";
			posArr.push(introStr.length);
			introStr	+=	String(cLeft);
			posArr.push(introStr.length);
			introStr	+=	"国家";
			posArr.push(introStr.length);
			introStr	+=	String(mLeft);
			posArr.push(introStr.length);
			introStr	+=	"任务等待您完成,已经有";
			posArr.push(introStr.length);
			introStr	+=	String(forwardNum);
			posArr.push(introStr.length);
			introStr	+=	"玩友在您前方,请加快您步伐前往目的地.";
			posArr.push(introStr.length);

			txt.text			=	introStr;
	
			fmt.color			=	0xFFA200;
			txt.setTextFormat(posArr[1], posArr[2], fmt);
			txt.setTextFormat(posArr[3], posArr[4], fmt);
			txt.setTextFormat(posArr[5], posArr[6], fmt);
			txt.setTextFormat(posArr[7], posArr[8], fmt);
			fmt.color			=	0xF23502;
			txt.setTextFormat(posArr[9], posArr[10], fmt);
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 显示数据
	*/
	public function showData():Void{
		var cXML:XMLNode	=	_returnXML.firstChild;
		var num:Number		=	null;
		var len:Number		=	16;
		var forwardNum:Number	=	0;
		var curGameLevel:Number	=	Math.floor(_root.personInfo.gameLevel/2);
		for(var i:Number=0;i<len;i++){
			num	=	Number(cXML.childNodes[i*2].firstChild.nodeValue)+
					Number(cXML.childNodes[i*2+1].firstChild.nodeValue);
			_target["num"+i].text	=	num;
			if(_root.personInfo.gameLevel==null){
				forwardNum	+=	num;
			}else if(i>curGameLevel){//统计在前方的人数,以国家为单位
				forwardNum	+=	num;
			}
		}
		
		setTableIntro(curGameLevel, forwardNum);
	}
	/**
	* 更新数据
	*/
	public function refresh():Void{
		isLoaded	=	false;
		_returnXML.load(GlobalProperty.SITE_HOST+"getGamepassCount.aspx?checkCode="+
									_root.checkCode+"&r="+random(0xffffff));
		
		var hintsMC:MovieClip	=	_target._parent.hints_mc;
		if(hintsMC!=null){
			if(hintsMC._currentframe==1){
				hintsMC.dataForm	=	this;
				hintsMC.gotoAndStop("dataLoading");
			}
		}
	}
	
	/**
	* 数据已经准备好了,可以执行以下动作
	*/
	public function dataReady():Void{
		_target.play();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GetGamePassCountFormDesktop 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
