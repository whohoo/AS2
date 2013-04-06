//******************************************************************************
//	name:	GoBridge 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 19:59:39 GMT+0800 2006
//	description: This file was created by "goBridge.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.GoBridgeMan;
import mx.utils.Delegate;
/**
 * 五人提灯夜过独木桥<p/>
 * 在规定的三十秒内，把右边的人全部移到左边。<br/>
 * 规则：一次只能过两人，走得慢的拿灯走在前方。
 * 把灯拿到对面后要求人有再把灯拿回去。
 * 
 * 答案：
 * 1.3先过，3回去，8，12过，1回去，1.6过，1回去，1.3过去
 */
class com.wangfan.rover.GoBridge extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _menSet:Array			=	null;
	private var _goBTN:MovieClip		=	null;
	private var _tryAgainBTN:MovieClip	=	null;
	private var _timeTXT:TextField		=	null;
	
	private var _facePos:Array			=	[];//5
	private var _walkingMen:Array		=	[];//2
	private var _state:Number			=	0;//0,游戏没开始
											//1,停止中
											//2,移动中
	private var _stoppingGame:Boolean	=	false;//游戏等待结束
	//private var _direction:Number		=	1;//右边	
	
	
	public  var lampMC:MovieClip		=	null;//左右两个灯
	//************************[READ|WIDTH]************************************//
	function set timer(value:Number):Void{
		if(value<=0){
			_stoppingGame	=	true;
			value	=	0;
		}
		_timeTXT.text		=	value.toString();
	}
	function get timer():Number{
		return Number(_timeTXT.text);
	}
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	public function GoBridge(target:MovieClip){
		this._target	=	target;
		this._goBTN		=	target.go_btn;
		this._tryAgainBTN	=	target.tryAgain_btn;
		this._timeTXT	=	target.countTime_mc.time_txt;
		
		lampMC			=	target.lamp_mc;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		GoBridgeMan.goBridge	=	this;
		
		var baseNum:Number		=	0.3;
		_menSet	=	[	new GoBridgeMan(_target.man0, 15*baseNum, 1),	//罗福
						new GoBridgeMan(_target.man1, 12*baseNum, 3),	//福尔魔西
						new GoBridgeMan(_target.man2, 10*baseNum, 6),	//憨豆
						new GoBridgeMan(_target.man3, 8*baseNum, 8),	//不认识
						new GoBridgeMan(_target.man4, 5*baseNum, 12)	//不知道
					];
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<5;i++){
			mc			=	_target["face"+i];
			initFace(mc);
			mc.index	=	i;
			_facePos[i]	=	1;//表示人在右边位置
		}
		_goBTN.onRelease=Delegate.create(this, onGoRelease);
		_tryAgainBTN.onRelease=Delegate.create(this, onTryAgainRelease);
		_goBTN.enabled	=	false;
	}
	
	private function initFace(mc:MovieClip):Void{
		mc.onRelease=Delegate.create(mc, onFaceRelease);
		mc.pClass	=	this;
	}
	
	private function onFaceRelease():Void{
		var pClass:Object	=	this["pClass"];
		if(pClass["_state"]==2)	return;
		
		var wMen:Array		=	pClass._walkingMen;
		var isSelf:Boolean	=	false;
		for(var i:Number=0;i<wMen.length;i++){
			if(wMen[i]==this["index"]){
				isSelf	=	true;
				break;
			}
		}
		if(isSelf){//删除自己
			wMen.splice(i, 1);
			this["gotoAndStop"](1);
		}else if(wMen.length<2){
			wMen.push(this["index"]);
			this["gotoAndStop"](2);
		}
	}
	
	private function onGoRelease():Void{
		if(_state==2)	return;
		var firstMan:Object	=	null;
		
		switch (_walkingMen.length){
			case 0:
				return;
			case 1:
				firstMan			=	_menSet[_walkingMen[0]];
				firstMan.isLeader	=	true;
				
				firstMan.secondMan	=	null;
				
				firstMan["goWithoutLamp"]();
				_state	=	2;//
				
				break;
			case 2:
				if(_walkingMen[0]>_walkingMen[1]){
					firstMan			=	_menSet[_walkingMen[0]];
					firstMan.secondMan	=	_menSet[_walkingMen[1]];
				}else{
					firstMan			=	_menSet[_walkingMen[1]];
					firstMan.secondMan	=	_menSet[_walkingMen[0]];
				}

				firstMan.isLeader	=	true;
				firstMan["goWithoutLamp"]();
				_state	=	2;//
				break;
			default:
				trace("不可能");
		}
		
	}
	
	private function onTryAgainRelease():Void{
		var face:MovieClip	=	null;
		for(var i:Number=0;i<5;i++){
			_menSet[i].reset();
			_facePos[i]	=	1;//表示人全站在右边
			face	=	_target["face"+i];
			face.gotoAndStop(1);
			face.enabled	=	true;
		}
		timer		=	30;
		_walkingMen	=	[];
		lampMC._xscale	=	100;
		lampMC._visible	=	true;
		lampMC._x		=	GoBridgeMan.RIGHT_LAMP_POS;
		
		_state		=	1;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 游戏开始
	*/
	public function startGame():Void{
		if(_state==0){
			timer	=	30;
			_goBTN.enabled	=	true;
			_state	=	1;
		}
	}
	/**
	* 游戏结束
	* @param	isWin
	*/
	public function stopGame(isWin:Boolean):Void{
		if(_state==0 && _state==2)	return;
		if(isWin){
			_target.gotoAndPlay("成功");
		}else{
			_target.gotoAndPlay("失败");
		}
	}
	/**
	* 当有两中的一人停止时，执行此函数
	* @param	goMan
	*/
	public function setPosition(goMan:GoBridgeMan):Void{
		var index:Number	=	Number(goMan["_target"]._name.substr(3));
		_facePos[index]		=	goMan["_direction"];
		var isReady:Boolean	=	true;
		for(var i:Number=0;i<5;i++){
			if(_menSet[i]["_state"]!=0){
				isReady	=	false;
				break;
			}
		}
		if(isReady){//只执行一次,最后一个停止的人执行此函数
			_state		=	1;//表示停止下来了
			
			var face:MovieClip		=	null;
			var inLeftNum:Number	=	0;//在左边的个数
			for(i=0;i<5;i++){
				face	=	_target["face"+i];
				//判断灯在哪一边，然后以此来判断由哪一边行动
				if(_facePos[i]==-lampMC._xscale/100){
					face.enabled	=	false;
					face.gotoAndStop(3);
				}else{
					face.enabled	=	true;
					face.gotoAndStop(1);
				}
				if(_facePos[i]==-1){
					inLeftNum++;
				}
			}
			_walkingMen	=	[];//清空
			//如果时间到了，游戏要停止，判断人是否都到了左边来决定胜负。
			
			if(_stoppingGame){//如果秒数达到0后，游戏失败
				stopGame(false);
			}else if(inLeftNum>=5){//如果还有一秒，但人物全走到左边了
				stopGame(true);
			}
		}
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GoBridge 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
