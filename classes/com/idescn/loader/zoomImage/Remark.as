//******************************************************************************
//	name:	LoadProgress 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Apr 28 13:23:25 2006
//	description: 在图片上做标注,记录标注的位置,及放大的级别,图片名称,及名称介绍
//			时间,可以传上网与用户共享,也可以本地保存.
//******************************************************************************

import mx.transitions.Tween;
import mx.events.EventDispatcher;
import com.idescn.loader.zoomImage.*;

class com.idescn.loader.zoomImage.Remark extends Object{
	
	private var _zoomImage:Object			=	null;
	private var _pointsLocal:Array			=	[];//[{date,x,y,level,mark}]
	private var _pointsRemote:Array			=	null;
	private var _flagsLocal:Array			=	[];//对应_pointsLocal的flag
	private var _mapMC:MovieClip			=	null;//标注点在上方显示[20]
	private var _flagMC:MovieClip			=	null;
	private var _flagControl:Object		=	null;
	
	public  var tilesName:String			=	null;
	public  var userName:String			=	null;
	public  var flagName:String			=	"remark flag";//默认库中的linked
	
	/////////////////event
	public	var addEventListener:Function;
	public	var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED	=	EventDispatcher.initialize(Remark.prototype);

	//[DEBUG]//your can remove it before finish this CLASS!
	//public static var tt:Function		=	null;
	
	//private var _value:String		=	null;
	
	/******************[READ|WIDTH]******************/
	function set points(value:Array):Void{
		
	}
	function get points():Array{
		return _pointsLocal;
	}
	
	function set flags(value:Array):Void{
		
	}
	function get flags():Array{
		return _flagsLocal;
	}
	
	/**
	 * construction function
	 * @param target point to zoomImage
	 * @param tilesName the loading path
	 */
	public function Remark(target:Object, tilesName:String){
		this._zoomImage		=	target;
		this.tilesName		=	tilesName;
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_mapMC		=	_zoomImage.target.createEmptyMovieClip("mcRemark", 20);
		//_pointsLocal	=	[];
		_pointsRemote	=	[];
		_zoomImage.bImageEvents.addEventListener("onLoaded", this);
		
	}
	
	/**
	 * 当tween结束时
	 * 
	 * @usage   
	 * @param   target  tween
	 * @return  
	 */
	private function onMotionStopped(tw:Tween):Void{
		var mc	=	tw.obj;//指向被拖动的影片
		mc.myCopy.removeMovieClip();
		mc.gotoAndStop("normal");
		if(tw.useSeconds){//表示没有在区域内放置flag
			
		}else{//表示在指定的区域内放置了flag
			var newPoint:Object	=	getCurrentPoint(mc, mc.dropX, tw.begin);
			var mc0:MovieClip		=	render(newPoint);
			newPoint.mc				=	mc0;
			//当放下点时,这事件应用于FlagControl类中
			dispatchEvent({type:"onDropPoint", point:newPoint, 
									index:_pointsLocal.length, isInput:true});
		}
	}
	
