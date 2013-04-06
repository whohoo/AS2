//******************************************************************************
//	name:	CatchHe 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-10-26 11:08
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;

/**
 * Mr.Ben要把拉登捉住<p/>
 * 他可以使用四种方法去捉住他,但只有最后一种方法要可以促住,
 */
class com.wangfan.rover.CatchHe extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _menMC:MovieClip		=	null;
	private var _whiskBTN:Button		=	null;
	private var _hammerBTN:Button		=	null;
	private var _shoeBTN:Button			=	null;
	private var _headBTN:Button			=	null;
	private var _timerTXT:TextField		=	null;
	private var _countTimer:Number		=	null;
	private var _interID:Number			=	null;
	private var _state:String			=	null;
	/**唯一此类对象(原来想生成一个唯一对象的,但由于游戏结束后再开始,部分MC消失,故去掉)*/
	public static var singlone:CatchHe	=	null;
	//************************[READ|WRITE]************************************//
	function set state(value:String):Void{
		if(value==_state)	return;
		if(value=="running"){
			_whiskBTN.enabled	=	
			_hammerBTN.enabled	=
			_shoeBTN.enabled		=	
			_headBTN.enabled		=	true;
		}else if(value=="throw"){
			_whiskBTN.enabled	=	
			_hammerBTN.enabled	=
			_shoeBTN.enabled		=	
			_headBTN.enabled		=	false;
		}
		_state	=	value;
		
	}
	/**在当中被移动的地图 */
	function get state():String{
		return _state;
	}
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new MoveMap(this);]
	 * @param target target a movie clip
	 */
	private function CatchHe(target:MovieClip){
		this._target		=	target;
		this._menMC			=	target.men_mc;
		this._whiskBTN		=	target.whisk_btn;
		this._hammerBTN		=	target.hammer_btn;
		this._shoeBTN		=	target.shoe_btn;
		this._headBTN		=	target.head_btn;
		this._timerTXT		=	target.timer_txt;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_whiskBTN.onRelease=Delegate.create(this, onWhiskRelease);
		_hammerBTN.onRelease=Delegate.create(this, onHammerRelease);
		_shoeBTN.onRelease=Delegate.create(this, onShoeRelease);
		_headBTN.onRelease=Delegate.create(this, onHeadRelease);
	}
	
	private function onWhiskRelease():Void{
		_menMC.gotoAndPlay("被道具砸");
		_menMC.objNum	=	1;
	}
	
	private function onHammerRelease():Void{
		_menMC.gotoAndPlay("被道具砸");
		_menMC.objNum	=	2;
	}
	
	private function onShoeRelease():Void{
		_menMC.gotoAndPlay("被道具砸");
		_menMC.objNum	=	3;
	}
	private function onHeadRelease():Void{
		_menMC.gotoAndPlay("用头撞");
		//stopGame(true);
	}
	
	private function startCount():Void{
		clearInterval(_interID);
		_interID=setInterval(Delegate.create(this, count), 1000);
	}
	
	private function count():Void{
		_countTimer--;
		_timerTXT.text	=	("0"+_countTimer).substr(-2);
		if(_countTimer<=0){
			stopGame(false);
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 开始游戏
	 * 
	 */
	public function startGame():Void{
		_countTimer				=	20;
		startCount();
		_whiskBTN.enabled		=	
		_hammerBTN.enabled		=
		_shoeBTN.enabled		=	
		_headBTN.enabled		=	true;
	}
	
	/**
	 * 结束游戏
	 * @param isWin
	 */
	public function stopGame(isWin:Boolean):Void{
		clearInterval(_interID);
		_whiskBTN.enabled		=	
		_hammerBTN.enabled		=
		_shoeBTN.enabled		=	
		_headBTN.enabled		=	false;
		if(isWin){
			_target.gotoAndStop("成功");
		}else{
			_target.gotoAndStop("失败");
		}
	}

	/**
	 * 开始游戏
	 * 
	 */
	public function pauseGame(isPause:Boolean):Void{
		clearInterval(_interID);
		if(isPause){
			_whiskBTN.enabled		=	
			_hammerBTN.enabled		=
			_shoeBTN.enabled		=	
			_headBTN.enabled		=	false;
		}else{
			startCount();
			_whiskBTN.enabled		=	
			_hammerBTN.enabled		=
			_shoeBTN.enabled		=	
			_headBTN.enabled		=	true;
		}
	}
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "CatchHe 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	public static function getInstance(target:MovieClip):CatchHe{
		//if(singlone==null){
			singlone	=	new CatchHe(target);
		//}
		return singlone;
	}
}//end class
//This template is created by whohoo.

