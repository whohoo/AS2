//******************************************************************************
//	name:	Cloud 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Nov 01 11:03:03 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************




/**
 * 云层<p>
 * 云层可能会移动，有问题，有爬起来者。
 */
class com.wangfan.rover.Cloud extends MovieClip{
	private var _xSpeed:Number			=	null;
	private var _ySpeed:Number			=	null;
	
	private var _bound:Object			=	{xMin:-200, xMax:200, yMin:-100, yMax:100};
	/**云层中的爬起者.*/
	public  var climbMan_mc:MovieClip	=	null;
	/**云层中的龙币得动画.*/	
	public  var winCoin_mc:MovieClip	=	null;
	/**云层中的问号，如果有问题，就有可能会出现问题或其它事件.*/
	public  var questionSymbol_mc:MovieClip	=	null;
	/**是否显示问题*/
	public  var hasQuestion:Boolean	=	false;
	/**向下的重力值*/
	static public var gravity:Number	=	.9;
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Cloud.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	private function Cloud(){
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		climbMan_mc._visible		=	
		questionSymbol_mc._visible	=	false;
		climbMan_mc.gotoAndStop(_root.personInfo.roleNum+1);
	}
	
	private function moveX():Void{
		_x	+=	_xSpeed;
		if(_x>=_bound.xMax){
			_x	=	_bound.xMax;
			_xSpeed	*=	-1;
			dispatchEvent({type:"onChangeDirection", xSpeed:_xSpeed});
		}else if(_x<=_bound.xMin){
			_x	=	_bound.xMix;
			_xSpeed	*=	-1;
			dispatchEvent({type:"onChangeDirection", xSpeed:_xSpeed});
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	/**
	* 开始移动云层
	* @param xSpeed 移动的速度
	*/
	public function startMove(xSpeed:Number):Void{
		_xSpeed	=	xSpeed;
		onEnterFrame=render;
	}
	/**
	* 停止移动云层。
	*/
	public function stopMove():Void{
		onEnterFrame=null;
	}
	/**
	* 更新云层的移动。
	*/
	public function render():Void{
		if(_parent.isPause)	return;
		moveX();
		//moveY();
	}
	/**
	* 如果有问号出现的云层，把问号显示出来。
	*/
	public function showQuestionSymbol():Void{
		if(hasQuestion){
			questionSymbol_mc._visible	=	true;
		}
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
