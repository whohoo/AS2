//******************************************************************************
//	name:	Member 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		
//******************************************************************************


import com.idescn.as3d.Vector3D;
import mx.utils.Delegate;
import com.wangfan.website.member.LoadXmlData;
/**
 * 在member.swf中的动态菜单.<p></p>
 * 菜单XML数据
 */
class com.wangfan.website.member.Member extends MovieClip{
	private var name_mc:MovieClip		=	null;
	
	private var pointID:String			=	"stickBall";
	private var points:Array			=	null;
	private var randomNum:Array			=	null;
	private var _curPoint:MovieClip	=	null;//指向点
	private var _curIndex:Number		=	0;
	private var _totalPoint:Number		=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoadXmlMenu4Lab(this);]
	 * @param target target a movie clip
	 */
	private function Member(){
		points	=	[];
		name_mc.swapDepths(1000000);
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function createPoint():MovieClip{
		var index:Number	=	points.length;
		var mc:MovieClip	=	createEmptyMovieClip("mcPoint"+index, index);
		points.push(mc);
		mc.v3d	=	new Vector3D(0, 0, 0);
		mc		=	mc.attachMovie(pointID, "point", 0);
		return mc._parent;
	}
	//更新point的位置
	private function renderPoint():Void{
		var len:Number		=	points.length;
		var mc:MovieClip	=	null;
		var v3d:Vector3D	=	null;
		var presp:Number	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	points[i];
			presp	=	mc.v3d.getPerspective(1000);
			v3d	=	mc.v3d.persProjectNew(presp);
			mc._x		=	v3d.x;
			mc._y		=	v3d.y;
			mc._xscale	=
			mc._yscale	=	presp*20+random(4)*10;
			mc.swapDepths(Math.round(presp*1000));
			checkLapOver(mc, i);
			mc._visible	=	true;
		}
	}
	//检查是否重叠，
	private function checkLapOver(mc0:MovieClip, len:Number):Void{
		//var len:Number	=	points.length;
		var mc:MovieClip	=	null;
		var distance:Number	=	null;
		var diffDistance:Number	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	points[i];
			distance	=	getDistance(mc, mc0);
			diffDistance	=	distance-(mc._width+mc0._width)/2;
			if(diffDistance<0){//两点之间的距离小于两球的半径，也就是重叠要一起了。
				if(distance<10){//之间的距离太小,移动对象
					mc._y	+=	10;
					mc0._y	-=	10;
				}else{//缩小对象
					mc._width	-=	5;
					mc._height	-=	5;
					mc0._width	-=	5;
					mc0._height	-=	5;
				}
				//mc._alpha	=	
				//mc0._alpha	=	50;
			}
		}
	}
	
	private function getDistance(mc0:MovieClip, mc1:MovieClip):Number{
		var x:Number	=	mc0._x-mc1._x;
		var y:Number	=	mc0._y-mc1._y;
		return Math.sqrt(x*x+y*y);
	}
	
	private function setPosition(mc:MovieClip):Void{
		var v3d:Vector3D	=	mc.v3d;
		var index:Number	=	mc.getDepth();
		switch(index%3){
			case 0:
				v3d.x	=	0;
				v3d.y	=	random(10)*2+150;
				v3d.z	=	random(10)*2+120;
				break;
			case 1:
				v3d.x	=	0;
				v3d.y	=	random(10)*2+50+240;
				v3d.z	=	random(10)*2+170;
				v3d.rotateY(1/_totalPoint*100);//修正位置
			case 2:
				v3d.x	=	0;
				v3d.y	=	random(10)*2+50+270;
				v3d.z	=	random(10)*2+170;
				v3d.rotateY(1/_totalPoint*200);//修正位置
		}
		v3d.rotateY(index/_totalPoint*300);
		
		v3d.rotateY(30);//人物后不会有点存在。
		mc._visible	=	false;
	}
	
	private function _onShowPoints():Void{
		var interTimes:Number	=	5;//多少次onEnterFrame后执行一次以下代码。
		if(_curIndex%interTimes==0){
			var mc	=	points[randomNum[_curIndex/interTimes]];
			mc.point.moveIn(null, Delegate.create(mc.point, mc.point.stickMouse));
			if(_curIndex==points.length*interTimes){
				onEnterFrame	=	null;
			}
		}
		_curIndex++;
		
	}
	//当name出现时，随着点移动
	private function onSticking(evtObj:Object):Void{
		var pos:Object	=	{x:evtObj.x, y:evtObj.y};
		var pPoint:MovieClip	=	evtObj.target._parent;
		pPoint.localToGlobal(pos);
		pPoint._parent.globalToLocal(pos);
		name_mc._x	=	pos.x;
		name_mc._y	=	pos.y-pPoint._height/2-5;
		
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 根据XML生成点
	 * 
	 * @param   child 
	 */
	public function createPoints(child:XMLNode):Void{
		_totalPoint		=	child.childNodes.length;
		child	=	child.firstChild;
		var mc:MovieClip	=	null;
		while(child!=null){
			mc		=	createPoint();
			setPosition(mc);
			mc.picUrl		=	child.attributes.profile_pic;
			mc.memberName	=	child.firstChild.nodeValue;
			mc.link			=	child.attributes.personal_url;
			mc.onRelease=function():Void{//trace(LoadXmlData.WEB_SITE+this["picUrl"])
				_parent._parent.picUrl	=	LoadXmlData.WEB_SITE+this["picUrl"];
				//更多详细资料。
				if(this["link"]!="none"){
					_parent._parent.link	=	this["link"];
				}else{
					_parent._parent.link	=	null;
				}
				enabledPoints(false);
				_parent._parent.gotoAndPlay("goDetail");
				this.onRollOut();
			}
			mc.onRollOver=function():Void{
				_parent.name_mc.name_mc.name_txt.text	=	this["memberName"];
				_parent._curPoint	=	this.point;
				this.point.addEventListener("onSticking", _parent);
				//_parent.name_mc.gotoAndPlay(1)
				//trace([this.point, _parent.name_mc.moveIn])
				_parent.name_mc.moveIn();
			}
			mc.onRollOut=mc.onReleaseOutside=function():Void{
				this.point.removeEventListener("onSticking", _parent);
				_parent._curPoint	=	null;
				_parent.name_mc.moveOut();
			}
			
			child	=	child.nextSibling;
		}
		renderPoint();
		_curIndex	=	0;
		randomNum	=	randomArray(points.length);//随机出现
		onEnterFrame=_onShowPoints;

	}
	/**
	 * 表示按键是否可用
	 * 
	 * @param   enabled 
	 */
	public function enabledPoints(enabled:Boolean):Void{
		var len:Number	=	points.length;
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<len;i++){
			mc	=	points[i];
			mc.enabled	=	enabled;
		}
	}
	
	//***********************[STATIC METHOD]**********************************//
	/**
	 * 得到随机的0-num的数组
	 * 
	 * @param   num 
	 * @return  
	 */
	public static function randomArray(num:Number):Array{
		var sortArr:Array	=	[];
		for(var i:Number=0;i<num;i++){
			sortArr.push(i);
		}
		var randomNum:Number	=	null;
		var rNum:Number		=	null;
		for(i=0;i<num;i++){
			randomNum	=	random(num);
			rNum		=	sortArr[randomNum];
			sortArr[randomNum]	=	sortArr[i];
			sortArr[i]	=	rNum;
		}
		
		return sortArr;
	}
}//end class
//This template is created by whohoo.
