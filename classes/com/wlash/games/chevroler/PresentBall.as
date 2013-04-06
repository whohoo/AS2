//******************************************************************************
//	name:	PresentBall 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Aug 22 00:17:43 GMT+0800 2006
//	description: This file was created by "shotTennisBall.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import mx.transitions.Tween;

/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.games.chevroler.PresentBall extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _ballMC:MovieClip		=	null;
	private var _ballCopyMC:MovieClip	=	null;
	private var _bound:Object			=	null;
	private var _tw:Tween				=	null;
	private var _moveFuncs:Array		=	null;
	private var _timeX:Number			=	null;
	private var _timeY:Number			=	null;
	
	//private var _isStop:Boolean		=	false;
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(PresentBall.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new PresentBall(this);]
	 * @param target target a movie clip
	 */
	public function PresentBall(target:MovieClip){
		this._target	=	target;
		_ballMC			=	target.ball_mc;
		_bound			=	target.getBounds();
		_ballMC.swapDepths(100);
		_moveFuncs	=	[mx.transitions.easing.None.easeIn,
						mx.transitions.easing.None.easeInOut,
						mx.transitions.easing.None.easeNone,
						mx.transitions.easing.None.easeOut,
						mx.transitions.easing.Strong.easeInOut];
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_tw	=	new Tween(_ballMC, "", null, 0, 0, 1.5, true);
		_tw.stop();
		_tw.addListener(this);

		_target.onRelease=Delegate.create(this, onTargetRelease);
		_target.enabled	=	false;
	}
	
	private function onMotionStopped(tw:Tween):Void{
		if(!(_target instanceof MovieClip)){
			stopMoving();
		}
		
	}
	
	//repeat
	private function onMotionFinished(tw:Tween):Void{
		if(_target.enabled){
			tw.yoyo();
		}
	}
	
	private function onTargetRelease():Void{
		var tw:Tween	=	_tw;
		var pos:Number	=	tw.position;
		if(tw.prop=="_x"){
			_timeX	-=	getTimer();
			//_ballMC.duplicateMovieClip("mcBallCopyX", 10, 
			//					{_x:pos,
			//					_y:0
			//					});
			_target.enabled	=	false;
			tw.stop();
			dispatchEvent({type:"onReady", 
							percentX:_ballMC._x/(_target._width/2),
							percentY:_ballCopyMC._y/(_target._height/2),
							timeX:-_timeX,
							timeY:-_timeY});
		}else{
			_timeY	-=	getTimer();
			_ballCopyMC	=	_ballMC.duplicateMovieClip("mcBallCopyY", 20, 
								{_x:0,
								_y:pos
								});
			moveHorizontal();
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 开始水平移动
	 */
	public function moveHorizontal():Void{
		
		_tw.begin	=	_bound.xMin;
		_tw.finish	=	_bound.xMax;
		_tw.prop	=	"_x";
		_tw.func	=	_moveFuncs[random(4)];
		_ballMC._y	=	0;
		_tw.start();
		
		_timeX		=	getTimer();
	}
	
	/**
	 * 开始垂直移动
	 */
	public function moveVertical():Void{
		
		_tw.begin	=	_bound.yMin;
		_tw.finish	=	_bound.yMax;
		_tw.prop	=	"_y";
		_tw.func	=	_moveFuncs[random(4)];
		_ballMC._x	=	0;
		_tw.start();
		
		_timeY		=	getTimer();
	}
	
	
	public function startMoving():Void{
		_ballCopyMC.removeMovieClip();
		_target.enabled	=	true;
		moveVertical();
	}
	
	public function stopMoving():Void{
		
		_ballCopyMC.removeMovieClip();
		_target.enabled	=	false;
	}
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "PresentBall 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
