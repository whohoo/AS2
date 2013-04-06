//******************************************************************************
//	name:	MusicBox 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 27 16:13:41 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************



/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.lufthansa.MusicBox extends MovieClip{
	
	private var soundBox:Array;
	private var subtitleIconMC:MovieClip;
	private var bg_sound:Sound;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function MusicBox(){
		soundBox	=	[];
		subtitleIconMC	=	_parent.subtitleIcon_mc
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		onReleaseOutside=onRollOut;
		/*bg_sound	=	new Sound(this);
		bg_sound.loadSound("flv/18 MUSIC.mp3", true);
		
		bg_sound.onSoundComplete=function(){
			this.start(0);
		}
		addSound(bg_sound, this);
		bg_sound.setVolume(0);
		fadeIn(soundBox[0], 5);*/
	}
	
	private function onRelease(){
		if(_currentframe==1){//开启状态
			stopAllSound();
			if(subtitleIconMC._currentframe==1){//强制把字幕打开
				subtitleIconMC.onRelease();
			}
		}else{//关闭状态
			startAllSound();
		}
		this.play();
	}
	private function onRollOver(){
		
	}
	private function onRollOut(){
		
	}
	private function startAllSound(){
		var len:Number	=	soundBox.length;
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	soundBox[i];
			if(obj.mc instanceof MovieClip){
				fadeIn(obj, 5);
			}else{
				soundBox.splice(i, 1);//delete.
			}
		}
	}
	private function stopAllSound(){
		var len:Number	=	soundBox.length;
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	soundBox[i];
			if(obj.mc instanceof MovieClip){
				fadeOut(obj, 5);
			}else{
				fadeOut(obj, 10);
				soundBox.splice(i, 1);//delete.
			}
		}
	}
	
	private function fadeIn(obj:Object, num:Number){
		clearInterval(obj.interID);
		obj.interID=setInterval(this, "_fadeIn", 30, obj, num);
	}
	private function _fadeIn(obj:Object, num:Number){
		var sound:Sound	=	obj.sound;
		var vol:Number	=	sound.getVolume();
		if(vol>=100){
			clearInterval(obj.interID);
			return;
		}
		if(obj.mc==this){
			sound.setVolume((vol+num)*0.95);
		}else{
			sound.setVolume(vol+num);
		}
	}
	
	private function fadeOut(obj:Object, num:Number){
		clearInterval(obj.interID);
		obj.interID=setInterval(this, "_fadeOut", 30, obj, num);
	}
	private function _fadeOut(obj:Object, num:Number){
		var sound:Sound	=	obj.sound;
		var vol:Number	=	sound.getVolume();
		if(vol<=0){
			clearInterval(obj.interID);
			return;
		}
		if(obj.mc==this){
			sound.setVolume((vol-num)*0.95);
		}else{
			sound.setVolume(vol-num);
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function addSound(sound:Sound, timeLine:MovieClip):Void{
		soundBox.push({sound:sound, mc:timeLine});
		if(_currentframe==2){//关闭状态
			this.onEnterFrame=function(){
				sound.setVolume(0);trace(sound.getVolume());
				if(sound.getVolume()==0){
					delete this.onEnterFrame;
				}
			}
		}
		//如果声音播放完,且mc已经不存在了,则删除掉
	}
	
	
	
	//***********************[STATIC METHOD]**********************************//

	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
