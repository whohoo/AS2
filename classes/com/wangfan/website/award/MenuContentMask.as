//******************************************************************************
//	name:	MenuContentMask 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 22:12:19 2006
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;
//import com.wangfan.website.award.LoadXmlMenu;

/**
 * 在award.swf中的动态菜单显示年份下内容的mask.<p></p>
 * 弹性的伸长与缩小。
 */
class com.wangfan.website.award.MenuContentMask extends MovieClip{
	private var _tempHeight:Number			=	0;
	//public  var curHeight:Number			=	0;
	
	public  var maxHeight:Number			=	0;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * CANNOT Create a class BY [new MenuYear();]
	 */
	private function MenuContentMask(){
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		
	}
	
	private function _expandContentMask():Void{
		_tempHeight	=	(((_height-maxHeight)*.5)+_tempHeight)*.5;
		_height		-=	_tempHeight;
		_parent.onExpanding(_height);
		if(Math.abs(_tempHeight)<.1){
			_tempHeight	=	0;
			_height		=	maxHeight;
			onEnterFrame	=	null;
			_parent.onExpandEnd();
		}
	}
	private function _collapseContentMask():Void{
		_tempHeight	=	(_height-maxHeight)*.3;
		_height		-=	_tempHeight;
		_parent.onCollapsing(_height);
		if(Math.abs(_tempHeight)<.1){
			_tempHeight	=	0;
			_height		=	maxHeight;
			onEnterFrame	=	null;
			_parent.onCollapseEnd();
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 把mask伸长
	* @param height 伸长到最大的高度。
	*/
	public function expandContentMask(height:Number):Void{
		maxHeight	=	height;
		onEnterFrame=_expandContentMask;
	}
	/**
	* 把mask缩小到0
	*/
	public function collapseContentMask():Void{
		maxHeight	=	0;
		onEnterFrame=_collapseContentMask;
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
