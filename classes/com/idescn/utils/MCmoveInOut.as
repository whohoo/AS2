//******************************************************************************
//	name:	MCmoveInOut 2.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 18 15:12:11 2006
//	description: 使影片具有moveIn与moveOut方法
//			增加了moveIn2与moveIn2的方法,此类方法不是根据onEnterFrame来驱动,
//			而是通过setInterval来驱使影片播放.
//		2.1 增加了stopMoveInOut()方法
//******************************************************************************

[IconFile("MCmoveInOut.png")]
/**
 *  make a movieclip playing to end frame by frame, or playing to frist frame by
 *  frame. <br>
 *  <p></p>
 *  there are only one method(initialize()) you must write, if you would like<br> 
 *  MovieClip.moveIn() or MovieClip.moveOut() methods. 
 * <pre>
 * <b>eg:</b>
 * com.idescn.utils.MCmoveInOut.initialize();//make all movieclip.
 * //or
 * com.idescn.utils.MCmoveInOut.initialize(target_mc);//only target_mc.
 * 
 *	//target_mc.stop();
 * target_mc.onPress=function(){
 *	this.moveIn(null, doFunc);//by onEnterFrame
 *	this.moveIn2(null, doFunc);//by interval time
 * }
 *
 * target_mc.onRelease=function(){
 *	this.moveOut(null, doFunc);//by onEnterFrame
 *	this.moveOut2(null, doFunc);//by interval time
 * }
 *
 * function doFunc(target:MovieClip):Void{
 *	trace(target._currentframe);
 * }
 * target.stopMoveInOut();//stop movieclip playing.
 * </pre>
 * 
 */
class com.idescn.utils.MCmoveInOut extends Object{
	
	private var _currentframe:Number;
	private var _totalframes:Number;
	private var __interMove2:Number;
	//private var __interval:Number;
	
	private var onEnterFrame:Function;
	private var nextFrame:Function;
	private var prevFrame:Function;
	
	
	/**
	 * initiallize target(movieclip), make target had tow methods(moveIn,moveOut)<br></br>
	 * if not point out which movieclip you wannna, it would make all movieclips<br></br>
	 * had those methods
	 * 
	 * @param   target if not movieclip or not undefined, it would regist <br></br>
	 * 		MovieClip.prototype, that means all movieclip would had those <br></br>
	 * 		methods.
	 * @return 
	 */
	public static function initialize(target:MovieClip):Boolean{
		var o	=	MovieClip.prototype;
		if(target instanceof MovieClip){
			o	=	target;
		}
		if(o.moveOut!=null){
			return false;
		}
		var m:Object	=	_global.com.idescn.utils.MCmoveInOut.prototype;
		
		o.moveIn		=	m.moveIn;
		o.moveOut		=	m.moveOut;
		o.moveIn2		=	m.moveIn2;
		o.moveOut2		=	m.moveOut2;
		o.stopMoveInOut	=	m.stopMoveInOut;
		o.__interMove2	=	m.__interMove2;
		//can't over-write, can't visible, but can delete
		_global.ASSetPropFlags(o, ["moveIn","moveOut","moveIn2","moveOut2", "stopMoveInOut", "__interMove2"], 5);
		return true;
	}
	
	/**
	 * a empty private CONSTRUCT FUNCTION, you can't create instance by this.
	 */
	private function MCmoveInOut(){
		
	}
	
	/**
	 * make a MovieClip playing untile end if not point param frame.<br></br>
	 * if you point a frame, and frame large then currentFrame,<br></br>
	 * this movieclip would not play, or it would stop.<br></br>
	 * 
	 * <pre>
	 * 	<b>eg:</b>
	 * 		car_mc is a movieclip.
	 * 		car_mc.moveIn();// it would play end
	 * 		car_mc.moveIn(4);// it would play to frame 4.
	 * 		car_mc.moveIn(null,doFunc);// it would play end and trigger function
	 * 		    //doFunc(target_mc);
	 * </pre>
	 * 
	 * @param   frame [optional parameters]<br></br>
	 * 		the default frame is last frame(_totalFramess), if not point.
	 * @param   func  [optional parameters]<br></br>
	 *		a function, when this movieclip gotopaly the frame,<br></br>
	 * 		the func would be trigger, and pass this movieclip to the parameter.
	 */
	public function moveIn(frame:Number, func:Function):Void{
		if(frame>this._totalframes || frame==undefined){
			frame	=	this._totalframes;
		}
		
		if(frame<this._currentframe){
			func(this);
		}else{
			this.onEnterFrame = function() {
				if (this._currentframe<frame) {
					this.nextFrame();
				} else {
					delete this.onEnterFrame;
					func(this);
				};
			};
		};
	}
	
