//******************************************************************************
//	name:	ForkliftSet 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Jun 09 17:11:19 GMT+0800 2006
//	description: 可以定义一定数量的叉车在场景上移动,如果任何一部移动到的指定的
//		位置,既激活任意一部车的移动,当点击叉车时,叉车上的箱子不会降下,并过一定
//		的时间后降下,如果点击同一部叉车次数大于一定的数,则其它叉车立即下降而不
//		等候下降的时间到来,
//		存在问题:感觉这样编写系统过于复杂,虽然可扩展性挺强的,但对于一个指定三部
//		叉在在指定位置的游戏来说,没必要这样写,这样只会导制更难理解游戏,所以重新
//		写个明了易懂的游戏比赛机制,
//******************************************************************************

import com.wlash.games.toyota.Forklift;
import mx.utils.Delegate;

/**
 * system of forklift game.<p></p>
 * 
 */
class com.wlash.games.toyota.ForkliftSet extends Object{
	//[**DEBUG**] your ought to remove it after finish this CLASS!
	public static var tt:Function		=	com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _forklifts:Array		=	null;
	private var _activeForklifts:Array	=	null;
	private var _winForkliftNum:Number	=	null;//可能走完的叉车,
	//private var _forkliftState:Object	=	null;//保存着叉车的状态,如前进的速度,
							//下降的速度,是否为上升.
	
	//叉车指定的位置,如果超过,激活事件.
	//任何一部车超过指定位置,则进入下一级别,
	private var _position:Array		=	null;
	private var _curLevel:Number	=	null;
	private var _interID:Number	=	null;
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(ForkliftSet.prototype);
	
	//***************************[READ|WIDTH]*********************************//
	[Inspectable(defaultValue="", verbose=1, type=Array)]
	function set position(value:Array):Void{
		_position	=	value;
	}
	/**Annotation */
	function get position():Array{
		return _position;
	}
	
	
	//***************************[READ ONLY]**********************************//
	
	
	/**
	 * construction function.<br></br>
	 * create a class BY [new ForkliftSet(this);]
	 * @param target target a movie clip
	 */
	public function ForkliftSet(target:MovieClip){
		this._target	=	target;
		
		init();
	}
	
	//***************************[PRIVATE METHOD]*****************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_forklifts			=	[];
		_activeForklifts	=	[];
		
