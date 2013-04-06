//******************************************************************************
//	name:	BeadOfNecklace 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Oct 20 11:26:38 2006
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;

/**
 * 把九个珠子填上不同的颜色<p/>
 * 参照例子与说明填上颜色，正确方可以完成游戏。
 */
class com.wangfan.rover.BeadOfNecklace extends Object{
	static public var RED:Number		=	2;
	static public var GREEN:Number		=	3;
	static public var BLUE:Number		=	4;
	
	private var _target:MovieClip		=	null;
	private var _beadBox:Array			=	[];
	
	
	private var _winBeadBox:Array		=	[BLUE,GREEN,RED,RED,BLUE,
												BLUE,RED,GREEN,GREEN];
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new GoRiver(this);]
	 * @param target target a movie clip
	 */
	public function BeadOfNecklace(target:MovieClip){
		this._target	=	target;
		//target._y	+=	100;//debug....
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<9;i++){
			mc	=	_target["c"+i];
			initBeadEvent(mc);
			_beadBox.push(mc);
			mc.stop();
		}
	}
	
	private function initBeadEvent(mc:MovieClip):Void{
		mc.onRelease=Delegate.create(mc, onBeadRelease);
		mc.enabled		=	false;
		mc["pClass"]	=	this;
	}
	
	private function onBeadRelease():Void{
		if(this["_currentframe"]==BLUE){//last frame
			this["gotoAndStop"](RED);
		}else{
			this["nextFrame"]();
		}
		this["pClass"].checkSort();
	}
	
	private function checkSort():Boolean{
		var mc:MovieClip		=	null;
		var curFrame:Number	=	null;
		var ret:Boolean		=	false;
		for(var i:Number=0;i<9;i++){
			mc	=	_beadBox[i];
			curFrame	=	mc._currentframe;
			switch(curFrame){
				case 1://blank
					
					break;
				case RED://red
					
					break;
				case GREEN://green
					
					break;
				case BLUE://blue
					ret	=	checkSortBlue(mc);
					break;
				
			}
			if(ret){
				stopGame();
				break;
			}
		}
		
		return ret;
	}
	
	private function checkSortBlue(mc):Boolean{
		if(getNearFrame(mc, 1)!=GREEN){
			return false;
		}
		var ret:Boolean	=	true;
		for(var i:Number=2;i<9;i++){
			if(getNearFrame(mc, i)!=_winBeadBox[i]){
				ret	=	false;
				break;
			}
		}
		return ret;
	}
	
	private function getNearFrame(mc:MovieClip, num:Number):Number{
		var curNum:Number	=	Number(mc._name.substr(1));
		var nearMC:MovieClip	=	_beadBox[(curNum+num+9)%9];
		return nearMC._currentframe;
	}
	
	private function beadEnable(enabled:Boolean):Void{
		for(var i:Number=0;i<9;i++){
			_beadBox[i].enabled	=	enabled;
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 游戏开始
	*/
	public function startGame():Void{
		beadEnable(true);
	}
	/**
	* 游戏结束
	*/
	public function stopGame():Void{
		beadEnable(false);
		_target._parent.play();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "BeadOfNecklace 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
