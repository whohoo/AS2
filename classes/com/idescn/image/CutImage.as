//******************************************************************************
//	name:	CutImage 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Jan 07 16:52:45 2006
//	description: 一张图片,当mouse划过时,把图片划为两部分,速度快时,是一条直线,速
//		度慢时,会切出锯齿的图片并摆几下后掉下
//		存在的bug,只能从左或从右横向切割,如果从底线或顶部切割,不会把图片切向正确
//		的方位,
//******************************************************************************

import com.idescn.utils.DynamicRegistration;
import mx.transitions.Tween;

//import mx.transitions.easing.Elastic;

class com.idescn.image.CutImage{
	private var target:MovieClip	=	null;
	private var targetA:MovieClip	=	null;//原图,变化depth[10]
	private var targetB:MovieClip	=	null;//原图复制出来的[depth]
	private var roll:MovieClip		=	null;//放在影片上方,用来判断mouse动作[100]
	private var maskA:MovieClip	=	null;//[1]
	private var maskAPoints:Object	=	null;//四个点的位置
	private var maskB:MovieClip	=	null;//[30]
	private var targetBDepth:Number	=	11;//从1开始,保留到100
	private var startPoint:Object	=	null;//进入图片的切入点
	private var endPoint:Object	=	null;//滑出图片的切点
	private var lastRip:Array		=	null;//最后一次锯齿的点数据
	//private var beforePoint:Object	=	null;//记录进入图片前最后点的坐标
	//private var afterPoint:Object	=	null;//记录滑出图片后最后点的坐标
	//private var centrePointB:Object	=	null;//被划出B部分的中心点
	
	//debug
	public static var tt:Function	=	null;
	
	/**
	* 构造函数
	* @param target
	*/
	public function CutImage(target:MovieClip){
		
		this.target	=	target._parent;
		target.swapDepths(0);
		targetA	=	target;
		
		roll	=	this.target.createEmptyMovieClip("mcRoll",1000);
		var bound:Object	=	target.getBounds();
		maskAPoints	=	{	p0:{x:bound.xMin,y:bound.yMin},	//左上
							p1:{x:bound.xMax,y:bound.yMin},	//右上
							p2:{x:bound.xMax,y:bound.yMax},	//右下
							p3:{x:bound.xMin,y:bound.yMax}		//左下
						};	
		drawRectRoll(roll,maskAPoints);
		//_global["eTrace"](bound)
		init();
		
	}
	
	/**
	* 初始化
	*/
	public function init():Void{
		//Mouse.addListener(this);
		setOnRoll(true);
	}
	
	/**
	* 捕捉mouse移动
	*/
	private function onMouseMove():Void{
		//beforePoint	=	{x:target._xmouse,	y:target._ymouse};
	}
	
	/**
	* 设置当mouse移动到图片上方或移出图片时,
	* 捕捉当开始点(startPoint)与结束点(endPoint)
	* @param enabled
	*/
	public function setOnRoll(enabled:Boolean):Void{
		if(enabled){
			var _this:Object	=	this;
			roll.onRollOver=function():Void{
				Mouse.removeListener(this);
				var _mc:MovieClip	=	_this.target;
				_this.startPoint	=	{x:_mc._xmouse,	y:_mc._ymouse,
											t:getTimer()};
				//tt(_this.beforePoint);
				
			}
			roll.onRollOut=roll.onReleaseOutside=function():Void{
				Mouse.addListener(this);
				var _mc:MovieClip	=	_this.target;
				_this.endPoint		=	{x:_mc._xmouse,	y:_mc._ymouse,
											t:getTimer()};
				_this.cut();
				
			}
			roll.useHandCursor	=	false;
		}else{
			delete roll.onRollOut;
			delete roll.onRollOver;
			delete roll.onReleaseOutside;
		}
	}
	/**
	* 检查startPoint与endPoint的连线,确定进入点与出来点与哪条边相交
	*/
	private function checkLine():Void{
		var bound:Object	=	roll.getBounds();
		var x:Number	=	endPoint.x-startPoint.x;
		var y:Number	=	endPoint.y-startPoint.y;
		var angel:Number	=	Math.atan2(y,x);
		if(x>0){//左切到右
			
		}else{//右切到左
			
		}
		//tt(bound)
	}
	/**
	* 切割图片
	*/
	private function cut():Void{
		var time:Number	=	endPoint.t-startPoint.t;
		checkLine();
		if(time>150){//如果太慢,不要切
			return;
		}
		
		//开始切时,复制一个被切掉的
		targetB.tw.stop();//停止晃动
		dropDown(targetB);//往下跌
		targetB	=	targetA.duplicateMovieClip("mcImageB"+targetBDepth,
															targetBDepth++);

		var bound:Object	=	roll.getBounds();
		maskA	=	targetA.createEmptyMovieClip("mcMaskA",1);
		maskB	=	targetB.createEmptyMovieClip("mcMaskB",30);
		var point:Object	=	null;//targetB的左上或右上边点
		point	=	drawMaskRect(bound,startPoint,endPoint,time);
		targetA.setMask(maskA);
		targetB.setMask(maskB);
		//targetB._y	+=	5;
		if(targetB._rotation2==null){
			DynamicRegistration.initialize(targetB);
		}
		targetB.setRegistration(point.x,point.y);
		
		shakeTargetB(point, time<50 ? true : false);//晃动影片
		
		drawRectRoll();//重新画过mouse响应区
	}
	
