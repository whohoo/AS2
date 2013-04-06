//******************************************************************************
//	name:	ScrollText 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon May 22 14:31:58 2006
//	description: 
//******************************************************************************

import com.idescn.utils.scroll.ScrollBar;

/**
 * scroll textfield,
 * <p></p>
 * when user roll mouse wheel above textfield, the bar_mc would move.
 * <pre>
 * <b>eg:</b>
 * var sMC	=	new ScrollText(scroll_mc, text_mc.content_txt);
 * sMC.render();
 * 
 * </pre>
 */
class com.idescn.utils.scroll.ScrollText extends ScrollBar{
	

	/**is active Mouse Wheel events.*/
	function set mouseWheelEnabled(enabled:Boolean):Void{
		super.mouseWheelEnabled	=	enabled;
		_targetObj.mouseWheelEnabled	=	enabled;
	}
		
	/**
	 * contruct function,
	 * creat a scroll for text
	 * @param target scroll include bar_mc and background_mc
	 * @param obj a textfield instance in stage
	 */
	public function ScrollText(target:MovieClip, obj:TextField){
		super(target);
		_targetObj	=	obj;
	}
	
	//******************[PRIVATE METHOD]******************//
	/**
	 * when the mouse wheel
	 * 
	 * @param   delta        
	 * @param   scrollTarget 
	 */
	private function onMouseWheel(delta:Number, scrollTarget:Object):Void{
		if(scrollTarget==_targetObj){
			if(scrollTarget.maxscroll==1){
				_barMC._y	=	_top;
			}else{
				_barMC._y	=	(scrollTarget.scroll-1)/
										(scrollTarget.maxscroll-1)*_length+_top;
			}
		}
	}
	
	/******************[PUBLIC METHOD]******************/
	
	
	/**
	 * the targetObj are scrolled by scrollBar.
	 * 
	 */
	public function update():Void{
		if(_targetObj.maxscroll==1)	return;
		
		var percent:Number	=	Math.round((_barMC._y - _top) * 100 / _length);

		_targetObj.scroll	=	Math.round(percent * (_targetObj.maxscroll - 1) / 100) + 1;
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
		//TODO percent must to use, and scroll=1
		var pageSize:Number	=	_targetObj.bottomScroll - _targetObj.scroll;
		setScrollProperties(pageSize, 1, _targetObj.maxscroll);
		//onMouseWheel(0, _targetObj);//做什么用的???!!
		this.percent	=	percent;
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "ScrollText 1.0";
	}
}