//******************************************************************************
//	name:	CloudyHawk 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Nov 01 11:03:03 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************




/**
 * 云层游戏中的老鹰<p>
 * 在云层中移动，捉人。
 */
class com.wangfan.rover.CloudyHawk extends MovieClip{
	private var _xSpeed:Number			=	null;
	private var _ySpeed:Number			=	null;
	private var interID:Number			=	null;
	
	private var man_mc:MovieClip		=	null;
	
	private var _bound:Object			=	{xMin:-300, xMax:300, yMin:-100, yMax:100};

	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	private function CloudyHawk(){
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		man_mc.gotoAndStop(_root.personInfo.roleNum+1);
		_visible		=	
		man_mc._visible	=	false;
	}
	
	private function moveX():Void{
		_x	+=	_xSpeed;
		if(_x<=_bound.xMin){
			if(man_mc._visible){//捉到人的老鹰
				if(_parent.deadOnce()){//人物生命值减少一条，如果还可以玩游戏
					_parent.man_mc.tryAgain();//再试一次
				}else{//游戏结束，老鹰不会再出现
					clearInterval(interID);
				}
			}
			stopMove();
			interID	=	_global.setTimeout(this, "startMove", random(4000)+2000, -4);
			return;
		}
		if(checkCatchMan()){//如果捉到人了
			man_mc._visible			=	true;
			_parent.man_mc._visible	=	false;
			_parent.man_mc.curCloud	=	null;//人物不用再跟着云层移动
		}else{
			
		}
	}
	
	private function checkCatchMan():Boolean{
		if(_parent.man_mc.isJumping)	return false;//只要人物离开云层，就表示不会被老鹰捉住
		if(man_mc._visible)	return	true; //已经捉到人了
		var pos:Object	=	{x:_x, y:_y};
		_parent.localToGlobal(pos);
		var manMC:MovieClip	=	_parent.man_mc;
		var posMan:Object	=	{x:manMC._x, y:manMC._y};
		manMC._parent.localToGlobal(posMan);
		var manBound:Object	=	manMC.getBounds();
		//trace([pos.x, pos.y, posMan.x, posMan.y])
		//trace([posMan.y+manBound.yMin,pos.y<posMan.y+manBound.yMax])
		if(pos.x>posMan.x+manBound.xMin){
			if(pos.x<posMan.x+manBound.xMax){
				if(pos.y>posMan.y+manBound.yMin){
					if(pos.y<posMan.y+manBound.yMax){

						return true;
					}
				}
			}
		}
		return false;
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	/**
	* 开始老鹰
	* @param xSpeed 移动的速度
	*/
	public function startMove(xSpeed:Number):Void{
		_xSpeed		=	xSpeed;
		_x			=	_bound.xMax;
		_visible	=	true;
		man_mc._visible	=	false;
		var pos:Object	=	{x:_x, y:_parent.globalBottonLine};
		_parent.globalToLocal(pos);
		_y			=	pos.y-90;
		onEnterFrame=render;
	}
	
	/**
	* 停止移动老鹰。
	*/
	public function stopMove():Void{
		onEnterFrame=null;
		_visible	=	false;
		clearInterval(interID);
	}
	
	/**
	* 更新云层的移动。
	*/
	public function render():Void{
		if(_parent.isPause)	return;
		moveX();
		//moveY();
	}
	
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
