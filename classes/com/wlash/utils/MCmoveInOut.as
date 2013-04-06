//******************************************************************************
//	name:	MCmoveInOut 2.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 18 15:12:11 2006
//	description: 使影片具有moveIn与moveOut方法
//			增加了moveIn2与moveIn2的方法,此类方法不是根据onEnterFrame来驱动,
//			而是通过setInterval来驱使影片播放.
//		2.1 增加了stopMoveInOut()方法
//		2.2 remove moveIn2 and moveOut2 method
//			add speed, scalce the playback speed.
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
 * com.wlash.utils.MCmoveInOut.initialize();//make all movieclip.
 * //or
 * com.wlash.utils.MCmoveInOut.initialize(target_mc);//only target_mc.
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
class com.wlash.utils.MCmoveInOut extends Object{
	
	
	
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
		var m:Object	=	_global.com.wlash.utils.MCmoveInOut.prototype;
		o.moveIn		=	m.moveIn;
		o.moveOut		=	m.moveOut;
		o.stopMoveInOut	=	m.stopMoveInOut;
		//can't over-write, can't visible, but can delete
		_global.ASSetPropFlags(o, ["moveIn", "moveOut", "stopMoveInOut"], 5);
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
	 * @param 	speed [optional parameters]<br/>
	 * 		scale the play timeline.
	 */
	public function moveIn(frame:Number, func:Function, speed:Number):Void{
		frame	=	(frame > this['_totalframes'] || frame == undefined || frame<1) ? this['_totalframes'] : Math.floor(frame);
		
		delete this['onEnterFrame'];
		if(frame<this['_currentframe']){
			trace("ERROR: target frame :" + frame + " < current frame :" + this['_currentframe']+" at mc: "+this['_name']);
		}else if (frame == this['_currentframe']) {
			func(this);
		}else {
			speed	=	(speed <= 0 || speed == undefined) ? 1 : speed;
			var curFrame:Number	=	this['_currentframe'];
			this['onEnterFrame'] = function() {
				if (this['_currentframe']<frame) {
					curFrame	+=	speed;
					this['gotoAndStop'](Math.round(curFrame));
				} else {
					delete this['onEnterFrame'];
					this['gotoAndStop'](frame);
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
	 * @param 	speed [optional parameters]<br/>
	 * 		scale the play timeline.
	 */
	public function moveOut(frame:Number, func:Function, speed:Number):Void{
		frame	=	(frame < 1 || frame == undefined || frame<1) ? 1 : Math.floor(frame);
		
		delete this['onEnterFrame'];
		if (frame > this['_currentframe']) {
			trace("ERROR: target frame :" + frame + " > current frame :" + this['_currentframe']+" at mc: "+this['_name']);
		}else if(frame==this['_currentframe']){	
			func(this);
		}else {
			speed	=	(speed <= 0 || speed == undefined) ? 1 : speed;
			var curFrame:Number	=	this['_currentframe'];
			this['onEnterFrame'] = function() {
				if (this['_currentframe'] > frame) {;
					//this.prevFrame();
					curFrame	-=	speed;
					this['gotoAndStop'](Math.round(curFrame));
				} else {
					delete this['onEnterFrame'];
					this['gotoAndStop'](frame);
					func(this);
				};
			};
		}
	}
	
	
	/**
	 * stop moveIn or moveOut enterframe.<br/>
	 * delete the movieclip onEnterFrame event.
	 * <pre>
	 * <b>eg.</b>
	 * mc.stopMoveInOut();
	 * </pre>
	 */
	public function stopMoveInOut():Void {
		delete this['onEnterFrame'];
	}
}