//******************************************************************************
//	name:	GoRiver 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Sep 29 10:45:09 GMT+0800 2006
//	description: This file was created by "river.fla" file.
//		
//******************************************************************************

import com.idescn.as3d.Vector3D;
import mx.utils.Delegate;
import mx.transitions.Tween;
import com.wangfan.rover.events2.OnTweenManMove;
import com.wangfan.rover.events2.OnTweenCaskSink;
import com.wangfan.rover.events2.OnTweenCaskSinkDown;
/**
 * 在平面上放着N只桶,然后每个桶有与附近的桶有关系.<p></p>
 * 如果在指定的范围内,则此桶会与范围的桶有关系.
 * 人物通过Tween类中三个方向的移动来确定人物的关系.
 * 随机木桶可能会下沉或上浮.
 * 整个游戏最多只能拿到20个金币，每次只拿5个。
 */
class com.wangfan.rover.GoRiver extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _casks:Array			=	null;
	private var _manMC:MovieClip		=	null;
	private var _getCoinMC:MovieClip	=	null;
	private var _curCask:MovieClip		=	null;
	private var _curSinkCasks:Array		=	null;
	private var _interID:Number		=	null;
	private var _isAutoJump:Boolean	=	null;
	private var totalCoin:Number		=	null;//游戏成功结束后应计算到内的龙币数.
	
	private var _state:Number			=	-1;//0表示游戏停止
												//1表示站在桶上,
												//2表示落下站在桶上,但桶是下沉.
												//3表示准备跳起
												//4表示跳起在空中飞跃中,

	/**当前状态下剩余的龙币*/
	//public  var remainCoin:Number		=	20;//默认只能得到20个龙币
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=MovieClip)]
	function set manMC(value:MovieClip):Void{
		_manMC	=	value;
	}
	/**人物的角色 */
	function get manMC():MovieClip{
		return _manMC;
	}
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new GoRiver(this);]
	 * @param target target a movie clip
	 */
	public function GoRiver(target:MovieClip){
		this._target	=	target;
		Vector3D.defaultViewDist	=	500;
		_manMC			=	target.roleMan_mc;
		_getCoinMC		=	target.getCoin_mc;
		OnTweenManMove.goRiver	=	this;
		OnTweenCaskSink.goRiver	=	this;
		OnTweenCaskSinkDown.goRiver	=	this;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_isAutoJump		=	false;
		_casks			=	[];
		_curSinkCasks	=	[];
		var mc:MovieClip	=	null;
		var amount:Number	=	0;
		var v3d:Vector3D	=	null;
		for(var prop:String in _target){
			mc	=	_target[prop];
			v3d	=	new Vector3D(mc._x, mc._y, 0);
			v3d.plus(new Vector3D(0, 0, 200));
			v3d.rotateX(-90);
			mc.v3d		=	v3d;
			if(mc._name.substr(0, 4)=="cask"){
				mc.nCasks	=	[];//他周围附近的桶
				initCask(mc);
				mc.gotoAndPlay(random(mc._totalframes))
				//木桶下沉与上浮,或有人占上去时下沉部分
				mc.tw	=	new Tween(mc.body.cask_mc, "_y", 
							mx.transitions.easing.None.easeNone,
							mc.body.cask_mc._y, 0, 1, true);
				mc.tw.stop();
				mc.body.cask_mc.hint_mc._visible	=	false;
				amount++;
			}else{//人的定义
				mc.twX	=	new Tween(v3d, "x", 
							mx.transitions.easing.None.easeNone,
							v3d.x, 0, 10, false);
				mc.twX.stop();
				mc.twY	=	new Tween(v3d, "y", 
							mx.transitions.easing.None.easeNone,
							v3d.y, 0, 10, false);
				mc.twY.stop();
				mc.twZ	=	new Tween(v3d, "z", 
							mx.transitions.easing.None.easeNone,
							v3d.z, 0, 10, false);
				mc.twZ.stop();
				mc.twZ.addListener(OnTweenManMove);
			}
		}
		//按顺序放进_casks中去
		for(var i:Number=0;i<amount;i++){
			_casks.push(_target["cask"+i]);
		}
		
		_curCask	=	_target.cask0;
		_curCask.v3d.y	-=	25;
		_casks[_casks.length-1].v3d.y	-=	30;
		//前后两桶不可见,默认为岸上
		_casks[_casks.length-1]._alpha	=	0;
		_curCask._visible	=	false;
		//TODO: 不能使用_manMC.v3d	=	_curCask.v3d.getClone();否则,人物不会跳
		_manMC.v3d.x	=	_curCask.v3d.x;//人站在第一个桶上
		_manMC.v3d.y	=	_curCask.v3d.y;
		_manMC.v3d.z	=	_curCask.v3d.z;
		
		countPosition(200);//得到桶之间的联系
		
		render();
		_state	=	0;//游戏初始完成,但游戏是停止的
	}
	
	private function initCask(mc:MovieClip):Void{
		mc.onRelease=Delegate.create(mc, onCaskRelease);
		mc.pClass	=	this;
	}
	///点击木桶事件
	private function onCaskRelease():Void{
		var pClass:Object	=	this["pClass"];
		if(pClass["_state"]!=1)		return;//人物不站在桶上
		var caskArr:Array	=	this["nCasks"];
		var len:Number		=	caskArr.length;
		var mc:MovieClip	=	null;
		
		pClass.highLight(this);
		pClass["_manMC"].man_mc.gotoAndPlay("readyJump");
		pClass["_manMC"].caskMC		=	this;
		pClass["_state"]	=	3;//准备起跳
	}
	
	private function highLight(mc:MovieClip):Void{
		
		var mc2:MovieClip	=	null;
		var len:Number		=	_casks.length;
		for(var i:Number=0;i<len;i++){//reset all
			mc2		=	_casks[i];
			mc2.body.cask_mc.hint_mc._visible	=	false;
			mc2.enabled	=	false;
		}
		if(_isAutoJump)	return;//如果是自动跳动，不要显示高亮的点
		//周末的显亮
		len	=	mc.nCasks.length;
		for(i=0;i<len;i++){
			mc2		=	mc.nCasks[i];
			mc2.body.cask_mc.hint_mc._visible	=	true;
			mc2.enabled	=	true;
		}
	}
	
	//得到两个影片之间的距离,
	private function getDistance(mc:MovieClip, mc2:MovieClip):Number{
		var x:Number	=	mc._x-mc2._x;
		var y:Number	=	mc._y-mc2._y;
		//trace([mc._name, mc2._name, Math.sqrt(x*x, y*y), x, y])
		return Math.sqrt(x*x+y*y);
	}
	//定义最小距离,得到相应的桶邻近的桶.
	public function countPosition(distance:Number):Void{
		var mc:MovieClip	=	null;
		var len:Number		=	_casks.length;
		var distance2:Number	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	_casks[i];
			var mc2:MovieClip	=	null;
			for(var ii:Number=0;ii<len;ii++){
				mc2	=	_casks[ii];
				if(mc2==mc)	continue;
				distance2	=	getDistance(mc, mc2);
				if(distance2<distance){
					mc.nCasks.push(mc2);
				}
			}
		}
	}
	
	//game's core
	private function interRunning():Void{
		switch(_state){
			case 0://游戏停止过程
				
				break;
			case 1://人站在桶上晃动
				switch(_curCask._name.substr(4)){
					case "0"://第一个桶
						
						return;
					case String(_casks.length-1)://最后一个桶
						stopGame(true);//成功地完成游戏
						return;
				}
				
				_manMC._rotation	=	-_curCask.body._rotation;
				break;
			case 2://人站在桶上下沉
				
				break;
			case 3://准备跳起来
				
				break;
			case 4://在空中飞跃
				
				break;
			default:
				trace(_state);
		}
		if(_target==null)	clearInterval(_interID)
		//updateAfterEvent();
	}
	
	private function render():Void{
		var len:Number		=	_casks.length;
		for(var i:Number=0;i<len;i++){
			renderObj(_casks[i])
		}
		renderMan();
	}
	
	private function renderObj(mc:MovieClip):Void{
		var v3d:Vector3D	=	mc.v3d;
		var pres:Number	=	mc.v3d.getPerspective();
		v3d		=	mc.v3d.persProjectNew(pres);
		mc._x	=	v3d.x;
		mc._y	=	v3d.y;
		mc._xscale	=
		mc._yscale	=	pres*60;
		mc.swapDepths(10000-Math.round(mc.v3d.z));
	}
	
	private function makeSinkCaskDown():Void{
		_curSinkCasks	=	[];
		//去掉一头一尾桶的数量,再取N个(5~~7)个
		var arr:Array	=	com.wangfan.rover.SlotMachine.randomArray(_casks.length-4);
		var len:Number	=	random(3)+2;
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	_casks[arr[i]+3];
			_curSinkCasks.push(mc);
			_global.setTimeout(	Delegate.create(this, sinkCaskDown), 
														random(70)*100, mc);
		}
	}
	
	private function stopAllSinkingCask():Void{
		var len:Number	=	_curSinkCasks.length;
		for(var i:Number=0;i<len;i++){
			//trace([_curSinkCasks[i], _curSinkCasks[i].onTweenCaskSinkDown]);
			_curSinkCasks[i].onTweenCaskSinkDown.mustStop	=	true;
		}
	}
	/**
	 * 随机显示问题
	 */ 
	private function showQuestion():Void{
		//if(_state==2)	return;//木桶在下沉,或准备下沉状态时,也不要显示问题
		if(Number(_curCask._name.substr(4))<10)	return;//在之前,不要显示问题
		var problemMC:MovieClip	=	_target._parent._parent.problem_mc;
		if(random(1)==0){//三分之一的机会会出现问答题
			problemMC.gotoAndPlay(2);
			stopAllSinkingCask();
		}
	}
	//当问题回答正确后，自动跳到终点
	private function autoJump():Void{
		caskEnabled(false);
		var arr:Array	=	_curCask.nCasks;
		arr[arr.length-1].onRelease();
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 更新人的位置,此函数主要被OnTweenManMove的onMotionChanged所调用
	 */ 
	public function renderMan():Void{
		renderObj(_manMC);
	}
	/**
	 * 人物开始跳,此函数主要在人物的动画过程中开始跳起的那部分开始调用.
	 */ 
	public function jumpCask(mc:Object):Void{
		//Tween X
		var tw:Tween	=	_manMC.twX;
		tw.begin		=	_manMC.v3d.x;
		tw.finish		=	mc.v3d.x;
		tw.start();
		//Tween Y
		tw				=	_manMC.twY;
		tw.begin		=	_manMC.v3d.y;
		tw.finish		=	mc.v3d.y;
		tw.start();
		//Tween Z
		tw				=	_manMC.twZ;
		tw.begin		=	_manMC.v3d.z;
		tw.finish		=	mc.v3d.z;
		tw.start();
		//trace([_manMC.v3d, mc.v3d])
		_state	=	4;//已经在空中
		sinkCask(-1);//把下沉的木桶恢复原样
		_curCask	=	_manMC.caskMC;
	}
	/**
	 * 开始游戏
	 */
	public function startGame():Void{
		//remainCoin		=	20;
		totalCoin		=	0;
		_isAutoJump		=	false;
		highLight(_casks[0]);
		clearInterval(_interID);
		_interID=setInterval(Delegate.create(this, interRunning), 30);
		_state	=	1;//人物正常站在桶上
		makeSinkCaskDown();
	}
	/**
	 * 结束游戏,
	 * @param isSuccess 如果值为false,则跳到游戏结束,并冻结时间五小时
	 */
	public function stopGame(isSuccess:Boolean):Void{
		_isAutoJump	=	false;
		if(isSuccess==false){
			new com.wangfan.rover.LockuserForm();
			_state	=	0;//表示游戏停止
			clearInterval(_interID);
			_target._parent._parent.gotoAndPlay("失败");
		}else{
			if(Number(_curCask._name.substr(4))==_casks.length-1){
				_state	=	0;//表示游戏停止
				clearInterval(_interID);
				new com.wangfan.rover.ChangeMoney(_target).change(totalCoin, "过河游戏奖励");
				_target._parent._parent.gotoAndPlay("成功");
			}else{//是回答问题正确后，直接走到岸边上。
				_isAutoJump	=	true;
				autoJump();
			}
		}
	}
	
	/**
	 * 木桶完全沉下去或浮上来,周期性的,但只有随机的部分木桶会有此现像
	 * @param mc
	 */
	public function sinkCaskDown(mc:MovieClip):Void{
		var startPosY:Number	=	mc.body.cask_mc._y;
		var endPosY:Number		=	startPosY+400;
		var tw:Tween	=	new Tween(mc.body.cask_mc, "_y", 
							mx.transitions.easing.None.easeNone,
							startPosY, endPosY, 2, true);
		tw.addListener(new OnTweenCaskSinkDown(mc));
		mc.isSinking	=	true;//开始下沉
	}
	
	/**
	 * 当人站在当前木桶上时,木桶下沉部分
	 * 
	 * @param coin 根据金币的多少来决定沉多少, -1表示木桶因人离开页浮上来
	 */
	public function sinkCask(coin:Number):Void{
		var mc:MovieClip		=	_curCask;
		if(mc._alpha==0)	return;
		var startPosY:Number	=	mc.body.cask_mc._y;
		var endPosY:Number		=	null;
		if(coin==-1){
			endPosY		=	0;
		}else{
			coin	=	coin==null ? 30 : coin;//30 are default value
			var percent:Number		=	coin/500;
			var coinWeight:Number	=	mc.body.cask_mc._height*(percent>.2 ? 
											.2 : percent);//限制最大重量值
			var manWeight:Number	=	10;//default weight
			endPosY		=	startPosY+coinWeight+manWeight;
		}
		var tw:Tween	=	new Tween(mc.body.cask_mc, "_y", 
							mx.transitions.easing.Strong.easeOut,
							startPosY, endPosY, .5, true);
		if(coin!=-1){//只有下沉状态下方可移动桶上的人
			tw.addListener(OnTweenCaskSink);
		}
	}
	
	/**
	 * 当跳动站稳到木桶上时,此函数被OnTweenManMove调用
	 */ 
	public function onMotionDone():Void{
		if(_isAutoJump){
			_global.setTimeout(this, "autoJump", 500);
			//自动跳时，不会执行下边的事件.
			return;
		}
		//var coin:Number	=	_root.personInfo.coin;
		//coin	=	coin==null ? 10 : coin;//缺省值
		if(_curCask.isSinking!=null){
			if(totalCoin<20){//龙币不能超过20个
				if(random(Math.ceil(totalCoin/5)+1)==0){//会下沉的桶可以得到更大的机会得到龙币
					
					totalCoin	+=	5;
					_manMC.getCoin_mc.gotoAndPlay(2);
					return;
				}
			}
		}else{
			if(totalCoin<20){//龙币不能超过20个
				if(random(Math.ceil(totalCoin/5)+2)==0){
					totalCoin	+=	5;
					_manMC.getCoin_mc.gotoAndPlay(2);
					return;
				}
			}
			//只当木桶不会下沉或上浮的,才会机会显示问题
			showQuestion();
		}
	}
	/**
	* 定义木桶是否可点击.
	* @param	enabled
	*/
	public function caskEnabled(enabled:Boolean):Void{
		var mc2:MovieClip	=	null;
		var len:Number		=	_casks.length;
		for(var i:Number=0;i<len;i++){//reset all
			mc2		=	_casks[i];
			mc2.enabled	=	enabled;
		}
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GoRiver 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
