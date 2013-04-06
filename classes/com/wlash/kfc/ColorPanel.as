//******************************************************************************
//	name:	ColorPanel 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 13 23:48:55 GMT+0800 2007
//	description: This file was created by "paint.fla" file.
//		
//******************************************************************************

import com.wangfan.utils.scroll.ScrollBar;
import flash.filters.DropShadowFilter;

/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.kfc.ColorPanel extends MovieClip{
	private var colorBox_mc:MovieClip;
	private var lineColor_mc:MovieClip;
	private var shapeColor_mc:MovieClip;
	private var hoverColor_mc:MovieClip;
	private var scroll_mc:MovieClip;
	private var dragBar_mc:MovieClip;
	private var scroll_com:ScrollBar;
	private var brickWidth:Number	=	10;
	private var oldColor:Number	=	null;
	
	private static var curItem:MovieClip;
	private static var curLineColor:Number;
	private static var curLineAlpha:Number;
	private static var curShapeColor:Number;
	private static var curShapeAlpha:Number;
	public  static var that:ColorPanel;
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set lineColor(value:Number):Void{
		lineColor_mc.colorObj_mc.color.setRGB(value);
	}
	/**Annotation */
	function get lineColor():Number{
		
		return lineColor_mc.colorObj_mc.color.getRGB();
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set lineAlpha(value:Number):Void{
		lineColor_mc.colorObj_mc._alpha	=	value;
	}
	/**Annotation */
	function get lineAlpha():Number{
		return lineColor_mc.colorObj_mc._alpha;
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set shapeColor(value:Number):Void{
		shapeColor_mc.colorObj_mc.color.setRGB(value);
	}
	/**Annotation */
	function get shapeColor():Number{
		return shapeColor_mc.colorObj_mc.color.getRGB();
	}
	
	[Inspectable(defaultValue=0, verbose=1, type=Number)]
	function set shapeAlpha(value:Number):Void{
		shapeColor_mc.colorObj_mc._alpha	=	value;
	}
	/**Annotation */
	function get shapeAlpha():Number{
		return shapeColor_mc.colorObj_mc._alpha;
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(ColorPanel.prototype);
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function ColorPanel(){
		that	=	this;
		init();
		loadState();
	}
	private function init():Void{
		buildColor();
		initCurColorEvent();
		dragEnabled(true);
		this.onEnterFrame=function(){
			//alpha
			renderScroll(curItem.colorObj_mc._alpha)
			scroll_com.addEventListener("onScroll", this);
			delete this.onEnterFrame;
		}
	}
	//************************[PRIVATE METHOD]********************************//
	

	private function buildColor():Void{
		var mc:MovieClip;
		var i:Number	=	0;
		for(var a:Number=0;a<16;a+=3){
			for(var b:Number=0;b<16;b+=3){
				for(var c:Number=0;c<16;c+=3){
					mc	=	colorBox_mc.attachMovie("colorBrick", "mc_"+a+"_"+b+"_"+c, i,
									{});
					if(a<=6){
						mc._x	=	a*brickWidth*2+b/3*brickWidth;
						mc._y	=	c/3*brickWidth;
					}else{
						mc._x	=	(a - 9) * brickWidth * 2 + (b / 3 * brickWidth);
						mc._y	=	(brickWidth * 6) + (c / 3 * brickWidth);
					}
					var color	=	new Color(mc);
					var rb = 17 * a;
					var gb = 17 * b;
                    var bb = 17 * c;
                    color.setTransform({rb:rb, gb:gb, bb:bb});
					mc.color	=	color;
					initEvent(mc);
					i++;
				}
			}
		}
	}
	
	private function initEvent(mc:MovieClip){
		mc.onRelease=function(){
			var hoverC:Color	=	that.hoverColor_mc.color;
			var colorValue:Number	=	this.color.getRGB();
			that.renderHover(colorValue);
			curItem.colorObj_mc.color.setRGB(colorValue);
			that.oldColor	=	hoverC.getRGB();
			//curItem.colorObj_mc._visible	=	true;
			that.dispatchEvent({type:"onSelectColor", curItem:curItem, color:colorValue});
		}
		mc.onRollOver=function(){
			var hoverC:Color	=	that.hoverColor_mc.color;
			that.oldColor	=	hoverC.getRGB();
			that.renderHover(this.color.getRGB());
		}
		mc.onRollOut=mc.onReleaseOutside=function(){
			//var hoverC:Color	=	that.hoverColor_mc.color;
			that.renderHover(that.oldColor);
			that.oldColor	=	null;
		}
	}
	
	private function initCurColorEvent(){
		lineColor_mc.onRelease=function(){
			if(curItem==this)	return;
			curShapeColor	=	curItem.colorObj_mc.color.getRGB();
			curShapeAlpha	=	curItem.colorObj_mc._alpha;

			curItem.frame_mc.gotoAndStop("up");
			this.frame_mc.gotoAndStop("down");
			curItem		=	this;
			curItem.colorObj_mc.color.setRGB(curLineColor);
			curItem.colorObj_mc._alpha	=	curLineAlpha;
			that.renderHover(curItem.colorObj_mc.color.getRGB());
			that.renderScroll(curItem.colorObj_mc._alpha);
			
		}
		lineColor_mc.onRollOver=function(){
			that._parent.hints_mc.show("笔解颜色");
			if(curItem==this)	return;
			this.frame_mc.gotoAndStop("over");
		}
		lineColor_mc.onRollOut=lineColor_mc.onReleaseOutside=function(){
			that._parent.hints_mc.hide();
			if(curItem==this)	return;
			this.frame_mc.gotoAndStop("up");
		}
		
		shapeColor_mc.onRelease=function(){
			if(curItem==this)	return;
			curLineColor	=	curItem.colorObj_mc.color.getRGB();
			curLineAlpha	=	curItem.colorObj_mc._alpha;
			curItem.frame_mc.gotoAndStop("up");
			this.frame_mc.gotoAndStop("down");
			curItem		=	this;
			curItem.colorObj_mc.color.setRGB(curShapeColor);
			curItem.colorObj_mc._alpha	=	curShapeAlpha;
			that.renderHover(curItem.colorObj_mc.color.getRGB());
			that.renderScroll(curItem.colorObj_mc._alpha);
		}
		shapeColor_mc.onRollOver=function(){
			that._parent.hints_mc.show("填充颜色");
			if(curItem==this)	return;
			this.frame_mc.gotoAndStop("over");
		}
		shapeColor_mc.onRollOut=shapeColor_mc.onReleaseOutside=function(){
			that._parent.hints_mc.hide();
			if(curItem==this)	return;
			this.frame_mc.gotoAndStop("up");
		}
	}
	
	private function onScroll(evtObj:Object){
		curItem.colorObj_mc._alpha	=	
		scroll_mc.bar_mc.num_txt.text	=	Math.round(evtObj.percent*100);
		dispatchEvent({type:"onChagneAlpha", curItem:curItem, alpha:curItem.colorObj_mc._alpha});
	}
	
	private function renderScroll(percent:Number){
		scroll_com.render(percent/100);
		scroll_mc.bar_mc.num_txt.text	=	Math.round(percent);
		
	}
	private function renderHover(num:Number):Void{
		//hoverColor_mc.color	=	new Color(hoverColor_mc);
		hoverColor_mc.color.setRGB(num);
	}
	
	private function dragEnabled(enabled:Boolean){
		if(enabled){
			dragBar_mc.onPress=function(){
				that.startDrag(false, 0, 0, Stage.width-that._width, Stage.height-that._height);
				that.makeShadow(true);
			}
			dragBar_mc.onRelease=dragBar_mc.onReleaseOutside=function(){
				that.stopDrag();
				that.makeShadow(false);
			}
		}else{
			delete dragBar_mc.onPress;
			delete dragBar_mc.onRelease;
			delete dragBar_mc.onReleaseOutside;
		}
	}
	
	private function makeShadow(isShadow){
		if(!isShadow){
			this.filters = [];
			this._x	+=	1;
			this._y	+=	1;
			return;
		}
		var distance:Number = 3;
		var angleInDegrees:Number = 45;
		var color:Number = 0x000000;
		var alpha:Number = .4;
		var blurX:Number = 2;
		var blurY:Number = 2;
		var strength:Number = 100;
		var quality:Number = 1;
		var inner:Boolean = false;
		var knockout:Boolean = false;
		var hideObject:Boolean = false;

		var filter:DropShadowFilter = new DropShadowFilter(distance, 
															angleInDegrees, 
															color, 
															alpha, 
															blurX, 
															blurY, 
															strength, 
															quality, 
															inner, 
															knockout, 
															hideObject);
		var filterArray:Array = new Array();
		filterArray.push(filter);
		this.filters = filterArray;
		this._x	-=	1;
		this._y	-=	1;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * load state
	 * 
	 */
	public function loadState(obj:Object):Void{
		if(obj==null){
			curItem			=	lineColor_mc;
			curLineColor	=	0x669900;
			curShapeColor	=	0xFB8800;
			curLineAlpha	=	
			curShapeAlpha	=	100;
		}else{
			curItem			=	obj.curItem;
			curLineColor	=	obj.curLineColor;
			curShapeColor	=	obj.curShapeColor;
			curLineAlpha	=	obj.curLineAlpha;
			curShapeAlpha	=	obj.curShapeAlpha;
		}
		lineColor_mc.frame_mc.gotoAndStop("up");
		shapeColor_mc.frame_mc.gotoAndStop("up");
		curItem.frame_mc.gotoAndStop("down");
		var color:Color;
		color	=	
		lineColor_mc.colorObj_mc.color	=	new Color(lineColor_mc.colorObj_mc);
		//trace(lineColor_mc.colorObj_mc.color)
		if(curLineColor>=0){
			lineColor_mc.colorObj_mc._visible	=	true;
			color.setRGB(curLineColor);
			lineColor_mc.colorObj_mc._alpha	=	curLineAlpha;
		}else{//no color
			lineColor_mc.colorObj_mc._visible	=	false;
		}
		color	=	
		shapeColor_mc.colorObj_mc.color	=	new Color(shapeColor_mc.colorObj_mc);
		if(curShapeColor>=0){
			shapeColor_mc.colorObj_mc._visible	=	true;
			color.setRGB(curShapeColor);
			shapeColor_mc.colorObj_mc._alpha	=	curShapeAlpha;
		}else{//no color
			shapeColor_mc.colorObj_mc._visible	=	false;
		}
		//当前色块
		hoverColor_mc.color	=	new Color(hoverColor_mc);
		oldColor	=	curItem.colorObj_mc.color.getRGB();
		renderHover(oldColor);
		
	}
	
	
	//***********************[STATIC METHOD]**********************************//

	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