	/**
	* targetB晃几下后掉下
	* @param p0 左上角或右上角的点,如果p0.x大于0,就是右上角的点
	* 		反之是左上角的点
	* @param isDropDown 如果为true,则直接掉下来而不是晃动
	*/
	private function shakeTargetB(p0:Object,isDropDown:Boolean):Void{
		var aimAngle:Number	=	0;//默认不要晃动
		var sec:Number			=	0.01;//默认迅速的晃动结束
		if(!isDropDown){//晃几下再落下
			var bound:Object		=	roll.getBounds();
			var p1:Object			=	null;
			
			if(p0.x>0){//切点在右上角
				p1	=	{x:bound.xMin,y:bound.yMax};//左下角的点
			}else{//切点在左上角
				p1	=	{x:bound.xMax,y:bound.yMax};//右下角的点
			}
			aimAngle	=	Math.atan2(p1.x-p0.x,p1.y-p0.y)*180/Math.PI;
			sec		=	3;
		}
		var tw:Tween	=	new Tween(targetB,"_rotation2", 
									mx.transitions.easing.Elastic.easeOut, 
									0, aimAngle, sec, true);
		tw.addListener(this);
		targetB.tw	=	tw;
	}
	
	/**
	* targetB晃几下后掉下去
	*/
	private function dropDown(mc:MovieClip):Void{
		var tw:Tween	=	new Tween(mc,"_y", 
									mx.transitions.easing.Strong.easeIn, 
									mc._y, Stage.height+mc._y, 1, true);
		tw.addListener(this);
	}
	
	/**
	* 当左右晃结束后,
	*/
	private function onMotionFinished(tw:Object):Void{
		if(tw.func==mx.transitions.easing.Elastic.easeOut){//如果是晃动结束
			dropDown(tw.obj);
		}else if(tw.func==mx.transitions.easing.Strong.easeIn){//往下掉结束
			tw.obj.removeMovieClip();//当掉出场景后消失
		}
	}
	