		_position			=	[];
		_curLevel			=	0;
		_winForkliftNum		=	0;
	}
	
	/**
	 * 定义操作叉的事件,比如点击车身身车前进,
	 * 或点击箱子抬上去
	 * 
	 * @param   fl 
	 */
	private function setEvent(fl:Forklift):Void{
		var body:MovieClip		=	fl.body;
		var liftBar:MovieClip	=	fl.liftBar;
		
		body.onRelease=Delegate.create(fl, onClickBody);
		liftBar.onRelease=Delegate.create(fl, onClickBox);
		
		fl.addEventListener("onLift", this);
	}
	
	/**
	 * 操作事件失效
	 * 
	 * @param   fl 
	 */
	private function setEventNone(fl:Forklift):Void{
		var body:MovieClip		=	fl.body;
		var liftBar:MovieClip	=	fl.liftBar;
		
		delete body.onRelease;
		delete liftBar.onRelease;
		
		fl.removeEventListener("onLift", this);
	}
	
	/**
	 * 当点击车身时使车子前边
	 */
	private function onClickBody():Void{
		//因为this指向这个类,但实际上是指身forklift类.
		this["move"](Math.random()*0.3+0.5);
	}
	
	/**
	 * 当点击箱子时把箱子抬起来
	 */
	private function onClickBox():Void{
		this["lPause"]		=	random(20)+100;
		this["clickTimes"]++;		
		this["lift"](Math.random()*0.3+0.2);
	}
	
	/**
	 * 驱使所有的车子不断改变状态,如前进,箱子往下掉.
	 * 
	 */
	private function driver():Void{
		var forklift:Forklift	=	null;
		var len:Number	=	_activeForklifts.length;
		for(var i:Number=0;i<len;i++){
			forklift	=	_activeForklifts[i];
			liftDown(forklift);
			moveAhead(forklift);
		}
	}
	
	/**
	 * 使某辆叉车的升降板下降.
	 * @param forklift
	 * @param d 下降多少,这个距离还要加上因为重产生的距离
	 */
	private function liftDown(forklift:Forklift):Void{
		//如果连击次数大于一定的数量,
		
		if(forklift["clickTimes"]>8){
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
		
		
		if(forklift["lPause"]>0){//暂停的时间
			forklift["lPause"]--;
			return;
		}
		forklift["lPause"]	=	0;
		var d:Number	=	.01;
		forklift.lift(-d);
		
	}
	
	/**
	 * 使某辆叉车的前进.
	 * @param forklift
	 * 
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
	 * 得到除了本车外的叉车
	 * 
	 * 
	 * @param   forklift 
	 * @return  other forklifts
	 */
	private function getOtherForklifts(forklift):Array{
		var ret:Array	=	_activeForklifts.slice();
		var len:Number	=	ret.length;
		for(var i:Number=0;i<len;i++){
			if(forklift==ret[i]){
				ret.splice(i,1);
				break;
			}
		}
		return ret;
	}
	
	/**
	 * 检查叉车的位置,如果达到指定位置,跳下一个级别,在这也就是激活下一辆叉车,
	 * 三车都到最后的位置时,游戏结束,WIN!
	 * @param forklift
	 */
	private function checkPosition(forklift:Forklift):Void{
		if(forklift==null)	return;
		var pos:Number	=	_position[_curLevel];
		if(forklift._x>=pos){//如果叉车行走到指定的位置
			var nextForklift:Forklift	=	_forklifts[_curLevel+1];
			if(nextForklift.active==false){//如果下趟车没有激活的话,
				_curLevel++;//进入下一关.
				activeForklift(nextForklift);
			}else{//最后一关时,nextForklift的值为null,所以把当前的叉车停掉.
				inactiveForklift(forklift)//如果没有激活的叉车后,
				//游戏结束,WIN!!!
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
		//var amount:Number		=	null;
		switch(eventObj.state){
			case 1 ://达到最低点
				_winForkliftNum--;
				setEventNone(forklift);
				inactiveForklift(forklift);
				
				break;
			case 2 ://达到最高点
				
				break;
			case 0 ://正常之中
				
				break;
		}
	}
	
	//***************************[PUBLIC METHOD]******************************//
	/**
	 * put forklift to this
	 * @param forklift
	 */
	public function addForklift(forklift:Forklift):Void{
		_forklifts.push(forklift);
	}
	
	/**
	 * inative forklift
	 * 
	 * @param   forklift 
	 */
	public function inactiveForklift(forklift:Forklift):Void{
		var len:Number	=	_activeForklifts.length;
		for(var i:Number=0;i<len;i++){
			if(_activeForklifts[i]==forklift){
				_activeForklifts.splice(i, 1);
				
				break;
			}
		}
		
		forklift.active	=	false;
		setEventNone(forklift);
		if(_activeForklifts.length==0){//没有激活的叉车,游戏结束,
			stopGame();
		}
	}
	
	/**
	 * ative forklift
	 * 
	 * @param   forklift 
	 */
	public function activeForklift(forklift:Forklift):Void{
		_activeForklifts.push(forklift);
		//var fName:String	=	forklift._name;
		//因为forklift是个movieclip类,所以可以添加成员变更
		//以下为初始化的值
		forklift["mSpeed"]		=	0,//移动的速度,
		forklift["lSpeed"]		=	0,//上升或下降的速度,
		forklift["lPause"]		=	10;//每次上升或下降暂停多少次后
									//再上升或下降.
		forklift["clickTimes"]	=	0;//连击次数,如果连击次数大于一个数,则另外的
									//叉车立即下降,而不管lPause时间
		
		forklift.active		=	true;
		setEvent(forklift);
		_winForkliftNum++;//假设此车会走完,
	}
	
	/**
	 * the game start.
	 */
	public function startGame():Void{
		clearInterval(_interID);
		
		activeForklift(_forklifts[0]);
		output("游戏中...");
		_interID	=	setInterval(this, "driver", 30);
	}
	
	/**
	 * end this game.
	 */
	public function stopGame():Void{
		clearInterval(_interID);
		dispatchEvent({type:"onStopGame", winNum:_winForkliftNum});
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ForkliftSet 1.0";
	}
	
	//***************************[STATIC METHOD]******************************//
	
	
}
