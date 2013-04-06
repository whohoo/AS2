
//******************************************************************************
//	name:	Ball 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2007-2-7 ����02:16:30
//	description: file path[D:\NoFunk&Fans\classes\com\wlash\games\benttohexa]
//******************************************************************************

import com.wlash.games.benttohexa.Scene;
import mx.transitions.Tween;
import mx.utils.Delegate;

/**
 * 各种色球.<p/>
 *
 */
class com.wlash.games.benttohexa.Ball extends MovieClip {
	private var ball_mc : MovieClip;
	private var moveIn:Function;	private var moveOut:Function;
	private var _tw:Tween		=	null;
	/**指向Scene*/
	public  var scene:Scene		=	null;
	/**颜色值*/
	public var index:Number		=	null;
	/**横向坐标位置*/
	public var wIndex:Number	=	null;
	/**竖向坐标位置*/
	public var hIndex:Number	=	null;
	/**表示当前的状态:<br>-1:初始化前,不存在,<br> 0:正常,<br>1:消失,<br>2:向下移动<br>*/
	public var state:Number		=	-1;
	/////////////////event
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Ball.prototype);

	private function Ball(){
		state	=	0;//正常
		stop();
		_tw	=	new Tween(this, "_y", 
					mx.transitions.easing.None.easeNone,
					0, 0, .1, true);
		_tw.stop();
		ball_mc.gotoAndStop(Scene.ballIndexFrame);
	}
	
	//当色球消失掉时
	private function onMelt(mc:MovieClip):Void{
		var obj:Object	=	scene["matrix"][wIndex][hIndex];
		//trace("onMelt obj.mc: "+obj.mc._name+" this: "+this._name+" w:"+wIndex+" h:"+hIndex);
		if(obj.mc==mc){//如果此位置的对象等于自己,则把matrix中的属性删除
			obj.mc		=	null;
			obj.index	=	-1;
		}//否则是上方掉下来的对象代替了此对象,所以不用删除.
		state	=	-1;//已经不存在了.
		mc.dispatchEvent({type:"onBallMelt"});
		mc.removeMovieClip();
	}
	/**
	 * 把球放在坐标上某个位置上
	 * @param w
	 * @param h
	 */
	public function position(w:Number, h:Number):Void{
		var diameter:Number	=	Scene.diameter;
		_x		=	w*diameter;
		_y		=	-h*diameter;
		wIndex	=	w;		hIndex	=	h;
	}
	/**
	 * 球往下移动hStep个格子.
	 * @param hStep 移动的格子数
	 */
	public function moveBallDown(hStep:Number):Void{
		//trace(["moveBallDown: "+hStep, "hIndex: "+hIndex,"wIndex: "+wIndex, "mcName: "+this._name]);
		//TODO 不知是什么原因导致最低层的一个对象还要往下移一格,真是怪事!!
		if(hIndex==0){	
			trace(["error!! moveBallDown: "+hStep, "hIndex: "+hIndex,"wIndex: "+wIndex, "mcName: "+this._name]);
			return;
		}
		var diameter:Number	=	Scene.diameter;
		//trace(["moveBallDown: "+hStep, "hIndex: "+hIndex]);
		var heightIndex:Number	=	hIndex - hStep;//准备移动到的位置.
		_tw.begin		=	this._y;
		_tw.finish		=	-heightIndex*diameter;
		_tw.duration	=	hStep*.01;
		_tw.start();
		//因为球往下移到了N个格子,所以原来球的位置因被set为空
		var oldObj:Object	=	scene["matrix"][wIndex][hIndex];//原来的位置
		oldObj.index		=	-1;
		oldObj.mc			=	null;
		
		var newObj:Object	=	{index:index,mc:this};//新位置,新对象
		scene["matrix"][wIndex][heightIndex]	=	newObj;
		hIndex	=	heightIndex;
		//if(index==8){//如果此球是屎球,则shitBalls数组中的位置也要变化
			
		//}
		
		state	=	2;//向下移动
	}
	/**
	 * 添加Tween移动的完成事件,onMotionFinished
	 * @param timeline 调用此timeline上的事件
	 */
	public function addTweenListener(timeline:Object):Void{
		if(timeline!=null){
			_tw.addListener(timeline);
		}
	}
	/**
	 * 把色球消除掉,有动画过场,当消失后,上方的球往下移
	 */
	public function melt():Void{
		state	=	1;//开始消失及过程当中
		this.moveIn(null,  Delegate.create(this, onMelt));
	}
	
}