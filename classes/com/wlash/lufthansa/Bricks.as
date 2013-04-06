//******************************************************************************
//	name:	Bricks 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Sep 28 16:16:46 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


import mx.transitions.Tween;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.lufthansa.Bricks extends MovieClip{
	private var brickBox:Array;
	private var widthNum:Number;
	private var heightNum:Number;
	
	private var speedFrame:Number;
	private var iCountFrame:Number;
	
	private var curWidthIndex:Number;
	private var curHeightIndex:Number;
	
	private var interID:Number;
	
	
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Bricks.prototype);
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function Bricks(){
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		//build(15, 15, 650, 340);
	}
	
	private function drawBrick(mc:MovieClip, width:Number, height:Number):Void{
		mc.beginFill(100, 100);
		mc.lineStyle(0, 0xFFFFFF, 100)
		mc.lineTo(width, 0);
		mc.lineTo(width, height);
		mc.lineTo(0, height);
		mc.lineTo(0, 0);
		mc.endFill();
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function build(wNum:Number, hNum:Number, width:Number, height:Number):Void{
		brickBox	=	[];
		var mc:MovieClip;
		widthNum	=	wNum;
		heightNum	=	hNum;
		var bWidth:Number	=	width/wNum;//brick width
		var bHeight:Number	=	height/hNum;//brick width
		for(var h:Number=0;h<hNum;h++){
			for(var w:Number=0;w<wNum;w++){
				mc	=	createEmptyMovieClip("b_"+w+"_"+h, w+h*wNum);
				drawBrick(mc, bWidth, bHeight);
				mc._x	=	w*bWidth;
				mc._y	=	h*bHeight;
				brickBox.push(mc);
			}
		}
		fadeOut1(1)
	}
	/**
	 * 参照num的速度来消失,从上往下斜着消失.
	 * 
	 * @param   num 
	 * @return  
	 */
	public function fadeOut1(num:Number){
		speedFrame	=	num;
		iCountFrame		=	
		curWidthIndex	=	
		curHeightIndex	=	0;
		//this.onEnterFrame=_fadeOut0;
		clearInterval(interID);
		
		interID=setInterval(this, "_fadeOut1", 10, widthNum+heightNum);
	}
	
	private function _fadeOut1(totalNum:Number):Void{
		var mc:MovieClip;
		var lastMC:MovieClip;
		var w:Number;
		var h:Number;
		var len:Number	=	curHeightIndex+1;
		//var startNum:Number	=	curHeightIndex>heightNum-1 ? 
		//				heightNum : 0;
		//trace("startNum: "+startNum);
		for(var i:Number=0;i<len;i++){
			
			h	=	i;
			
			w	=	curHeightIndex-i;
			mc	=	this["b_"+w+"_"+h];
			//trace([mc._name, w, h])
			//if(w>widthNum-1){
				
				//break;
			//}
			_fadeOutBrick0(mc);
			//trace([lastMC._name, mc._name])
			if(lastMC instanceof MovieClip){
				if(mc==null){
					break;
				}
			}
			lastMC	=	mc;
		}

		if(++curHeightIndex>=totalNum){
			dispatchEvent({type:"onFinishFadeOut"});
			clearInterval(interID);
		}
	}
	
	/**
	 * 参照num的速度来消失,从左到右,竖着消失
	 * 
	 * @param   num 
	 * @return  
	 */
	public function fadeOut0(num:Number){
		speedFrame	=	num;
		iCountFrame		=	
		curWidthIndex	=	
		curHeightIndex	=	0;
		//this.onEnterFrame=_fadeOut0;
		clearInterval(interID);
		interID=setInterval(this, "_fadeOut0", 5);
	}
	
	private function _fadeOut0():Void{
		if(iCountFrame++%speedFrame==0){
			var mc:MovieClip;//	=	this["b_"+curWidthIndex+"_"+curHeightIndex];
			for(var h:Number=0;h<heightNum;h++){
				mc	=	this["b_"+curWidthIndex+"_"+h];
				curHeightIndex	=	h;
				_fadeOutBrick0(mc);
			}
			curWidthIndex++;//trace([curHeightIndex, curWidthIndex])
			if(curHeightIndex==heightNum-1){
				if(curWidthIndex==widthNum-1){
					dispatchEvent({type:"onFinishFadeOut"});
					delete this.onEnterFrame;
					clearInterval(interID);
				}
			}
		}
	}
	
	private function _fadeOutBrick0(mc:MovieClip):Void{
		mc.tw	=	new Tween(mc, "_xscale2", 
							mx.transitions.easing.Strong.easeOut,
							100, 0, 1, true);
		mc.xreg	=	mc._width/2;
		mc.yreg	=	mc._height/2;
		mc.tw.addListener(mc);
		mc.onMotionChanged=function(tw:Tween){
			this._yscale2	=	this._xscale2;
		}
	}
	
	public function delBricks():Void{
		//**开始brickBox[Array]循环体**\\
		var arr:Array		=	brickBox;//Array 对象的局部引用。
		var len:Number		=	arr.length;//brickBox里对象的总数
		var obj:MovieClip	=	null;//brickBox[i]内的某个具体对象
		for(var i:Number=0; i<len; i++){
			obj		=	arr[i];
			obj.removeMovieClip();
		}
		//**结束brickBox[Array]循环体**\\
	}
	//***********************[STATIC METHOD]**********************************//

	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
