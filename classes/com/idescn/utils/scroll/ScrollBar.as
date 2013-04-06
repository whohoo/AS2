//******************************************************************************
//	name:	ScrollBar 1.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon May 22 13:37:24 2006
//	description: 一个简单的滚动条,当滚动滚动条时,会产生onScroll事件,传递当前滚动
//			了多少百分比的最上方为百分之零,最下方为百分之百
// 		1.1 把activeMouseWheel方法去掉,改为mouseWheelEnabled只写属性
//		1.2 原来的startDrag改为onMouseMove,因为startDrage只支持整数的坐标
//******************************************************************************

import com.idescn.utils.scroll.ScrollFactory;
import mx.utils.Delegate;
import mx.events.EventDispatcher;

/**
* scrolling, when drag scroll bar.
* <p></p>
* to use this class, you must create a movieclip, that include tow movieclips inside.<br></br>
* the name must "background_mc" and "bar_mc".<br></br>
* when user roll mouse wheel above scroll movieclip, bar_mc would move.<br></br>'
* <pre>
* <b>eg:</b>
* var sMC	=	new ScrollBar(scroll_mc);
* sMC.render();
* sMC.addEventsListener("onScroll", onScroll);
* function onScroll(eventObj){
*   trace(eventObj.percent);
* }
* </pre>
* <p></p>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onPress({}): on press bar_mc </li>
* <li>onScroll({percent}): when drag bar_mc or roll your mosue wheel </li>
* <li>onRelease({}): on release bar_mc </li>
* </ul>
*/
class com.idescn.utils.scroll.ScrollBar extends Object implements ScrollFactory{
	private var _target:MovieClip			=	null;
	private var _backgroundMC:MovieClip		=	null;
	private var _barMC:MovieClip			=	null;
	private var _targetObj:Object			=	null;
	
	private var _top:Number				=	null;//背景条与拉动条距中心点的距离
	private var _bottom:Number			=	null;
	private var _length:Number			=	null;//拉动条可移动的长度
	private var _hoverTarget:Array		=	null;
	
	//private var _pressPosX:Number;
	private var _pressPosY:Number;
	
	/**
	* the min size of scroll bar, the default value is 10<br></br>
	* this property only for TextScroll
	*/
	public var minSize:Number			=	10;//bar最短尺寸.
	/**scroll mouse wheel, the move barMC distance is 1,*/
	public var wheelNum:Number			=	1;
	
	[Inspectable(defaultValue="", verbose=1, type=Number)]
	function set percent(value:Number):Void{
		//value	=	value > 1 ? 1 : value < 0 ? 0 : value;
		value	=	Math.max(Math.min(value, 1), 0);
		_barMC._y	=	value * _length + _top;
	}
	/**mask height */
	function get percent():Number{
		return (_barMC._y - _top) / _length;
	}
	
	//************[WRITE ONLY]*****************\\
	/**is active Mouse Wheel events.*/
	function set mouseWheelEnabled(enabled:Boolean):Void{
		if(enabled){
			Mouse.addListener(this);
		}else{
			Mouse.removeListener(this);
		}
	}

	//************[READ ONLY]*****************\\
	/**mask height */
	function get top():Number{
		return _top;
	}
	/**mask height */
	function get bottom():Number{
		return _bottom;
	}
	/////////////////event
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	EventDispatcher.initialize(ScrollBar.prototype);
	
	/**
	 * contruct function,
	 * 
	 * @param target scroll include bar_mc and background_mc
	 */
	public function ScrollBar(target:MovieClip){
		this._target	=	target;
		_hoverTarget	=	[];
		init();
	}
	
