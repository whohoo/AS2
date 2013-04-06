//******************************************************************************
//	name:	MenuContentMask 1.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 22:12:19 2006
//	description: 
//		增加了dispatchEvent事件
//******************************************************************************


import mx.utils.Delegate;


/**
 * 在join.swf中的动态菜单显示年份下内容的mask.<p></p>
 * 弹性的伸长与缩小。
 */
class com.wangfan.website.join.MenuContentMask extends MovieClip{
	private var _tempHeight:Number			=	0;
	private var _tempWidth:Number			=	0;
	
	private var mcWidth:MovieClip			=	null;
	private var mcHeight:MovieClip			=	null;
	/**mask可以伸展到最大的高度*/
	public  var maxHeight:Number			=	0;
	/**mask可以伸展到最大的宽度*/
	public  var maxWidth:Number			=	0;
	
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(MenuContentMask.prototype);
	
	/**
	 * Construction function.<br></br>
	 * CANNOT Create a class BY [new MenuYear();]
	 */
	private function MenuContentMask(){
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		createEmptyMovieClip("mcWidth", getNextHighestDepth());
		createEmptyMovieClip("mcHeight", getNextHighestDepth());
	}
	
	private function _expandHeightMask():Void{
		_tempHeight	=	(_height-maxHeight)*.5;
		_height		-=	_tempHeight;
		//_parent.onExpanding(_height);
		dispatchEvent({type:"onHeightExpanding", height:_height});
		if(Math.abs(_tempHeight)<.1){
			_tempHeight	=	0;
			_height		=	maxHeight;
			mcHeight.onEnterFrame	=	null;
			//_parent.onExpandEnd();
			dispatchEvent({type:"onHeightExpandEnd", height:_height});
		}
	}
	private function _collapseHeightMask():Void{
		_tempHeight	=	(_height-maxHeight)*.3;
		_height		-=	_tempHeight;
		//_parent.onCollapsing(_height);
		dispatchEvent({type:"onHeightCollapsing", height:_height});
		if(Math.abs(_tempHeight)<.1){
			_tempHeight	=	0;
			_height		=	maxHeight;
			mcHeight.onEnterFrame	=	null;
			//_parent.onCollapseEnd();
			dispatchEvent({type:"onHeightCollapseEnd", height:_height});
		}
	}
	
	private function _expandWidthMask():Void{
		_tempWidth	=	(_width-maxWidth)*.3;
		_width		-=	_tempWidth;
		dispatchEvent({type:"onWidthExpanding", width:_width});
		if(Math.abs(_tempWidth)<.1){
			_tempWidth	=	0;
			_width		=	maxWidth;
			mcWidth.onEnterFrame	=	null;
			dispatchEvent({type:"onWidthExpandEnd", width:_width});
		}
	}
	
	private function _collapseWidthMask():Void{
		_tempWidth	=	(_width-maxWidth)*.3;
		_width		-=	_tempWidth;
		dispatchEvent({type:"onWidthCollapsing", width:_width});
		if(Math.abs(_tempWidth)<.1){
			_tempWidth	=	0;
			_width		=	maxWidth;
			mcWidth.onEnterFrame	=	null;
			dispatchEvent({type:"onWidthCollapseEnd", width:_width});
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 把mask伸长
	* @param height 伸长到最大的高度。
	*/
	public function expandHeightMask(height:Number):Void{
		maxHeight	=	height;
		mcHeight.onEnterFrame=Delegate.create(this, _expandHeightMask);
	}
	/**
	* 把mask缩小到0
	*/
	public function collapseHeightMask():Void{
		maxHeight	=	0;
		mcHeight.onEnterFrame=Delegate.create(this, _collapseHeightMask);
	}
	
	/**
	* 把mask伸长
	* @param height 伸长到最大的高度。
	*/
	public function expandWidthMask(width:Number):Void{
		maxWidth	=	width;
		mcWidth.onEnterFrame=Delegate.create(this, _expandWidthMask);
	}
	
	/**
	* 把mask缩小到304
	*/
	public function collapseWidthMask():Void{
		maxWidth	=	314;
		mcWidth.onEnterFrame=Delegate.create(this, _collapseWidthMask);
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
