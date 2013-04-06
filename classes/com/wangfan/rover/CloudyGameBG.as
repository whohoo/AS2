//******************************************************************************
//	name:	CloudyGameBG 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Nov 01 11:03:03 2006
//	description: This file was created by "box.fla" file.
//		
//******************************************************************************


import com.wangfan.rover.CloudGame;

/**
 * 云层游戏背景图移动<p>
 * 
 */
class com.wangfan.rover.CloudyGameBG extends MovieClip{
	private var left0:MovieClip		=	null;
	private var left1:MovieClip		=	null;
	
	private var upMC:MovieClip			=	null;
	private var downMC:MovieClip		=	null;
	private var cloudGame:CloudGame		=	null;
	
	//单个壁的高度。如果小于这个距离，就应换位了。
	private var _sHeight:Number		=	0;
	/**检查点，如果超过这个点，就换位*/
	public  var checkPoint:Object		=	null;

	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	private function CloudyGameBG(){
		cloudGame	=	_parent["_parent"];
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		upMC	=	left1;
		downMC	=	left0;

		_sHeight	=	downMC._y-upMC._y;
		
		
		//onSceneMoving();
	}
	private function onSceneMoving(evtObj:Object):Void{
		var pos:Object	=	{x:downMC._x, y:downMC._y};
		localToGlobal(pos);
		//trace([pos.y, checkPoint.y+_sHeight])
		if(pos.y-cloudGame.globalBottonLine>_sHeight+20){
			downMC._y	=	upMC._y-_sHeight;
			downMC.swapDepths(upMC);
			//upMC与downMC交换。
			var tempMC:MovieClip	=	downMC;
			downMC	=	upMC;
			upMC	=	tempMC;
		}

	}
	
	//***********************[PUBLIC METHOD]**********************************//
	

	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
