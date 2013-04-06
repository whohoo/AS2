//******************************************************************************
//	name:	ZoomImageScroll 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon May 08 15:03:09 GMT+0800 2006
//	description: 事件类,定义当滚动放大与缩小zoomImage时滚动条时的事件
//******************************************************************************



class com.idescn.loader.zoomImage.events.ZoomImageScroll extends Object{
	
	public  var zoom:Object			=	null;
	public  var num_txt:TextField		=	null;
	public  var level_txt:TextField	=	null;
	
	
	public function ZoomImageScroll(){
		
	}
	/******************[PRIVATE METHOD]******************/
		
	/**
	 * 当scroll在滚动时,所产生的事件
	 * 
	 * @usage   
	 * @param   eventObj {percent}
	 * @return  
	 */
	private function onScroll(eventObj:Object):Void{
		var maxNum:Number	=	zoom.zoomLevelMax;
		var curNum:Number	=	Math.round(eventObj.percent*maxNum);
		num_txt.text		=	(curNum+'/'+maxNum);
		level_txt.text		=	curNum.toString();
	}
	
	/**
	 * 当scroll在放开时,所产生的事件
	 * 
	 * @usage   
	 * @param   eventObj {percent}
	 * @return  
	 */
	private function onRelease(eventObj:Object):Void{
		var maxNum:Number	=	zoom.zoomLevelMax;
		var curNum:Number	=	Math.round(eventObj.percent*maxNum);
		eventObj.target.update(false, curNum/maxNum);
		zoom.zoom2Level(curNum, true);
	}
	
	/**
	 * 当scroll在按下时,所产生的事件
	 * 
	 * @usage   
	 * @param   eventObj {percent}
	 * @return  
	 */
	private function onPress(eventObj:Object):Void{
		var maxNum:Number	=	zoom.zoomLevelMax;
		var curNum:Number	=	Math.round(eventObj.percent*maxNum);
		trace(curNum)
	}
	/******************[PUBLIC METHOD]******************/
	
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ZoomImageScroll 1.0";
	}
}
