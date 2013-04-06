//******************************************************************************
//	name:	ChangeGameLevel 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 13:59:24 GMT+0800 2006
//	description: This file was created by "game.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.MapTiles;
import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;
/**
 * 得到游戏统计数据.<p></p>
 * 得到当前走到此国家的统计数据
 */
class com.wangfan.rover.GetGamePassCountForm extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _returnXML:XML			=	null;
	private var _baseNumber:Number		=	null;
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
	public function GetGamePassCountForm(target:MovieClip){
		this._target	=	target;
		target.stop();
		init();
		//_root.personInfo	=	{gameLevel:8};//debug
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_returnXML	=	new XML();
		_returnXML.ignoreWhite	=	true;
		_returnXML.load(GlobalProperty.SITE_HOST+"getGamepassCount.aspx?checkCode="+_root.checkCode);
		//_returnXML.load("getGamepassCount.aspx");
		_returnXML.onLoad=Delegate.create(this, onReturnLoad);
		//_returnLV.onData=Delegate.create(this, onReturnData);
		cArr	=	["英国",  "法国",  "瑞士",  "埃及",  "意大利",  
					"卢森堡",  "奥地利",  "丹麦", "芬兰",  "俄罗斯",  "缅甸", 
					"泰国",  "印度",  "土耳其", "日本",  "中国"];
	}
	
	private function onReturnLoad(success:Boolean):Void{
		//trace(_returnXML)
		if(success){
			if(_returnXML.toString().indexOf("returnValue")>0){
				//_root.page	=	"登录";
				//_root.gotoAndPlay("gotomap");
				
			}else if(_returnXML.status=="0"){
				_target.play();
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
		var missionNum:Number	=	_root.personInfo.gameLevel%2+1;
		var cLeft:Number		=	cArr.length-curLevel-1;//剩余的国家数
		var mLeft:Number		=	cArr.length*2-_root.personInfo.gameLevel-1;//剩余的任务
		var posArr:Array		=	[];
		var introStr:String	=	"";
		posArr.push(introStr.length);
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
		
		var txt:TextField	=	_target.table_mc.intro_txt;
		txt.text			=	introStr;
		var fmt:TextFormat	=	txt.getTextFormat();
		fmt.color			=	0xFFA200;
		txt.setTextFormat(posArr[1], posArr[2], fmt);
		txt.setTextFormat(posArr[3], posArr[4], fmt);
		txt.setTextFormat(posArr[5], posArr[6], fmt);
		txt.setTextFormat(posArr[7], posArr[8], fmt);
		fmt.color			=	0xF23502;
		txt.setTextFormat(posArr[9], posArr[10], fmt);
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 使地图上的柱子显示数据,如果显示的数据超过9999,就显示9999而不会超过.
	*/
	public function showData():Void{
		var cXML:XMLNode	=	_returnXML.firstChild;
		var mapMC:MovieClip	=	_target.map_mc;
		var cArr:Array	=	["英国",  "法国",  "瑞士",  "埃及",  "意大利",  
					"卢森堡",  "奥地利",  "丹麦", "芬兰",  "俄罗斯",  "缅甸", 
					"泰国",  "印度",  "土耳其", "日本",  "中国"];
		var mc:MovieClip	=	null;
		var num:Number		=	null;
		var bigNum:Number	=	0;
		var len:Number		=	cArr.length;
		for(var i:Number=0;i<len;i++){
			mc	=	mapMC[cArr[i]];
			num	=	Number(cXML.childNodes[i*2].firstChild.nodeValue)+
					Number(cXML.childNodes[i*2+1].firstChild.nodeValue);
			mc.num_mc.num_txt.text	=	num	=	num>10000 ? 9999 : num;
			if(bigNum<num){
				bigNum	=	num;
			}
		}
		
		//定义柱子的高度
		for(i=0;i<len;i++){
			mc	=	mapMC[cArr[i]];
			num	=	mc.num_mc.num_txt.text;
			if(num==0){
				mc._visible	=	false;
				continue;
			}
			mc.count_mc._yscale		=	num/bigNum*100+3;
			mc.num_mc._y	=	mc.count_mc._y-mc.count_mc._height*1.4-20;
			switch(true){
				case num>bigNum*3/4:
					mc.gotoAndStop(4);
					break;
				case num>bigNum*2/4:
					mc.gotoAndStop(3);
					break;
				case num>bigNum*1/4:
					mc.gotoAndStop(2);
					break;
				case num>bigNum*0/4:
					mc.gotoAndStop(1);
					break;
			}
			mc.num_mc.num_txt.text	=	formatNum(num);
		}
	}
	/**
	* 使表格上显示数据,如果显示的数据超过9999,就显示9999而不会超过.
	*/
	public function showData2():Void{
		var cXML:XMLNode		=	_returnXML.firstChild;
		var tableMC:MovieClip	=	_target.table_mc;
		
		var curLevel:Number	=	_root.personInfo.gameLevel;//当前任务数
		var curGameLevel:Number	=	Math.floor(curLevel/2);//当前国家数
		var mc:MovieClip	=	null;
		var num:Number		=	null;
		var bigNum:Number	=	0;
		var txt:TextField	=	null;
		var len:Number		=	cArr.length;
		var forwardNum:Number	=	0;//在当前任务前方的人数
		for(var i:Number=0;i<len;i++){
			mc	=	tableMC[cArr[i]];
			num	=	Number(cXML.childNodes[i*2].firstChild.nodeValue)+
					Number(cXML.childNodes[i*2+1].firstChild.nodeValue);
			if(i>curGameLevel){//统计在前方的人数,以国家为单位
				forwardNum	+=	num;
			}
			////txt
			txt			=	tableMC[cArr[i]+"_txt"];
			txt.text	=	String(num);
			if(bigNum<num){
				bigNum	=	num;
			}
		}
		
		//定义表格的数值
		var txt:TextField	=	null;
		var bar:MovieClip	=	null;
		
		for(i=0;i<len;i++){
			txt			=	tableMC[cArr[i]+"_txt"];
			bar			=	tableMC[cArr[i]+"_bar"];
			if(i==curGameLevel){
				mc	=	tableMC[cArr[i]+"_mc"];//高亮显示当前用户所在的国家
				mc.gotoAndStop(2);
			}
			num	=	Number(txt.text);
			/////bar
			bar.xScale	=	num/bigNum*100+2;
			var frameNum:Number	=	1;
			switch(true){
				case num>bigNum*3/4:
					frameNum	=	4;
					break;
				case num>bigNum*2/4:
					frameNum	=	3;
					break;
				case num>bigNum*1/4:
					frameNum	=	2;
					break;
				case num>bigNum*0/4:
					frameNum	=	1;
					break;
			}
			
			bar.gotoAndStop(frameNum);
		}
		setTableIntro(curGameLevel, forwardNum);
	}
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GetGamePassCountForm 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
