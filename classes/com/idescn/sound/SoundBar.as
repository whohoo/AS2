//******************************************************************************
//	name:	SoundBar 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Mar 22 14:53:58 GMT+0800 2006
//	description: 扩展sound类,可定义拉动条,当是数据流时,音量慢慢变大.
//******************************************************************************

import com.idescn.utils.scroll.ScrollBar;


/**
 * extend Sound,
 * <br></br>add tow method of  fade in and fade out voluem <P></P>
 * if the construct function parameter are scroll bar, you could control the 
 * volume by scroll bar,
 * if loadSound("youAreBeautiful.mp3", true), the sound would fade in to 80.<P></P>
 * Note: when fadeOut(0), the sound would stop;<P></P>
 * <b>EventDispatcher</b>
 * <ul>
 * <li>fadeIn({position}): </li>
 * <li>fadeOut({position}): </li>
 * </ul>
 */
class com.idescn.sound.SoundBar extends Sound{
	
	private var _scrollBar:ScrollBar	=	null;
	private var _fadeID:Number			=	null;
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(SoundBar.prototype);
	
	//******************[READ|WIDTH]******************//
	
	
	/**
	* construct function<br></br>
	* Creates a new Sound object for a specified movie clip. that movie clip is 
	* a scroll bar.<br></br>
	* If you do not specify a target instance, the Sound object controls all of 
	* the sounds in the movie.
	* @param  target a scroll bar.
	* 
	*/
	public function SoundBar(target:MovieClip){
		super(target);
		if(target.bar_mc instanceof MovieClip){
			if(target.background_mc instanceof MovieClip){
				_scrollBar	=	new ScrollBar(target);
				init();
			}
		}
	}
	
	//******************[PRIVATE METHOD]******************//
	/**
	* Initializtion this class
	* 
	*/
	private function init():Void{
		_scrollBar.render();
		_scrollBar.addEventListener("onScroll", this);
	}
	
	/**
	 * 当拉动条被拉动时.
	 * @param eventObj  
	 */
	private function onScroll(eventObj:Object):Void{
		stopFade();
		setVolume(Math.round(eventObj.percent*100));
	}
	
	/**
	 * stop the fade interval
	 */
	private function stopFade():Void{
		if(_fadeID==null)	return;
		clearInterval(_fadeID);
		_fadeID	=	null;
	}
	
	/**
	 * fade in or out volume
	 * 
	 * 
	 * @param   volume 
	 * @param   dir    
	 */
	private function _fade(volume:Number, dir:Number):Void{
		var curVolume:Number	=	getVolume();
		if(volume*dir<=curVolume*dir){
			stopFade();
			dispatchEvent({type:dir==1 ? "onFadeIn" : "onFadeOut", 
													position:position});
			if(volume==0){
				this.stop();
			}
			return;
		}
		setVolume(curVolume+1*dir);
		render();
	}
	
	/**
	 * 根据音量大小定义条的位置
	 * 
	 */
	private function render():Void{
		if(_scrollBar==null)	return;
		var percent:Number	=	getVolume()/100;
		_scrollBar.render(percent);
	}
	
	//******************[PUBLIC METHOD]******************//
	/**
	* fade in the volume.
	* @param volume fade to volume, defalut value is 80
	* @param step one millisecond add one volmue, default are 30.
	*/
	public function fadeIn(volume:Number,step:Number):Void{
		stopFade();
		render();
		// default value 
		volume	=	volume==null ? 80 : volume;
		step	=	step==null ? 30 : step;// default value 

		_fadeID	=	setInterval(this, "_fade", step, volume, 1);
	}
	
	/**
	* fade out the volume.
	* @param volume fade to volume, defalut value is 0
	* @param step one millisecond add one volmue, default are 30.
	*/
	public function fadeOut(volume:Number,step:Number):Void{
		stopFade();
		render();
		volume	=	volume==null ? 0 : volume;// default value 
		step	=	step==null ? 30 : step;// default value 

		_fadeID	=	setInterval(this, "_fade", step, volume, -1);
	}
	
	
	
	/**
	 * Loads an MP3 file into a Sound object. You can use the isStreaming 
	 * parameter to indicate whether the sound is an event or a streaming sound. <p></p>
	 * Event sounds are completely loaded before they play. They are managed by 
	 * the ActionScript Sound class and respond to all methods and properties of
	 * this class.<p></p>
	 * Streaming sounds play while they are downloading. Playback 
	 * begins when sufficient data has been received to start the decompressor. 
	 * All MP3s (event or streaming) loaded with this method are saved in 
	 * the browser's file cache on the user's system.<p></p>
	 * When using this method, consider the Flash Player security model.

	 * @param   url         The location on a server of an MP3 sound file.
	 * @param   isStreaming A Boolean value that indicates whether the sound is 
	 * 		a streaming sound (true) or an event sound (false).<br></br>
	 * 		if true, the volume would be fadeIn by default value.
	 */
	public function loadSound(url:String, isStreaming:Boolean):Void{
		super.loadSound(url, isStreaming);
		if(isStreaming==true){
			setVolume(0);
			fadeIn(80, 30);
		}
	}
	
	/**
	* get position of this sound played and the duration
	* @return positon
	*/
	public function toString():String{
		return this.position+"/"+this.duration;
	}
}

	/*
	 * Invoked automatically when a sound finishes playing. You can use this 
	 * handler to trigger events in a SWF file when a sound finishes playing. <p></p>
	 * You must create a function that executes when this handler is invoked. 
	 * You can use either an anonymous function or a named function.
	 
	public function onSoundComplete ():Void{
		start();
	}*/
	/*
	 * Sets the volume for the Sound object.
	 * <b>Over-write</b>
	 * @param   volume A number from 0 to 100 representing a volume level. 
	 * 100 is full volume and 0 is no volume. The default setting is 100.
	 
	public function setVolume(volume:Number):Void{
		super.setVolume(volume);trace(volume)
		if(volume==0){
			volumeOff	=	true;
		}else{
			volumeOff	=	false;
		}
	}
	*/