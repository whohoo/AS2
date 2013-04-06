
//******************************************************************************
//	name:	ScrollBar 1.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2007-1-11 ����02:35:28
//	description: file path[D:\flash_CODE\AS2_CODE\com\wangfan\utils\scroll]
//		增加是否支持mosue wheel滚动事件
//	1.2 增加了sclaeThumb属性,指明是否缩放bar
//******************************************************************************

import com.idescn.utils.scroll.ScrollFactory;

/**
 * a scroll bar component.<p/>
 * you could drap and drop this component to scroll_mc[MovieClip],<br/>
 * the scroll_mc must compose with bar_mc and background_mc.<br/>
 * parameter targetInstanceName the scroll_mc <br/>
 * parameter targetObj blank or TextField or MovieClip.<br/>
 * parameter maskHeight the mask height if the targetObj is MovieClip.<br/>
 * <p>
 * dispatchEvent({type:"onScroll", percent:percent});<br/>
 * dispatchEvent({type:"onPress", percent:percent});<br/>
 * dispatchEvent({type:"onRelease", percent:percent});<br/>
 * </p>
 */
class com.wangfan.utils.scroll.ScrollBar extends MovieClip {
	private var symbol_mc:MovieClip			=	null;
	private var _scrollObj:ScrollFactory	=	null;
	[Inspectable(defaultValue=true, type=Boolean, name="enableWheel")]
	private var _enableWheel:Boolean		=	true;
	[Inspectable(defaultValue=1, type=Number, name="wheelNum")]
	private var _wheelNum:Number			=	1;
	
	[Inspectable(defaultValue="", type=String, name="targetInstanceName")]
	private var _targetInstanceName:String	=	"";
	[Inspectable(defaultValue="", type=String, name="targetObj")]
	private var _targetObj					=	null;

	[Inspectable(defaultValue=0, type=Number)]
	/**在滚动影片对象时,mask被滚动对象的高度*/
	public var maskHeight:Number			=	0;
	
	[Inspectable(defaultValue=true, type=Boolean)]
	/**是否因滚动值的大小改变bar的大小*/
	public var scaleThumb:Boolean			=	true;
	
	/**得到滚动条对象*/
	function get targetInstanceName(){
		 return this._parent[_targetInstanceName];
	}
	
	/**得到被滚动条对象*/
	function get targetObj(){
		 //return this._parent[_targetObj];
		 return eval(this._parent+"."+_targetObj);
	}
	
	/**拉动条的把手*/
	function get barMC():MovieClip{
		 return targetInstanceName.bar_mc;
	}
	/**拉动条的背景手*/
	function get backgroundMC():MovieClip{
		 return targetInstanceName.background_mc;
	}
	
	function set active(value:Boolean):Void{
		 barMC.enabled	=	value;
		 if(scaleThumb){
			_scrollObj.render(0);
		 }else {
			_scrollObj["getScrollRange"](true);
		 }
		 _scrollObj.update();
		 if(!value){
		 	delete this.onEnterFrame;
		 }
	}
	/**滚动条是否可用*/
	function get active():Boolean{
		 return barMC.enabled;
	}
	
	function set enableWheel(value:Boolean):Void{
		_scrollObj["mouseWheelEnabled"]	=	value;
		_enableWheel	=	value;
	}
	/**是否能用mouse的wheel*/
	function get enableWheel():Boolean{
		 return _enableWheel;
	}
	
	function set wheelNum(value:Number):Void{
		_scrollObj["wheelNum"]	=	value;
	}
	/**mouse的wheel的距离*/
	function get wheelNum():Number{
		 return _scrollObj["wheelNum"];
	}
	
	
	
	private function ScrollBar(){
		
		if(typeof targetObj =="movieclip"){
			_scrollObj	=	new com.idescn.utils.scroll.ScrollMC(targetInstanceName, targetObj, maskHeight);
			
		}else if(targetObj instanceof TextField){
			_scrollObj	=	new com.idescn.utils.scroll.ScrollText(targetInstanceName, targetObj);
			
		}else{
			_scrollObj	=	new com.idescn.utils.scroll.ScrollBar(targetInstanceName);
			
		}
		if(scaleThumb){
			_scrollObj.render(0);
		}else {
			_scrollObj["getScrollRange"](true);
		}
		enableWheel	=	_enableWheel;
		wheelNum	=	_wheelNum;
		
		symbol_mc.swapDepths(19899);
		symbol_mc.removeMovieClip();
	}
	
	////////////////////////////[PUBLIC MOTHED]/////////////////////////////////
	/**
	 * render bar_mc size and position, <br>
	 * only when textField maxscroll number change bar_mc size.<br></br>
	 * if percent is null, just render bar_mc size.<p>
	 * </p>
	 * this is only abstract method. you must implement the method.
	 * @param percent
	 */
	public function render(percent:Number):Void{
		_scrollObj.render(percent);
	};
	/**
	 * the targetObj are scrolled by scrollBar.<p>
	 * </p>
	 * this is only abstract method. you must implement the method.
	 *  
	 */
	public function update():Void{
		_scrollObj.update();
	};
	
	/**
	* add a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public function addEventListener(event:String, handle):Void{
		_scrollObj["addEventListener"](event, handle);
	}
	/**
	* remove a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public function removeEventListener(event:String, handle):Void{
		_scrollObj["removeEventListener"](event, handle);
	}
	
	/**
	 * UP button, when press UP button, scroll the scrollBar.
	 * scrolling before you release the button.
	 * @param step the value must 0 <setp< 1;
	 */
	public function onPressUp(step:Number):Void{
		if(!barMC.enabled)	return;
		step	=	step==null? 0.02 : (Math.abs(step)>=1 ? 0.02 : step);
		_scrollObj["percent"]	-=	step;
		_scrollObj.update();
		this.onEnterFrame=function():Void{
			_scrollObj["percent"]	-=	step;
			_scrollObj["_onMouseMove"]();
		};
	}
	/**
	 * DOWN button, when press DOWN button, scroll the scrollBar.
	 * scrolling before you release the button.
	 * @param step the value must 0 <setp< 1;
	 */
	public function onPressDown(step:Number):Void{
		if(!barMC.enabled)	return;
		step	=	step==null? 0.02 : (Math.abs(step)>=1 ? 0.02 : step);
		_scrollObj["percent"]	+=	step;
		_scrollObj.update();
		this.onEnterFrame=function():Void{
			_scrollObj["percent"]	+=	step;
			_scrollObj["_onMouseMove"]();
		};
	}
	/**
	 * UP button, when release UP button, 
	 * stop scrolling before you release the button.
	 */
	public function onReleaseUp():Void{
		delete this.onEnterFrame;
	}
	/**
	 * DOWN button, when release DOWN button, 
	 * stop scrolling before you release the button.
	 */
	public function onReleaseDown():Void{
		delete this.onEnterFrame;
	}
	
	
	/**
	 * show this class name.
	 * @return this name
	 */
	public function toString():String{
		return "ScrollBar 1.2 ["+_scrollObj+"]";
	}
}