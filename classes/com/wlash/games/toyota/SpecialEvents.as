//******************************************************************************
//	name:	SpecialEvents 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Jun 24 00:45:10 GMT+0800 2006
//	description: this file was created by "forklift_run.fla" file.
//		比如飞碟的出现,把货给偷走,这样叉车可以直接冲到终点,而不用担心有货物掉下
//		来.
//******************************************************************************


import com.wlash.games.toyota.ForkliftGameSystem;

/**
 * specail events for ForkliftGameSystem.<p></p>
 * 
 */
class com.wlash.games.toyota.SpecialEvents extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _sys:ForkliftGameSystem	=	null;
	private var _evtMC:MovieClip			=	null;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * construction function.<br></br>
	 * create a class BY [new SpecialEvents(this);]
	 * @param target target a movie clip
	 * @param sys
	 */
	public function SpecialEvents(target:MovieClip, sys:ForkliftGameSystem){
		this._target	=	target;
		this._sys		=	sys;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		
	}
	/*
	* UFO出现把货吸走
	*/
	private function UFO():Void{
		var mc:MovieClip	=	_target.attachMovie("UFO", "mcUFO", 
									_target.getNextHighestDepth(), 
									{_x:random(800)+100, _y:random(20)});
		mc._xscale=mc._yscale	=	random(10)+20;//大小
		//TODO 飞碟出后,飞向车的上空,把货吸走
		
		
		_evtMC	=	mc;
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	public function makeEvents():Void{
		switch(random(0)){
			case 0://飞碟出现
				UFO();
				break;
			
		}
	}
	
	public function clearEvents():Void{
		_evtMC.removeMovieClip();
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "SpecialEvents 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//this template is created by whohoo.