	/**
	 * make a MovieClip playing untile first if not point param frame.<br></br>
	 * if you point a frame, and frame less then currentFrame,<br></br>
	 * this movieclip would not play, or it would stop.<br></br>
	 * 
	 * <pre>
	 * <b>eg:</b>
	 * 		car_mc is a movieclip.
	 * 		car_mc.moveOut();// it would play end
	 * 		car_mc.moveOut(4);// it would play to frame 4.
	 * 		car_mc.moveOut(null,doFunc);// it would play end and trigger function
	 * 		   //doFunc(target_mc);
	 * </pre>
	 * 
	 * @param   frame [optional parameters]<br></br>
	 * 		the default frame is first frame(1), if not point.
	 * @param   func  [optional parameters]<br></br>
	 *		a function, when this movieclip gotopaly the frame,<br></br>
	 * 		the func would be trigger, and pass this movieclip to the parameter.
	 */
	public function moveOut(frame:Number, func:Function):Void{
		if(frame<1 || frame==undefined){
			frame	=	1;
		}
		
		if(frame>this._currentframe){
			func(this);
		}else{
			this.onEnterFrame = function() {
				if (this._currentframe>frame) {
					this.prevFrame();
				} else {
					delete this.onEnterFrame;
					func(this);
				};
			};
		}
	}
	//TODO 测试,说明文档
	/////////////因为MovieClip.moveIn与MovieClip.moveOut事件与onEnterFrame事件有冲突
	//而不能执行,所以重新定义使用setInterval来调用
	/**
	 * make a MovieClip playing untile end if not point param frame.<br></br>
	 * if you point a frame, and frame large then currentFrame,<br></br>
	 * this movieclip would not play, or it would stop.<br></br>
	 * <b>NOTE: </b>
	 * this function different from moveIn, it play movieclip by time, moveIn play <br/>
	 * movieclip by frame, the interval time is 30/1000 second. you can't redefined the<br/>
	 * value.<br/>
	 * <pre>
	 * 	<b>eg:</b>
	 * 		car_mc is a movieclip.
	 * 		car_mc.moveIn2();// it would play end
	 * 		car_mc.moveIn2(4);// it would play to frame 4.
	 * 		car_mc.moveIn2(null,doFunc);// it would play end and trigger function
	 * 		    //doFunc(target_mc);
	 * </pre>
	 * 
	 * @param   frame [optional parameters]<br></br>
	 * 		the default frame is last frame(_totalFramess), if not point.
	 * @param   func  [optional parameters]<br></br>
	 *		a function, when this movieclip gotopaly the frame,<br></br>
	 * 		the func would be trigger, and pass this movieclip to the parameter.
	 */
	public function moveIn2(frame:Number, func:Function):Void{
		if(frame>this._totalframes || frame==undefined){
			frame	=	this._totalframes;
		}
		
		if(frame<this._currentframe){
			func(this);
		}else{
			clearInterval(this.__interMove2);
			this.__interMove2 = setInterval(
					function(mc:MovieClip) {
						if (mc._currentframe<frame) {
							mc.nextFrame();
						} else {
							clearInterval(mc.__interMove2);
							func(mc);
						};
					}, 30, this);
		};
	};
	/**
	 * make a MovieClip playing until first if not point param frame.<br></br>
	 * if you point a frame, and frame less then currentFrame,<br></br>
	 * this movieclip would not play, or it would stop.<br></br>
	 * <b>NOTE: </b>
	 * this function different from moveIn, it play movieclip by time, moveIn play <br/>
	 * movieclip by frame, the interval time is 30/1000 second. you can't redefined the<br/>
	 * value.<br/>
	 * <pre>
	 * <b>eg:</b>
	 * 		car_mc is a movieclip.
	 * 		car_mc.moveOut2();// it would play end
	 * 		car_mc.moveOut2(4);// it would play to frame 4.
	 * 		car_mc.moveOut2(null,doFunc);// it would play end and trigger function
	 * 		   //doFunc(target_mc);
	 * </pre>
	 * 
	 * @param   frame [optional parameters]<br></br>
	 * 		the default frame is first frame(1), if not point.
	 * @param   func  [optional parameters]<br></br>
	 *		a function, when this movieclip gotopaly the frame,<br></br>
	 * 		the func would be trigger, and pass this movieclip to the parameter.
	 */
	public function moveOut2(frame:Number, func:Function):Void{
		if(frame<1 || frame==undefined){
			frame	=	1;
		}
		
		if(frame>this._currentframe){
			func(this);
		}else{
			clearInterval(this.__interMove2);
			this.__interMove2 =  setInterval(
					function(mc:MovieClip) {
						if (mc._currentframe>frame) {
							mc.prevFrame();
						} else {
							clearInterval(mc.__interMove2);
							func(mc);
						}
					}, 30, this);
		}
	};
	
	/**
	 * stop moveIn or moveOut enterframe.<br/>
	 * delete the movieclip onEnterFrame event.
	 * <pre>
	 * <b>eg.</b>
	 * mc.stopMoveInOut();
	 * </pre>
	 */
	public function stopMoveInOut():Void {
		delete this.onEnterFrame;
		clearInterval(this.__interMove2);
	}
}