	//******************[PRIVATE METHOD]******************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		try{
			setBackGround(_target.background_mc);
			setBar(_target.bar_mc);
		}catch(e:Error){
			trace(e);
		}
		this.addScrollTarget(_target);
		this.setBarEvent();
		mouseWheelEnabled	=	true;
	}
	
	/**
	 * set backgroundMC movieclip, default [background_mc]
	 * 
	 * @param   mc 
	 * @throws Error if there is a failure in not exist [background_mc] movieclip.
	 */
	private function setBackGround(mc:MovieClip):Void{
		_backgroundMC	=	mc;
		if(mc==null){
			throw new Error("you must defined the name [background_mc]");
		}
	}
	
	/**
	 * set barMC movieclip, default [bar_mc]
	 * @param   mc 
	 * @throws Error if there is a failure in not exist [bar_mc] movieclip.
	 */
	private function setBar(mc:MovieClip):Void{
		_barMC		=	mc;
		if(mc==null){
			throw new Error("you must defined the name [bar_mc]");
		}
	}
	
	/**
	 * define bar mouse events
	 * 
	 * 
	 */
	private function setBarEvent():Void{
		var barMC:MovieClip		=	_barMC;
		barMC.onPress			=	Delegate.create(this, _onPress);
		barMC.onRelease			=	
		barMC.onReleaseOutside	=	Delegate.create(this, _onRelease);
	}
	
	/**
	 * barMC mouse events
	 * 
	 */
	private function _onPress():Void{
		var barMC:MovieClip	=	_barMC;
		//barMC.startDrag(false, barMC._x, _top, barMC._x, _bottom);
		_pressPosY	=	_target._ymouse-barMC._y;
		barMC.onMouseMove	=	Delegate.create(this, _onMouseMove);
		dispatchEvent({type:"onPress", percent:percent});
		
	}
	
	/**
	 * barMC mouse events
	 * 
	 */
	private function _onMouseMove():Void {
		var barPosY:Number	=	_target._ymouse - _pressPosY;
		_barMC._y	=	Math.min(Math.max(_top, barPosY), _bottom);
		update();
		dispatchEvent({type:"onScroll", percent:percent});
	}
	
	/**
	 * barMC mouse events
	 * 
	 */
	private function _onRelease():Void{
		var barMC:MovieClip	=	_barMC;
		barMC.stopDrag();
		delete barMC.onMouseMove;
		dispatchEvent({type:"onRelease", percent:percent});
	}
	
	/**
	 * set scroll bar length, <p></p>
	 * this code form MM scroll component.
	 * @param  pSize  page size
	 * @param  mnPos  min position
	 * @param  mxPos  max position
	 */
	private function setScrollProperties(pSize:Number, mnPos:Number, mxPos:Number):Void{
		_barMC._height	=	pSize / (mxPos - mnPos + pSize) * _backgroundMC._height;
		//_barMC._height	=	_barMC._height<minSize ? minSize : _barMC._height;
		_barMC._height	=	Math.max(minSize, _barMC._height);
		getScrollRange(true);
	}
	
	
	
	private function isHoverTarget(scrollTarget:Object):Boolean{
		var retValue:Boolean	=	false;
		var len:Number	=	_hoverTarget.length;
		for(var i:Number=0;i<len;i++){
			if(scrollTarget._target.indexOf(_hoverTarget[i]._target)==0){
				retValue	=	true;
				break;
			}
		}
		return retValue;
	}
	/**
	 * Notified when the user rolls the mouse wheel.
	 * 
	 * @param   delta     A number indicating how many lines should be scrolled 
	 * for each notch the user rolls the mouse wheel. A positive delta value 
	 * indicates an upward scroll; a negative value indicates a downward scroll.
	 * Typical values are from 1 to 3; faster scrolling can produce larger values.
	 * 
	 * @param   scrollTarget A parameter that indicates the topmost movie clip 
	 * instance under the mouse pointer when the mouse wheel is rolled. 
	 * If you want to specify a value for scrollTarget but don't want to specify 
	 * a value for delta, pass null for delta.
	 */
	private function onMouseWheel(delta:Number, scrollTarget:Object):Void{
		if(isHoverTarget(scrollTarget)){
			_barMC._y	-=	delta * wheelNum;
			_barMC._y	=	Math.max(_top, Math.min(_bottom, _barMC._y));
			_onMouseMove();
		};
	}
	
	//******************[PUBLIC METHOD]******************//
	/**
	 * reset scroll range,
	 * @param isUpdate 强制更新,如果isUpdata为真的时候,
	 */
	public function getScrollRange(isUpdate:Boolean):Void{
		if(isUpdate!=true && _length!=null)	return;
		var bgBound:Object		=	_backgroundMC.getBounds();
		var barBound:Object	=	_barMC.getBounds();
		
		var bgPosY:Number		=	_backgroundMC._y;
		var scale:Number		=	_barMC._yscale/100;
		_top	=	bgBound.yMin - barBound.yMin * scale + bgPosY;
		_bottom	=	bgBound.yMax - barBound.yMax * scale + bgPosY;
		_length	=	_bottom-_top;
	}
	/**
	 * add scroll target
	 * @param scrollTarget
	 */
	public function addScrollTarget(scrollTarget:Object):Void{
		_hoverTarget.push(scrollTarget);
	}
	/**
	 * add scroll target
	 * @param scrollTarget
	 * @return TRUE if remove success, or FALSE 
	 */
	public function removeScrollTarget(scrollTarget:Object):Boolean{
		var retValue:Boolean	=	false;
		var len:Number	=	_hoverTarget.length;
		for(var i:Number=0;i<len;i++){
			if(_hoverTarget[i]==scrollTarget){
				_hoverTarget.splice(i, 1);
				retValue	=	true;
				break;
			}
		}
		return retValue;
	}
	
	/**
	 * the targetObj are scrolled by scrollBar.<br></br>
	 * this method is empty.
	 */
	public function update():Void{
		
	}
	
	/**
	 * render bar_mc size and position, <br>
	 * only when textField maxscroll number change bar_mc size.<br></br>
	 * if percent is null, just render bar_mc size.
	 * 
	 * this is only abstract method. you must implement the method.
	 * @param percent the position of scroll bar
	 */
	public function render(percent:Number):Void{
		getScrollRange();
		if(!isNaN(percent)){
			this.percent	=	percent;
		}
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ScrollBar 1.2";
	}
}