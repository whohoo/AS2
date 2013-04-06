//******************************************************************************
//	name:	SlotMachine 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 21 19:47:03 GMT+0800 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************



import mx.utils.Delegate;
import com.wangfan.rover.MapTiles;

/**
 * 老虎机的一滚动条.<p></p>
 * 由上向下滚动，可以定义指定的滚动数值码,此码不能大于总数
 */
class com.wangfan.rover.SlotMachine extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _cardUp:MovieClip		=	null;//最上方的那张牌
	private var _cardDown:MovieClip	=	null;//最下方的那张牌
	
	private var _posUp:Number			=	null;//最上方位置
	private var _posDown:Number		=	null;//最下方位置

	private var _state:Number			=	0;//0:停止,1:开始滚动,2:快速滚动中
												//3:作弊高速阶段,4:减速停下,
												//5:调整状态到停止状态
	private var _curCard:MovieClip		=	null;
	
	
	private var _inter:Number			=	null;
	private var _interSP:Number		=	null;
	private var _curSpeed:Number		=	0;
	private var _minSpeed:Number		=	20;//调整速度过程的最小速度
	/**滚动条中共有多少张牌*/
	public  var maxCardNum:Number		=	6;//罗福，车Logo,福尔摩思，车照，Mr.Ben, roverLogo
	/**此滚动条中滚动的最大速度*/
	public  var maxSpeed:Number		=	80;
	/**开始加速的速度*/
	public  var accSpeed:Number		=	10;
	/**减速的减速度*/
	public  var decSpeed:Number		=	5;
	
	private var _cheatNum:Number		=	null;
	
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set cheatNum(value:Number):Void{
		_cheatNum	=	isNaN(value) ? null : value%maxCardNum;
	}
	/**作弊，希望转到的第几个牌*/
	function get cheatNum():Number{
		return _cheatNum;
	}
	
	//************************[READ ONLY]*************************************//
	/**当前状态 */
	function get state():Number{
		return _state;
	}
	/**可显示的卡片 */
	function get curCard():MovieClip{
		return _curCard;
	}
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(SlotMachine.prototype);
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachine(this);]
	 * @param target target a movie clip
	 */
	public function SlotMachine(target:MovieClip){
		this._target	=	target;
		_cardUp			=	target.card0;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		var mc:MovieClip	=	null;
		var mcLast:MovieClip	=	null;
		var sortArr:Array	=	randomArray(maxCardNum);
		_cardUp.swapDepths(0);
		for(var i:Number=0;i<maxCardNum;i++){
			if(i!=0){
				mc	=	_cardUp.duplicateMovieClip("card"+i,i);
			}else{
				mc	=	_cardUp;
			}
			mc._y	=	(i-3)*300;
			mc.gotoAndStop(i+1);
			
			mc.prevCard		=	mcLast;
			mcLast.nextCard	=	mc;
			//trace([mc, mcLast])
			mcLast	=	mc;
		}
		_cardDown	=	mc;
		_cardUp.prevCard	=	mc;//上一个mc的指向
		mc.nextCard	=	_cardUp;//最后一个指向第一个
		
		_posUp		=	_cardUp._y;
		_posDown	=	_cardDown._y;
		//打乱顺序
		shuffle();
	}
	
	private function run():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<maxCardNum;i++){
			mc	=	_target["card"+i];
			mc._y	+=	_curSpeed;
			//trace([mc.prevCard._name, mc._name, mc.nextCard._name]);
			mc.blurY	=	Math.round(_curSpeed/2.5);
		}
		if(_cardDown._y>=_posDown){
			_cardDown._y	=	_cardUp._y-300;
			mc			=	_cardUp;
			_cardUp		=	_cardDown;
			_cardDown	=	_cardDown.prevCard;
		}
		//不同的状态,不同的滚动速度
		switch(_state){
			case 0://停止,
				
				break;
			case 1://加速
				setSpeedUp();
				break;
			case 2://均速
				
				break;
			case 3://作弊阶段,滚动到指定的数值才会停下来
				if(_cheatNum==null){
					_state	=	4;
				}else{
					simTest(_cardUp);
				}
				break;
			case 4://减速,
				setSpeedDown();
				break;
			case 5://调整状态
				stopAt();
				break;
		}
		updateAfterEvent();
	}
	//加速
	private function setSpeedUp():Void{
		_curSpeed	+=	accSpeed;
		if(_curSpeed>=maxSpeed){
			_state		=	2;
		}
	}
	//减速
	private function setSpeedDown():Void{
		_curSpeed	-=	decSpeed;
		if(_curSpeed<=_minSpeed){
			_state		=	5;//调整状态
			if(_cheatNum!=null){//如果已经是在作弊,就不必要再去查找哪一个是在
								//中间可显示的卡片了
				return;
			}
			var mc:MovieClip	=	null;
			for(var i:Number=0;i<maxCardNum;i++){
				mc	=	_target["card"+i];
				if(mc._y>=-300){//看看哪一个在在可显示的框中
					if(mc._y<0){
						_curCard	=	mc;
						//trace([_target._name,mc])
						break;
					}
				}
			}
		}
	}
	
	private function stopAt():Void{
		if(_curCard._y+_curSpeed>=0){
			_curSpeed	=	0;
			_curCard.prevCard._y	=	-300;
			_curCard._y	=	0;
			_curCard.blurY	=	0;
			clearInterval(_inter);
			_cheatNum	=	null;
			_state	=	0;
			dispatchEvent({type:"onStop", card:_curCard});
		}
	}
	
	//当卡片滚动到最高速度时,根据当前的速度与减速度计算,指定的mc最终会落在何位置
	private function simTest(mc:MovieClip):Void{
		var curSpeed:Number	=	_curSpeed;
		var curY:Number		=	mc._y;
		var cardNum:Number		=	mc._currentframe-1;
		//trace("开始位置:"+curY)
		while(true){
			curY	+=	curSpeed;
			curSpeed	-=	decSpeed;
			if(curSpeed<=_minSpeed){
				//trace("最终位置: "+["ABCDEFG".charAt(cardNum), curY, _target._name]);
				break;
			}
		}
		//判断进入可显示框的牌是否是我想要的那张牌.
		switch(Math.floor(curY/300)){
			case -3://-900~~-600
				if(mc.nextCard.nextCard._currentframe-1==_cheatNum){
					_state	=	4;
					_curCard	=	mc.nextCard.nextCard;
				}
				break;
			case -2://-600~~-300
				if(mc.nextCard._currentframe-1==_cheatNum){
					_state	=	4;
					_curCard	=	mc.nextCard;
				}
				break;
			case -1://-300~~0
				if(mc._currentframe-1==cheatNum){
					_state	=	4;
					_curCard	=	mc;
				}
				break;
			case 0://0~~300
				if(mc.prevCard._currentframe-1==_cheatNum){
					_state	=	4;
					_curCard	=	mc.prevCard;
				}
				break;
			case 1://300~~600
				if(mc.prevCard.prevCard._currentframe-1==_cheatNum){
					_state	=	4;
					_curCard	=	mc.prevCard.prevCard;
				}
				break;
			case 2://600~~900
				
				break;
		}
	}
	
	private function shuffle():Void{
		_cardUp		=	_target["card"+random(maxCardNum)];
		_cardUp._y	=	_posUp;
		var mc:MovieClip	=	_cardUp;
		var len:Number		=	maxCardNum-1;
		for(var i:Number=0;i<len;i++){
			mc.nextCard._y	=	mc._y+300;
			mc	=	mc.nextCard;
		}
		_cardDown	=	mc;
		//trace([mc._y, mc._name, _posDown, _target._name])
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 开始滚动
	 */
	public function startRun():Void{
		if(_state!=0)	return;//只有在停止状态下方可以开始滚动
		clearInterval(_inter);
		_inter=setInterval(Delegate.create(this, run), 30);
		_state		=	1;//开始加速滚动状态
	}
	/**
	* 开始停止滚动
	*/
	public function stopRun():Void{
		if(_state!=2)	return;//只有在高速转动时方可以停止
		//simTest(_cardUp);
		_state		=	3;//进入伐作弊高速状态
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "SlotMachine 1.0";
	}

	//***********************[STATIC METHOD]**********************************//
	/**
	 * 得到随机的0-num的数组
	 * 
	 * @param   num 
	 * @return  
	 */
	public static function randomArray(num:Number):Array{
		var sortArr:Array	=	[];
		for(var i:Number=0;i<num;i++){
			sortArr.push(i);
		}
		var randomNum:Number	=	null;
		var rNum:Number		=	null;
		for(i=0;i<num;i++){
			randomNum	=	random(num);
			rNum		=	sortArr[randomNum];
			sortArr[randomNum]	=	sortArr[i];
			sortArr[i]	=	rNum;
		}
		
		return sortArr;
	}
}//end class
//This template is created by whohoo.
