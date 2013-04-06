//******************************************************************************
//	name:	ToolLeft 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Sep 15 14:23:29 GMT+0800 2007
//	description: This file was created by "paint.fla" file.
//		
//******************************************************************************


//import com.idescn.draw.ExShape;
import flash.display.BitmapData;
import com.wlash.kfc.PaintAction;
import com.wlash.kfc.ModifyMC;
import mx.utils.Delegate;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.kfc.ToolLeft extends MovieClip{
	private var toolNames:Array;
	private var layers:Array;
	private var topDepth:Number;//已经画到最高层的数值
	private var startPosX:Number;
	private var startPosY:Number;
	private var endPosX:Number;
	private var endPosY:Number;
	private var _thickness:Number;
	private var _curToolName:String;//当前状态下的名称
	private var curOption:MovieClip;
	private var isMoveMouse:Boolean;
	private var interBrush:Number;//画brush时调用的setInterval
	private var pressKeyObj:Object;
	public var paintAction:PaintAction;
	public var loader_mcl:MovieClipLoader;//load extend element
	
	private static var curLayer:MovieClip;
	private static var curTool:MovieClip;
	public  static var that:ToolLeft;
	private static var mcBlackBG:MovieClip;//黑色背景
	private static var isOverWorkArea:Boolean;//黑色背景
	
	public var board:MovieClip;
	public var paintMC:MovieClip;
	public var colorPanel:MovieClip;
	public var tips:MovieClip;
	public var hintsMC:MovieClip;//mouse over
	public var styleMC:MovieClip;
	public var mcModify:MovieClip;//edit mc
	//public var toolRight:ToolRight;
	
	public var checkBox_mc:MovieClip;
	public var optionBox_mc:MovieClip;
	public var mcMouseStyle:MovieClip;
	//public var pencil_mc:MovieClip;
	//public var pen_mc:MovieClip;
	//public var line_mc:MovieClip;
	//public var brush_mc:MovieClip;
	//public var rent_mc:MovieClip;
	//public var oval_mc:MovieClip;
	//public var word_mc:MovieClip;
	public var redo_mc:MovieClip;
	public var undo_mc:MovieClip;
	//************************[READ|WRITE]************************************//
	[Inspectable(defaultValue="", verbose=1, type=String)]
	function set curToolName(value:String):Void{
		_curToolName	=	value
	}
	/**当前状态下的名称 */
	function get curToolName():String{
		return _curToolName;
	}
	
	//************************[READ ONLY]*************************************//

	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function ToolLeft(){
		
		paintMC		=	_parent.mainBoard_mc.paint_mc;
		board		=	paintMC.content_mc;
		mcBlackBG	=	_parent.mainBoard_mc.blackBG_mc;
		tips		=	_parent.tips_mc;
		hintsMC		=	_parent.hints_mc;
		styleMC		=	_parent.style_mc;
		colorPanel	=	_parent.colorPanel_mc;
		mcMouseStyle=	_parent.mouseStyle_mc;
		that		=	this;
		pressKeyObj	=	{};
		loader_mcl	=	new MovieClipLoader();
		loader_mcl.addListener(this);
		init();
		showOption();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		toolNames	=	["pencil", "pen", "line", "brush", "rent", "oval", "word", "modify",
							"preview", "zoom", "hand", "redo", "undo", "new"];
		
		layers		=	[];
		paintAction		=	new PaintAction(this);
		paintMC.initX	=	paintMC._x;
		paintMC.initY	=	paintMC._y;//记录初始位置,方便在preview与缩小时重置大小
		mcMouseStyle.onEnterFrame=function(){
			if(!isWorkArea()){//在工作区外
				if(this.mcStyle!=null){
					this.mcStyle._visible	=	false;
					Mouse.show();
				}
			}else{//工作区内
				if(this.mcStyle!=null){
					this.mcStyle._visible	=	true;
					Mouse.hide();
				}
				this._x		=	_root._xmouse;
				this._y		=	_root._ymouse;
			}
		}
		initToolIcon();
		enabledKey(true);
	}
	
	private function initToolIcon(){
		var len:Number	=	toolNames.length;
		var mc:MovieClip;
		var tName:String;
		var hintsNames:Array	=	["铅笔", "钢笔", "直线", "笔刷", "多边形", "椭圆", "文字", "修改",
									"预览", "放大/缩小", "移动", "重做", "撤消", "新建"];
		for(var i:Number=0;i<len;i++){
			tName	=	toolNames[i];
			mc		=	this[tName+"_mc"];
			mc.index	=	i;
			mc.tName	=	tName;
			mc.hintsName	=	hintsNames[i];//trace([mc, mc.hintsName])
			if(tName=="preview" || tName=="redo" || tName=="undo" || tName=="new"){
				mc.onRelease=function(){
					that["make_"+this.tName]();
				}
				mc.onRollOver=function(){
					that.hintsMC.show(this.hintsName);
					if(curTool==this)	return;
					this.iconBG_mc.gotoAndStop("over");
				}
				mc.onRollOut=mc.onReleaseOutside=function(){
					that.hintsMC.hide();
					if(curTool==this)	return;
					this.iconBG_mc.gotoAndStop("up");
				}
			}else{
				mc.onRelease=function(){
					if(curTool==this){
						that["end_"+curToolName]();
						that.curToolName	=	null;
						that.mouseStyle(null);
						that.showOption(null);
						that.tips.show("");
						this.iconBG_mc.gotoAndStop("up");
						curTool	=	null;
						return;
					}
					curTool.iconBG_mc.gotoAndStop("up");
					this.iconBG_mc.gotoAndStop("down");
					
					curTool	=	this;
					that["make_"+this.tName]();
				}	
				mc.onRollOver=function(){//trace([this, this.hintsName])
					that.hintsMC.show(this.hintsName);
					if(curTool==this)	return;
					this.iconBG_mc.gotoAndStop("over");
				}
				mc.onRollOut=mc.onReleaseOutside=function(){
					that.hintsMC.hide();
					if(curTool==this)	return;
					this.iconBG_mc.gotoAndStop("up");
				}
			}
		}
		undo_mc.gotoAndStop("disabled");//gray , means unuse.
		redo_mc.gotoAndStop("disabled");
		undo_mc.enabled	=	
		redo_mc.enabled	=	false;
	}
	
	private function createLayer():MovieClip{
		var depth:Number	=	layers.length;
		var mc:MovieClip	=	board.createEmptyMovieClip("mcLayer"+depth, depth);
		//mc.createEmptyMovieClip("mcLine", 20);
		//mc.createEmptyMovieClip("mcShape", 10);
		return mc;
	}
	public function deleteMC(mc:MovieClip):Void{
		//mc.removeMovieClip();
		//trace("deleteMC: "+mc)
		mcModify._visible	=	
		mc._visible			=	false;
		paintAction.addAction({mc:mc, act:"del"});
	}
	public function removeMC(mc:MovieClip):Void{
		mc.state	=	"DEL";
		/*var len:Number	=	layers.length;
		var mc0:MovieClip;
		
		for(var i:Number=0;i<len;i++){
			mc0	=	layers[i];
			if(mc0==mc){
				layers.splice(i, 1);
				mc.removeMovieClip();
				return;
			}
		}*/
		//trace("Func|removeMC|can't found: "+mc);
	}
	public function copyMC(mc:MovieClip):Void{
		var depth:Number	=	layers.length;
		var mc0:MovieClip	=	mc.duplicateMovieClip("mcCopy"+depth, depth, 
										{xreg:mc.xreg, yreg:mc.yreg, 
										initWidth:mc.initWidth, initHeight:mc.initHeight,
										_x:mc._x+20, _y:mc._y+20, type:mc.type});
		mc0.path	=	mc.path;
		mc0.path	=	mc.path;
		mc0.drawPoints	=	mc.drawPoints;
		mc0.propretyObj	=	{};
		for(var prop:String in mc.propretyObj){
			mc0.propretyObj[prop]	=	mc.propretyObj[prop];
		}
		layers.push(mc0);
		//trace(mc0)
		paintAction.addAction({mc:mc0, act:"add"});
	}
	public function upDepthMC(mc:MovieClip):Void{
		var curDepth:Number	=	mc.getDepth();
		var len:Number	=	topDepth;
		var nextMC:MovieClip;
		for(var i:Number=curDepth+1;i<=len;i++){
			nextMC	=	board.getInstanceAtDepth(i);
			if(nextMC instanceof MovieClip){
				if(!nextMC._visible)	continue;//已经被删除
				mc.swapDepths(nextMC);
				break;
			}
		}
	}
	public function downDepthMC(mc:MovieClip):Void{
		var curDepth:Number	=	mc.getDepth();
		var len:Number	=	topDepth;
		var nextMC:MovieClip;
		for(var i:Number=curDepth-1;i>=0;i--){
			nextMC	=	board.getInstanceAtDepth(i);
			if(nextMC instanceof MovieClip){
				if(!nextMC._visible)	continue;//已经被删除
				mc.swapDepths(nextMC);
				break;
			}
		}
	}
	/////onEndDraw
	private function onEndDraw():Void{
		if(curLayer==null)	return;
		layers.push(curLayer);
		var bounds:Object	=	curLayer.getBounds(board);//得到中心点
		curLayer.xreg	=	(bounds.xMax-bounds.xMin)/2+bounds.xMin;
		curLayer.yreg	=	(bounds.yMax-bounds.yMin)/2+bounds.yMin;
		curLayer.initWidth	=	curLayer._width;
		curLayer.initHeight	=	curLayer._height;
		topDepth	=	curLayer.getDepth();
		//trace("onEndDraw: "+layers)
		paintAction.addAction({mc:curLayer, act:"add"});
		undo_mc.gotoAndStop("enabled");
		undo_mc.enabled	=	true;
		curLayer		=	null;
	}
	
	private function mouseStyle(styleName:String){
		if(styleName!=null){//trace(styleName)
			mcMouseStyle["mcStyle"]	=	mcMouseStyle.attachMovie(styleName, "mcStyle", 0, {_visible:false});
			//Mouse.hide();
		}else{
			Mouse.show();
			mcMouseStyle.mcStyle.removeMovieClip();
			mcMouseStyle.mcStyle	=	null;
		}
	}
	private function showOption(name:String){
		var len:Number	=	toolNames.length;
		var mc:MovieClip;
		for(var i:Number=0;i<len;i++){
			mc	=	optionBox_mc[toolNames[i]+"_mc"];
			if(toolNames[i]==name){
				mc._visible	=	true;
				curOption	=	mc;
			}else{
				mc._visible	=	false;
			}
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	///////////********TOOL LEFT
	public function make_pencil():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"pencil";
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		tips.show("当前工具：铅笔，在画布上拖动画出线条。");
		board.onMouseDown=function(){
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer	=	that.createLayer();
				curLayer.path		=	[{x:this._xmouse, y:this._ymouse}];
				curLayer.type		=	"pencil";
				that.setLineStyle(curLayer);
				var cPanel:MovieClip	=	that.colorPanel;
				var obj:Object	=	curLayer.path[0];
				if(that.curOption.checkBox_mc.isCheck){//已经勾选，笔触.
					curLayer.lineStyle(0, 0, 100);
					curLayer.lastEndX	=	obj.x;
					curLayer.lastEndY	=	obj.y;
					curLayer.curThick	=	0;
				}else{
					curLayer.lineStyle(that.curOption.thickness, 0, 100);
				}
				
				curLayer.moveTo(obj.x, obj.y);
				that.isMoveMouse	=	false;
			}else{
				
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse			=	true;
				that.drawPencil(this._xmouse, this._ymouse);
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				if(that.isMoveMouse==false){//mouse no moving
					curLayer.removeMovieClip();
					curLayer	=	null;
				}else{
					that.end_pencil();
				}
			}
		}
	}
	private function drawPencil(x:Number, y:Number){
		if(curOption.checkBox_mc.isCheck){//已经勾选，笔触.
			var penAdd:Number	=	(15 - getDistance(x, y, curLayer.lastEndX, curLayer.lastEndY)) / 8;
			penAdd	=	Math.min(3, Math.max(penAdd, -3));
			if (Math.abs(penAdd) > 1) {
				curLayer.penAdd	=	penAdd;
			}else{
				penAdd	=	curLayer.penAdd;
			}
			var offsetX:Number;
			var offsetY:Number;
			var iCount:Number;
			var cPanel:MovieClip	=	colorPanel;
			if (penAdd > 0) {
				iCount	=	0;
				while (iCount < penAdd) {
					offsetX = ((x - curLayer.lastEndX) / Math.abs(penAdd)) * (penAdd - iCount);
					offsetY = ((y - curLayer.lastEndY) / Math.abs(penAdd)) * (penAdd - iCount);
					if (curLayer.curThick <= curOption.thickness) {
						curLayer.lineStyle(++curLayer.curThick, 0, 100);
						curLayer.lineTo(x - offsetX, y - offsetY);
					} else {
						curLayer.lineTo(x, y);
						break;
					 }
					iCount++;
				}
			} else {
				iCount = penAdd;
				while (iCount < 0) {
					offsetX = ((x - curLayer.lastEndX) / Math.abs(penAdd)) * iCount;
					offsetY = ((y - curLayer.lastEndY) / Math.abs(penAdd)) * iCount;
					if (curLayer.curThick > 1) {
						curLayer.lineStyle(--curLayer.curThick, 0, 100);
						curLayer.lineTo(x + offsetX, y + offsetY);
					} else {
						curLayer.lineTo(x, y);
						break;
					}
					iCount++;
				}
			 }
			curLayer.lastEndX = x;
			curLayer.lastEndY = y;
		}else{
			curLayer.lineTo(x, y);
		}
		//curLayer.path.push({x:x,y:y});
	}
	public function make_pen():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"pen";
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		tips.show("当前工具：钢笔，在画布上拖动画出曲线。");
		board.onMouseDown=function(){
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer	=	that.createLayer();
				curLayer.path	=	[{startX:this._xmouse, startY:this._ymouse}];
				curLayer.type	=	"pen";
				that.setLineStyle(curLayer);
				
				that.isMoveMouse	=	false;
			}else {
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse	=	true;
				var obj:Object	=	curLayer.path[curLayer.path.length-1];
				//trace(["onMouseMove: ", obj.endX, obj.ctrlX])
				if(obj.endX==null){
					that.drawPenEndPoint(this._xmouse, this._ymouse, false);
				}else if(obj.ctrlX==null){
					that.drawPenCtrlPoint(this._xmouse, this._ymouse, false);
				}
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				if(that.isMoveMouse==false){//mouse no moving
					curLayer.removeMovieClip();
					curLayer	=	null;
				}else{
					var obj:Object	=	curLayer.path[curLayer.path.length-1];
					if(obj.endX==null){
						that.drawPenEndPoint(this._xmouse, this._ymouse, true);
					}else if(obj.ctrlX==null){
						that.drawPenCtrlPoint(this._xmouse, this._ymouse, true);
					}
				}
			}
		}
	}
	private function drawPenEndPoint(x:Number, y:Number, isMouseUp){
		drawCurve();
		var obj:Object	=	curLayer.path[curLayer.path.length-1];
		if(obj.startX==x){
			if(obj.startY==y){
				return;
			}
		}
		if(isMouseUp){
			obj.endX	=	x;
			obj.endY	=	y;
		}
		curLayer.moveTo(obj.startX, obj.startY);
		curLayer.lineTo(x, y);
	}
	private function drawPenCtrlPoint(x:Number, y:Number, isMouseUp){
		drawCurve();
		var obj:Object	=	curLayer.path[curLayer.path.length-1];
		if(isMouseUp){
			obj.ctrlX	=	x;
			obj.ctrlY	=	y;
		}
		//trace([isMouseUp, obj.startX, obj.startY, obj.ctrlX, y, x, y])
		drawCurve3Pts(curLayer, obj.startX, obj.startY, x, y, obj.endX, obj.endY);
		if(isMouseUp){//终止
			if(!curOption.checkBox_mc.isCheck){//没勾选，非连笔.
				end_pen();//结束此层
			}else{//已经勾选，连笔.
				var obj:Object	=	curLayer.path[curLayer.path.length-1];
				//trace("连 new "+[obj.ctrlX, curLayer.path.length])
				curLayer.path.push({startX:obj.endX, startY:obj.endY});
			}
		}
	}
	private function drawCurve(){//draw all curve
		var cPanel:MovieClip	=	colorPanel;
		curLayer.clear();
		curLayer.lineStyle(curOption.thickness, 0, 100);
		var path:Array	=	curLayer.path;
		var obj:Object;
		//curLayer.moveTo(obj.x, obj.y);
		var len:Number	=	path.length;
		for(var i:Number=0;i<len;i++){
			obj	=	curLayer.path[i];
			if(obj.endX==null){
				continue;
			}else if(obj.ctrlX==null){
				continue;
			}
			drawCurve3Pts(curLayer, obj.startX, obj.startY, obj.ctrlX, obj.ctrlY, obj.endX, obj.endY);
		}
		
	}
	public function make_line():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"line";//trace("curToolName: "+curToolName+" func: "+endFunc)
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		tips.show("当前工具：直线，在画布上拖动画出直线。");
		board.onMouseDown=function(){
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer		=	that.createLayer();
				curLayer.path	=	[{x:this._xmouse, y:this._ymouse}];
				curLayer.type	=	"line";
				that.setLineStyle(curLayer);
				that.isMoveMouse			=	false;
			}else{
				
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse			=	true;
				curLayer.clear();
				that.drawLine(this._xmouse, this._ymouse);
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				if(that.isMoveMouse==false){//mouse no moving
					curLayer.removeMovieClip();
					curLayer	=	null;
				}else{
					if(that.curOption.checkBox_mc.isCheck){//已经勾选，连笔.
						curLayer.path.push({x:this._xmouse, y:this._ymouse});
					}else{
						that.end_line();
					}
				}
			}
		}
	}
	private function drawLine(x1:Number, y1:Number){
		var cPanel:MovieClip	=	colorPanel;
		curLayer.lineStyle(curOption.thickness, 0, 100);
		var path:Array	=	curLayer.path;
		var obj:Object	=	path[0];
		curLayer.moveTo(obj.x, obj.y);
		var len:Number	=	path.length;
		for(var i:Number=1;i<len;i++){
			obj	=	curLayer.path[i];
			curLayer.lineTo(obj.x, obj.y);
		}
		curLayer.lineTo(x1, y1);
	}
	private function setLineStyle(mc:MovieClip){//only for line
		mc.color	=	new Color(mc);
		mc.color.setRGB(colorPanel.lineColor);
		mc._alpha	=	colorPanel.lineAlpha;
	}
	
	public function make_brush():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"brush";
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		styleMC.setBrush();
		tips.show("当前工具：笔刷，在画布上拖动画出下方的笔刷样式。");
		board.onMouseDown=function(){
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer	=	that.createLayer();
				curLayer.path			=	[{x:this._xmouse, y:this._ymouse}];
				curLayer.iCount	=	0;
				that.drawBrush(this._xmouse, this._ymouse);
				that.isMoveMouse			=	false;
			}else{
				
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse			=	true;
				that.drawBrush(this._xmouse, this._ymouse);
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.end_brush();
			}
		}
	}
	
	private function drawBrush(x:Number, y:Number){
		curLayer.color	=	new Color(curLayer);
		curLayer.color.setRGB(colorPanel.lineColor);
		curLayer._alpha	=	colorPanel.lineAlpha;
		curLayer._onEnterFrame=function(){
			var mc	=	this.attachMovie("brush_style", "mcStyle"+this.iCount, this.iCount, {});
			var curFrame	=	that.styleMC.curBrushFrame;
			if(curFrame==null){
				curFrame	=	1;
			}
			mc.gotoAndStop(curFrame);
			mc._x	=	x;
			mc._y	=	y;
			mc.initWidth	=	mc._width;
			mc.initHeight	=	mc._height;
			mc._width		=	that.curOption.size+5;
			mc._yscale	=	mc._width/mc.initWidth*100;
			//mc._yscale	=	mc.initHeight/that.curOption.size*100;
			mc._rotation	=	random(360);
			this.iCount++;
			updateAfterEvent();
		}
		clearInterval(interBrush);
		interBrush=setInterval(curLayer, "_onEnterFrame", 10);
		curLayer._onEnterFrame();
	}
	////////RENT
	public function make_rent():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"rent";
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		tips.show("当前工具：多边形工具，在画布上拖动画出多边形。");
		board.onMouseDown=function(){
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer		=	that.createLayer();
				curLayer.path	=	[{x:this._xmouse, y:this._ymouse}];
				curLayer.type	=	"rent";
				//var cPanel:MovieClip	=	that.colorPanel;
				var refMC:MovieClip;
				//refMC.beginFill(cPanel.shapeColor, cPanel.shapeAlpha);
				var obj:Object	=	curLayer.path[0];
				//trace([curLayer, curOption, cPanel.lineColor, cPanel.lineAlpha])
				var cPosX:Number	=	 obj.x;
				var cPosY:Number	=	 obj.y;
				//临时画的，得到宽与高。
				//that.curOption.side	=	3;that.curOption.thickness=5;
				if(that.curOption.side==4){
					//refMC.initWidth		=	
					//refMC.initHeight	=	100;
				}else{
					curLayer.refMC	=	
					refMC	=	curLayer.createEmptyMovieClip("mcRef", 90);
					refMC.lineStyle(0.1, 0, 100);
					drawPoly(curLayer, 0, 0, that.curOption.side, 50);
					refMC.initWidth		=	curLayer._width;
					refMC.initHeight	=	curLayer._height;
				}
				refMC.endFill();
				//draw second
				refMC.clear();
				refMC.lineStyle(0.1, 0, 100);
				refMC._visible	=	false;
				if(that.curOption.side==4){//矩形
				}else{//多边形
					refMC.xreg		=	obj.x;
					refMC.yreg		=	obj.y;
					cPosX	=	obj.x+refMC.initWidth/2;
					if(that.curOption.side%2==0){//偶边
						cPosY	=	obj.y+refMC.initHeight/2;
					}else{//奇边
						cPosY	=	obj.y+50;
					}
					curLayer.drawPoints	=	drawPoly(refMC, cPosX, cPosY, that.curOption.side, 50);
				}
			
				that.isMoveMouse	=	false;
			}else{
				
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse			=	true;
				that.drawRent(this._xmouse, this._ymouse);
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				var obj:Object	=	curLayer.path[0];
				if(this._xmouse==obj.x){
					if(this._xmouse==obj.x){
						curLayer.removeMovieClip();
						curLayer	=	null;
					}
				}
				that.end_rent();
			}
		}
	}
	private function drawRent(x:Number, y:Number){
		var cPanel:MovieClip	=	colorPanel;
		//curLayer.clear();
		curLayer.clear();
		curLayer.lineStyle(curOption.thickness, cPanel.lineColor, cPanel.lineAlpha);
		curLayer.beginFill(cPanel.shapeColor, cPanel.shapeAlpha);
		var obj:Object	=	curLayer.path[0];
		if(curOption.side==4){//矩形
			drawRect(curLayer, obj.x, obj.y, x-obj.x, y-obj.y);
			//drawRect(curLayer.mcShape, obj.x, obj.y, x-obj.x, y-obj.y);
			//curLayer.mcLine.endFill();
			curLayer.endFill();
			return;
		}
		////多边形
		var refMC:MovieClip	=	curLayer.refMC;
		refMC._xscale2	=	(x-obj.x)/refMC.initWiidth*100;
		refMC._yscale2	=	(y-obj.y)/refMC.initHeight*100;
		var retPoints:Array	=	curLayer.drawPoints;
		var len:Number		=	retPoints.length;
		var point:Object;
		var points:Array	=	[];
		for(var i=0;i<len;i++){
			point	=	{x:retPoints[i].x, y:retPoints[i].y};
			refMC.localToGlobal(point);
			curLayer.globalToLocal(point);
			points.push(point);
		}
		drawShape(curLayer, points);
		//drawShape(curLayer.mcShape, points);
		curLayer.endFill();
	}
	private function updateRent(mc:MovieClip, kind:String, type:String, value:Number){
		var obj:Object		=	mc.propretyObj;
		var updateObj:Object	=	{};
		for(var prop:String in obj){
			updateObj[prop]	=	obj[prop];
		}
		updateObj[kind+type]	=	value;
		
		draw_rentByObj(mc, updateObj);
	}
	private function draw_rentByObj(mc:MovieClip, updateObj:Object){
		mc.clear();
		mc.lineStyle(updateObj.thickness, updateObj.lineColor, updateObj.lineAlpha);
		mc.beginFill(updateObj.shapeColor, updateObj.shapeAlpha);
		var points:Array	=	mc.drawPoints;
		drawShape(mc, points);
		//drawShape(curLayer.mcShape, points);
		mc.endFill();
		mc.propretyObj	=	updateObj;
	}
	public function make_oval():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"oval";
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		tips.show("当前工具：椭圆，在画布上拖动画出椭圆。");
		board.onMouseDown=function(){
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer	=	that.createLayer();
				curLayer.path	=	[{x:this._xmouse, y:this._ymouse}];
				curLayer.type	=	"oval";
				that.isMoveMouse	=	false;
			}else{
				
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse			=	true;
				//curLayer.clear();
				that.drawOval(this._xmouse, this._ymouse);
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				var obj:Object	=	curLayer.path[0];
				if(this._xmouse==obj.x){
					if(this._xmouse==obj.x){
						curLayer.removeMovieClip();
						curLayer	=	null;
					}
				}
				that.end_oval();
			}
		}
	}
	private function drawOval(x:Number, y:Number){
		curLayer._visible	=	true;
		var obj:Object		=	curLayer.path[0];
		var cPanel:MovieClip	=	colorPanel;
		//curLayer.mcLine.clear();
		curLayer.clear();
		curLayer.lineStyle(curOption.thickness, cPanel.lineColor, cPanel.lineAlpha);
		curLayer.beginFill(cPanel.shapeColor, cPanel.shapeAlpha);
		var width2:Number	=	(x-obj.x)/2;
		var height2:Number	=	(y-obj.y)/2;
		drawOval2(curLayer, obj.x+width2, obj.y+height2, width2, height2);
		//drawOval2(curLayer.mcShape, obj.x+width2, obj.y+height2, width2, height2);
		curLayer.endFill();
	}
	public function updateOval(mc:MovieClip, kind:String, type:String, value:Number){
		var points:Array	=	mc.drawPoints;
		var obj:Object		=	mc.propretyObj;
		var updateObj:Object	=	{};
		for(var prop:String in obj){
			updateObj[prop]	=	obj[prop];
		}
		updateObj[kind+type]	=	value;
		
		draw_ovalByObj(mc, updateObj);
	}
	public function draw_ovalByObj(mc:MovieClip, updateObj:Object){
		mc.clear();
		mc.lineStyle(updateObj.thickness, updateObj.lineColor, updateObj.lineAlpha);
		mc.beginFill(updateObj.shapeColor, updateObj.shapeAlpha);
		//trace([mc, points[0].x, updateObj.shapeAlpha])
		drawOval2(mc, mc.xreg, mc.yreg, mc.initWidth/2, mc.initHeight/2);
		//drawShape(curLayer.mcShape, points);
		mc.endFill();
		mc.propretyObj	=	updateObj;
	}
	////////WORD
	public function make_word():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"word";
		endFunc();
		mouseStyle(curToolName+"Style");
		showOption(curToolName);
		tips.show("当前工具：文字，在画布上拖动画出文本框");
		board.onMouseDown=function(){
			var targetPathArr	=	Selection.getFocus().split(".");
			if(targetPathArr[targetPathArr.length-1]=="txt"){
				//focus still on TextField
				return;
			}
			//trace("make_word: "+curLayer)
			if(curLayer==null){//new Layer
				if(!isWorkArea())	return;//不在工作区内
				curLayer	=	that.createLayer();
				curLayer.path	=	[{x:Math.round(this._xmouse), y:Math.round(this._ymouse)}];
				curLayer.type	=	"word";
				//var cPanel:MovieClip	=	that.colorPanel;//that.curOption

				that.isMoveMouse	=	false;
			}else{
				
			}
			this.onMouseMove=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.isMoveMouse			=	true;
				that.drawWord(Math.round(this._xmouse), Math.round(this._ymouse));
			}
			this.onMouseUp=function(){
				if(!isWorkArea())	return;//不在工作区内
				that.end_word();
			}
		}
	}
	private function drawWord(x:Number, y:Number){
		var obj:Object	=	curLayer.path[0];
		var w:Number	=	x-obj.x;
		var h:Number	=	y-obj.y;
		//if(w<=0 || h<=0)	return;
		curLayer.path[1]	=	{w:w, h:h};
		curLayer.clear();
		curLayer.lineStyle(0.1, 0x0, 100);
		drawRect(curLayer, obj.x, obj.y, w, h);
		curLayer.endFill();
	}
	private function addTextField(){
		curLayer._visible	=	true;
		var obj:Object	=	curLayer.path[0];
		var obj1:Object	=	curLayer.path[1];
		var width:Number;
		var height:Number;
		//var x:Number;
		//var y:Number;
		if(isMoveMouse==true){
			width	=	curLayer._width;
			height	=	curLayer._height;
			if(obj1.w<0){
				obj.x	+=	obj1.w;
			}
			if(obj1.h<0){
				obj.y	+=	obj1.h;
			}
		}else{//mouse only one click, not moving, so the default width and height
			width	=	curOption.fontSize*6;
			height	=	curOption.fontSize+6;
		}
		curLayer.createTextField("txt", 1, obj.x, obj.y, width, height);
		var txt:TextField	=	curLayer.txt;
		txt.multiline 	= true;
		txt.wordWrap 	= true;
		txt.border 		= true;
		txt.borderColor	=	0x0;
		txt.type 		= "input";//dynamic
		var fmt:TextFormat	=	txt.getTextFormat();
		fmt.color		=	colorPanel.shapeColor;
		fmt.size		=	curOption.fontSize;
		fmt.italic		=	curOption.i_mc._currentframe==1 ? false : true;
		fmt.bold		=	curOption.b_mc._currentframe==1 ? false : true;
		fmt.underline	=	curOption.u_mc._currentframe==1 ? false : true;
		txt.setNewTextFormat(fmt)
		Selection.setFocus(txt);
		txt.onKillFocus=function(newFocus){
			this.type		=	"dynamic";
			this.selectable	=	false;
			this.border		=	false;
			if(this.length>0){//word must large then 0
				that.onEndDraw();
			}else{
				curLayer.removeMovieClip();
				curLayer	=	null;
			}
		}
	}
	//////MODIFY
	public function make_modify():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"modify";
		endFunc();
		//mouseStyle(curToolName+"Style");
		mouseStyle(null);
		showOption(null);
		tips.show("当前工具：修改，点取要修改的对像.");
		board.onMouseDown=function(){
			if(!isWorkArea())	return;//不在工作区内
			//that.isMoveMouse			=	false;
			that.drawModify();
		}
		mcModify	=	board.attachMovie("modifyMC", "mcModify", 7900, 
									{});
		colorPanel.addEventListener("onSelectColor", this);
		colorPanel.addEventListener("onChagneAlpha", this);
		mcModify.addEventListener("onModify", this);//当有对像属性修改结束时，也就是失去修改框的焦点时
	}
	private function onModify(evtObj:Object):Void{
		for(var prop:String in evtObj.changeProp){
			//trace("onModify: prop= "+prop+", oldValue= "+
					//evtObj.changeProp[prop].oldValue+", newValue= "+
					//evtObj.changeProp[prop].newValue);
		}
		paintAction.addAction({mc:evtObj.target.editMC, act:"modify", 
						changeProp:evtObj.changeProp});
	}
	private function drawModify():Void{
		var len:Number	=	layers.length;
		var mc:MovieClip;
		mc	=	mcModify;
		if(mc._visible){//如果点到编辑框,不会消失
			if(mc.hitTest(_root._xmouse, _root._ymouse, true)){
				return;
			}
		}
		if(colorPanel.hitTest(_root._xmouse, _root._ymouse, true)){//如果点到颜色框,不会消失
			return;
		}
		for(var i:Number=topDepth;i>=0;i--){
			mc	=	board.getInstanceAtDepth(i);
			if(mc==undefined)	continue;
			if(!mc._visible)	continue;
			if(mc.hitTest(_root._xmouse, _root._ymouse, true)){
				if(mcModify.editMC==mc){//点选当前对像.
					return;
				}
				mcModify.editMC	=	mc;
				return;
			}
		}
		
		if(mcModify instanceof ModifyMC){
		//if(mcModify instanceof MovieClip){
			mcModify.editMC	=	null;
		}
	}
	private function onSelectColor(evtObj:Object):Void{
		var editMC:MovieClip	=	mcModify.editMC;
		if(editMC==null)	return;
		switch(editMC.type){
			case "pencil":
			case "pen":
			case "line":
			case "brush":// only change line color
				if(evtObj.curItem._name=="lineColor_mc"){
					var color:Color	=	new Color(editMC);
					color.setRGB(evtObj.color);
				}
				break;
			case "rent":
				if(evtObj.curItem._name=="lineColor_mc"){
					updateRent(editMC, "line", "Color", evtObj.color);
				}else{
					updateRent(editMC, "shape", "Color", evtObj.color);
				}
				break;
			case "oval":
				if(evtObj.curItem._name=="lineColor_mc"){
					updateOval(editMC, "line", "Color", evtObj.color);
				}else{
					updateOval(editMC, "shape", "Color", evtObj.color);
				}
				break;
			case "word":
				if(evtObj.curItem._name=="shapeColor_mc"){
					var fmt:TextFormat	=	editMC.txt.getTextFormat();
					fmt.color	=	evtObj.color;
					editMC.txt.setTextFormat(fmt);
				}
				break;
			case "element":
				if(evtObj.curItem._name=="shapeColor_mc"){
					editMC.color	=	new Color(editMC);
					editMC.color.setRGB(evtObj.color);
				}
				break;
			default:
				trace("ERROR: what type of "+editMC+" | "+editMC.type);
		}
	}
	private function onChagneAlpha(evtObj:Object):Void{
		var editMC:MovieClip	=	mcModify.editMC;
		if(editMC==null)	return;
		
		switch(editMC.type){
			case "pencil":
			case "pen":
			case "line":
			case "brush":// only change line color
				if(evtObj.curItem._name=="lineColor_mc"){
					editMC._alpha	=	evtObj.alpha;
				}
				break;
			case "rent":
			case "oval":
				if(evtObj.curItem._name=="lineColor_mc"){
					updateRent(editMC, "line", "Alpha", evtObj.alpha);
				}else{
					updateRent(editMC, "shape", "Alpha", evtObj.alpha);
				}
				break;
			case "word":
				if(evtObj.curItem._name=="shapeColor_mc"){
					//editMC._alpha	=	evtObj.alpha;
				}
				break;
			case "element":
				if(evtObj.curItem._name=="shapeColor_mc"){
					editMC._alpha	=	evtObj.alpha;
				}
				break;
			default:
				trace("ERROR: what type of "+editMC+" | "+editMC.type);
		}
	}
	
	////END DRAW
	public function end_pencil():Void{
		curLayer.endFill();
		onEndDraw();
		//isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_pen():Void{
		curLayer.endFill();
		onEndDraw();
		isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_line():Void{
		curLayer.endFill();
		onEndDraw();
		//isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_brush():Void{
		clearInterval(interBrush);
		//trace([curToolName, this, onEndDraw])
		if(curToolName!="brush"){
			styleMC.setNone();//不要显示状态
		}
		//curLayer.onEnterFrame	=	null;
		onEndDraw();
		//isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_rent():Void{
		//保存各顶点的位置,方便重绘.
		if(curOption.side==4){//矩形
			var bounds:Object	=	curLayer.getBounds(board);
			curLayer.drawPoints	=	[{x:bounds.xMin, y:bounds.yMin},//左上
									{x:bounds.xMax, y:bounds.yMin},//右上
									{x:bounds.xMax, y:bounds.yMax},//右下
									{x:bounds.xMin, y:bounds.yMax},//左下
									{x:bounds.xMin, y:bounds.yMin}];//左上
			
		}else{
			var retPoints:Array	=	curLayer.drawPoints;
			var len:Number		=	retPoints.length;
			var point:Object;
			var refMC:MovieClip	=	curLayer.refMC;
			var points:Array	=	[];//转为当前点,方便对像的颜色修改
			for(var i=0;i<len;i++){
				point	=	{x:retPoints[i].x, y:retPoints[i].y};
				refMC.localToGlobal(point);
				curLayer.globalToLocal(point);
				points.push(point);
			}
			curLayer.drawPoints	=	points;
		}
		//curLayer.lineStyle(curOption.thickness, cPanel.lineColor, cPanel.lineAlpha);
		//curLayer.beginFill(cPanel.shapeColor, cPanel.shapeAlpha);
		curLayer.propretyObj	=	getShapeStyle();
		curLayer.refMC.removeMovieClip();//删除辅助线
		curLayer.refMC	=	null;
		onEndDraw();
		//isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_oval():Void{
		curLayer.propretyObj	=	getShapeStyle();
		onEndDraw();
		isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	private function getShapeStyle():Object{
		return		{thickness:curOption.thickness,
					lineColor:colorPanel.lineColor,
					lineAlpha:colorPanel.lineAlpha,
					shapeColor:colorPanel.shapeColor,
					shapeAlpha:colorPanel.shapeAlpha
					}
	}
	public function end_word():Void{
		addTextField();
		curLayer.clear();
		//onEndDraw();
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_modify():Void{
		mcModify.removeMovieClip();
		mcModify	=	null;
		colorPanel.removeEventListener("onSelectColor", this);
		colorPanel.removeEventListener("onChagneAlpha", this);
		mcModify.removeEventListener("onModify", this);
		//isMoveMouse	=	null;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	
	///////////********TOOL RIGHT
	public function make_preview():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"preview";
		endFunc();
		_parent.mainBoard_mc.gotoAndStop("preview");
		var iStep:Number	=	paintAction.getUndoStep();
		var num:Number	=	paintAction.undo();
		resetPaint();
		if(num==-1){//没有记录
			return;
		}else if(num>0){//大于一条的记录
			while(paintAction.undo()!=0){
			}
		}
		
		var speed:Number	=	100/num;//数量越多，显示越快，反之。。。
		speed	=	Math.min(Math.max(speed, 1), 5);
		var iCount:Number	=	0;
		board.onEnterFrame=function(){
			if(iCount++%speed==0){
				if(that.paintAction.redo()==0 || --iStep==0){
					delete this.onEnterFrame;
				}
			}
		}
		//tips.show("当前工具：直线，拖到mouse画出直线。");
	}
	
	public function make_zoom():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"zoom";
		endFunc();
		mouseStyle(curToolName+"Style");
		tips.show("当前工具：放大镜，在画面点击放大画面。可按住Ctrl进行缩小.");
		board.onMouseDown=function(){
			var mc:MovieClip	=	this._parent;//paint_mc
			if(!mc.hitTest(_root._xmouse, _root._ymouse, true))	return;
			mc.xreg		=	mc._xmouse;
			mc.yreg		=	mc._ymouse;
			var dir:Number	=	1;
			if(that.pressKeyObj.control==true){
				dir	=	-1;
			}
			var scale:Number	=	mc._xscale2*(1+0.2*dir);
			mc._xscale2	=	
			mc._yscale2	=	Math.max(100, Math.min(scale, 250));
			if(mc._xscale==100){//居中
				//mc._x		=	mc.initX;
				//mc._y		=	mc.initY;
			}
		}
	}
	
	public function make_hand():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"hand";
		endFunc();
		mouseStyle(curToolName+"Style");
		tips.show("当前工具：拖动，在画布上拖动移动画面。");
		board.onMouseDown=function(){
			var mc:MovieClip	=	this._parent;
			if(mc.hitTest(_root._xmouse, _root._ymouse, true)){
				mc.clickX	=	mc._xmouse;
				mc.clickY	=	mc._ymouse;
				this.onMouseMove=function(){
					mc._x	+=	(mc._xmouse-mc.clickX);
					mc._y	+=	(mc._ymouse-mc.clickY);
				}
				this.onMouseUp=function(){
					delete mc.clickX;
					delete mc.clickY;
					delete this.onMouseMove;
					delete this.onMouseUp;
				}
			}
		}
	}
	public function make_redo():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName		=	"redo";
		endFunc();
		var ret:Number	=	paintAction.redo();
		if(ret==0){
			redo_mc.gotoAndStop("disabled");
			redo_mc.enabled	=	false;
		}
		undo_mc.gotoAndStop("enabled");
		undo_mc.enabled	=	true;
	}
	
	public function make_undo():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"undo";
		endFunc();
		var ret:Number	=	paintAction.undo();
		if(ret==0){
			undo_mc.gotoAndStop("disabled");
			undo_mc.enabled	=	false;
		}
		redo_mc.gotoAndStop("enabled");
		redo_mc.enabled	=	true;
	}
	
	public function make_new():Void{
		onClickIcon();
		var endFunc:Function	=	Delegate.create(this, this["end_"+curToolName]);
		curToolName	=	"new";
		endFunc();
		_parent.confirmClear_mc.show();
	}
	
	public function end_zoom():Void{
		
		delete board.onMouseDown;
	}
	
	public function end_hand():Void{
		
		delete board.onMouseDown;
		delete board.onMouseMove;
		delete board.onMouseUp;
	}
	public function end_redo():Void{
		
	}
	
	public function end_undo():Void{
		
	}
	
	public function end_new():Void{
		
	}
	private function onClickIcon(){
		//styleMC.setNone();
	}
	public function clearData():Void{
		var mc:MovieClip;
		for(var prop:String in board){
			mc	=	board[prop];
			mc.removeMovieClip();
		}
		layers		=	[];
		paintAction.clearAll();
		resetPaint();
		redo_mc.gotoAndStop("disabled");
		undo_mc.gotoAndStop("disabled");
		redo_mc.enabled	=	
		undo_mc.enabled	=	false;
	}
	
	public function resetPaint():Void{
		paintMC._xscale	=	
		paintMC._yscale	=	100;
		paintMC._x		=	paintMC.initX;
		paintMC._y		=	paintMC.initY;
		//trace([paintMC._xscale, paintMC._xscale, paintMC._x, paintMC._x])
	}
	public function enabledKey(enabled:Boolean){
		if(enabled){
			Key.addListener (this);
		}else{
			Key.removeListener(this);
		}
	}
	
	private function onKeyDown() {
		if(Key.isDown(Key.CONTROL)){
			pressKeyObj.control	=	true;
		}
	}
	private function onKeyUp() {
		for(var prop in pressKeyObj){
			pressKeyObj[prop]	=	false;
		}
	}
	
	public function dragOutElement(mc:MovieClip):Void{
		curLayer		=	createLayer();
		curLayer.createEmptyMovieClip("mcLoader", 30);
		curLayer.path	=	[{x:0, y:0}];
		curLayer.type	=	"element";//trace([mc,mc.path])
		loader_mcl.loadClip(mc.path, curLayer.mcLoader);
	}
	
	//***MovieClipLoader Events***\\
	private function onLoadStart(mc:MovieClip):Void{
		
	}
	private function onLoadProgress(mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void{
		var percent:Number	=	Math.round(loadedBytes/totalBytes*100);
		
	}
	private function onLoadComplete(mc:MovieClip):Void{
		
	}
	private function onLoadInit(mc:MovieClip):Void{
		mc._x	=	127.5 - mc._width/2;//水平居中
		mc._y	=	127.5 - mc._height/2;//垂直居中
		onEndDraw();
		if(curToolName!="modify"){
			this["modify_mc"].onRelease();
		}
		mcModify.editMC	=	mc._parent;
	}
	private function onLoadError(mc:MovieClip, errorCode:String):Void{
		switch(errorCode){
			case "URLNotFound":
				tips.show("错误: URLNotFound");
				break;
			case "LoadNeverCompleted":
				tips.show("错误: LoadNeverCompleted");
				break;
		}
		 
	}
	//***MovieClipLoader Events END***\\
	
	
	private function getBitmapData(width:Number, height:Number):String{
		var mainBoard:MovieClip	=	board._parent._parent;
		mainBoard.paint_mc.setMask(null);//去掉mask
		mainBoard.paint_mc.mask_mc._visible	=	true;
		var bmp:BitmapData	=	new BitmapData(width, height, false, 0);
		bmp.draw(mainBoard.paint_mc);
		mainBoard.paint_mc.mask_mc._visible	=	false;
		mainBoard.paint_mc.setMask(mainBoard.mask_mc);//加上mask
		var str:String = "";
		for (var i:Number = 0; i<height; i++) {
			for (var j:Number = 0; j<width; j++) {
				var cstr:Number = bmp.getPixel(j, i);
				str += ((cstr).toString(36)+",");
			}
		}
		//_root.trace_bmp.draw(bmp);//debug
		return str.substr(0, -1);
	}
	//***********************[STATIC METHOD]**********************************//
	
	public static function isWorkArea():Boolean{
		var bounds:Object	=	mcBlackBG.getBounds(_root);
		//trace([bounds.xMin, bounds.xMax, bounds.yMin, bounds.yMax])
		var ret:Boolean	=	false;
		if(_root._xmouse>bounds.xMin){
			if(_root._xmouse<bounds.xMax){
				if(_root._ymouse>bounds.yMin){
					if(_root._ymouse<bounds.yMax){
						//window showing
						if(_root.submitWorks_mc._currentframe==1){//submit 
							if(_root.confirmClear_mc._currentframe==1){//confirm
								if(_root.mainBoard_mc._currentframe==1){//preview
									ret 	=	true;
								}
							}
						}
					}
				}
			}
		}
		//isOverWorkArea	=	ret;
		return ret;
		//return mcBlackBG.hitTest(_root._xmouse, _root._ymouse, false);
	}
	
	public static function getDistance(x0:Number, y0:Number, x1:Number, y1:Number){
		return Math.sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0));
	}
	
	public static function drawPoly(mc:MovieClip, x:Number, y:Number, 
						sides:Number, radius:Number):Array {
		var step:Number, start:Number, dx:Number, dy:Number;
		// calculate span of sides
		step = (Math.PI*2)/sides;
		// calculate starting angle in radians
		var start:Number = (90/180)*Math.PI;
		var retObj	=	[];
		var point:Object	=	{x:x+(Math.cos(start)*radius), y:y-(Math.sin(start)*radius)}
		retObj.push(point)
		mc.moveTo(point.x, point.y);
		// draw the polygon
		for (var n:Number=1; n<=sides; n++) {
			dx = x+Math.cos(start+(step*n))*radius;
			dy = y-Math.sin(start+(step*n))*radius;
			var point	=	{x:dx,y:dy}
			retObj.push(point)
			mc.lineTo(point.x, point.y);
			//trace(["out: ",point.x, point.y])
		}
		return retObj;
	};
	public static function drawShape(mc:MovieClip, arr:Array):Void{
		var point:Object;
		point	=	arr[0];
		var len:Number		=	arr.length;
		mc.moveTo(point.x, point.y);
		for(var i:Number=1;i<len;i++){
			point	=	arr[i];
			mc.lineTo(point.x, point.y);
		}
	}
	
	public static function drawRect(mc:MovieClip,x:Number,y:Number,w:Number,
													h:Number,c:Number):Void{
		mc.moveTo(x, y);
		mc.lineTo(x+w, y);
		mc.lineTo(x+w, y+h);
		mc.lineTo(x, y+h);
		mc.lineTo(x, y);
	}
	
	public static function drawCurve3Pts(mc:MovieClip, xStart:Number, yStart:Number,
							x:Number, y:Number, xEnd:Number, yEnd:Number):Void{
		mc.moveTo (xStart, yStart);
		mc.curveTo (2*x-.5*(xStart+xEnd), 2*y-.5*(yStart+yEnd), xEnd, yEnd);
	}
	public static function drawOval2(mc:MovieClip, x:Number, y:Number, 
										radius:Number, yRadius:Number):Void {
		// init variables
		var theta:Number, xrCtrl:Number, yrCtrl:Number, angle:Number, angleMid:Number;
		var px:Number, py:Number, cx:Number, cy:Number;
		// if only yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// covert 45 degrees to radians for our calculations
		theta = Math.PI/4;
		// calculate the distance for the control point
		xrCtrl = radius/Math.cos(theta/2);
		yrCtrl = yRadius/Math.cos(theta/2);
		// start on the right side of the circle
		angle = 0;
		mc.moveTo(x+radius, y);
		// this loop draws the circle in 8 segments
		for (var i:Number = 0; i<8; i++) {
			// increment our angles
			angle += theta;
			angleMid = angle-(theta/2);
			// calculate our control point
			cx = x+Math.cos(angleMid)*xrCtrl;
			cy = y+Math.sin(angleMid)*yrCtrl;
			// calculate our end point
			px = x+Math.cos(angle)*radius;
			py = y+Math.sin(angle)*yRadius;
			// draw the circle segment
			mc.curveTo(cx, cy, px, py);
		}
	}
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*

*/
