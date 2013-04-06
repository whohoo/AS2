//******************************************************************************
//	name:	ContentLoader 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 05 16:41:24 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import mx.transitions.Tween;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.lufthansa.ContentLoader extends MovieClip{
	private var curLoaderMC:MovieClip;
	private var preLoaderMC:MovieClip;
	private var mask_mc:MovieClip;
	private var refMaskMC:MovieClip;//_parent.changeScene.move_mc
	private var loader_mcl:MovieClipLoader;
	private var isIntro:Boolean;
	private var _tw:Tween;
	private var iCount:Number;
	//private var bricks_mc:MovieClip;
	public static var curLoadingMC:MovieClip;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function ContentLoader(){
		refMaskMC	=	_parent.changeScene_mc.move_mc;
		refMaskMC._visible	=	
		mask_mc._visible	=	false;
		_tw	=	new Tween(this, "iCount",
						mx.transitions.easing.Strong.easeOut,
						0, 100, 2, true);
		_tw.stop();
		_tw.addListener(this);
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		preLoaderMC	=	createEmptyMovieClip("loader0_mc", 0);
		curLoaderMC	=	createEmptyMovieClip("loader1_mc", 2);
		loader_mcl	=	new MovieClipLoader();
		loader_mcl.addListener(this);
		//this.onEnterFrame=function(){
			//bricks_mc.addEventListener("onFinishFadeOut", this);
			//delete this.onEnterFrame;
		//}
		isIntro		=	true;
	}
	
	private function getRefMaskPos():Object{
		var pos:Object	=	{x:refMaskMC._x, y:refMaskMC._y};
		refMaskMC._parent.localToGlobal(pos);
		globalToLocal(pos);
		return pos;
	}
	
	private function onChangeSceneMove():Void{
		mask_mc._width	=	getRefMaskPos().x;
		
	}
	private function onChangeSceneEnd():Void{
		loader_mcl.unloadClip(preLoaderMC);//过渡场景结束,删除原来加载的内容 
		curLoaderMC.setMask(null)
		mask_mc._visible	=	false;
	}
	//***MovieClipLoader Events***\\
	private function onLoadStart(mc:MovieClip):Void{
		mc._visible	=	false;
		curLoaderMC.stopAll();
	}
	private function onLoadProgress(mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void{
		var percent:Number	=	Math.round(loadedBytes/totalBytes*100);
		
	}
	private function onLoadComplete(mc:MovieClip):Void{
		//_parent.preLoader_mc.startPreLoad();
		
	}
	private function onLoadInit(mc:MovieClip):Void{
		if(!isIntro){
			//trace(curLoaderMC.getBytesTotal())
			if(curLoaderMC.getBytesTotal()>20){
				//bricks_mc.build(15, 10, 655, 340);
				//curLoaderMC.setMask(bricks_mc);
				fadeInOut();
			}else{//第一次加载
				onFinishFadeOut();
			}
			
			
		}
		mc._visible	=	true;
		if(_global.isSkip2LuckyDraw){
			_global.isSkip2LuckyDraw	=	false;
			mc.gotoAndPlay("form");
		}else if(_global.isSkip2Network){
			_global.isSkip2Network	=	false;
			mc.gotoAndPlay("network");
		}else{
			mc.gotoAndPlay(2);
		}
	}
	private function onLoadError(mc:MovieClip, errorCode:String):Void{
		switch(errorCode){
			case "URLNotFound":
				
				break;
			case "LoadNeverCompleted":
				
				break;
			
		}
		trace("MovieClipLoader errorCode: "+errorCode);
		 
	 }
	//***MovieClipLoader Events END***\\
	private function fadeInOut():Void{
		preLoaderMC._visible	=	true;
		_tw.start();
		preLoaderMC.colour	=	new Color(preLoaderMC);
		onChanging(preLoaderMC, 0);

		curLoaderMC.colour	=	new Color(curLoaderMC);
		onChanging(curLoaderMC, 100);
	}
	private function onMotionChanged(tw:Tween){
		onChanging(preLoaderMC, tw.position);//trace(tw.position)
		onChanging(curLoaderMC, 100-tw.position);
	}
	private function onMotionFinished(tw:Tween){
		onFinishFadeOut();
		//curLoaderMC.gotoAndPlay(2);
	}
	private function onChanging(mc:MovieClip, num:Number){
		var b:Number	=	(100-num)*2.55;
		//mc._alpha	=	num;
		//trace([mc._name, b])
		mc.colour.setTransform({ ra:'100', rb:b, 
							   ga:'100', gb:b, 
							   ba:'100', bb:b, 
							   aa:'100', ab: -b});
		//trace([mc._parent._name, b, tw.finish,tw.begin])
	}
	
	private function onFinishFadeOut(evtObj:Object):Void{
		
		var tempMC:MovieClip	=	curLoaderMC;
		curLoaderMC	=	preLoaderMC;
		preLoaderMC	=	tempMC;
		curLoaderMC.swapDepths(preLoaderMC);//换到上层来
		//preLoaderMC.onUnloadMC();
		loader_mcl.unloadClip(preLoaderMC);
		//onChanging(preLoaderMC, 0);
		//preLoaderMC._visible	=	false;
		//preLoaderMC.setMask(null);
		_parent.arrowRight_mc.enabled	=	
		_parent.arrowLeft_mc.enabled	=	true;
		//bricks_mc.delBricks();
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	public function loadContent(url:String):Void{
		curLoaderMC.stop();
		curLoaderMC.stopAll();
		curLoadingMC	=	preLoaderMC;
		loader_mcl.loadClip(url, preLoaderMC);
		isIntro	=	false;
		//curLoaderMC.swapDepths(preLoaderMC);//换到上层来
		//trace([preLoaderMC.getDepth(), curLoaderMC.getDepth()])
		//_parent.preLoader_mc.pausePreLoad();
		_parent.arrowRight_mc.enabled	=	
		_parent.arrowLeft_mc.enabled	=	false;
	}
	
	public function loadIntro(url:String):Void{
		loader_mcl.loadClip(url, curLoaderMC);
		isIntro	=	true;
	}
	//***********************[STATIC METHOD]**********************************//
	
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
