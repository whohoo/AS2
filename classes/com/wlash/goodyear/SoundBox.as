//******************************************************************************
//	name:	SoundBox 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Jul 26 17:17:54 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "goodyear animation.fla" file.
//		
//******************************************************************************



/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.goodyear.SoundBox extends MovieClip{
	
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	private static var soundBox:Object	=	{};
	private static var curSound:Sound	=	null;
	private static var iCount:Number	=	null;
	public  static var mp3Path:String	=	null;
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function SoundBox(){
		
		//init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
	}
	
	private function getSound(id:String):Object{
		var obj:Object	=	null;
		for(var prop:String in soundBox){
			if(prop==id){
				obj	=	soundBox[prop];
				break;
			}
		}
		return	obj;
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function show(mp3Url:String, onComplete:Function){
		
		var obj:Object	=	getSound(mp3Url);
		var sound:Sound;
		if(obj!=null){
			sound	=	obj.sound;
			if(obj.isLoaded){
				sound.start();
			}else{
				sound.loadSound(mp3Path+mp3Url+".mp3", true);//stream sound
			}
			//sound.setVolume(5);
			curSound.stop();
			curSound	=	sound;
			var timeline:SoundBox	=	this;
			sound.onSoundComplete=function(){
				onComplete(timeline);
			}
		}else{
			trace("no Found the mp3: "+mp3Url);
		}
	}
	
	public function hide(mp3Url:String){
		var obj:Object;
		if(mp3Url!=null){
			obj	=	getSound(mp3Url);
			obj.sound.stop();
		}else{
			curSound.stop();
			curSound	=	null;
		}
	}
	
	public function addSound(mp3Url:String){
		var obj:Object	=	getSound(mp3Url);
		
		if(obj==null){
			if(soundBox.__index==null){
				soundBox.__index	=	[];
			}
			var mc:MovieClip	=	createEmptyMovieClip("mc_"+mp3Url, getNextHighestDepth());
			var sound:Sound		=	new Sound(mc);
			obj				=	
			soundBox[mp3Url]	=	{mc:mc, sound:sound};
			soundBox.__index.push(mp3Url);
		}
		obj.isLoaded	=	false;
	}
	
	public function startLoading(){
		iCount	=	0;
		loadNext()
	}
	
	public function loadNext(){
		var sound:Sound;
		var obj:Object;
		var arr:Array	=	soundBox.__index;
		if(iCount==arr.length)	return;
		obj	=	getSound(arr[iCount]);
		sound	=	obj.sound;
		if(obj.isLoaded){
			iCount++;
			loadNext();
		}
		loadSound(arr[iCount],
				function(mc:SoundBox){//when loaded
					obj.isLoaded	=	true;
					sound.stop();
					//sound.start();
					iCount++;
					mc.loadNext();
				});
	}
	
	public function loadSound(id:String, onLoaded:Function):Sound{
		var obj:Object	=	getSound(id);
		if(obj==null)	return	null;
		var sound:Sound	=	null;
		var timeline:SoundBox	=	this;
		if(!obj.isLoaded){
			sound	=	obj.sound;
			sound.loadSound(mp3Path+id+".mp3", false);
			sound.onLoad=function(){
				obj.isLoaded	=	true;
				onLoaded(timeline);
			}
			//this.onEnterFrame=function(){
				//trace("sound.BytesLoaded: "+sound.getBytesLoaded()+
						//", BytesTotal()"+sound.getBytesTotal());
			//}
		}else{
			onLoaded(timeline);
		}
		return	sound;
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
