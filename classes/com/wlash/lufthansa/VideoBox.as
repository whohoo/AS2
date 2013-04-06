//******************************************************************************
//	name:	VideoBox 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Oct 10 11:44:53 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "scene2_1.fla" file.
//		
//******************************************************************************


import com.wlash.lufthansa.ContentLoader;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.lufthansa.VideoBox extends MovieClip{
	
	private var b_video:Video;
	private var state:String;
	private var flvUrl:String;
	
	[Inspectable(defaultValue=6, verbose=0, type=Number)]
	public var lastFrame:Number;
	public var video_ns:NetStream;
	[Inspectable(defaultValue="", verbose=0, type=Array)]
	public var cuePoints:Array;
	public var curCue:Number;
	public var mix_sound:Sound;
	
	
	public static var curVideo:VideoBox;
	public static var interID:Number;
	public static var interID2:Number;//检查是否连接了server
	public static var connect_nc:NetConnection;
	public static var serverName:String	=	"localhost/luthansa_virtual_tour_stream";
	private static var isInit:Boolean	=	initCon();
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(VideoBox.prototype);
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function VideoBox(){
		clearInterval(interID2);
		interID2=setInterval(this, "checkIsConnect", 30);
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function checkIsConnect():Void{
		if(connect_nc.isConnected){
			clearInterval(interID2);
			initNetStream();
		}else{
			
		}
	}
	private function initNetStream():Void{
		var that:VideoBox	=	this;

		video_ns = new NetStream(connect_nc);
		b_video.attachVideo(video_ns);
		
		video_ns.onMetaData = function(infoObject:Object) {
			this["duration"]	=	infoObject["duration"];
			//this.setBufferTime(Math.min(5, 
					//Math.max(0.2, this["duration"]/4)));
			this.setBufferTime(this["duration"]/2);
			//trace("duration: "+this["duration"]+", time: "+this.time)
			if(that._parent._currentframe==that.lastFrame){//当加载完成时就开始播放
				that.onPlay("onMetaData");
			}else{//等到最后再播放,很快的.
				this.pause(true);
				//connect_nc.call("logInfo", null, "onMetaData|video_ns.pause(true)|"+that.flvUrl);
				//_root.pause_mc.gotoAndStop(2);
				//trace("bufferLength: "+this["bufferLength"])
				//this.seek(0.04);
			}
			
		}
		
		video_ns.onStatus = function(info:Object){
			//trace([that, that.flvUrl, info.code])
			switch(info.code){
				case "NetStream.Buffer.Empty":
					//_root.preLoader_mc.pausePreLoad();
					//_root.buffering_mc.show();
					break;
				case "NetStream.Buffer.Full":
					//_root.preLoader_mc.startPreLoad();
					//_root.buffering_mc.hide();
					break;
				case "NetStream.Buffer.Flush":
					//_root.buffering_mc.hide();
					break;
				case "NetStream.Play.Start":
					//_root.buffering_mc.hide();
					break;
				case "NetStream.Play.Stop":
					//if(Math.round(this.time)==Math.round(this.duration)){
						//_root.arrowRight_mc.onRelease();
						
						//that.dispatchEvent({type:"onStop"});
						//that.onVideoStop();
					//}
					break;
				case "NetStream.Play.StreamNotFound":
					//that.loadFLV(that.flvUrl);
					break;
				case "NetStream.Seek.InvalidTime":
					
					break;
				case "NetStream.Seek.Notify":
					//_root.buffering_mc.hide();
					break;
			};
		  
		}
		video_ns.onPlayStatus = function(infoObject:Object){
			if(infoObject.code=="NetStream.Play.Complete"){
				that.dispatchEvent({type:"onStop"});
				that.onVideoStop();
				//that.video_ns.close();
			}
			
		};
		//onEnterFrame=_onEnterFrame;
		/*_root.subtitle_mc	=	{};
		_root.subtitle_mc.switchWord=function(str){
			trace("time: "+curVideo.video_ns.time+" | word: "+str);
		}
		_root.onMouseDown=function(){
			trace("**time: "+curVideo.video_ns.time);
		}*/
		
	}
	private function _onEnterFrame(){
		
		if(video_ns.time>=cuePoints[curCue]){
			dispatchEvent({type:"onCue", cue:curCue});
			curCue++;
			//trace(video_ns.time)
			if(curCue>=cuePoints.length){
				delete onEnterFrame;
			}
		}
	}
	private function onPlay(p){//trace([this, p])
		if(state=="play")	return;
		state	=	"play";//trace([this, state])
		this.attachAudio(video_ns);
		var sound:Sound	=	new Sound(this);
		_root.musicBox_mc.addSound(sound, this);
		if(cuePoints.length==0){
			curCue	=	-1;
			delete onEnterFrame;
		}else{
			curCue	=	0;
			onEnterFrame=_onEnterFrame;
		}
		if(curVideo!=this){
			curVideo.stopVideo();
			curVideo	=	this;
		}
		_visible	=	true;
		clearInterval(interID);
		interID=setInterval(this, "checkBuffering", 30);
	}
	
	private function checkBuffering():Void{
		//trace("videoName: "+this._name+", buffer: "+video_ns.bufferLength+", "+video_ns.bufferTime);
		if(video_ns.bufferLength==0){
			if(video_ns.bufferTime==0.1){
				//trace("*******PLAY AGAIN: "+flvUrl);
				//video_ns.pause(false);
				//video_ns.play(flvUrl);
			}
		}
		if(video_ns.bufferLength<=0.5){
			//_root.preLoader_mc.pausePreLoad();
			//video_ns.pause(true);
			_root.buffering_mc.show();
		}else if(video_ns.bufferLength<video_ns.bufferTime/2){
			//_root.preLoader_mc.pausePreLoad();
			//video_ns.pause(false);
			_root.buffering_mc.hide();
		}else {
			//_root.preLoader_mc.startPreLoad();
			//video_ns.pause(false);
			_root.buffering_mc.hide();
		}
	}
	private function onVideoStop(){
		clearInterval(interID);
		_root.buffering_mc.hide();
		//video_ns.close();
		//_root.preLoader_mc.startPreLoad();
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function loadFLV(flvUrl2:String){
		if(this._parent._name=="preLoaderMC"){
			//this is perloader, so ...
			return;
		}
		var iDelay:Number	=	0;
		this.onEnterFrame=function(){
			//trace([getBytesLoaded(),getBytesTotal(), connect_nc.isConnected, video_ns])
			if(iDelay++<2)	return;
			if(getBytesLoaded()<getBytesTotal())	return;
			video_ns.play(flvUrl, 0.04);//http://203.166.160.229/
			onVideoStop();
			delete this.onEnterFrame;
		}
		state	=	"stop";//trace([this, state])
		var flvUrlArr:Array	=	flvUrl2.split(".");
		flvUrlArr.pop();
		this.flvUrl	=	flvUrlArr.join(".");
		curVideo.mix_sound.stop();//trace([curVideo, curVideo.mix_sound])
	}
	//当播放到某一帧时,开始播放.
	public function onStartPlay():Boolean{
		//trace([ContentLoader.curLoadingMC, _parent])
		if(ContentLoader.curLoadingMC instanceof MovieClip){
			if(ContentLoader.curLoadingMC!=_parent){
				video_ns.pause(true);//第一场景时，中断
				//connect_nc.call("logInfo", null, "onStartPlay|第一场景时，中断|video_ns.pause(false)");
				return	false;
			}
		}
		
		if(video_ns["duration"]==null)	return	false;//ought to add other videoBox
		video_ns.pause(false);//trace("onStartPlay: "+this._name);
		//connect_nc.call("logInfo", null, "onStartPlay|video_ns.pause(false)");
		onPlay("onStartPlay");
		return true;
	}
	
	public function stopVideo(){
		video_ns.pause(true);
		onVideoStop();//trace(["stopVideo ",this, mix_sound])
		
		//trace([this.flvUrl, mix_sound])
		//video_ns.close();
	}
	
	public function getVideoTime(){
		return video_ns.time;
	}

	public function mixSound(url:String, isLoop:Boolean, isSynchro:Boolean){
		if(mix_sound==null){
			mix_sound	=	new Sound(this);
			_root.musicBox_mc.addSound(mix_sound, this);
		}
		mix_sound.loadSound(url, true);
		if(isLoop==true){
			mix_sound.onSoundComplete=function(){
				this.start();
			}
		}else{
			mix_sound.onSoundComplete=null;
		}
	}
	//***********************[STATIC METHOD]**********************************//
	public static function initCon():Boolean{
		if(isInit==true)	return	true;
		connect_nc	=	new NetConnection();
		connect_nc.connect("rtmp://"+serverName);
		connect_nc["retryTimes"]	=	0;
		connect_nc["retryTotalTimes"]	=	4;
		connect_nc.onStatus=function(infoObject:Object){
			//for (var prop in infoObject){trace("connect_nc.onStatus|"+prop+": "+infoObject[prop]);}
			if(infoObject.code=="NetConnection.Connect.Success"){
				
			}else{
				if(this["retryTimes"]<this["retryTotalTimes"]){//以两种方式各试两次
					this.connect("rtmp"+(this["retryTimes"]%2==0 ? "t" : "")+
								"://"+serverName);
					this["retryTimes"]++;
				}
			}
		}
		return true;
	}
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
