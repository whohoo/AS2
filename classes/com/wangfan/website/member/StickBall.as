//******************************************************************************
//	name:	StickBall 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Nov 08 13:24:52 2006
//	description: 
//		
//******************************************************************************




/**
 * 在member.swf中的动态菜单.<p></p>
 * 球的粘性。
 * 广播onSticking({x, y, tempX, tempY})事件
 * 广播onFreeze({x, y})事件
 */
class com.wangfan.website.member.StickBall extends MovieClip{
	private var initX:Number	=	0;
	private var initY:Number	=	0;
	
	private var targetX:Number	=	0;
	private var targetY:Number	=	0;
	
	private var tempX:Number	=	0;
	private var tempY:Number	=	0;
	
	private var isStick:Boolean	=	true;
	public  var elasticCoeff:Number	=	.6;
	public  var moveCoeff:Number		=	.6;
	//************************[READ|WRITE]************************************//
	
	//************************[READ ONLY]*************************************//
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(StickBall.prototype);
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoadXmlMenu4Lab(this);]
	 * @param target target a movie clip
	 */
	private function StickBall(){
		initX	=	_x;
		initY	=	_y;
		stickMouse();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function _onEnterFrame():Void {
		var distanceX:Number	=	initX-_parent._xmouse;
		var distanceY:Number	=	initY-_parent._ymouse;
		
		var distance:Number	=	Math.sqrt(distanceX*distanceX+distanceY*distanceY);
		if (distance<_width/2) {
			targetX = _parent._xmouse;
			targetY = _parent._ymouse;
		} else {
			targetX = this.initX;
			targetY = this.initY;
		}
		
		tempX = (((_x-targetX)*moveCoeff)+tempX)*elasticCoeff;
		_x -= tempX;
		tempY = (((_y-targetY)*moveCoeff)+tempY)*elasticCoeff;
		_y -= tempY;
		dispatchEvent({type:"onSticking", x:_x, y:_y, tempX:tempX, tempY:tempY});
		if(isStick==false){
			if(Math.abs(tempX)<.1){
				if(Math.abs(tempY)<.1){
					_x	=	targetX;
					_y	=	targetY;
					dispatchEvent({type:"onFreeze", x:_x, y:_y});
					//onEnterFrame	=	null;
				}
			}
		}
	};
	
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 开始stick
	*/
	public function stickMouse():Void{
		isStick	=	true;
		onEnterFrame=_onEnterFrame;
	}
	
	/**
	* 停止stick
	*/
	public function stickNone():Void{
		isStick	=	false;
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
