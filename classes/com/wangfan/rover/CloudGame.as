//******************************************************************************
//	name:	CloudGame 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Nov 01 11:03:03 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.Cloud;


/**
 * 跳云游戏<p/>
 * 控制着人物在云层中跳跃。
 */
class com.wangfan.rover.CloudGame extends MovieClip{
	private var _cloudBox:Array			=	null;
	private var man_mc:MovieClip		=	null;
	//private var climbMan_mc:MovieClip	=	null;
	private var hawkMan_mc:MovieClip	=	null;
	private var bridgeMC:MovieClip		=	null;
	private var _curLevel:Number		=	0;
	private var _lifeBox:Array			=	null;
	private var totalCoin:Number		=	null;//应得的
	private var _aimPos:Number			=	null;//移动到位置
	/**可视范围,指被mask所masked的范围*/
	public  var vBound:Object			=	null;
	/**是否轻暂停移动*/
	public  var isPause:Boolean		=	false;
	/**可显示最底层的全局Y轴值。由localToGlobal得来。*/
	public  var globalBottonLine:Number	=	null;
	/**当前状态下剩余的龙币*/
	public  var remainCoin:Number		=	20;//默认只能得到20个龙币
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(CloudGame.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	private function CloudGame(){
		super();
		bridgeMC			=	this["bgSide_mc"].bridge_mc;
		bridgeMC._visible	=	false;//开始是不可见的，当进入可视范围时再出现
		if(_root.personInfo.roleNum==null){
			_root.personInfo	=	{roleNum:1};//debug
		}
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		var bound:Object	=	_parent.mask_mc.getBounds();
		vBound		=	{xMin:bound.xMin+_parent.mask_mc._x,
						xMax:bound.xMax+_parent.mask_mc._x,
						yMin:bound.yMin+_parent.mask_mc._y,
						yMax:bound.yMax+_parent.mask_mc._y
						}
		var posObj:Object	=	{x:0, y:vBound.yMax};
		_parent.localToGlobal(posObj);
		globalBottonLine	=	posObj.y;
		_cloudBox	=	[];
		for(var i:Number=0;i<18;i++){
			//把云朵加入_cloudBox中去
			_cloudBox.push(this["cloud"+i]);
			//出现问号的机率 2分之一
			this["cloud"+i].hasQuestion	=	random(2)==0 ? true : false;
			//trace(this["cloud"+i].hasQuestion)
		}
		man_mc.cloudBox		=	_cloudBox;
		//三条生命值
		_lifeBox	=	[_parent.life0_mc, _parent.life1_mc, _parent.life2_mc];
		var lifeMC:MovieClip	=	null;
		for(i=0;i<3;i++){
			lifeMC	=	_lifeBox[i];
			lifeMC.gotoAndStop(_root.personInfo.roleNum+1);
		}
		
		man_mc._visible		=	false;
		man_mc.gotoAndStop(_root.personInfo.roleNum+1);

		renderCloud();
	}
	
	//整个场景移动。当每跳上一级时
	private function moveDown(yPos:Number):Void{
		_parent.distanceBar_mc.nextFrame();
		_curLevel++;//trace("curLevel: "+_curLevel); //9
		isPause	=	true;//人物与云层暂停移动。
		_aimPos	=	this._y+yPos;
		onEnterFrame=_onEnterFrame;
		if(_curLevel==10){
			bridgeMC._visible	=	true;
			this["bgSide_mc"].bgLeft_mc.upMC._visible	=	false;
			this["bgSide_mc"].bgRight_mc.upMC._visible	=	false;
			removeEventListener("onSceneMoving", this["bgSide_mc"].bgLeft_mc);
			removeEventListener("onSceneMoving", this["bgSide_mc"].bgRight_mc);
		}else if(_curLevel==11){//再跳到就桥上了
			man_mc.isLastJump	=	true;
		}
		//由_curLevel判定哪些云层是可见的。
		renderCloud();
		
	}
	
	private function _onEnterFrame():Void{
		this._y	+=	(_aimPos-this._y)*.5;
		dispatchEvent({type:"onSceneMoving", y:_y});
		if(Math.abs(_aimPos-this._y)<1){
			isPause	=	false;
			//老鹰如果是在飞行的，停止，不可见的。
			//hawkMan_mc.stopMove();
			if(random(3)==0){
				//hawkMan_mc.startMove(-4);
			}
			delete onEnterFrame;
		}
		//////////最上方的桥是否出现
		
	}
	//由_curLevel判定哪些云层是可见的。在屏幕可显示范围外的云层是不可见的。
	private function renderCloud():Void{
		var len:Number	=	_cloudBox.length/3*2;
		var startNum:Number	=	Math.floor(_curLevel/2)*3+_curLevel%2;
		//trace([_curLevel, startNum])
		var cloud:Cloud	=	null;
		for(var i:Number=0;i<len;i++){
			cloud	=	_cloudBox[i];
			if(i<startNum || i>startNum+4){
				cloud._visible	=	false;
			}else{
				cloud._visible	=	true;
				//有可能出现问号，不会动的云层才能显示有问号出现。
				if(cloud.onEnterFrame==null){
					cloud.showQuestionSymbol();
					
				}
			}
		}
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 游戏前的准备，如人物从云层后爬出来
	*/
	public function readyGame(cloud:Cloud):Void{
		cloud.climbMan_mc.man_mc.gotoAndPlay(2);
		cloud.climbMan_mc._visible	=	true;
	}
	
	/**
	* 开始游戏
	*/
	public function startGame():Void{
		totalCoin	=	0;//一开始总数为0
		remainCoin	=	20;//剩余可用的龙币总数。
		readyGame(this["cloud0"]);
		//正式开始游戏
		var len:Number	=	_cloudBox.length/3;
		var cloud:Cloud	=	null;
		for(var i:Number=0;i<len;i++){
			cloud	=	_cloudBox[i*3];
			cloud.startMove(i%2==0 ? -2 : 2);
		}
		_curLevel	=	0;
		renderCloud();
		man_mc.startGame();
		man_mc["_prevCloud"]	=	
		man_mc.curCloud			=	this["cloud0"];
		
		addEventListener("onSceneMoving", this["bgSide_mc"].bgLeft_mc);
		addEventListener("onSceneMoving", this["bgSide_mc"].bgRight_mc);
		//1到5秒内老鹰会从右边飞出。
		_global.setTimeout(hawkMan_mc, "startMove", random(4)*1000+1000, -4);
	}
	
	/**
	 * 结束游戏
	 * 
	 * @param   isWin 
	 */
	public function stopGame(isWin:Boolean):Void{
		if(isWin){
			new com.wangfan.rover.ChangeMoney(this).change(totalCoin, "过山游戏奖励");
			_parent.gotoAndStop("成功");
		}else{
			_parent.gotoAndStop("失败");
		}
		man_mc.stopGame();
	}
	
	/*
	* 当人从云朵后爬起来后，此影片消失，然后出现人
	*/
	public function climpManUp(mc:MovieClip):Void{
		mc._parent._visible	=	false;
		man_mc._visible		=	true;
		man_mc._x	=	mc._parent._parent._x;
		man_mc._y	=	mc._parent._parent._y;
		man_mc.man_mc.gotoAndPlay("stand");
		//trace([mc._parent._parent._x, mc._parent._parent._y, man_mc._x, man_mc._y])
	}
	
	/**
	 * 生命值减少一次
	 * 
	 * @return  如果是结束游戏了，则返回false，否则返回true表示还有机会再玩一次
	 */
	public function deadOnce():Boolean{
		var mc:Object	=	_lifeBox.pop();
		mc.face_mc.face_mc._visible	=	false;
		if(_lifeBox.length==0){
			stopGame(false);
			return false;
		}
		return true;
	}
	
	/*
	* 碰到有问题的云层，有可能出现不同的事件
	*/
	public function meetQuestion(cloud:Cloud):Void{
		if(random(1)==0){
			if(remainCoin>=4){
				var coin:Number	=	random(3)+2;
				remainCoin	-=	coin;
				totalCoin	+=	coin;
				cloud.winCoin_mc.coin	=	coin;
				cloud.winCoin_mc.gotoAndPlay(2);
			}
		}else{//后边两个游戏问题不再出现
			//_parent.problem_mc.gotoAndPlay(2);
		}
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
/*
//暂停所有移动的云层。
	private function pauseAllCloudMoving(enabled:Boolean):Void{
		var len:Number	=	_cloudBox.length;
		var cloud:Cloud	=	null;
		for(var i:Number=0;i<len;i++){
			cloud	=	_cloudBox[i];
			//if(cloud._visible){
				cloud.isPause	=	enabled;
			//}
		}
	}
*/