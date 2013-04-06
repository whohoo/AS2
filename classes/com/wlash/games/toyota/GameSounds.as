//******************************************************************************
//	name:	GameSounds 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Jun 21 00:57:25 2006
//	description: 
//******************************************************************************

import com.idescn.sound.SoundBar;
import mx.utils.Delegate;
/**
 * control game sounds.<p></p>
 * 
 */
class com.wlash.games.toyota.GameSounds extends Object{
	private var _target:MovieClip			=	null;
	private var _introSound:SoundBar		=	null;//开场介绍音乐
	private var _introMC:MovieClip			=	null;
	private var _endSound:SoundBar			=	null;//结束成绩音乐
	private var _endMC:MovieClip			=	null;
	
	private var _egSound:SoundBar			=	null;//engine sound
	//private var _runSound:SoundBar			=	null;//running sound
	private var _bg0Sound:SoundBar			=	null;//background sound
	private var _bg1Sound:SoundBar			=	null;//background sound
	private var _bg2Sound:SoundBar			=	null;//background sound
	private var _bg0MC:MovieClip			=	null;
	private var _bg1MC:MovieClip			=	null;
	private var _bg2MC:MovieClip			=	null;
	
	
	private var _curSound:SoundBar			=	null;
	/*
	 * constrcution function
	 * @param target
	 */
	public function GameSounds(target:MovieClip){
		this._target	=	target;
		init();
	}
	
	//***************************[PRIVATE METHOD]*****************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		var target:MovieClip	=	_target;
		var depth:Number	=	target.getNextHighestDepth();
		//开场音乐
		var mc:MovieClip	=	target.createEmptyMovieClip("mcIntroSound", depth++);
		_introSound	=	new SoundBar(mc);
		mc.loadMovie("sound/intro.swf");
		_introMC	=	mc;
		//结束音乐
		var mc:MovieClip	=	target.createEmptyMovieClip("mcEndSound", depth++);
		_endSound	=	new SoundBar(mc);
		mc.loadMovie("sound/end.swf");
		_endMC	=	mc;

		//启动音乐
		mc		=	target.createEmptyMovieClip("mcEngineSound", depth++);
		_egSound	=	new SoundBar(mc);
		_egSound.loadSound("sound/start_running3.mp3", false);
		//游戏音乐
		for(var i:Number=0; i<3; i++){
			mc	=	target.createEmptyMovieClip("mcBG"+i+"sound", depth++);
			mc.loadMovie("sound/bg"+i+".swf");
			this["_bg"+i+"Sound"]	=	new SoundBar(mc);
			this["_bg"+i+"MC"]		=	mc;
		}
		
	}
	
	/*
	 * 因为游戏过后,会被跳到第二帧,所以要重新返回第一帧无声音的.
	 * 
	 */
	private function resetBGsound():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0; i<3; i++){
			mc	=	this["_bg"+i+"MC"];
			mc.gotoAndStop(1);
		}
	}
	//***************************[PUBLIC METHOD]******************************//
	/*
	 * intro music start playing.
	 * 
	 */
	public function introStart():Void{
		_introMC.gotoAndStop(2);
		_introSound.setVolume(0);
		_introSound.fadeIn(70, 15);
		_curSound	=	_introSound;
	}
	/*
	 * intro music stop playing.
	 * 
	 */
	public function introStop():Void{
		_introSound.fadeOut(0, 20);
		_introMC.gotoAndStop(1);
	}
	
	/*
	 * end music start playing.
	 * 
	 */
	public function endStart():Void{
		_endMC.gotoAndStop(2);
		_endSound.setVolume(0);
		_endSound.fadeIn(70, 15);
		_curSound	=	_endSound;
	}
	
	/*
	 * end music stop playing.
	 * 
	 */
	public function endStop():Void{
		_endSound.fadeOut(0, 20);
		_endMC.gotoAndStop(1);
	}
	
	/*
	 * engine start playing.
	 * 
	 */
	public function engineStart():Void{
		_egSound.start();
		_egSound.setVolume(100);
		_curSound	=	_egSound;
		resetBGsound();
	}
	
	/*
	 * background sound start,and the playing sound would fadeout.
	 * @param id
	 */
	public function bgStart(id:String):Void{
		var bgSound:SoundBar	=	this["_bg"+id+"Sound"];
		var bgMC:MovieClip		=	this["_bg"+id+"MC"];
		bgSound.setVolume(0);
		bgMC.gotoAndStop(2);
		bgSound.fadeIn(80);
		_curSound.fadeOut(0);
		_curSound	=	bgSound;
	}
	
	
	/*
	 * stop all playing sounds.
	 * 
	 */
	public function stopAllSound():Void{
		_curSound.fadeOut(0);
	}
	
	/*
	 * get all loading sound loading progress.
	 * @return progress
	 */
	public function getLoadProgress():Number{
		var BL:Number	=	_egSound.getBytesLoaded();
		var BT:Number	=	_egSound.getBytesTotal();
		//开场音乐
		var bgMC:MovieClip	=	_introMC;
		BL		+=	bgMC.getBytesLoaded();
		BT		+=	bgMC.getBytesTotal();
		//结束音乐
		bgMC	=	_endMC;
		BL		+=	bgMC.getBytesLoaded();
		BT		+=	bgMC.getBytesTotal();
		//游戏音乐
		for(var i:Number=0;i<3;i++){
			bgMC	=	this["_bg"+i+"MC"];
			BL		+=	bgMC.getBytesLoaded();
			BT		+=	bgMC.getBytesTotal();
		}
		return BL/BT;
	}
	
	/*
	 * get this class name.
	 * @return class name;
	 */
	public function toString():String{
		return "GameSounds 1.0";
	}
}