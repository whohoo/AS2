//******************************************************************************
//	name:	MenuBG 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 05 12:10:34 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


import mx.transitions.Tween;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.lufthansa.MenuBG extends MovieClip{
	private var width2:Number;
	private var height2:Number;
	private var xreg:Number;
	private var yreg:Number;
	private var _xscale2:Number;
	private var _yscale2:Number;
	private var _x2:Number;
	private var _y2:Number;
	private var _tw:Tween;
	private var _onChanging:Function;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function MenuBG(){
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		width2			=	_width/2;
		height2			=	_height/2;
		this.yreg		=	height2;
		this._yscale2	=	0;
		_tw	=	new Tween(this, "_yscale2",
						mx.transitions.easing.Strong.easeOut,
						0, 0, 1, true);
		_tw.stop();
		_tw.addListener(this);
	}
	
	private function onMotionChanged(tw:Tween):Void{
		_alpha	=	tw.position*3/10+70;
		_onChanging(tw);
	}
	private function onMotionFinished(tw:Tween):Void{
		if(tw.finish==0){
			_y2	=	height2;
			_visible	=	false;
		}
		//_onFinished(tw);
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function show(){
		_visible	=	true;
		//_y2			=	height2;
		//_yscale2	=	0;
		//yreg		=	height2;
		_tw.func	=	mx.transitions.easing.Strong.easeOut;
		_tw.duration	=	((100-_yscale2)*0.01);
		_tw.begin	=	_yscale2;
		_tw.finish	=	100;
		_tw.start();
		//_onChanging	=	onChanging;
	}
	
	public function hide(){
		//_yscale2	=	100;
		//yreg		=	-height2;
		_tw.func	=	mx.transitions.easing.Strong.easeOut;
		_tw.duration	=	(_yscale2*0.01);
		_tw.begin	=	_yscale2;
		_tw.finish	=	0;
		_tw.start();
		//_onChanging	=	onChanging;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
