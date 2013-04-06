
//******************************************************************************
//	name:	GameLevel 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2007-2-13 ����02:51:20
//	description: file path[D:\NoFunk&Fans\classes\com\wlash\games\benttohexa]
//******************************************************************************

import com.wlash.games.benttohexa.Scene;
import com.wlash.games.benttohexa.BrickBall;

/**
 * 定义游戏的难度级别.<p/>
 *
 */
class com.wlash.games.benttohexa.GameLevel extends Object {
	private var matrix:Array	=	null;//初始的matrix
	private var _scene:Scene	=	null;
	private var fixBalls:Array	=	[[0,0],
									[1,1],
									[1,1],
									[2,3],
									[2,3],
									[3,2]];//用于测试时使用
	/**游戏难度的级别*/
	//public  var level:Number	=	0;
	/**
	 * 生成可控制游戏难度的类
	 * @param scene
	 */
	public function GameLevel(scene:Scene){
		this._scene	=	scene;
		//得到一个全空的matrix矩阵, 引用
		matrix	=	scene["matrix"];//.concat();
		
	}
	
	private function getNewColorIndex(index:Number, retCheck:Number, allColorBox:Array):Number{
		var retIndex:Number	=	index;
		if(retCheck>=3){
			if(index!=null){//不是第一次得到随机数
				if(random(20)==0){//有一定的概率得到屎星
					return 8;//得到屎星
				}
			}
			retIndex	=	random(allColorBox.length);
			allColorBox.splice(retIndex, 1);//去掉一个不能再显示的颜色.
			//trace("原来的颜色: "+index+" | 生成的颜色: "+retIndex+" | 剩下的颜色: "+allColorBox);
		}
		return retIndex;
	}
	
	/**
	 * 定义游戏难度
	 * @param level
	 */
	public function setGameLevel(level:Number):Void{
		//this.level			=	level;	
		var width:Number	=	_scene["widthNum"];
		var mc:MovieClip	=	null;		var index:Number	=	null;		var depth:Number	=	_scene["balls_mc"].getNextHighestDepth()+1;
		var maxBallColor:Number	=	Scene.maxBallColorNum;
		for(var w:Number=0;w<width;w++){
			//至少到高度的一半.比如定义的level为4,那么最底层的两层是填满的,而倒数第三第四层可能
			//为有或没有,如果level为6,那最底层的三层为填满的,而第四,五,六层可能有或没有球.
			var height:Number	=	level-random(Math.ceil(level/2));
			//height	=	fixBalls[w].length;//**DUBUG**
			//trace("setGameLevel height: "+height+" | level: "+level);
			
			var retCheck:Number	=	null;
			for(var h:Number=0;h<height;h++){
				var allColorBox:Array	=	[];//当有三连色的球,备选的球
				for(var i:Number=0;i<maxBallColor;i++){
					allColorBox.push(i);
				}
				//得到随机的球
				index		=	getNewColorIndex(index, 3, allColorBox);
				//检测重复的球
				retCheck	=	_scene["checkVertical"](index, w, h, false);
				index		=	getNewColorIndex(index, retCheck, allColorBox);
				retCheck	=	_scene["checkHorizon"](index, w, h, false);
				index		=	getNewColorIndex(index, retCheck, allColorBox);
				retCheck	=	_scene["checkDiagonalLeft"](index, w, h, false);
				index		=	getNewColorIndex(index, retCheck, allColorBox);
				retCheck	=	_scene["checkDiagonalRight"](index, w, h, false);
				index		=	getNewColorIndex(index, retCheck, allColorBox);
				
				//index	=	fixBalls[w][h];//**DUBUG**
				mc		=	_scene["balls_mc"].attachMovie("ball"+index, "b"+depth, depth, 
								{index:index, scene:_scene});//球的颜色值
				mc.position(w, h);
				matrix[w][h]	=	{index:index, mc:mc};
				//_scene["matrix"]	=	matrix.concat();
				depth++;
			}
			_scene["horizonHeight"][w]	=	height;
		}
		//_scene.nextBrickBall	=	[0,4,9];//**DUBUG**
		
		
	}
}