	/**
	* 画出两个shape,
	* @param bound roll的
	* @param p2 中间的那两点
	* @param p3 中间的那两点
	* @param time 如果时间太短,则直接划直线而不是锯齿
	* @return 左或右上角的点
	*/
	public function drawMaskRect(bound:Object,p2:Object,p3:Object,
														time:Number):Object{
		maskA.beginFill(0xff0000,30);
		maskB.beginFill(0x00ff00,30);
		//maskA的左上与右上两点
		var p0:Object	=	maskAPoints.p0;//{x:bound.xMin,y:bound.yMin};
		var p1:Object	=	maskAPoints.p1;//{x:bound.xMax,y:bound.yMin};
		//maskB左下与右下两点
		var p4:Object	=	maskAPoints.p3;//{x:bound.xMin,y:bound.yMax};
		var p5:Object	=	maskAPoints.p2;//{x:bound.xMax,y:bound.yMax};
		var lastRipPoint:Array	=	null;
		//_global["eTrace"](maskAPoints);
		if(p2.x>p3.x){////////////////////////////右边切到左边
			p2.x	=	bound.xMax;
			p3.x	=	bound.xMin;
			if(time<50){//切成直线
				_drawRect(maskA,p0,p1,p2,p3);
				_drawRect2(maskB,p3,p2,p5,p4,[false,false,lastRip,false]);
				lastRip	=	null;
			}else{//切成带rip的线
				lastRipPoint	=	_drawRect2(maskA,p0,p1,p2,p3,
												[false,false,true,false]);
				_drawRect2(maskB,p3,p2,p5,p4,[true,false,lastRip,false]);
				
				lastRip	=	lastRipPoint;
			}
			maskAPoints	=	{p0:p0,p1:p1,p2:p2,p3:p3};
		}else{
			p2.x	=	bound.xMin;
			p3.x	=	bound.xMax;
			if(time<50){//切成直线
				_drawRect(maskA,p0,p1,p3,p2);
				_drawRect2(maskB,p2,p3,p5,p4,[false,false,lastRip,false]);
				lastRip	=	null;
			}else{//切成带rip的线
				lastRipPoint	=	_drawRect2(maskA,p0,p1,p3,p2,
												[false,false,true,false]);
				_drawRect2(maskB,p2,p3,p5,p4,[true,false,lastRip,false]);

				lastRip	=	lastRipPoint;
			}
			maskAPoints	=	{p0:p0,p1:p1,p2:p3,p3:p2};
		}
		
		maskA.endFill();
		maskB.endFill();
		return	p3;
	}
	
	/**
	* draw a rect
	* @param p0
	* @param p1
	* @param p2
	* @param p3
	*/
	private function _drawRect(mc:MovieClip,p0:Object,p1:Object,p2:Object,
															p3:Object):Void{
		mc.moveTo(p0.x,p0.y);
		mc.lineTo(p1.x,p1.y);
		mc.lineTo(p2.x,p2.y);
		mc.lineTo(p3.x,p3.y);
		mc.lineTo(p0.x,p0.y);
	}
	
	/**
	* draw a rect with rip line
	* @param p0
	* @param p1
	* @param p2
	* @param p3
	* @param ripPoint
	*/
	private function _drawRect2(mc:MovieClip,p0:Object,p1:Object,p2:Object,
										p3:Object,ripPoint:Array):Array{
		var p:Array		=	[p0,p1,p2,p3,p0];
		var rip:Array	=	null;
		var rPoint:Object	=	null;
		mc.moveTo(p0.x,p0.y);
		for(var i:Number=0;i<4;i++){
			rPoint	=	ripPoint[i];
			if(rPoint==true){
				rip	=	drawRip2(mc,p[i],p[i+1],5);
			}else if(rPoint instanceof Array){
				drawRip3(mc,lastRip);
			}else{
				mc.lineTo(p[i].x,p[i].y);
			}
		}
		return rip;
	}
	
