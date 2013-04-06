//******************************************************************************
//	name:	ForkliftGameSystem 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Jun 09 17:11:19 GMT+0800 2006
//	description: 游戏分为三部分,也可以主是分为三关,用_curLevel表示
//		一开始_curLevel为0,游戏开始后_curLevel=1,如果车达到第二辆车的位置,
//		则为第二关,_curLevel=2.
//		过关后叉车数增加,下降的速度减少,但总体游戏难度还是增加了(叉车数*游戏难度),
//		
//		
//		难度机制:
//		A:如果过第一关时,车的高度达到一半以上的,难度增加2%,
//		如果过第二关时,两车的的高度都在一半以上的,难度增加4%,两车累加.
//		同时,每过一关,难度降低15%.(在checkPosition方法中实现)
//
//		B:如果中途有车停下,则难度增加30%,如果箱子已经被抬到最高点后还继续点击箱子,
//		则每点击一次游戏增加0.5%的难度(在onLift方法中实现).
//
//		C:由于升降部分分为五等分,当箱子在越高的位置,下降的的距离越大,越下方下降
//		的距离越小(liftDown).而相反,当被用户抬起时,越下方的箱子被抬起的距离越大,越高的位置
//		被抬起的距离越小(onClickBox).
//
//		D:每次点击抬升箱子,会暂停箱子下降,如果连续点击箱子超过一定次数,则其它叉车的
//		的箱子会立即掉下来,不管是否还在暂停的时间内(liftDown),[已经取消]
//
//		E:箱子不会总是往下掉的,有可能会掉下来中途会停会再继续掉.当多于一辆叉车存
//		的条件下,
//******************************************************************************

import com.wlash.games.toyota.Forklift;
import com.wlash.games.toyota.SpecialEvents;
import mx.utils.Delegate;

/**
 * system of 3 forklifts game.<p></p>
 * 
 * <b>EventDispatcher</b>
 * <ul>
 * <li>onLiftState({forklift, state}):</li>
 * <li>onStopGame({winNum}):</li>
 * <li>onPosition({level})</li>
 * </ul>
 */
class com.wlash.games.toyota.ForkliftGameSystem extends Object{
	//[**DEBUG**] your ought to remove it after finish this CLASS!
	//public static var tt:Function		=	com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _liftUpIcon:MovieClip	=	null;
	private var _forklifts:Array		=	null;
	
	private var _winForkliftNum:Number	=	null;//已经完成的叉车.
	private var _activeNum:Number		=	null;//活动叉车的数量
	private var _gameLevel:Number		=	null;//游戏难易度,会随着游戏改变,
	
	//叉车指定的位置,如果超过,激活事件.
	//任何一部车超过指定位置,则进入下一级别,
	private var _position:Array			=	null;//三部车位置
	private var _initLiftHeight:Array	=	null;
	private var _curLevel:Number		=	null;
	private var _interID:Number		=	null;//循环的句柄.
	//游戏过程中随机出现的特殊事件.
	private var _specialEvt:SpecialEvents	=	null;
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br>
	* add a listener for a particular event<br>
	* parameters event the name of the event ("click", "change", etc)<br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br>
	* remove a listener for a particular event<br>
	* parameters event the name of the event ("click", "change", etc)<br>
	* parameters handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(ForkliftGameSystem.prototype);
	
	//***************************[READ|WRITE]*********************************//
	
	
	
	//***************************[READ ONLY]**********************************//
	
	
	/**
	 * construction function.<br></br>
	 * create a class BY [new ForkliftGameSystem(this);]
	 * @param target target a movie clip
	 */
	public function ForkliftGameSystem(target:MovieClip){
		this._target	=	target;
		init();
	}
	