	/**
	 * 当load tiles完成时,显示flag
	 * 此方法被LoadTileImageEvents2调用
	 * @usage   
	 * @param   eventObj 
	 * @return  
	 */
	private function onLoaded(eventObj:Object):Void{
		if(eventObj.isFinish){
			showFlags();
		}
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * 把原来在上边的flag删除
	 * 
	 * @usage   
	 * @return  
	 */
	public function removeFlags():Void{
		for(var prop:String in _mapMC){
			_mapMC[prop].removeMovieClip();
		}
		_flagsLocal	=	[];
	}
	
	/**
	 * 得到mcPoint相对于bottomImage的位置
	 * 
	 * @usage   
	 * @param   mcPoint 
	 * @param   x       
	 * @param   y       
	 * @return  
	 */
	public function getCurrentPoint(mcPoint:MovieClip, x:Number, 
															y:Number):Object{
		var point:Object	=	{x:x, y:y};
		mcPoint._parent.localToGlobal(point);
		_zoomImage.bottomImage.globalToLocal(point);
		var scale:Number	=	_zoomImage.bottomImage._xscale/100;
		return	{x:point.x*scale, y:point.y*scale, level:_zoomImage.curLevel,
																	mark:null};
	}
	
	/**
	 * 在图片上标注flag
	 * 
	 * @usage   
	 * @param   point 
	 * @return 
	 */
	public function render(point:Object):MovieClip{
		//_global["eTrace"](point)
		var nPoint:Object	=	convertByLevel(point, _zoomImage.curLevel);
		//临时创建的参考点
		var mc:MovieClip	=	_zoomImage.target.createEmptyMovieClip("tempPoint",
																			100);
		mc._x	=	_zoomImage.bottomImage._x;
		mc._y	=	_zoomImage.bottomImage._y;
		mc.localToGlobal(nPoint);
		mc.removeMovieClip();//删除参考点
		
		_mapMC.globalToLocal(nPoint);
		
		var depth:Number	=	_mapMC.getNextHighestDepth();
		var width:Number	=	0;//_zoomImage.MIN_WIDTH/2 -_zoomImage.curPosX;
		var height:Number	=	0;//_zoomImage.MIN_HEIGHT/2-_zoomImage.curPosY;
		mc	=	_mapMC.attachMovie(flagName, "mcFlag"+depth, depth, 
									{_x:nPoint.x-width, _y:nPoint.y-height});
		
		dispatchEvent({type:"onAddPoint", point:point});
		_flagsLocal.push(mc);
		return mc;
	}
	
	/**
	 * 把point的坐标根据level重新计算坐标,并返回一个新的point对象
	 * 
	 * @usage   
	 * @param   point 
	 * @param   level 
	 * @return  
	 */
	public function convertByLevel(point:Object, level:Object):Object{
		//得到point所记录当前层下的缩放值
		//var scaleA:Number	=	_zoomImage.getBImageScale(point.level);
		//得到要转换得到point指定的层的缩放值
		//var scaleB:Number	=	_zoomImage.getBImageScale(level);
		//var scale:Number	=	scaleB/scaleA;
		
		var scale:Number	=	1;
		if(point.level!=level){
			//取得不同级别下的比值.
			var tXML:Object	=	_zoomImage.tilesXML;
			scale	=	tXML.getImageProp(level, "width")/
										tXML.getImageProp(point.level, "width");
		}
		return {x:point.x*scale, y:point.y*scale, level:level};
	}
	
	/**
	 * 把_points内的数据全读出来,并标注上
	 * 
	 * @usage   
	 * @param isEdit 如果为真,更新显示的列表,否则只刷新图片上的point,当加载
	 * 			部分tiles完成时刷新point
	 * @return  
	 */
	public function showFlags(isEdit:Boolean):Void{
		removeFlags();
		var len:Number		=	_pointsLocal.length;
		var point:Object	=	null;
		for(var i:Number=0;i<len;i++){
			point	=	_pointsLocal[i];
			var mc:MovieClip	=	render(point);
			if(isEdit==true){
				point.mc	=	mc;
				//当放下点时,这事件应用于FlagControl类中
				dispatchEvent({type:"onDropPoint", point:point,
												index:i, isInput:false});
			}
		}
	}
	
	/**
	 * 把信息添加入数组内
	 * 
	 * @usage   
	 * @param   point {x,y,level,mark,date}
	 * @return  
	 */
	public function addMark(point:Object):Void{
		point.date	=	new Date();
		_pointsLocal.push(point);

	}
	
	/**
	 * 编辑原来的数据
	 * 
	 * @usage   
	 * @param   index 
	 * @param   prop  
	 * @param   value 
	 * @return  
	 */
	public function editMark(index:Number):Void{
		var obj:Object	=	_pointsLocal[index];
		var len:Number	=	arguments.length;
		for(var i:Number=1;i<len;i+=2){
			obj[arguments[i]]	=	arguments[i+1];
		}
		obj.date	=	new Date();
	}
	
	/**
	 * 删除point
	 * 
	 * @usage   
	 * @param   index 
	 * @return  
	 */
	public function delMark(index:Number):Void{
		//_global["eTrace"](_pointsLocal);
		_pointsLocal.splice(index, 1);
		_flagsLocal.splice(index, 1);
		//_global["eTrace"](_pointsLocal);
	}
	
	/**
	 * 设置可拖动的flag
	 * 
	 * @usage   
	 * @param   mc 
	 * @return  
	 */
	public function setDNDFlag(mc:MovieClip):Void{
		_flagMC		=	mc;
		var _this:Object	=	this;
		mc.onPress=function():Void{
			this.startDrag(true);
			this.myCopy=this.duplicateMovieClip("mcFlag_copy", 100, {_alpha:50});
			this.gotoAndStop("move");
		}
		mc.onRelease=function():Void{
			this.stopDrag();
			var isOutArea:Boolean	=	false;//是否在区域外
			if(!_this._zoomImage.target.hitTest(this._x, this._y, true)){
				isOutArea	=	true;
			}
			var twX:Tween	=	new Tween(this, "_x",
								mx.transitions.easing.Strong.easeOut,
								this._x, this.myCopy._x, 1, isOutArea);
			var twY:Tween	=	new Tween(this, "_y",
								mx.transitions.easing.Strong.easeOut,
								this._y, this.myCopy._y, 1, isOutArea);
			twY.addListener(_this);
			this.dropX	=	this._x;//因为twY记录_y位置,故不用记录
		}
		mc.onReleaseOutside=mc.onRelease;
	}
	
	/**
	 * 读出本地数据
	 * 
	 * @usage   
	 * @return  
	 */
	public function readLocal():Void{
		var so:SharedObject	=	SharedObject.getLocal(tilesName);
		var points:Array		=	so.data.points;
		_pointsLocal	=	points==null ? [] : points;
		showFlags(true);
	}
	
	/**
	 * 把数据写入本地disk
	 * 
	 * @usage   
	 * @return  
	 */
	public function writeLocal():Void{
		var so:SharedObject	=	SharedObject.getLocal(tilesName);
		so.data.points			=	_pointsLocal;
		so.flush();
	}
	
	/**
	 * 设定可以与flagList_mc进行通讯的类,用于操作此数据
	 * 
	 * @usage   
	 * @param   mc 
	 * @return  
	 */
	public function setFlagControl(mc:MovieClip):Void{
		_flagControl	=	new FlagControl(mc, this, _zoomImage);
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "Remark 1.0";
	}
}
