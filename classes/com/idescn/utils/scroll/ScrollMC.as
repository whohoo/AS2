//******************************************************************************
//	name:	ScrollMC 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon May 22 16:02:49 2006
//	description: 1.1增加了tween类的缓冲时间.
//******************************************************************************

import com.idescn.utils.scroll.ScrollBar;
import mx.transitions.Tween;
import mx.transitions.easing.Strong;
/**
 * scroll movieclip.
 * <p></p>
 * this class no effect when rolling mouse wheel.
 * <pre>
 * <b>eg:</b>
 * var sMC	=	new ScrollMC(scroll_mc, text_mc, 100);
 * sMC.render(0);
 * sMC.twTime = 0.5;
 * </pre>
 * 
 */
class com.idescn.utils.scroll.ScrollMC extends ScrollBar {
	//private var _twTime:Number				=	0.8;//
	
	private var _maskHeight:Number			=	null;
	private var _initPosY:Number			=	null;//滚动影片的初始位置,当_targetObjType
									//为movieclip时,记录影片的初始位置,并此点对应_barMC对应的_top位置
	private var _tw:Tween					=	null;
	
	function set maskHeight(value:Number):Void{
		_maskHeight	=	value;
	}
	/**mask height */
	function get maskHeight():Number{
		return _maskHeight;
	}
	
	public function set twTime(value:Number):Void {
		_tw.duration	=	value;
	}
	/**tween类缓冲的时间*/
	public function get twTime() { return _tw.duration; }
	
	
	/**
	 * contruct function,
	 * create scroll for movieclip
	 * @param target scroll include bar_mc and background_mc
	 * @param obj a movieclip instance in stage
	 * @param maskHeight the height of mask obj.
	 */
	public function ScrollMC(target:MovieClip, obj:MovieClip, maskHeight:Number){
		super(target);
		_targetObj	=	obj;
		_maskHeight	=	maskHeight;
		_initPosY	=	obj._y;
		this.addScrollTarget(obj);
		_tw	=	new Tween(_targetObj, "_y", Strong.easeOut, _targetObj._y, _targetObj._y, 0.8, true);
		_tw.stop();
	}
	
	//******************[PRIVATE METHOD]******************//
	/**
	 * barMC mouse events
	 * over-write
	 */
	private function _onPress():Void{
		//_tw.stop();
		super._onPress();
	}
	
	
	
	//******************[PUBLIC METHOD]******************//
	/**
	 * the targetObj are scrolled by scrollBar.
	 * 
	 */
	public function update():Void{
		if(_targetObj._height<=_maskHeight)		return;
		
		var posY:Number	=	_initPosY - (_targetObj._height - _maskHeight) * ((_barMC._y - _top) / _length);
		//_targetObj._y	=	posY;trace(_initPosY)
		_tw.begin	=	_targetObj._y;
		_tw.finish	=	posY;
		_tw.start();
		
	}
	
	/**
	 * render bar_mc size and position, <br>
	 * only when textField maxscroll number change bar_mc size.<br></br>
	 * if percent is null, just render bar_mc size.
	 * 
	 * 
	 * @param percent the position of scroll bar
	 */
	public function render(percent:Number):Void{
		setScrollProperties(_maskHeight, 0, _targetObj._height);
		if(!isNaN(percent)){
			_barMC._y	=	percent*_length+_top;
		}
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ScrollMC 1.1";
	}
}