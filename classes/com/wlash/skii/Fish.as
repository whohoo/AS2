//******************************************************************************
//	name:	Fish 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Apr 26 17:11:41 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "fish.fla" file.
//		
//******************************************************************************



/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.skii.Fish extends MovieClip{
	private var xPos:Array		=	null;
	private var yPos:Array		=	null;
	
	public  var coeffR:Number		=	300;
	public  var coeffC:Number		=	2;
	public  var size:Number			=	0;
	public  var baitMC:MovieClip	=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Fish(this);]
	 * @param target target a movie clip
	 */
	private function Fish(){
		xPos	=	[];
		yPos	=	[];
		
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	public function init(num, initX, initY):Void{
		num = num==null ? 30 : num;
		initX = initX==null ? 0 : initX;
		initY = initY==null ? 0 : initY;
		var i:Number = 0;
		while (i < num) {
			xPos[i] = initX;
			yPos[i] = initY;
			i++;
		}
		i = 1;
		var mc:MovieClip;
		while (i < num) {
			if (i == 1) {
				mc	=	attachMovie("Cabeza", "Pieza" + i, (num + 1) - i);
			} else if ((i == 4) || (i == 14)) {
				mc	=	attachMovie("Aletas", "Pieza" + i, (num + 1) - i);
			} else {
				mc	=	attachMovie("Espina", "Pieza" + i, (num + 1) - i);
			}
			mc._x =  xPos[i - 1];
			mc._y =  yPos[i - 1];
			mc._xscale = 100 +size*(1 - i);
			mc._yscale = 100 +size*(1 - i);
			mc._alpha = 100 - (100 / num) * i;
			i++;
		}
	}
	
	public function startMove(){
		this.onEnterFrame=function(){
			xPos[0] += ((baitMC._x - xPos[0]) ) / coeffR;
			yPos[0] += ((baitMC._y - yPos[0]) ) / coeffR;
			var i:Number = 1;
			var num:Number	=	xPos.length;
			while (i < num) {
				xPos[i] += ((xPos[i-1] - xPos[i]) / coeffC);
				yPos[i] += ((yPos[i-1] - yPos[i]) / coeffC);
				i++;
			}
			i = 1;
			var mc:MovieClip;
			while (i < num) {
				mc	=	this["Pieza" + i];
				mc._x = ((xPos[i - 1] + xPos[i]) / 2);
				mc._y = ((yPos[i - 1] + yPos[i]) / 2);
				mc._rotation = 180/Math.PI*Math.atan2(yPos[i]-yPos[i-1], xPos[i]-xPos[i-1]);
				i++;
			}
		}
	}
	
	public function stopMove(){
		this.onEnterFrame=null;
	}
	//***********************[PUBLIC METHOD]**********************************//
	

	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.

//below code were remove from above.
/*

*/
