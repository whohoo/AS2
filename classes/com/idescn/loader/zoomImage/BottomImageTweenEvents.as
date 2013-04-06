//******************************************************************************
//	name:	BottomImageTweenEvents 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Apr 25 15:23:01 GMT+0800 2006
//	description: 当缩放背景图片时,使用了tween的缓冲效果,
//				缓冲效果过程事件及结果
//******************************************************************************



class com.idescn.loader.zoomImage.BottomImageTweenEvents extends Object{
	
	private var _zoomImage:Object		=	null;
	
	
	//[DEBUG]//your can remove it before finish this CLASS!
	//public static var tt:Function		=	null;
	
	//private var _value:String		=	null;
	
	/******************[READ|WIDTH]******************/
	/*[Inspectable(defaultValue="", verbose=1, type=String)]
	function set value(value:String):Void{
		
	}
	function get value():String{
		return _value;
	}*/
	
	
	/**
	 * construction function
	 * @param target 
	 */
	public function BottomImageTweenEvents(target:Object){
		this._zoomImage	=	target;
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	 * 当tween移动过程
	 * 
	 * @usage   
	 * @param   target tween
	 * @param   pos    
	 * @return  
	 */
	private function onMotionChanged(target:Object, pos:Number):Void{
		var bImage:MovieClip	=	_zoomImage.bottomImage;
		//得到bottom image影片缩放的程度,
		var scale:Number	=	(bImage._yscale-bImage._xscale)/bImage._xscale;
		//tileslayer随着影片缩放
		_zoomImage.zoomTilesImage(scale);
		bImage._xscale2	=	bImage._yscale;
		
		_zoomImage.updatePosition();
		_zoomImage.dispatchEvent({type:"onScale", scale:scale, 
			x:_zoomImage.curPosX, y:_zoomImage.curPosY, updateImageNav:true});
		
	}
	
	/**
	 * 当tween开始时
	 * 
	 * @usage   
	 * @param   target  tween
	 * @return  
	 */
	private function onMotionStarted(target:Object):Void{
		
	}
	
	/**
	 * 当tween结束时
	 * 
	 * @usage   
	 * @param   target  tween
	 * @return  
	 */
	private function onMotionStopped(target:Object):Void{
		var bImage:MovieClip	=	_zoomImage.bottomImage;
		_zoomImage.loadTiles(_zoomImage.curLevel);//reload tiles
	}
	
	/**
	 * 当tween被resum时
	 * 
	 * @usage   
	 * @param   target    tween
	 * @return  
	 */
	private function onMotionResumed(target:Object):Void{
		
	}
	/******************[PUBLIC METHOD]******************/
	
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "BottomImageTweenEvents 1.0";
	}
}
