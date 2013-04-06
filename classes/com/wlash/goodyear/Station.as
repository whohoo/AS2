//******************************************************************************
//	name:	Station 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Jul 12 18:19:01 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "goodyear animation.fla" file.
//		
//******************************************************************************


import mx.transitions.Tween;
import com.idescn.as3d.Vector3D;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.goodyear.Station extends MovieClip{
	private var _group:String;
	private var _index:Number;
	public  var scale:Number;
	private var asset_mc:MovieClip;
	private var v3d:Vector3D;
	[Inspectable(defaultValue="0", verbose=0, type=Number)]
	public var x:Number;
	[Inspectable(defaultValue="0", verbose=0, type=Number)]
	public var y:Number;
	[Inspectable(defaultValue="0", verbose=0, type=Number)]
	public var z:Number;
	
	public static var viewPoint:Vector3D	=	new Vector3D(0,100,0);
	public static var points:Object	=	{};
	public static var curStation:Station;
	public static var curArea:String;
	//public static var terminal:Station;
	public static var stepStation:Array;//各个点行走的路径
	public static var stepIndex:Number;//当前的index位置
	public static var obj:MovieClip;
	public static var perspective:Number;
	public static var tw:Tween;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	[Inspectable(defaultValue="sideA", verbose=0, type=List, enumeration="sideA,sideB,sideC,sideD,sideE,sideF,node"))]
	function set group(value:String):Void{
		if(value=="sideA" || value=="sideB" || value=="sideC" || 
				value=="sideD" || value=="sideE" || value=="sideF" || value=="node"){
			_group	=	value;
		}else{
			throw new Error("invaild value with group property");
		}
	}
	/**group side or node */
	function get group():String{
		return _group;
	}
	
	[Inspectable(defaultValue="-1", verbose=0, type=Number)]
	function set index(value:Number):Void{
		_index	=	value;
	}
	/**sort for this index, default value -1 means auto index */
	function get index():Number{
		return _index;
	}
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function Station(){
		if(points[_group]==null){
			points[_group]	=	[];
		}
		if(_index==-1){
			_index	=	points[_group].length;
		}
		points[_group][_index]	=	this;
		asset_mc._alpha	=	100;
		init();
		
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		v3d	=	new Vector3D(x, y, z);
		render();
		_visible	=	false;
	}
	
	private function render():Void{
		var v3d2:Vector3D	=	v3d.plusNew(viewPoint);
		var prep:Number	=	v3d2.getPerspective(300);
		v3d2.persProject(prep);
		_x		=	v3d2.x;
		_y		=	v3d2.y;
		_xscale	=
		_yscale	=	prep*100;//trace([_name, _xscale]);
		swapDepths(Math.round(prep*1000)+10000);
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	
	
	
	//***********************[STATIC METHOD]**********************************//
	/**
	 * initailize all Stations, and make the scale value
	 * @param max max scale
	 * @param min min scale
	 */
	public static function initailize(max:Number, min:Number):Void{
		curArea		=	curStation.group;
		var gObj:Array;
		var maxMC:Object	=	{_xscale:Number.MIN_VALUE};
		var minMC:Object	=	{_xscale:Number.MAX_VALUE};
		for(var prop in points){
			gObj	=	points[prop];
			var len:Number	=	gObj.length;
			var mc:Station;
			for(var i:Number=0;i<len;i++){
				mc	=	gObj[i];
				if(mc._xscale>maxMC._xscale){
					maxMC	=	mc;
				}
				if(mc._xscale<minMC._xscale){
					minMC	=	mc;
				}
			}
		}
		
		perspective	=	(max-min)/(maxMC._xscale-minMC._xscale);
		
		for(var prop:String in points){
			gObj	=	points[prop];
			var len:Number	=	gObj.length;
			var mc:Station;
			for(var i:Number=0;i<len;i++){
				mc	=	gObj[i];
				//mc._yscale	=	
				//mc._xscale	=	
				mc.scale	=	perspective*(mc._xscale-minMC._xscale)+min;
				//trace([mc._name, "mc.scale= ", mc.scale,"mc.v3d.z= " , mc.v3d.z])
				//mc.onRelease=function(){
					//var station	=	this;
					//goStation(station);
				//}
			}
		}
		
		//points["node"][0].onRelease=function(){
			//goNode();
		//}
		
		obj.v3d	=	curStation.v3d.getClone();
		tw	=	new Tween(obj.v3d, "z", 
					mx.transitions.easing.None.easeNone,
					curStation.v3d.z, curStation.v3d.z, 1, true);
		tw.stop();
		tw.addListener(Station);
		obj.render();
	}
	/**
	 * 返回原始点
	 * 
	 * @usage   
	 * @param   onWalkFinishFunc 当走完时的动作
	 * @return  
	 */
	public static function goNode(onWalkFinishFunc:Function){
		if(curStation==points["node"][0]){
			trace("Func|goNode curStation: "+curStation);
			return;
		}
		var sideObj:Array;
		switch(curStation.group){
			case "sideA":
				sideObj		=	points["sideA"];
				stepStation	=	[curStation, sideObj[0], points["node"][0]];//一步一步走完
				stepIndex	=	1;
				obj.walk("back");
				//当worker_mc要开始行走时,就执行这条命令
				obj.startWalk=function(){
					startMove(stepStation[0], stepStation[1]);
				}
				break;
			case "sideB":
				sideObj		=	points["node"];
				stepStation	=	[curStation, sideObj[0]];//一步一步走完
				stepIndex	=	1;
				switch(curStation.index){
					case 0:
						//same to below
						//break;
					case 1:
						obj.walk("right");
						//当worker_mc要开始行走时,就执行这条命令
						obj.startWalk=function(){
							startMove(stepStation[0], stepStation[1]);
						}
						break;
					case 2:
						//same to below
						//break;
					case 3:
						obj.walk("front", "right");
						//当worker_mc要开始行走时,就执行这条命令
						obj.startWalk=function(){
							startMove(stepStation[0], stepStation[1]);
						}
						break;
					default:
						trace("error|goNode curStation.index= "+curStation.index);
				}
				break;
			default:
				trace("error|goNode curStation.group= "+curStation.group);
				return;
		}
		curArea	=	"node";//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj.stand("front", "right");
			onWalkFinishFunc(obj);
			
		}
	}
	
	public static function goSideA(onWalkFinishFunc:Function){
		if(curStation!=points["node"][0]){
			trace("Func|goSideA curStation: "+curStation);
			return;
		}
		var sideObj:Array	=	points["sideA"];
		stepStation	=	[curStation, sideObj[0], sideObj[1]];//一步一步走完
		stepIndex	=	1;
		obj.walk("right");
		//当worker_mc要开始行走时,就执行这条命令
		obj.startWalk=function(){
			startMove(stepStation[0], stepStation[1]);
		}
		curArea	=	"sideA";//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj.stand("front", "right");
			onWalkFinishFunc(obj);
		}
	}
	
	/**
	 * make obj move to the sideB.
	 * 
	 */
	public static function goSideB(onWalkFinishFunc:Function):Void{
		if(curStation!=points["node"][0]){
			trace("Func|goSideB curStation: "+curStation);
			return;
		}
		var sideObj:Array	=	points["sideB"];
		stepStation	=	[curStation, sideObj[3]];//一步一步走完
		stepIndex	=	1;
		obj.walk("back");
		//当worker_mc要开始行走时,就执行这条命令
		obj.startWalk=function(){
			startMove(stepStation[0], stepStation[1]);
		}
		curArea	=	"sideB";//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj.stand("front", "left");
			onWalkFinishFunc(obj);
		}
	}
	
	public static function goSideC(onWalkFinishFunc:Function):Boolean{
		switch(curStation.group){
			case "sideC":
				return false;
				break;
			case "sideD":
				stepStation	=	[curStation, points["sideC"][0]];//一步一步走完
				obj.walk("right");
				break;
			case "sideE":
				stepStation	=	[curStation, points["sideF"][0], points["sideC"][0]];//一步一步走完
				obj.walk("right");
				break;
			case "sideF":
				stepStation	=	[curStation, points["sideC"][0]];//一步一步走完
				obj.walk("front");
				break;
			default:
				trace("error|Station goSideC curStation: "+curStation);
		}
		
		stepIndex	=	1;
		
		//当worker_mc要开始行走时,就执行这条命令
		obj.startWalk=function(){
			startMove(stepStation[0], stepStation[1]);
		}
		curArea	=	"sideC";
		//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj._parent.forceDir	=	1;//show in left.
			obj.talk("front");
			onWalkFinishFunc(obj);
		}
		return true;
	}
	public static function goSideD(onWalkFinishFunc:Function):Boolean{
		switch(curStation.group){
			case "sideD":
				return false;
				break;
			case "sideC":
				stepStation	=	[curStation, points["sideD"][0]];//一步一步走完
				obj.walk("left");
				break;
			case "sideE":
				stepStation	=	[curStation, points["sideD"][0]];//一步一步走完
				obj.walk("front", "right");
				break;
			case "sideF":
				stepStation	=	[curStation, points["sideC"][0], points["sideD"][0]];//一步一步走完
				obj.walk("front", "left");
				break;
			default:
				trace("error|Station goSideD curStation: "+curStation);
		}
		
		stepIndex	=	1;
		
		//当worker_mc要开始行走时,就执行这条命令
		obj.startWalk=function(){
			startMove(stepStation[0], stepStation[1]);
		}
		curArea	=	"sideD";
		//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj._parent.forceDir	=	-1;//show in right.
			obj.talk("front");
			onWalkFinishFunc(obj);
		}
		return true;
	}
	public static function goSideE(onWalkFinishFunc:Function):Boolean{
		switch(curStation.group){
			case "sideE":
				return false;
				break;
			case "sideC":
				stepStation	=	[curStation, points["sideF"][0], points["sideE"][0]];//一步一步走完
				obj.walk("back");
				break;
			case "sideD":
				stepStation	=	[curStation, points["sideE"][0]];//一步一步走完
				obj.walk("back");
				break;
			case "sideF":
				stepStation	=	[curStation, points["sideE"][0]];//一步一步走完
				obj.walk("left");
				break;
			default:
				trace("error|Station goSideE curStation: "+curStation);
		}
		
		stepIndex	=	1;
		
		//当worker_mc要开始行走时,就执行这条命令
		obj.startWalk=function(){
			startMove(stepStation[0], stepStation[1]);
		}
		curArea	=	"sideE";
		//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj._parent.forceDir	=	-1;//show in right.
			obj.talk("left");
			onWalkFinishFunc(obj);
		}
		return true;
	}
	public static function goSideF(onWalkFinishFunc:Function):Boolean{
		switch(curStation.group){
			case "sideF":
				return false;
				break;
			case "sideC":
				stepStation	=	[curStation, points["sideF"][0]];//一步一步走完
				obj.walk("back");
				break;
			case "sideD":
				stepStation	=	[curStation, points["sideC"][0], points["sideF"][0]];//一步一步走完
				obj.walk("right");
				break;
			case "sideE":
				stepStation	=	[curStation, points["sideF"][0]];//一步一步走完
				obj.walk("right");
				break;
			default:
				trace("error|Station goSideF curStation: "+curStation);
		}
		
		stepIndex	=	1;
		
		//当worker_mc要开始行走时,就执行这条命令
		obj.startWalk=function(){
			startMove(stepStation[0], stepStation[1]);
		}
		curArea	=	"sideF";
		//stepStation[stepStation.length-1].group;
		obj.onWalkFinished=function(){
			obj._parent.forceDir	=	1;//show in left.
			obj.talk("left");
			onWalkFinishFunc(obj);
		}
		return true;
	}
	public static function goStation(station:Station, onWalkFinishFunc:Function, btnName:Object):Boolean{
		if(curStation.group!="sideB"){
			trace("Func|goStation station: "+station);
			return;
		}
		if(curStation==station)	return	false;
		var sideObj:Array	=	points["sideB"];
		if(curStation.index>station.index){
			obj.walk("front", "right");
			stepStation	=	[station, curStation];//一步一步走完
			stepStation.reverse();
			stepIndex	=	1;
			//当worker_mc要开始行走时,就执行这条命令
			obj.startWalk=function(){
				startMove(stepStation[0], stepStation[1]);
			}
		}else{
			obj.walk("back");
			stepStation	=	[curStation, station];//一步一步走完
			stepIndex	=	1;
			//当worker_mc要开始行走时,就执行这条命令
			obj.startWalk=function(){
				startMove(stepStation[0], stepStation[1]);
			}
		}
		obj.onWalkFinished=function(){
			if(btnName.name=="up"){
				if(btnName.index=="0"){
					obj.talk("left");//左上角第一块轮胎,特别介绍
				}else{
					obj.talk("left", true);//抬手,但不说话
				}
			}else{//下方轮胎不要抬手
				obj.stand("front", "left");
			}
			onWalkFinishFunc(obj, btnName);
		}
		return true;
	}
	
	private static function startMove(stationA:Station, stationB:Station):Void{
		var distance:Number	=	getDistance(stationA, stationB);
		var duration:Number	=	distance/100;//number 100 is speed
		tw.duration	=	duration;
		obj.v3d.x	=	stationA.v3d.x;
		obj.v3d.y	=	stationA.v3d.y;
		obj.v3d.z	=	stationA.v3d.z;
		//trace([stationA._name+"= "+stationA.v3d, stationB._name+"= "+stationB.v3d, "distance= "+distance]);
		tw.begin	=	obj.v3d.z;
		tw.finish	=	stationB.v3d.z;
		onMotionInit(tw);
		tw.start();
		
	}
	
	private static function getDistance(sA:Station, sB:Station):Number{
		var v3d:Vector3D	=	sA.v3d.minusNew(sB.v3d);
		return v3d.getLength();
	}
	
	private static function onMotionInit(tw:Tween):Void{
		var nextStation:Station	=	stepStation[stepIndex];
		obj.beginY	=	curStation.v3d.y;
		obj.changeY	=	nextStation.v3d.y-curStation.v3d.y;
		obj.beginX	=	curStation.v3d.x;
		obj.changeX	=	nextStation.v3d.x-curStation.v3d.x;

	}
	
	private static function onMotionChanged(tw:Tween):Void{
		if(obj.beginY==null)	return;
		obj.v3d.y	=	tw.func(tw.time, obj.beginY, obj.changeY, tw.duration);
		obj.v3d.x	=	tw.func(tw.time, obj.beginX, obj.changeX, tw.duration);
		//var scale	=	tw.func(tw.time, obj.beginS, obj.changeS, tw.duration);
		//obj._xscale	=	
		//obj._yscale	=	
		obj.render();
		//trace([obj.v3d,tw.begin, tw.finish])
		//trace([obj._xscale, obj.beginS, obj.changeS])
	}
	
	private static function onMotionFinished(tw:Tween):Void{
		var dir:String	=	"left";
		var lastStation:Station	=	curStation;
		curStation	=	stepStation[stepIndex];
		if(++stepIndex==stepStation.length){
			obj.onWalkFinished();
			return;
		}
		
		var nextStation:Station	=	stepStation[stepIndex];
		switch(curStation.group){
			case "sideA":
				dir	=	"right";
				switch(nextStation.group){
					case "node":
						obj.walk("left", dir);//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					case "sideA":
						obj.walk("front", dir);//从向右走转身向前走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
				}
				break;
			case "sideB":
				dir	=	"left";
				break;
			case "sideC":
				switch(nextStation.group){
					case "sideD":
						obj.walk("left");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					case "sideF":
						obj.walk("back");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					//default:
						//trace("")
				}
				break;
			case "sideD":
				switch(nextStation.group){
					case "sideC":
						obj.walk("right");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					case "sideE":
						obj.walk("back");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					//default:
						//trace("")
				}
				break;
			case "sideE":
				switch(nextStation.group){
					case "sideD":
						obj.walk("front", "right");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					case "sideF":
						obj.walk("right");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					//default:
						//trace("")
				}
				break;
			case "sideF"://只经过此点.
				switch(nextStation.group){
					case "sideC":
						obj.walk("front", "left");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					case "sideE":
						obj.walk("left");//从向后走转身向左走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					//default:
						//trace("")
				}
				break;
			case "node":
				switch(nextStation.group){
					case "sideA":
						obj.walk("front", dir);//从向右走转身向前走
						obj.startWalk=function(){
							startMove(curStation, nextStation);
						}
						break;
					case "sideB":
						if(nextStation.index>1){//从向左走转身向后走
							obj.walk("back", "left");
							obj.startWalk=function(){
								startMove(curStation, nextStation);
							}
						}else{//继续向左走
							startMove(curStation, nextStation);
						}
						
						break;
					case "node"://两个节点之间,继续行走
						switch(lastStation.group){
							case "sideA":
								obj.walk("left");//从向后走变为向左走
								obj.startWalk=function(){
									startMove(curStation, nextStation);
								}
								break;
							case "sideB":
								if(lastStation.index>1){//从向前走变为向右走
									obj.walk("right");
									obj.startWalk=function(){
										startMove(curStation, nextStation);
									}
								}else{//继续向左走
									startMove(curStation, nextStation);
								}
								break;
							case "node":
								startMove(curStation, nextStation);
								break;
						}
						
						break;
					default:
						trace("error|Station onMotionFinished nextStation.group: "+nextStation.group);
				}
				break;
			default:
				trace("error|Station onMotionFinished curStation.group: "+curStation.group);
		}
		

	}
	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*
private static function onMotionFinished(tw:Tween):Void{
		var dir:String;
		var lastStation:Station	=	curStation;
		curStation	=	nextStation;
		switch(curStation.group){
			case "sideA":
				dir	=	"right";
				break;
			case "sideB":
				dir	=	"left";
				break;
			case "node":
				switch(lastStation.group){
					case "sideA":
							
						break;
					case "sideB":
						startMove(curStation, points["node"][curStation.index-1]);
						break;
					case "node":
						if(nextStation.index>0){
							startMove(curStation, points["node"][curStation.index-1]);
						}else if(terminal.index==0){
							//if(terminal.group=="sideA")
							obj.walk("front", dir);//从向左走转身向前走
							obj.startWalk=function(){
								startMove(curStation, terminal);
							}
						}
						break;
					default:
						trace("error|Station onMotionFinished cur.group: "+lastStation.group);
				}
				break;
			default:
				trace("error|Station onMotionFinished next.group: "+curStation.group);
		}
		
		if(curStation==terminal){
			obj.talk(dir);
		}
		

	}
*/
