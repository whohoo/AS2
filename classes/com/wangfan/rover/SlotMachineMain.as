//******************************************************************************
//	name:	SlotMachineMain 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 19:59:39 GMT+0800 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************


import com.wangfan.rover.SlotMachine;
import com.wangfan.rover.MapTiles;

/**
 * 管理三条从上到下滚动的条.<p></p>
 * 模拟老虎机,当三条都结束时,广播onStopGame({win, cardNum})事件<br></br>
 * 参数:win, 如果是两条一样,win为1,如果三条一样win的值为2, cardNum表示第几个数字
 * 
 */
class com.wangfan.rover.SlotMachineMain extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _slot0:SlotMachine		=	null;
	private var _slot1:SlotMachine		=	null;
	private var _slot2:SlotMachine		=	null;
	
	private var _resultTXT:TextField	=	null;
	private var _resultMC:MovieClip	=	null;
	/**作弊要出现的字母*/
	public  var cheatNum:Array			=	[];
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(SlotMachineMain.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	public function SlotMachineMain(target:MovieClip){
		this._target	=	target;
		_slot0			=	new SlotMachine(target.slot0_mc);
		_slot1			=	new SlotMachine(target.slot1_mc);
		_slot2			=	new SlotMachine(target.slot2_mc);
		//com.wangfan.utils.MCblur.initialize();
		_resultMC		=	target._parent.result_mc;
		_resultTXT		=	_resultMC.result_txt;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		var s:SlotMachine	=	null;
		for(var i:Number=0;i<3;i++){
			var s	=	this["_slot"+i];
			s.addEventListener("onStop", this);
		}
		
		showAward();//debug
	}
	//SlotMachine事件,当有一个停止时
	private function onStop(evtObj:Object):Void{
		var s:SlotMachine		=	null;
		var curSlot:SlotMachine	=	evtObj.target;
		var isFinish:Boolean	=	true;
		for(var i:Number=0;i<3;i++){
			var s	=	this["_slot"+i];
			if(s!=curSlot){
				if(s.state>0){
					isFinish	=	false;
					break;
				}
			}
		}
		
		if(isFinish){
			var win:Number			=	0;
			//中间那条的牌的位置。
			var curFrame1:Number	=	_slot1.curCard._currentframe;
			if(curFrame1==_slot0.curCard._currentframe){ 
				win	+=	1;
			}
			if(curFrame1==_slot2.curCard._currentframe){
				win	+=	1;
			}
			dispatchEvent({type:"onStopGame", win:win, cardNum:curFrame1-1});
		}
		
	}
	
	private function showMsg(msg:String):Void{
		_resultTXT.text		+=	msg+"\r";
		_resultTXT.scroll	=	_resultTXT.maxscroll;
	}
	
	private function showAward():Void{
		var awardArr:Array	=	_root.personInfo.award;
		var len:Number		=	awardArr.length;
		var award:Number	=	null;
		for(var i:Number=0;i<len;i++){
			award	=	awardArr[i];
			if(award==undefined){
				award	=	0;
			}
			_resultTXT.text	+=	"奖项"+i+": "+award+"次, ";
		}
	}
	
	private function cheat(str:String):Void{
		var arr:Array	=	str.split("");
		for(var i:Number=0;i<3;i++){
			cheatNum[i]	=	Number(arr[i]==undefined ? random(6) : arr[i]);
		}
		//trace(cheatNum)
		var num:Number		=	cheatNum[1];
		if(num==cheatNum[0]){
			if(num==cheatNum[2]){//三个都一样。
				
				switch(num){
					case 0://罗福//1贝瓷单杯单碟
						if(_root.personInfo.roleNum==0){
							checkAwardNum(1);
						}else{
							//4Jonnie Walker杯垫
							checkAwardNum(4);
						}
						break;
					case 1://车logo//2英国锡兵玩具
						checkAwardNum(2);
						break;
					case 2://福尔摩西//1贝瓷单杯单碟
						if(_root.personInfo.roleNum==1){
							checkAwardNum(1);
						}else{
							//4Jonnie Walker杯垫
							checkAwardNum(4);
						}
						break;
					case 3://车照
						//4Jonnie Walker杯垫
						checkAwardNum(4);
						
						break;
					case 4://Mr.Ben//1贝瓷单杯单碟
						if(_root.personInfo.roleNum==2){
							checkAwardNum(1);
						}else{
							//4Jonnie Walker杯垫
							checkAwardNum(4);
						}
						break;
					case 5://rover game logo.//3美加净护肤品
						checkAwardNum(3);
						break;
					default:
						trace("老虎机出错了：cardNum = "+num);
				}
			}
		}
		//一等奖（3个你选择的游戏人物成一排）       贝瓷单杯单碟   　　　　100份  　	
		//二等奖（3个荣威Logo成一排）              英国锡兵玩偶           200份  	
		//三等奖（3个游戏Logo成一排）              美加净护肤品           200份            
		//四等奖 （其它3个相同图片成一排）          Jonnie Walker杯垫      40份

		//trace(cheatNum)
	}
	//根据还有多少分礼物来决定是否中奖。如果剩余的奖品不多了，就不要再分配了
	//根据剩余数来决定中奖的机率，
	//个人感觉这样的分配还不是很合理。
	private function checkAwardNum(num:Number):Void{
		var awardArr:Array	=	_root.personInfo.award;
		//TODO dubug
		var opLevel:Number	=	MapTiles.openPointLevel;//只有三个阶段。
		var curAwardNum:Number	=	awardArr[num];//已经分配出去的奖品数
		var remainAward:Number	=	null;
		if(num==1){//一等奖只有一百份礼物
			remainAward	=	25*opLevel-curAwardNum;//在opLevel阶段下还有多少份礼物没分配出去
			if(remainAward<=0){//此阶段下不再有奖品可分配了
				cheat();
			}else if(random(30-remainAward)!=0){//根据剩余数来决定中奖的机率，
				cheat();
			}else{
				awardArr[num]++;
			}
			//trace("remainAward: "+remainAward)
		}else if(num==4){//四等奖只有40份，:( 稀有动物呀！！:<<<<<<<<<<<< 变态！
			remainAward	=	10*opLevel-curAwardNum;//在opLevel阶段下还有多少份礼物没分配出去
			if(remainAward<=0){//此阶段下不再有奖品可分配了
				cheat();
			}else if(random(70-remainAward)!=0){//根据剩余数来决定中奖的机率，
				cheat();
			}else{
				awardArr[num]++;
			}
		}else{//二三等奖各有200分礼物
			remainAward	=	60*opLevel-curAwardNum;//在opLevel阶段下还有多少份礼物没分配出去
			if(remainAward<=0){//此阶段下不再有奖品可分配了
				cheat();
			}else if(random(70-remainAward)!=0){//根据剩余数来决定中奖的机率，
				cheat();
			}else{
				awardArr[num]++;
			}
		}
		//trace(awardArr)
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 开始转动
	 * @return 如果都可以启动就返回真,否则为假
	 */
	public function startRun():Boolean{
		var s:SlotMachine	=	null;
		for(var i:Number=0;i<3;i++){
			s	=	this["_slot"+i];
			if(s.state!=0)	return false;
		}
		cheat(_target._parent.cheatNum_txt.text);
		for(var i:Number=0;i<3;i++){
			s	=	this["_slot"+i];
			s.maxSpeed	=	random(30)+70;
			s.accSpeed	=	random(3)+7;
			s.cheatNum	=	cheatNum[i];//测试,定义作弊得到的结果
			//trace(s.cheatNum)
			s.startRun();
		}

		return true;
	}
	/**
	 * 开始停止转动
	 *
	 */
	public function stopRun():Void{
		var s:SlotMachine	=	null;
		for(var i:Number=0;i<3;i++){
			var s	=	this["_slot"+i];
			s.stopRun();
		}
		
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "SlotMachineMain 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
