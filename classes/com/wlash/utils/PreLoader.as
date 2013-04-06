//******************************************************************************
//	name:	PreLoader 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 06 18:22:25 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "PreLoader.fla" file.
//		
//******************************************************************************


[IconFile("PreLoader.png")]
/**
 * preload mp3, flv, jpg, png.<p></p>
 * 
 */
class com.wlash.utils.PreLoader extends MovieClip{
	[Inspectable(defaultValue="", verbose=0, type=Array)]
	private var loaderName:Array;
	[Inspectable(defaultValue=3, verbose=0, type=Number)]
	public  var ignoreTimes:Number	=	3;
	[Inspectable(defaultValue=2, verbose=0, type=Number)]
	public  var tryTimes:Number	=	2;
	
	private var loaderBox:Array;
	private var isLoadAll:Boolean;
	private var preLoaderMC:MovieClip;
	private var loader_mcl:MovieClipLoader;
	private var curLoader:Object;
	private var isLoading:Boolean	=	false;
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(PreLoader.prototype);
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new PreLoader();]
	 */
	public function PreLoader(){
		createEmptyMovieClip("preLoaderMC", 10);
		loader_mcl	=	new MovieClipLoader();
		loader_mcl.addListener(this);
		init();
		var mc:MovieClip	=	this["asset"];
		mc.swapDepths(1990);
		mc.removeMovieClip();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		loaderBox	=	[];
		var len:Number	=	loaderName.length;
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	loaderName[i];
			loaderBox.push({isLoaded:false, url:obj, tryTimes:0});
		}
		isLoadAll	=	false;
	}
	private function getCurLoadNext():Object{
		if(isLoadAll)	return null;
		var len:Number	=	loaderBox.length;
		var obj:Object;
		var nextIndex:Number	=	getUrlIndex(curLoader.url);
		
		for(var i:Number=nextIndex+1;i<len;i++){
			obj	=	loaderBox[i];
			if(obj.isLoaded){
				continue;
			}
			return	obj;
		}
		isLoadAll	=	true;
		return null;
	}
	private function getNextPreLoader():Object{
		if(isLoadAll)	return null;
		var len:Number	=	loaderBox.length;
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	loaderBox[i];
			if(obj.isLoaded || obj.tryTimes>ignoreTimes){
				continue;
			}
			return	obj;
		}
		isLoadAll	=	true;
		return null;
	}
	private function getUrlIndex(url:String):Number{
		var len:Number	=	loaderBox.length;
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	loaderBox[i];
			if(obj.url==url){
				return i;
			}
		}
		return -1;
	}
	private function startPreLoadNext():Void{
		var obj:Object	=	
		curLoader		=	getCurLoadNext();
		//trace("startPreLoadNext: "+obj.url)
		if(isLoadAll)	return;
		loader_mcl.loadClip(obj.url, preLoaderMC);
	}
	//***MovieClipLoader Events***\\
	private function onLoadStart(mc:MovieClip):Void{
		preLoaderMC._visible	=	false;
	}
	private function onLoadProgress(mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void{
		var percent:Number	=	Math.round(loadedBytes/totalBytes*100);
		//trace(percent)
		//_parent.loading_txt.text	=	percent+"%";
		dispatchEvent({type:"onLoadProgress", percent:percent, 
					loadedBytes:loadedBytes, totalBytes:totalBytes, url:curLoader.url})
	}
	private function onLoadComplete(mc:MovieClip):Void{
		curLoader.isLoaded	=	true;
	}
	private function onLoadInit(mc:MovieClip):Void{
		startPreLoad2();
	}
	private function onLoadError(mc:MovieClip, errorCode:String):Void{
		switch(errorCode){
			case "URLNotFound":
				break;
			case "LoadNeverCompleted":
				break;
		}
		//trace("MovieClipLoader errorCode: "+errorCode);
		//curLoader.tryTimes++;
		if(++curLoader.tryTimes>tryTimes){
			startPreLoadNext();//不要再努力尝试去下载
		}else{
			startPreLoad2();
		}
		
	}
	
	//***MovieClipLoader Events END***\\
	public function startPreLoad2():Void{
		if(isLoadAll)	return;
		var obj:Object	=	
		curLoader		=	getNextPreLoader();
		if(isLoadAll)	return;
		loader_mcl.loadClip(obj.url, preLoaderMC);
		isLoading	=	true;
		//trace("startPreLoad url: "+obj.url+", "+loaderBox.length);
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * start auto preload
	 */
	public function startPreLoad():Void{
		if(isLoading)	return;
		startPreLoad2();
		
	}
	/**
	 * pause preload
	 * 
	 */
	public function pausePreLoad():Void{
		if(!isLoading)	return;
		loader_mcl.unloadClip(preLoaderMC);
		isLoading	=	false;
	}
	/**
	 * add url at 
	 * 
	 * @param   url      
	 * @param   posIndex 
	 */
	public function addUrlAt(url:String, posIndex:Number):Void{
		var index:Number	=	getUrlIndex(url);
		var obj:Object	=	{isLoaded:false, url:url, tryTimes:0};
		if(index!=-1){
			obj	=	loaderBox[index];
			loaderBox.splice(index, 1);//delete, and put it at index.
		}
		loaderBox.splice(posIndex, 0, obj);
		isLoadAll	=	isLoadAll && obj.isLoaded;
	}
	/**
	 * add url
	 * 
	 * @param   url 
	 */
	public function addUrl(url:String):Void{
		var index:Number	=	getUrlIndex(url);
		if(index!=-1){
			loaderBox.splice(index, 1);//delete, and put it in last.
		}
		loaderBox.push({isLoaded:false, url:url, tryTimes:0});
		isLoadAll	=	false;
	}
	
	/**
	 * get loader error .
	 * @return {isLoaded, url, tryTimes}
	 */
	public function getLoadError():Array{
		var retArr:Array;
		var len:Number	=	loaderBox.length;
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	loaderBox[i];
			if(!obj.isLoaded){
				if(obj.tryTimes>0){
					retArr.push(obj);
				}
			}
		}
		return retArr;
	}
	/**
	 * get loaded error and total of load content
	 * 
	 * @return  {loaded, error ,total}
	 */
	public function getState():Object{
		var len:Number	=	loaderBox.length;
		var retObj:Object	=	{loaded:0, error:0, total:len};
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			obj	=	loaderBox[i];
			if(obj.isLoaded){
				retObj.loaded++;
			}else if(obj.tryTimes>0){
				retObj.error++;
			}
		}
		return retObj;
	}
	/**
	 * get all loadedBytes and all totalBytes
	 * 
	 * @return  {loadedBytes, totalBytes}
	 */
	public function getBytes():Object{
		var len:Number	=	loaderBox.length;
		var retObj:Object	=	{loadedBytes:0, totalBytes:0};
		var obj:Object;
		for(var i:Number=0;i<len;i++){
			
		}
		return retObj;
	}
	
	public function traceTotalBytes():Void{
		var len:Number	=	loaderBox.length;
		var obj:Object;
		var mcTemp:MovieClip	=	createEmptyMovieClip("tempMC", 99);
		var mc0:MovieClip;
		var mc1:MovieClip;
		var BT:Number	=	0;
		var depth	=	0;
		for(var i:Number=0;i<len;i++){
			obj	=	loaderBox[i];
			mc0	=	mcTemp.createEmptyMovieClip("mc"+depth, depth);
			mc0.index	=	i;
			mc1	=	mc0.createEmptyMovieClip("mc0", 0);
			mc1.loadMovie(obj.url);
			mc0.onEnterFrame=function(){
				var bytes:Number	=	this.mc0.getBytesTotal();
				if(bytes>0){
					BT	+=	bytes;
					delete this.onEnterFrame;
					this.mc0.unloadMovie();
					this.removeMovieClip();
					trace("i: "+i+", totalBytes: "+BT);
				}else if(bytes==-1){
					trace(loaderBox[this.index]);
				}
			}
			depth++;
		}
		//return BT;
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
