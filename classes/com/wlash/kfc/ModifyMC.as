//******************************************************************************
//	name:	ModifyMC 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Sep 17 21:32:54 GMT+0800 2007
//	description: This file was created by "drawPencil.fla" file.
//		
//******************************************************************************


import com.wlash.kfc.ToolLeft;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.kfc.ModifyMC extends MovieClip{
	private var _editMC:MovieClip;
	private var _mcProps:Object;//保存mc的属性
	//private var pressY:Number;
	
	private var frame_mc:MovieClip;
	private var del_btn:Button;
	private var copy_btn:Button;
	private var up_btn:Button;
	private var down_btn:Button;
	private var scale_btn:Button;
	private var rotate_btn:Button;
	
	private static var that:ModifyMC;
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=MovieClip)]
	function set editMC(value:MovieClip):Void{
		if(_editMC==value)	return;
		if(_editMC==null){//原来是空的，也就是没有哪个有修改高亮状态。
			//none.
		}else{//原来就是修改状态的，现改为另一个，如果有修改，记录下来，
			var ret:Object	=	comparePropBefore();//当前对像失去修改的焦点
			dispatchEvent({type:"onModify", changeProp:ret});
		}
		_editMC		=	value;
		if(value==null){
			_visible	=	false;
			return;
		}
		_mcProps	=	saveMovieClipProp(value);
		_visible	=	true;
		_x			=	value._x2;
		_y			=	value._y2;
		frame_mc._xscale	=	value.initWidth*value._xscale/100;
		frame_mc._yscale	=	value.initHeight*value._yscale/100;
		_rotation			=	value._rotation;
		if(value.type=="word"){
			rotate_btn._visible	=	false;
		}else{
			rotate_btn._visible	=	true;
		}
		updateFrame();
		
	}
	/**Annotation */
	function get editMC():MovieClip{
		return _editMC;
	}
	
	////////////////////////[mx.events.EventDispatcher]\\\\\\\\\\\\\\\\\\\\\\\\\
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(ModifyMC.prototype);
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function ModifyMC(){
		that	=	this;
		_visible	=	false;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		del_btn.onRelease=function(){
			ToolLeft.that.deleteMC(that._editMC);
		}
		del_btn.onRollOver=function(){
			ToolLeft.that.hintsMC.show("删除");
		}
		del_btn.onRollOut=del_btn.onReleaseOutside=function(){
			ToolLeft.that.hintsMC.hide();
		}
		
		copy_btn.onRelease=function(){
			//trace("copy: Release "+that._editMC)
			ToolLeft.that.copyMC(that._editMC);
		}
		copy_btn.onRollOver=function(){
			ToolLeft.that.hintsMC.show("复制");
		}
		copy_btn.onRollOut=copy_btn.onReleaseOutside=function(){
			ToolLeft.that.hintsMC.hide();
		}
		
		up_btn.onRelease=function(){
			ToolLeft.that.upDepthMC(that._editMC);
		}
		up_btn.onRollOver=function(){
			ToolLeft.that.hintsMC.show("移上一层");
		}
		up_btn.onRollOut=up_btn.onReleaseOutside=function(){
			ToolLeft.that.hintsMC.hide();
		}
		
		down_btn.onRelease=function(){
			ToolLeft.that.downDepthMC(that._editMC);
		}
		down_btn.onRollOver=function(){
			ToolLeft.that.hintsMC.show("移下一层");
		}
		down_btn.onRollOut=down_btn.onReleaseOutside=function(){
			ToolLeft.that.hintsMC.hide();
		}
		
		scale_btn.onPress=function(){
			that.startScale();
		}
		scale_btn.onRelease=scale_btn.onReleaseOutside=function(){
			that.stopScale();
		}
		scale_btn.onRollOver=function(){
			ToolLeft.that.hintsMC.show("缩放");
		}
		scale_btn.onRollOut=scale_btn.onReleaseOutside=function(){
			ToolLeft.that.hintsMC.hide();
		}
		rotate_btn.onPress=function(){
			that.startRotate();
		}
		rotate_btn.onRelease=rotate_btn.onReleaseOutside=function(){
			that.stopRotate();
		}
		rotate_btn.onRollOver=function(){
			ToolLeft.that.hintsMC.show("旋转");
		}
		rotate_btn.onRollOut=rotate_btn.onReleaseOutside=function(){
			ToolLeft.that.hintsMC.hide();
		}
		frame_mc.onPress=function(){
			that.startMove();
		}
		frame_mc.onRelease=frame_mc.onReleaseOutside=function(){
			that.stopMove();
		}
		frame_mc.useHandCursor	=	false;
	}
	
	private function startScale(){//居中放大，所以移动的距离要*2
		var pressWidth:Number	=	frame_mc._width - this._xmouse*2;
		var pressHeight:Number	=	frame_mc._height - this._ymouse*2;
		this.onMouseMove=function(){
			frame_mc._width		=	this._xmouse*2 + pressWidth;
			frame_mc._height	=	this._ymouse*2 + pressHeight;
			updateMC();
		}
	}
	
	private function stopScale(){
		delete this.onMouseMove;
	}
	
	
	private function startRotate(){
		var pressX:Number		=	_parent._xmouse - _x;
		var pressY:Number		=	_parent._ymouse - _y;
		var rad0:Number			=	Math.atan2 (pressY, pressX);
		var initAngle:Number	=	this._rotation;
		this.onMouseMove=function(){
			//var rad1:Number		=	Math.atan2 (_parent._ymouse - _y, _parent._xmouse - _x);
			_editMC._rotation2	=	
			this._rotation		=	initAngle+(Math.atan2 (_parent._ymouse - _y, _parent._xmouse - _x) - rad0)*(180/Math.PI);
			
		}
	}
	
	private function stopRotate(){
		delete this.onMouseMove;
		delete this.onMouseUp;
	}
	
	private function startMove(){
		var pressX:Number	=	this._xmouse;
		var pressY:Number	=	this._ymouse;
		this.onMouseMove=function(){
			var offsetX	=	this._xmouse - pressX;
			var offsetY	=	this._ymouse - pressY;
			this._x		+=	offsetX;
			this._y		+=	offsetY;
			_editMC._x	+=	offsetX;
			_editMC._y	+=	offsetY;
		}
	}
	
	private function stopMove(){
		delete this.onMouseMove;
	}
	
	//////update
	private function updateMC(){
		_editMC._xscale2	=	(frame_mc._xscale-_editMC.initWidth)/_editMC.initWidth*100+100;
		_editMC._yscale2	=	(frame_mc._yscale-_editMC.initHeight)/_editMC.initHeight*100+100;
		updateFrame();
	}
	private function updateFrame(){
		var fWidth2:Number	=	frame_mc._width/2;
		var fHeight2:Number	=	frame_mc._height/2;
		rotate_btn._x	=	fWidth2;
		rotate_btn._y	=	-fHeight2;//右上角
		scale_btn._x	=	fWidth2;
		scale_btn._y	=	fHeight2;//右下角
		del_btn._x		=	-fWidth2;
		copy_btn._y		=	
		up_btn._y		=	
		down_btn._y		=	
		del_btn._y		=	fHeight2;//左下角
		//copy_btn._x		=	del_btn._x+del_btn._width+2;
		up_btn._x		=	del_btn._x+del_btn._width+2;
		down_btn._x		=	up_btn._x+up_btn._width+2;
	}
	//***********************[PUBLIC METHOD]**********************************//
	public static function saveMovieClipProp(mc:MovieClip):Object{
		var mcProps:Object	=	null;
		if(mc==null){
			return	mcProps;
		}
		mcProps	=	{};
		switch(mc.type){
			case "pencil":
			case "pen":
			case "line":
			case "brush":
				mcProps.lineColor	=	mc.color.getRGB();
				mcProps.lineAlpha	=	mc._alpha;
				break;
			case "rent":
			case "oval":
				for(var prop:String in mc.propretyObj){
					mcProps[prop]	=	mc.propretyObj[prop];
				}
				break;
			case "word":
				mcProps.shapeColor	=	mc.txt.getTextFormat().color;
				break;
			case "element"://bugs: 如果用户更改了颜色，必影响整个对像
				mcProps.shapeColor	=	mc.color.getRGB();
				mcProps.shapeAlpha	=	mc._alpha;
				break;
			default:
				trace("ERROR: what type of "+mc+" | "+mc.type);
		}
		//share properties.
		mcProps._x2			=	mc._x2;
		mcProps._y2			=	mc._y2;
		mcProps._xscale2	=	mc._xscale2;
		mcProps._yscale2	=	mc._yscale2;
		mcProps._rotation2	=	mc._rotation2;
		return mcProps;
	}
	
	private function comparePropBefore():Object{
		var mcProps:Object	=	saveMovieClipProp(_editMC);
		var retObj:Object	=	{};
		for(var prop:String in _mcProps){
			if(mcProps[prop]!=_mcProps[prop]){
				retObj[prop]	=	{oldValue:_mcProps[prop], newValue:mcProps[prop]};
				//trace("retObj.prop: "+prop+", retObj.prop"+retObj[prop])
			}
		}
		return retObj;
	}
	
	//***********************[STATIC METHOD]**********************************//
	/**
	 * Main method for executing code.
	 */
	public static function main():Void{
		var selfClass:ModifyMC	=	new ModifyMC();
	}	
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
