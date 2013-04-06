//******************************************************************************
//	name:	FlagListScroll 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon May 08 15:03:09 GMT+0800 2006
//	description: 事件类,定义当滚动flaglist时滚动条时的事件
//******************************************************************************



class com.idescn.loader.zoomImage.events.FlagListScroll extends Object{
	
	public  var flagControl:Object		=	null;
	
	
	/******************[PRIVATE METHOD]******************/
	
	/**
	 * 当scroll在滚动时,所产生的事件
	 * 
	 * @usage   
	 * @param   eventObj {percent}
	 * @return  
	 */
	private function onScroll(eventObj:Object):Void{
		//var maxNum:Number	=	flagControl.scrollMaxNum
		var num:Number	=	Math.round(eventObj.percent*(flagControl.scrollMaxNum-1));
		flagControl.showItems(num);
	}
	
	/**
	 * 当scroll在放开时,所产生的事件
	 * 
	 * @usage   
	 * @param   eventObj {percent}
	 * @return  
	 */
	private function onRelease(eventObj:Object):Void{
		
	}
	
	/**
	 * 当scroll在按下时,所产生的事件
	 * 
	 * @usage   
	 * @param   eventObj {percent}
	 * @return  
	 */
	private function onPress(eventObj:Object):Void{
		
	}
	/******************[PUBLIC METHOD]******************/
	
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "FlagListScroll 1.0";
	}
}
