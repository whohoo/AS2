//******************************************************************************
//	name:	CloudyMan 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Nov 01 11:03:03 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************


import com.wangfan.rover.Cloud;

/**
 * 在云层中跳跃的人物<p>
 * 按空格键跳起
 */
class com.wangfan.rover.CloudyMan extends MovieClip{
	private var man_mc:MovieClip		=	null;
	
	private var _xSpeed:Number			=	null;
	private var _ySpeed:Number			=	null;
	private var _xPos:Number			=	null;
	private var _yPos:Number			=	null;
	private var _isJumping:Boolean		=	null;//如果为真，就更新moveY方法
	
	private var _interID:Number		=	null;
	
	private var _curCloud:Cloud			=	null;
	private var _prevCloud:Cloud		=	null;
	/**表明是否为最后一跳，如果是，则跳完上桥后就直接完成游戏*/
	public  var isLastJump:Boolean	=	null;
	
	/**场景中所有云朵*/
	public  var cloudBox:Array			=	null;
	/**可站在云朵上的位置*/
	private var _cloudBound:Object		=	{xMin:-35, xMax:35, yMin:-10, yMax:30};
	/**向下的重力值*/
	static public var gravity:Number	=	.9;
	/**水平方向的摩擦力*/
	static public var hFriction:Number	=	.01;
	//************************[READ|WRITE]************************************//
	function set curCloud(cloud:Cloud):Void{
		if(cloud==null){
			_curCloud.removeEventListener("onChangeDirection", this);
		}else{
			_xSpeed		=	cloud["_xSpeed"];
			cloud.addEventListener("onChangeDirection", this);
		}
		_curCloud	=	cloud;
	}
	/**当前站在某云层上。*/
	function get curCloud():Cloud{
		return _curCloud;
	}
	//************************[READ ONLY]*************************************//
	/**当前人物是站在云层上还是跳在空中。*/
	function get isJumping():Boolean{
		return _isJumping;
	}	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	private function CloudyMan(){
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		enabled			=	
		useHandCursor	=	false;
	}
	
	private function moveX():Void{
		if(_isJumping){//在空中时，横向速度会减少。
			_xSpeed	*=	(1-hFriction);
		}
		_x	+=	_xSpeed;
	}
	private function moveY():Void{
		_y	+=	_ySpeed;
		
	}
	
	//click mouse, the man jump
	private function onPress():Void{
		if(!_visible)	return;//如果人被老鹰捉走，则人不可见。
		man_mc.gotoAndPlay("down");
		//jump();
	}
	
	private function onKeyDown():Void{
		if(Key.isDown(Key.SPACE)){
			onPress();
		}
	}
	
	private function render():Void{
		if(_parent.isPause)	return;
		moveX();
		
		if(_isJumping){//当站在跳在空中时，才会计算重力引起的竖直方向的变化。
			_ySpeed	+=	gravity;
			moveY();
			checkPoint();
		}
		
	}
	//检查是否站到云朵上了
	private function checkPoint():Void{
		if(_ySpeed>0){//往下掉
			man_mc.gotoAndStop("fall");
			var pMan:Object	=	{x:_x, y:_y};
			_parent.localToGlobal(pMan);
			//这是最后一跳，也就是到桥上了
			if(isLastJump)	{
				var pBridge:Object	=	{x:_parent.bridgeMC._x, y:_parent.bridgeMC._y};
				_parent.bgSide_mc.localToGlobal(pBridge);
				if(pMan.y>=pBridge.y){
					onStandUpBridge(pBridge.x);
				}
				return;
			}
			//判断是否站到云层上
			var len:Number	=	cloudBox.length;
			var cloudMC:Cloud	=	null;
			for(var i:Number=0;i<len;i++){
				cloudMC	=	cloudBox[i];
				if(!cloudMC._visible)	continue;
				//在云朵竖直条内
				if(_x>=cloudMC._x+_cloudBound.xMin){
					if(_x<=cloudMC._x+_cloudBound.xMax){
						//在云朵横条内
						if(_y>=cloudMC._y+_cloudBound.yMin){
							if(_y<=cloudMC._y+_cloudBound.yMax){
								onStandUpCloud(cloudMC);
								break;
							}
						}
					}
				}
			}
			//人物掉到屏幕下方不可见。
			var pMask:Object	=	{x:0, y:_parent.vBound.yMax};
			_parent._parent.localToGlobal(pMask);
			if(pMan.y>=pMask.y+_height){
				if(_parent.deadOnce()){
					tryAgain();
				}
			}
		}
	}
	//当人站到云层上时
	private function onStandUpCloud(cloudMC:Cloud):Void{
		_isJumping	=	false;
		_ySpeed		=	0;
		curCloud	=	cloudMC;
		man_mc.gotoAndPlay("stand");
		if(cloudMC.onEnterFrame==null){//不会移动的云层
			if(cloudMC.hasQuestion){//有问题的云层
				cloudMC.questionSymbol_mc._visible	=	false;
				cloudMC.hasQuestion	=	false;//不用再出现问号
				_parent.meetQuestion(cloudMC);
			}
		}
		
		//移动背景图层。
		var distance:Number	=	_prevCloud._y-cloudMC._y;
		if(distance>10){
			_parent.moveDown(distance);
		}
		_prevCloud	=	cloudMC;
	}
	//当完成时，跳到桥上
	private function onStandUpBridge(xPos:Number):Void{
		_isJumping	=	false;
		_ySpeed		=	0;
		man_mc.gotoAndPlay("stand");
		_y	-=	Math.abs(xPos)*.02;
		_parent.stopGame(true);
	}
	
	//云层走到左或右尽头时改变方向。
	private function onChangeDirection(evtObj:Object):Void{
		_xSpeed	=	evtObj.xSpeed;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/*
	* 如果失败了，再来一次
	*/
	public function tryAgain():Void{
		_isJumping	=	false;//trace([_curCloud, _prevCloud])
		curCloud	=	_prevCloud;
		_ySpeed		=	0;
		_parent.readyGame(_prevCloud);
	}
	
	/**
	* 人物准备好了，可以开始点击跳跃。
	*/
	public function startGame():Void{
		Key.addListener(this);
		isLastJump	=	false;
		enabled		=	true;
		onEnterFrame=render;
		
	}
	
	/**
	* 人物不能再跳跃。
	*/
	public function stopGame():Void{
		isLastJump	=	false;
		enabled		=	false;
		stopMove();
		Key.removeListener(this);
	}
	/**
	* 人物开始跳跃。
	*/
	public function jump():Void{
		if(!_visible)	return;//如果人被老鹰捉走，则人不可见。则不会被跳起
		if(_isJumping)	return;//如果已经在空中了，不会连续跳起。
		_ySpeed		=	-20;
		_isJumping	=	true;
		//_prevCloud	=	_curCloud;
		curCloud	=	null;
	}
	/**
	* 停止人物的移动。
	*/
	public function stopMove():Void{
		onEnterFrame=null;
	}
	
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
