//******************************************************************************
//	name:	ExSound 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Jun 22 16:43:57 GMT+0800 2006
//	description: this file was created by "ExSound.fla" file.
//		扩展Sound类,提供指定时间激活事件
//		原来是想增加cue点的,但因为如果机器过于负载,则时间对不上,所以这个
//		类的实用性不是很大,故暂时停止开发,
//******************************************************************************



/**
 * extend Sound, add some useful method.<p></p>
 * 
 */
class com.idescn.sound.ExSound extends Sound{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	//private var _position:Array		=	null;//保存millsecond单位的数组.
	//private var _curCue:Number		=	null;
	//private var _interID:Number	=	null;
	

	private var _pausePos:Number		=	null;//当前暂停到的地址
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * construction function.<br></br>
	 * create a class BY [new ExSound(this);]
	 * @param target target a movie clip
	 * @param position a position for cue.
	 */
	public function ExSound(target:MovieClip){
		super(target);
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		//_curCue		=	0;
	}
	
	
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * over-write start method
	 * @param secondOffset
	 * @param loop
	 */
	public function start(secondOffset:Number, loop:Number):Void{
		super.start(secondOffset, loop);
		
	}
	
	/**
	 * puase the sound
	 * @return the position of pause sound
	 */
	public function pause():Number{
		_pausePos	=	this.position;
		return _pausePos;
	}
	
	/**
	 * resume the sound
	 */
	public function resume():Void{
		this.start(_pausePos/1000);
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ExSound 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//this template is created by whohoo.
/*
	 * 开始激活position事件
	 * @param cuePos 某一点
	 
	private function startEvents(cuePos:Number):Void{
		clearInterval(_interID);
		var millisecond:Number	=	_position[cuePos];
		if(millisecond>this.duration || millisecond==null){
			return;
		}
		_interID=setInterval(this, "activeCuePoint", millisecond, millisecond);
	}
	
	private function activeCuePoint(millisecond:Number):Void{
		dispatchEvent({type:"onCuePoint", millisecond:millisecond});
		clearInterval(_interID);
		startEvents(++_curCue);
	}
	
*/