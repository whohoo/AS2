import com.wlash.games.benttohexa.Scene;
//******************************************************************************
//	name:	BrickBall 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2007-2-2 ����02:28:50
//	description: file path[D:\NoFunk&Fans\classes\com\wlash\games\benttohexa]
//******************************************************************************



/**
 * add comment here.<p/>
 *
 */
class com.wlash.games.benttohexa.BrickBall extends MovieClip {
	private var ballBox:Array		=	null;
	
	/**最上方的球*/
	public  var upBall:MovieClip	=	null;
	/**中间的球*/
	public  var midBall:MovieClip	=	null;
	/**最下方的球*/
	public  var downBall:MovieClip	=	null;
	
	private function BrickBall(){
		//var ballMC:MovieClip	=	null;
		//for(var i:Number=0;i<3;i++){
		//	ballMC	=	this["ball"+i+"_mc"];
		//	ballMC.swapDepths(i+10);
		//	ballMC.removeMovieClip();
		//}
		ballBox	=	[];
	}
	
	/**
	 * 两球交换位置.
	 * @param num1 球
	 * @param num1 球
	 */
	private function switchBall(num1:Number, num2:Number):Void{
		var ball1:MovieClip	=	ballBox[num1];
		var ball2:MovieClip	=	ballBox[num2];
		ballBox[num1]	=	ball2;
		ballBox[num2]	=	ball1;
		var tempBallPos:Object	=	{_x:ball1._x, _y:ball1._y};
		ball1._x	=	ball2._x;
		ball1._y	=	ball2._y;
		
		ball2._x	=	tempBallPos._x;
		ball2._y	=	tempBallPos._y;
	}
	
	/**
	 * 生成球,根据indexColor来的值来指定生的索引值来生成色球块.
	 * @param indexColor [optional]
	 */
	public function createBalls(indexColor:Array):Void{
		var mc:MovieClip	=	null;
		var index:Number	=	null;
		var diameter:Number		=	Scene.diameter;
		for(var i:Number=0;i<3;i++){
			index	=	indexColor[i]==null ? random(Scene.maxBallColorNum) : indexColor[i];
			mc	=	this.attachMovie("ball"+index, "mcBall"+i, i,
						 {index:index});
			mc._y	=	-diameter*i;
			//mc.gotoAndStop(Scene.ballIndex);
			ballBox[i]	=	mc;
		}
		
		//不要出现三色一样的球
		//if(ballBox[0].index==ballBox[1].index){
			//if(ballBox[0].index==ballBox[2].index){
				//createBalls();
			//}
		//}
	}
	
	/**
	 * 把球的顺序打乱掉
	 */
	public function randomBall():Void{
		for(var i:Number=0;i<3;i++){
			switchBall(i, random(3));
		}
	}
	

	/**
	 * 把最下方的球往上移,然后上边两球掉下来.
	 */
	public function moveBall():Void{
		switchBall(2, 1);
		switchBall(1, 0);
	}
	
	/**
	 * 改变球的样式,每一关的,不同的样式
	 * @param frame
	 */
	public function changeBallIndexFrame(frame:Number):Void{
		//trace(frame);
		for(var i:Number=0;i<3;i++){
			ballBox[i].gotoAndStop(frame);
		}
	} 
}