	//***************************[PRIVATE METHOD]*****************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_liftUpIcon			=	_target.hoverIcon_mc;
		_forklifts			=	[];
		_position			=	[];
		_initLiftHeight		=	[];
		_curLevel			=	
		_winForkliftNum		=	
		_activeNum			=	0;
		_gameLevel			=	1.00;
		_specialEvt			=	new SpecialEvents(_target, this);
	}
	
	/**
	 * 定义操作叉的事件,比如点击车身身车前进,
	 * 或点击箱子抬上去
	 * 
	 * @param   forklift 
	 */
	private function setEvent(forklift:Forklift):Void{
		
		var liftBar:MovieClip	=	forklift;
		
		//liftBar.onPress		=	Delegate.create(this, onPressBox);
		liftBar.onRollOver	=	Delegate.create(this, onHoverBox);
		liftBar.onRollOut	=	liftBar.onReleaseOutside	=	
									Delegate.create(this, onRollOutBox);
		liftBar.onRelease	=	Delegate.create(forklift, onClickBox);
		liftBar.useHandCursor	=	false;
		//当箱子到顶或到底时产生的事件,实际在升降过程中也会产生.
		//只是state不一样
		forklift.addEventListener("onLift", this);
		forklift.active		=	true;
		_activeNum++;
	}
	
	/*
	 * 当mouse按下时
	 */
	private function onPressBox():Void{
		_liftUpIcon.staff_mc.nextFrame();
	}
	
	/*
	 * 当mouse在箱子上方时
	 */
	private function onHoverBox():Void{
		Mouse.hide();
		_liftUpIcon._x	=	_target._xmouse;
		_liftUpIcon._y	=	_target._ymouse;
		_liftUpIcon._visible	=	true;
		Mouse.addListener(this);
	}
	
	/*
	 * 当mouse离开箱子上方时
	 */
	private function onRollOutBox():Void{
		_liftUpIcon._visible	=	false;
		Mouse.show();
		Mouse.removeListener(this);
	}
	
	/*
	 * 当mouse在箱子上方移动时
	 */
	private function onMouseMove():Void{
		_liftUpIcon._x	=	_target._xmouse;
		_liftUpIcon._y	=	_target._ymouse;
		updateAfterEvent();
	}
	
	/**
	 * 当点击箱子时把箱子抬起来
	 */
	private function onClickBox():Void{
		this["lPause"]		=	random(20)+20;
		this["clickTimes"]++;
		var d:Number	=	Math.random()*.3+.4;
		//把升降的长度分为五个级别,达到不同的位置,升降的高度不一样,
		switch(this["liftLevel"]){
			case 5:
				d	*=	.5;
				break;
			case 4:
				d	*=	.6;
				break;
			case 3:
				//d	*=	1.1;
				break;
			case 2:
				d	*=	1.1;
				break;
			case 1:
				d	*=	1.2;
				break;
			case 0:
				
				break;
		}
		
		this["lift"](d);
		
	}
	
	/**
	 * 操作事件失效
	 * 
	 * @param   forklift 
	 */
	private function setEventNone(forklift:Forklift):Void{
		
		var liftBar:MovieClip	=	forklift.liftBar;
		
		delete liftBar.onRelease;
		forklift.warnning(false);//取消车的警告
		forklift.removeEventListener("onLift", this);
		forklift.active		=	false;
		_activeNum--;
	}
	
	/**
	 * 驱使所有的车子不断改变状态,如前进,箱子往下掉.
	 * 
	 */
	private function driver():Void{
		var forklift:Forklift	=	null;
		//var activeNum:Number	=	0;//假设没有车的是激活的.
		for(var i:Number=0;i<3;i++){
			forklift	=	_forklifts[i];
			//trace([forklift,forklift.active]);
			if(!forklift.active){//如果没有激活的车,跳过.
				continue;
			}
			//activeNum++;//激活叉车的数量.
			liftDown(forklift);
			moveAhead(forklift);
		}
		
		if(_activeNum==0){//已经没有激活的叉车,游戏结束
			stopGame();//如果是已经冲到终点结束的,则胜利,半路结束的,则为失败
		}
	}
	
	/**
	 * 使某辆叉车的升降板下降.
	 * @param forklift
	 * @param d 下降多少,这个距离还要加上因为重产生的距离
	 */
	private function liftDown(forklift:Forklift):Void{
		//如果连击次数大于一定的数量,则其它叉车不用等待,直接下降
		//checkClicks(forklift);
		
		if(forklift["lPause"]>0){//暂停的次数
			forklift["lPause"]--;
			return;
		}
		
		var d:Number	=	.12*_gameLevel;
		//越在上方的位置,下降的距离越大.
		switch(forklift.liftLevel){
			case 5:
				d	*=	1.2;
				break;
			case 4:
				d	*=	1.15;
				break;
			case 3:
				d	*=	1.1;
				break;
			case 2:
				d	*=	.9;
				break;
			case 1:
				d	*=	.8;
				break;
			case 0:
				
				break;
		}
		
		//如果激活的叉车数量越过一部,则有一定的概率暂停下降箱子,
		//pauseLiftDown(forklift);
		
		forklift.lift(-d);
	}
	
	/**
	 * 使某辆叉车的前进.
	 * @param forklift
	 */
	private function moveAhead(forklift:Forklift):Void{
		var d:Number			=	null;
		var maxSpeed:Number	=	forklift.maxSpeed;
		if(forklift["mSpeed"]<maxSpeed){//最高速度
			//使车子慢慢加速前进.
			d	=	forklift["mSpeed"]+.003;
			forklift["mSpeed"]	=	d;
			
		}else{
			d	=	maxSpeed;
		}
		forklift.move(d);
		checkPosition(forklift);
	}
	
	/**
	 * 检查叉车的位置,如果达到指定位置,跳下一个级别,在这也就是激活下一辆叉车,
	 * 三车都到最后的位置时,游戏结束,WIN!!
	 * @param forklift
	 */
	private function checkPosition(forklift:Forklift):Void{
		
		var activePos:Number	=	_position[_curLevel];
		
		if(_curLevel>2){//最后一个位置,也就是终点的位置,
			if(forklift._x>activePos){
				setEventNone(forklift);
				_winForkliftNum++;
			}
		}else if(forklift._x>activePos){//任一部车达到指定的过关点.
			//检查当前升级的高度来决定游戏难度
			if(_curLevel==1){//第一关结束
				//按箱子位置增加游戏难度
				_gameLevel	*=	(1+(forklift.liftLevel-3)/80);
				//激活一次特殊事件
				//_specialEvt.makeEvents();
				_gameLevel	*=	0.85;
			}else if(_curLevel==2){//第二关结束
				var forklift2:Forklift	=	null;
				for(var i:Number=0;i<2;i++){
					//按箱子高低位置增加游戏难度
					_gameLevel	*=	(1+(forklift.liftLevel-3)/50);
				}
				//_gameLevel	*=	0.9;
			}
			//由于过了一关,叉车增加一部,所以游戏难度降低15%
			//_gameLevel	*=	0.85;
			setEvent(_forklifts[_curLevel]);
			dispatchEvent({type:"onPosition", level:_curLevel});
			_curLevel++;
		}
		
	}
	
	/**
	 * 得到除了本车外的叉车
	 * @param   forklift 
	 * @return  other forklifts
	 */
	private function getOtherForklifts(forklift):Array{
		var ret:Array	=	_forklifts.slice();
		var len:Number	=	ret.length;
		for(var i:Number=0;i<len;i++){
			if(forklift==ret[i]){
				ret.splice(i,1);
				break;
			}
		}
		return ret;
	}
	
	/*
	 * 检查叉车点击的次数,如果超过一定的次数,则其它等待下降的叉车立即下降,
	 * [增加游戏难度]
	 */
	private function checkClicks(forklift:Forklift):Void{
		if(forklift["clickTimes"]>20){
			var otherForklifts:Array	=	getOtherForklifts(forklift);
			var len:Number		=	otherForklifts.length;
			var oForklift:Forklift	=	null;
			for(var i:Number=0;i<len;i++){//则其它车立即下降
				oForklift	=	otherForklifts[i];
				if(oForklift["lPause"]>0){
					oForklift["lPause"]	=	0;
				}
			}
		}
	}
	
	/*
	 * 如果激活的叉车数量越过一部,则有一定的概率使当前的叉车暂停下降箱子,
	 * [减少游戏难度]
	 */
	private function pauseLiftDown(forklift:Forklift):Void{
		if(_activeNum>0){
			if(random(_activeNum*3)==0){
				var otherForklifts:Array	=	getOtherForklifts(forklift);
				var len:Number		=	otherForklifts.length;
				var oForklift:Forklift	=	null;
				for(var i:Number=0;i<len;i++){
					oForklift	=	otherForklifts[i];
					if(oForklift["lPause"]<=0){
						//只有一部车得于暂停下降
						forklift["lPause"]	=	random(_activeNum*4)+10;
						return;
					}
				}
				
			}
		}
	}
	
	//////////////////[Forklift events]\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	 * forklift的升降事件
	 * @param   eventObj {type, target, state, liftHeight}
	 */
	private function onLift(eventObj:Object):Void{
		var forklift:Forklift	=	eventObj.target;
		switch(eventObj.state){
			case 0 ://达到最低点
				//由于箱子落地,失去一叉车,游戏难度增加30%
				//由于少了一部车,下降的速度应增加,
				_gameLevel	*=	1.30;
				//如果有车落地了,停止警告.
				
				setEventNone(forklift);
				forklift.death();//使叉车变为死灰色,表示不能移动.
				break;
			case 6 ://达到最高点,默认他为五等分所以最高点为5+1
				//由于已经到最高点了,应增加游戏难度.
				_gameLevel	*=	1.05;
				break;
			case 1 ://警告!
				forklift.warnning(true);
				break;
			case 2 ://取消警告
				forklift.warnning(false);
		}
	}
	
	/*
	* 初始化新添加进来的forklift,因为有些属性是forklift没有定义,故要添加进去
	*/
	private function initForklift(forklift:Forklift):Void{
		//因为forklift是个movieclip类,所以可以添加成员变更
		//以下为初始化的值
		forklift.liftLevel	=	0,//升降板在升降架上的位置,分为五等分.
		forklift["mSpeed"]		=	0,//移动的速度,
		forklift["mPause"]		=	0,//移动时保持此速度的次数.
		forklift["lSpeed"]		=	0,//上升或下降的速度,
		forklift["lPause"]		=	10;//每次上升或下降暂停多少次后
									//再上升或下降.
		forklift["clickTimes"]	=	0;//连击次数,如果连击次数大于一个数,则另外的
									//叉车立即下降,而不管lPause时间
	}
	
	//***************************[PUBLIC METHOD]******************************//
	/**
	 * put forklift to this
	 * @param forklift
	 */
	public function addForklift(forklift:Forklift):Void{
		_forklifts.push(forklift);
		initForklift(forklift);
	}
	
	/**
	 * the game start.
	 */
	public function startGame():Void{
		clearInterval(_interID);
		//得到三车的位置,并以此为激活此车的界线
		var forklift:Forklift	=	null;
		for(var i:Number=0;i<3;i++){
			forklift	=	_forklifts[i]
			_position.push(forklift._x);
			_initLiftHeight.push(forklift.liftBar._y);
		}
		//增加结束的终点位置
		_position.push(900);
		//_root.vt	=	getTimer();
		_curLevel	=	1;
		var forklift:Forklift	=	_forklifts[0]
		//使子可以响应点击事件
		setEvent(forklift);
		
		_interID	=	setInterval(this, "driver", 30);
		
	}
	
	/**
	 * end this game.
	 */
	public function stopGame():Void{
		//trace((getTimer()-_root.vt)/1000);
		clearInterval(_interID);
		
		dispatchEvent({type:"onStopGame", winNum:_winForkliftNum});
	}
	
	/*
	 * reset the game, and make it could play again.
	 */
	public function resetGame():Void{
		//重置数据
		_curLevel			=	
		_winForkliftNum		=	
		_activeNum			=	0;
		_gameLevel			=	1.00;
		
		var forklift:Forklift	=	null;
		for(var i:Number=0;i<3;i++){
			forklift	=	_forklifts[i]
			forklift._x	=	_position[i];
			forklift.liftTo(_initLiftHeight[i]);
		}
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ForkliftGameSystem 1.0";
	}
	
	//***************************[STATIC METHOD]******************************//
	/**
	 * debug output
	 */
	public static function output(str:String):Void{
		_root.debug_txt.text	+=	str+newline;
		_root.debug_txt.scroll	=	_root.debug_txt.maxscroll;
	}
}