	/**
	* 画带锯齿的线条,给点指定的点
	* @param mc
	* @param points
	*/
	private function drawRip3(mc:MovieClip,points:Array):Void{
		var x1:Number,y1:Number;
		var pointNum:Number	=	points.length;
		for(var i:Number=0;i<pointNum;i++){
			x1	=	points[i].x;
			y1	=	points[i].y;
			mc.lineTo(x1,y1);
		}
		
	}
	/**
	* 画带锯齿的线条,随机生成锯齿的点
	* @param mc
	* @param p0
	* @param p1
	* @param tolerate
	*/
	private function drawRip2(mc:MovieClip,p0:Object,p1:Object,
									tolerate:Number,pointNum:Number):Array{
		var x:Number = p1.x-p0.x;
		var y:Number = p1.y-p0.y;
		var x1:Number,y1:Number;
		var angel:Number	=	Math.atan2(y,x);//trace(angel*180/Math.PI);
		var tan:Number		=	Math.tan(angel);//x,y的角度的tan值
		var distance:Number =	Math.sqrt(x*x+y*y);//两点的距离
		if(pointNum==null){//直线内的点个数
			pointNum	=	Math.ceil(distance/tolerate*(1+
													(random(60)-30)/100));
		}
		var point_arr:Array	=	[];//存放点
		point_arr.push({x:p0.x,y:p0.y});//添加首点
		//trace(point_arr[0].y)
		//如果角度大于45度,则...
		var isBig:Boolean	=	Math.abs(x)>Math.abs(y) ? true : false;
		for(var i:Number=0;i<pointNum;i++){
			if(isBig){/////横线
				x1	=	(x*i/pointNum)+random(tolerate*10)/20-tolerate/4;
				y1	=	(x1)*tan+p0.y+random(tolerate*10)/10-tolerate/2;
				x1	+=	p0.x;
			}else{
				y1	=	(y*i/pointNum)+random(tolerate*10)/20-tolerate/4;
				x1	=	y1/tan+p0.x+random(tolerate*10)/10-tolerate/2;
				y1	+=	p0.y;
			}
			mc.lineTo(x1,y1);
			point_arr.push({x:x1,y:y1});
		}
		point_arr.push({x:p1.x,y:p1.y});//添加末点
		return point_arr;
	}
	
	/**
	* 画一个roll
	*/
	private function drawRectRoll():Void{
		var mc:MovieClip	=	roll;
		mc.clear();
		mc.beginFill(0xffff00,0);
		_drawRect(mc,maskAPoints.p0,maskAPoints.p1,maskAPoints.p2,maskAPoints.p3);
		mc.endFill();
	}
	
	/**
	* draw a rect with rip line
	* 此方法暂时用不上
	* @param p0
	* @param p1
	* @param p2
	* @param p3
	* @param ripPoint
	
	private function _drawRect3(mc:MovieClip,p0:Object,p1:Object,p2:Object,
										p3:Object,ripPoint:Array):Void{
		var p:Array	=	[p0,p1,p2,p3,p0];
		mc.moveTo(p0.x,p0.y);
		for(var i:Number=0;i<4;i++){
			if(ripPoint[i]){
				drawRip3(mc,lastRip);
			}else{
				mc.lineTo(p[i].x, p[i].y);
			}
		}
	}
	*/
	
	/**
	* 计算中心点,暂时用不上
	* @param p0
	* @param p1
	* @param p2
	* @param p3
	* @return point
	
	private function getCentrePoint(p0:Object,p1:Object,p2:Object,p3:Object):Object{
		var y1:Number	=	Math.abs(p2.y-p0.y);
		var y2:Number	=	Math.abs(p3.y-p1.y);
		var x1:Number	=	Math.abs(p1.x-p0.x);
		var x2:Number	=	Math.abs(p3.x-p2.x);
		var y:Number	=	y1*y2/(y1+y2);
		var x:Number	=	y*x1/y2;
		return {x:x,y:roll._height-y};
	}
	*/
	/**
	* 计算startPoint与endPoint之间的速度与方向
	* 从左到右x轴为正值,从上到下y轴为正值
	
	private function countDiffPoint():Void{
		var xDiff:Number	=	endPoint.x-startPoint.x;
		var yDiff:Number	=	endPoint.y-startPoint.y;
		var tDiff:Number	=	endPoint.t-startPoint.t;
		var xSpeend:Number	=	xDiff/tDiff;//x轴方向的速度
		var ySpeend:Number	=	yDiff/tDiff;//y轴方向的速度
		cut();
	}
	*/
	/**
	* 显示名称
	* @return string
	*/
	public function toString():String{
		return "CutImage 1.0";
	}
	
	///////debug
	/**
	* 画出一条线
	
	private function drawLine(mc:MovieClip,p0:Object,p1:Object):Void{
		//var mc:MovieClip	=	target.createEmptyMovieClip("mcPoint",1000);
		//mc.lineStyle(.1,0xff0000,100);
		mc.moveTo(p0.x,p0.y);
		mc.lineTo(p1.x,p1.y);
		//mc.endFill();
	}
	*/
}