//******************************************************************************
//	name:	Bait 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Apr 26 17:59:07 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "fish.fla" file.
//		
//******************************************************************************



/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.skii.Bait extends MovieClip{
	private var diffX:Number	=	null;
	private var diffY:Number	=	null;
	private var targetX:Number	=	null;
	private var targetY:Number	=	null;
	private var xPos:Number		=	null;
	private var yPos:Number		=	null;
	private var speed:Number	=	null;
	private var timer:Number	=	-1;
	public  var width:Number	=	500;
	public  var height:Number	=	500;
	public  var pauseTime:Number	=	2000;
	public  var baseSpeed:Number	=	.8;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new Bait(this);]
	 * @param target target a movie clip
	 */
	private function Bait(){
		_visible	=	false;
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		//reset();
	}
	
	private function getdistance(x, y, x1, y1) {
		var a:Number	=	x1-x;
		var b:Number	=	y1-y;
        return Math.sqrt((a * a) + (b * b));
    }
	
	private function reset() {
        xPos = _x;
        yPos = _y;
        speed = Math.random() + baseSpeed;
        targetX = Math.random() * width;
        targetY = Math.random() * height;
        var distance:Number = getdistance(xPos, yPos, targetX, targetY);

        diffX = (targetX - xPos) * speed / distance;
        diffY = (targetY - yPos) * speed / distance;
    };
	
	private function move() {
        if (getdistance(xPos, yPos, targetX, targetY) > speed) {
            xPos += diffX;
            yPos += diffY;
        } else {
            xPos = targetX;
            yPos = targetY;
			reset();
		}
        _x = xPos;
        _y = yPos;
    };
	
	public function startMove(){
		onEnterFrame=move;
		
	}
	
	public function stopMove(){
		onEnterFrame	=	null;
	}
	//***********************[PUBLIC METHOD]**********************************//
	
	
	
	
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.

//below code were remove from above.
/*

*/
