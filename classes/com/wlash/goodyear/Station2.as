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
	//public static var nextStation:Station;
	//public static var terminal:Station;
	public static var stepStation:Array;//各个点行走的路径
	public static var stepIndex:Number;//当前的index位置
	public static var obj:MovieClip;
	public static var perspective:Number;
	public static var tw:Tween;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	[Inspectable(defaultValue="sideA", verbose=0, type=List, enumeration="sideA,sideB,node"))]
	function set group(value:String):Void{
		if(value=="sideA" || value=="sideB" || value=="node"){
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
		asset_mc._alpha	=	40;
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
		
		for(var prop in points){
			gObj	=	points[prop];
			var len:Number	=	gObj.length;
			var mc:Station;
			for(var i:Number=0;i<len;i++){
				mc	=	gObj[i];
				//mc._yscale	=	
				//mc._xscale	=	
				mc.scale	=	perspective*(mc._xscale-minMC._xscale)+min;
				//trace([mc._name, "mc.scale= ", mc.scale,"mc.v3d.z= " , mc.v3d.z])
				mc.onRelease=function(){
					var station	=	this;
					goStation(station);
				}
			}
		}
		obj.v3d	=	curStation.v3d.getClone();
		tw	=	new Tween(obj.v3d, "z", 
					mx.transitions.easing.None.easeNone,
					curStation.v3d.z, curStation.v3d.z, 1, true);
		tw.stop();
		tw.addListener(Station);
	}
	
	/**
	 * make obj move to the station.
	 * 
	 * @param   station 
	 */
	public static function goStation(station:Station):Void{
		if(station==stepStation[stepStation.length-1])		return;
		if(station.group=="node")	return;
		var nodes:Object	=	points["node"];
		if(station.group==curStation.group){
			stepStation	=	[curStation, station];//一步走完
			stepIndex	=	1;
			if(station.index>curStation.index){//向后走
				//obj.actionLabel	=	"walk_back";
				obj.walk("back");
			}else{//向前走
				//obj.actionLabel	=	"walk_front_right";
				obj.walk("front", "right");
			}
			//当worker_mc要开始行走时,就执行这条命令
			obj.startWalk=function(){
				startMove(stepStation[0], stepStation[1]);
			}
		}else if(station.group=="sideA"){//from sideB to sideA, need through node station,
			stepStation	=	[curStation, nodes[1], nodes[0], station];//一步一步走完
			stepIndex	=	1;
			if(curStation.index>1){//means index= 2,3
				obj.walk("front", "right");
			}else{
				obj.walk("right");
			}
			obj.startWalk=function(){
				startMove(stepStation[0], stepStation[1]);
			}
		}else if(station.group=="sideB"){//from sideA to sideB, need through node station,
			stepStation	=	[curStation, nodes[0], nodes[1], station];//一步一步走完
			stepIndex	=	1;
			obj.walk("back");
			obj.startWalk=function(){
				startMove(stepStation[0], stepStation[1]);
			}
		}
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
			obj.talk(dir);
			return;
		}
		
		var nextStation:Station	=	stepStation[stepIndex];
		switch(curStation.group){
			case "sideA":
				dir	=	"right";
				break;
			case "sideB":
				dir	=	"left";
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
