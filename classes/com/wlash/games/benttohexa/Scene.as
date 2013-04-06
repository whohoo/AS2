
//******************************************************************************
//	name:	Scene 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2007-2-2 ����03:21:53
//	description: file path[D:\NoFunk&Fans\classes\com\wlash\games\benttohexa]
//******************************************************************************


import mx.transitions.Tween;
import com.wlash.games.benttohexa.Ball;
import com.wlash.games.benttohexa.BrickBall;
import com.wlash.games.benttohexa.GameLevel;

/**
 * 整个游戏的Core.<p/>
 *
 * 广播事件
 * onMelt({hits, total});//time连续消失的次数,也就是连发,total是这一次要消失多少个球
 * onCreateNew({nextBrickBall, brickBallIndex});//time连续消失的次数,也就是连发
 * onGameFail({brickBallIndex})
 */
class com.wlash.games.benttohexa.Scene extends MovieClip {
	private var balls_mc:MovieClip	=	null;
	private var curBall:BrickBall	=	null;	private var mask_mc:MovieClip	=	null;	private var pressUpLastTime:Number	=	0;//用来统计在onEnterFrame中延迟向上按键的次数,
											//如果之间的间隔超过半秒就再执行一次
	private var widthNum:Number		=	null;//可以排多少列
	private var heightNum:Number	=	null;//横向有多少行
	private var horizonHeight:Array	=	null;//横向的最低线的高度.
	private var indexPosX:Number		=	null;//横向的位置	
	private var matrix:Array		=	null;//一个二维数据矩阵.
	/**活动的球,也就是刚移动过的球.<br>结构[{mc,index},{mc,index},...]*/
	private var activeBalls:Array	=	[];
	private var metlBalls:Array		=	null;//决定要消失的球
	/**这个是用来检测当所有移动的球是否都移动过,而进行整体的判断.<br>
	 * 当所有该移动的球都移动过后,就进行判断是否有活动的球(activeBalls),<br>
	 * 如果有,就进行判断是否还有球,再进行有三连色的判断,否则掉下一组方块对象.
	 */	private var movableBalls:Array	=	null;
	private var shitBalls:Array		=	null;//这个是特别的一种色球,这种球三连色不会消失,只有当他周围八个方向的球
											//有所消失时,他才会跟着消失.
	private var brickBallIndex:Number	=	0;//已经掉下了多少块三色球的方块.
	private var hits:Number			=	0;//连击,也就是连续消失球的次数
	private var gameLevel:GameLevel	=	null;
	
	/**下一组要出现的色球*/
	public var nextBrickBall:Array	=	null;
	/**当前游戏难度级别*/
	public var level:Number			=	0;
	/**用于测试时指定生成的色球组.*/
	public  var debugArr:Array		=	[[1,0,0],//绿,红,红
										[2,1,0],//绿,绿,红										[0,1,1],//绿,绿,红
										[0,1,1],
										[2,1,0]
										];//绿,绿,红
	
	/**球的直径*/
	public  static var diameter:Number	=	null;//圆的直径
	/**最大的下降速度*/
	public  var maxSpeed:Number			=	20;
	/**在没有按下键的时候下降速度.*/
	public var speedY:Number			=	null;
	/**定义方块的形状,这是按帧来跳转来决定方块的形状*/
	public static var ballIndexFrame:Number	=	1;//缺省的第一个圆,第二个为方块,第三个为三角,每一关提供不同的物品.
	/**有多少颜色的球可随机出来.*/
	public static var maxBallColorNum:Number	=	null;
	
	//public static var tt:Function		=	null;
	
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
	private static var __mixinFED =	mx.events.EventDispatcher.initialize(Scene.prototype);
	
	private function Scene(){
		//tt	=	_global.tt;
		widthNum	=	6;//6列
		heightNum	=	13;//13行
		emptyMatrix();//生成一个新的,空的二维数组
		gameLevel	=	new GameLevel(this);
		
		init();
		setNextBrickBall();

	}
	////////////////////////[PRIVATE METHOD]\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	private function init():Void{
		activeBalls		=	[];
		metlBalls		=	[];		movableBalls	=	[];
		nextBrickBall	=	[];
		shitBalls		=	[];//{w,h,mc}
		speedY			=	1;
		diameter		=	40;
		maxBallColorNum	=	4;
		horizonHeight	=	[0,0,0,0,0,0];//六列,初始都是0
		
		
		//gameLevel.setGameLevel(5);
	}
	
	private function emptyMatrix():Void{
		//根据长宽数生成二维的矩阵,内在储存着是否有球,及球的颜色索引值
		matrix		=	[];
		for(var w:Number=0;w<widthNum;w++){
			var arr:Array	=	[];
			for(var h:Number=0;h<heightNum;h++){
				arr.push({index:-1,//颜色的索引值,如果为-1,表示为空 
						mc:null//指向当地的影片.
						//path:[]
						});//上下左右及斜角四个方向的路径.
			}
			matrix.push(arr);
		}
	}

	
	private function createNew():Void{
		var mc	=	balls_mc.attachMovie("BrickBall", "mcBrickBall", 0, 
										{_y:-mask_mc._height});
		mc.createBalls(nextBrickBall);
		setNextBrickBall();
		indexPosX	=	Math.round(widthNum/2);
		mc._x	=	indexPosX*diameter;
		curBall	=	mc;
		brickBallIndex++;
		hits	=	0;
		//当开始生成新下掉球时广播.
		dispatchEvent({type:"onCreateNew", brickBallIndex:brickBallIndex, nextBrickBall:nextBrickBall});
	};
	
	//生成下一组要出现的色球
	private function setNextBrickBall():Void{
		var num:Number	=	maxBallColorNum;
		var arr:Array	=	randomArray(num);
		arr[random(3)]	=	arr[random(num)];//有可能会有两个重复的球出现.
		//出现屎的机率,
		if(makeShit()){
			arr[random(3)]	=	8;//屎
		}else if(makeFlashStar()){
			arr[random(3)]	=	9;//闪光星
		}
		nextBrickBall	=	arr.slice(0, 3);
	}
	
	private function makeShit():Boolean{
		var retValue:Boolean	=	false;
		if(level<4)	return false;//在四级前不要出现屎
		//随机得到指定例的高度,高度越低,出现屎的机会越大,
		var colHeight:Number	=	horizonHeight[random(widthNum)]-
										//gameLevel.level+//游戏难度增大时,屎出现的机会也减少(无用,移除)
										0;
		if(random(colHeight)==0){
			retValue	=	true;
		}
		return retValue;
	}
	
	private function makeFlashStar():Boolean{
		var retValue:Boolean	=	false;
		if(level<7)	return false;//在七级前不要出现闪光星
		//随机得到指定例的高度,高度越高,出现闪光星的机会越大,
		var colHeight:Number	=	heightNum-horizonHeight[random(widthNum)]-
										//gameLevel.level+//游戏难度增大时,闪光星出现的机会也增大(无用,移除)
										0;
		if(random(colHeight)==0){
			retValue	=	true;
		}
		return retValue;
	}
	
	private function _onEnterFrame():Void{
		var pressTime:Number	=	getTimer();
		if(Key.isDown(Key.UP)){
			//isPressUp	=	true;
			if(pressTime-pressUpLastTime>=200){
				pressUpLastTime	=	getTimer();
				curBall.moveBall();
			}
		}else if(Key.isDown(Key.DOWN)){
			curBall._y	+=	(maxSpeed-speedY);
		}
		
		if(Key.isDown(Key.LEFT)){
			if(pressTime-pressUpLastTime>=200){
				pressUpLastTime	=	getTimer();
				moveLeftRight(-1);
			}
		}else if(Key.isDown(Key.RIGHT)){
			if(pressTime-pressUpLastTime>=200){
				pressUpLastTime	=	getTimer();
				moveLeftRight(1);
			}
		}
		
		moveDown();
	}
	//三个球的方块左右移动,并限制在宽度内
	private function moveLeftRight(dir:Number):Void{
		indexPosX	+=	dir;
		//trace([horizonHeight[indexPosX]*diameter,curBall._y]);
		if(indexPosX>=widthNum){//右边界
			indexPosX	-=	dir;
		}else if(indexPosX<0){//左边界
			indexPosX	-=	dir;
		}else if(horizonHeight[indexPosX]*diameter>-curBall._y){//二者之间
			indexPosX	-=	dir;
		}else{
			curBall._x	=	indexPosX*diameter;
		}
	}
	//三个球的方块下移
	private function moveDown():Void{
		curBall._y	+=	speedY;
		var bottomHeight:Number	=	-diameter*horizonHeight[indexPosX];//最低层的高度
		if(curBall._y>bottomHeight){
			curBall._y	=	bottomHeight;
			if(!freezeBall()){//把移动的三连球不可动,凝固在最低层
				stopGame();
				//当游戏失败时,广播此事件
				dispatchEvent({type:"onGameFail", totalBrickBall:brickBallIndex});
			}else{
				var arr:Array	=	checkBall(true);//查找上下左右斜线是否有相同的球色
				meltBall(arr);//把横竖斜同色的方块溶解掉
			}
			
		}
	}
	/**
	 * 把移动的三连球不可动,凝固在最低层
	 * @return false,如果越过最高界线就结束游戏
	 */
	private function freezeBall():Boolean{
		var depth:Number	=	balls_mc.getNextHighestDepth()+1;
		var mc:MovieClip	=	null;
		var verticalIndex:Number	=	null;
		var index:Number	=	null;
		for(var i:Number=0;i<3;i++){
			verticalIndex	=	horizonHeight[indexPosX]+i;
			if(verticalIndex>heightNum)	return false;
			index	=	curBall["ballBox"][i].index;
			mc		=	balls_mc.attachMovie("ball"+index, "b"+depth, depth, 
								{index:index, scene:this});//球的颜色值
			mc.position(indexPosX, verticalIndex);
			matrix[indexPosX][verticalIndex]	=	{index:index,mc:mc};
			depth++;			//trace(matrix[indexPosX][verticalIndex].index);
			if(index==8){////屎球,不活动不做判断的球,只有当他周围的球有所消失时才会带动此球消失.
				shitBalls.push({w:indexPosX, h:verticalIndex, mc:mc});
			}else{
				activeBalls.push({w:indexPosX, h:verticalIndex, mc:mc});//添加最后一次活动的球
			}
		};
		horizonHeight[indexPosX]	+=	3;
		curBall.removeMovieClip();
		return true;
	}
	/**
	 * 查找上下左右斜线是否有相同的球色
	 * @param isFirst 是否第一次检查,也就是方块掉下时,这时,activeBalls.length肯定为3,
	 * 如果是假,就是上次消除后再掉来的,所以activeBalls不一定为3,
	 * @return 四个方向是有多少个球消失.
	 */
	private function checkBall(isFirst:Boolean):Array{
		var len:Number		=	activeBalls.length;
		var mc:MovieClip	=	null;
		var obj:Object		=	null;
		var curColor:Number	=	null;//当前活动的球的颜色值
		var retValue:Array	=	[0,0,0,0];
		var actBall:Array	=	[];
		//trace("activeBalls length: "+len+" isFrist:"+isFirst);
		for(var i:Number=0;i<len;i++){
			obj	=	activeBalls[i];
			mc	=	matrix[obj.w][obj.h].mc;
			curColor	=	mc.index;
			//trace(["i: "+i, "color index: "+curColor]);
			if(isFirst){//只有是方块掉下来时才有闪光星,如果是消除后再掉下来的,就不会存在.
				if(curColor==9){//闪光球
					//var belowMC:MovieClip	=	matrix[obj.w][obj.h+1].mc;
					metlBalls	=	[obj];//闪光球无论如何都要消失,先把同色球消除后,上方掉下来再做判断
					if(obj.h!=0){//不是最低层,把闪光球下方的色球,全屏消失.
						metlBalls	=	metlBalls.concat(getArrayObjByColor(matrix[obj.w][obj.h-1].mc.index));
					}
					if(i==2){//这表示闪光星在掉下来的三连色中最上方,这样最下方的球应增加进
						actBall.push(activeBalls[0]);//当闪光星消失后下次活动的球的判断.
					}
					break;//中断for,因为先把碰到颜色的球消失掉.
				}
			}
			if(curColor==null){
				trace(["error!! mcName:"+mc._name, "color: "+curColor,"w: "+obj.w,"h: "+obj.h]);
				continue;
			}
			retValue[0]	+=	(checkVertical(curColor, obj.w, obj.h, true));//查找垂直同色球
			retValue[1]	+=	(checkHorizon(curColor, obj.w, obj.h, true));//查找水平同色球			retValue[2]	+=	(checkDiagonalLeft(curColor, obj.w, obj.h, true));//查找斜线同色球,左上角向左下角斜线			retValue[3]	+=	(checkDiagonalRight(curColor, obj.w, obj.h, true));//查找斜线同色球,右上角向右下角斜线
		}
		
		//这个不能设置为空,如果三连块最上方为闪光星,中间与最下边不是同一色的,那最下那个应还留在activeBalls中,
		//当闪光星消除后,最后一个还要继续检测是否还要消除周边的连色球.
		//trace(["1.activeBalls: "+activeBalls," actBall: "+actBall]);
		activeBalls	=	actBall;
		//trace(["2.activeBalls: "+activeBalls," actBall: "+actBall]);
		return retValue;
	}
	//查找垂直同色球
	private function checkVertical(curColor:Number, posW:Number, posH:Number, isAddMetl:Boolean):Number{
		var obj:Object		=	null;
		var mc:MovieClip	=	null;
		var colorArr:Array	=	[{w:posW,h:posH}];
		var objColor:Number	=	null;
		var arr:Array		=	matrix[posW];
		for(var h:Number=posH+1;h<heightNum;h++){//向上查找同色的球
			obj	=	arr[h];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.push({w:posW,h:h});
			}else{
				break;
			}
		}
		//trace("curColor: "+curColor);
		for(var h:Number=posH-1;h>=0;h--){//向下查找同色的球
			obj	=	arr[h];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.splice(0, 0, {w:posW,h:h});
			}else{//当出现不一样的颜色的球时,中止查找.
				break;
			}
		}
		
		return checkAddMeltBalls(colorArr, isAddMetl);
	}
	
	
	//查找水平同色球
	private function checkHorizon(curColor:Number, posW:Number, posH:Number, isAddMetl:Boolean):Number{
		var obj:Object		=	null;
		var mc:MovieClip	=	null;
		var colorArr:Array	=	[{w:posW,h:posH}];
		var objColor:Number	=	null;
		for(var w:Number=posW+1;w<widthNum;w++){//向右查找同色的球
			obj	=	matrix[w][posH];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.push({w:w,h:posH});
			}else{
				break;
			}
		}
		
		for(var w:Number=posW-1;w>=0;w--){//向左查找同色的球
			obj	=	matrix[w][posH];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.splice(0, 0, {w:w,h:posH});
			}else{//当出现不一样的颜色的球时,中止查找.
				break;
			}
		}
		return checkAddMeltBalls(colorArr, isAddMetl);
	}
	
	private function checkDiagonalLeft(curColor:Number, posW:Number, posH:Number, isAddMetl:Boolean):Number{
		var obj:Object		=	null;//{mc,index} in matrix
		var mc:MovieClip	=	null;
		var colorArr:Array	=	[{w:posW,h:posH}];
		var objColor:Number	=	null;
		for(var w:Number=posW-1, h:Number=posH+1;(w>=0 && h<heightNum);w--, h++){//向左上方向查找同色的球
			obj	=	matrix[w][h];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.push({w:w,h:h});
			}else{
				break;
			}
		}
		
		for(var w:Number=posW+1, h:Number=posH-1;(w<widthNum && h>=0);w++, h--){//向右下方向查找同色的球
			obj	=	matrix[w][h];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.splice(0, 0, {w:w,h:h});
			}else{//当出现不一样的颜色的球时,中止查找.
				break;
			}
		}
		return checkAddMeltBalls(colorArr, isAddMetl);
	}
	
	private function checkDiagonalRight(curColor:Number, posW:Number, posH:Number, isAddMetl:Boolean):Number{
		var obj:Object		=	null;
		var mc:MovieClip	=	null;
		var colorArr:Array	=	[{w:posW,h:posH}];
		var objColor:Number	=	null;
		for(var w:Number=posW+1, h:Number=posH+1;(w<widthNum && h<heightNum);w++, h++){//向右上方向查找同色的球
			obj	=	matrix[w][h];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.push({w:w,h:h});
			}else{
				break;
			}
		}
		
		for(var w:Number=posW-1, h:Number=posH-1;(w>=0 && h>=0);w--, h--){//向左下方向查找同色的球
			obj	=	matrix[w][h];
			objColor	=	obj.mc.index;
			if(objColor==curColor){
				colorArr.splice(0, 0, {w:w,h:h});
			}else{//当出现不一样的颜色的球时,中止查找.
				break;
			}
		}
		return checkAddMeltBalls(colorArr, isAddMetl);
	}
	
	function checkAddMeltBalls(colorArr:Array, isAddMetl:Boolean):Number{
		var len:Number	=	colorArr.length;
		if(isAddMetl==false)	return len;
		if(len<3){//
			//trace("竖直方向不连色数不足3个.");
			return 0;
		}else{//超过三连色,消失
			//trace("超过三连色,消失");
			var obj:Object	=	null;
			for(var i:Number=0;i<len;i++){
				obj	=	colorArr[i];
				addMetlBalls(obj.w, obj.h);//把要消除的球球添加到metlBalls数组当中,去掉重复的球球.
			};
			return len;
		}
	}
	//把要消除的球球添加到metlBalls数组当中,去掉重复的球球.
	private function addMetlBalls(w:Number, h:Number):Void{
		var len:Number	=	metlBalls.length;
		for(var i:Number=0;i<len;i++){//重复的球球就不要再添加进去
			if(metlBalls[i].w==w){				if(metlBalls[i].h==h){//重复的球不用添加进去
					return;
				}
			}
		}
		metlBalls.push({w:w, h:h});//把要消除的球的坐标写入数组中去
	}
	
	/**
	 * 把横竖斜同色的方块溶解掉,并把上方的块往下掉,
	 * @param arr 从checkBall()中返回的值,也就是横竖斜四个方向是否有消失的球
	 */
	private function meltBall(arr:Array):Void{
		var len:Number	=	metlBalls.length;
		//trace("meltBall meltBalls.length:"+len);
		if(len==0){//没有可溶解的球
			createNew();//固定后,再新建一个从上往下掉
			return;
		}
		var w:Number	=	null;		var h:Number	=	null;
		var mc:MovieClip	=	null;
		//var obj:Object		=	null;
		for(var i:Number=0;i<len;i++){//所有要消失的球
			w	=	metlBalls[i].w;			h	=	metlBalls[i].h;
			//obj	=	matrix[w][h];
			mc	=	matrix[w][h].mc;
			if(mc==null){
				trace("meltBall mc==null | w: "+w+", h: "+h);
			}else{	
				mc.melt();//在melt()方法执行完成后,会删除matrix中的mc与index
			}
		}
		metlBalls	=	[];
		mc.addEventListener("onBallMelt", this);
		//对shitBalls的检测
		var sBall:Ball	=	null;//id号为8的屎球
		//trace("shitBalls.length: "+shitBalls.length);
		for(i=0;i<shitBalls.length;){
			w	=	shitBalls[i].w;
			h	=	shitBalls[i].h;
			//obj	=	matrix[w][h];
			sBall	=	matrix[w][h].mc;
			if(checkShitBall(sBall)){//如果返回真,则他周围就是有消失的球.则屎球要消失.
				sBall.melt();//把屎球也消除掉.
				shitBalls.splice(i,1);//从数组中删除
				//i--;//因为删除了一个数,故要减去一个.
			}else{
				i++;//如果没有删除的球,继续下一个.
			}
		}
		//四个方向消失的球
		var len2:Number	=	arr.length;//实际这个值始终为4
		var meltLineNum:Number	=	0;//横竖斜四个方向消失的线的数量
		//trace(arr);
		for(i=0;i<len2;i++){
			if(arr[i]!=0){//如果某方向有消失的球线,
				meltLineNum++;//增加一个
			}
		}
		//当开始消失球时广播,并累加hits的次数
		dispatchEvent({type:"onMelt", hits:++hits, total:len, meltLineNum:meltLineNum});
		
	}
	//此事件被Ball类调用,当球消失的完成时,上方的球往下掉,填补空档.
	private function onBallMelt(evtObj:Object):Void{
		evtObj.target.removeEventListener("onBallMelt", this);//只执行一次响应的事件.
		var colActBalls:Array	=	[];//每一列活动过的球,也就是向下移动过的球.
		for(var i:Number=0;i<widthNum;i++){
			//检查每一纵列是否有空隙.如果有,上方就直接往下掉.
			colActBalls	=	colActBalls.concat(checkColumnInterspace(i));
		}
		//如果没有激活的球,也就是无刚移动过的球,就直接新建掉下的三色球.
		if(colActBalls.length==0){
			if(activeBalls.length>0){//虽然没有移动的球,但如果原来有活动的球因其它原因没有
							//检查是否有达到条件的三连色,这时要重新检测,
				var arr:Array	=	checkBall(false);
				meltBall(arr);//把横竖斜同色的方块溶解掉
			}else{
				createNew();//固定后,再新建一个从上往下掉
			}
		}else{
			activeBalls	=	colActBalls.concat(activeBalls);
		}
	}
	//检查这一纵列是否有空档的,如果有,上方的球往下掉
	private function checkColumnInterspace(num:Number):Array{
		var col:Array	=	matrix[num];
		var obj:Object	=	null;
		var mc			=	null;
		var interspaceNum:Number	=	0;//假设没有空隙,如果有空隙,上方的掉下来填充(空隙的个数)
		var retMoveObj:Array	=	[];//返回移动过(活动)的球,
		for(var i:Number=0;i<heightNum;i++){
			obj	=	col[i];
			mc	=	obj.mc;
			//trace("is Ball: "+(mc instanceof Ball));
			if(!(mc instanceof Ball) || //如果obj.mc对象不为影片,直接忽略过
						mc.state==1){//如果球正在消失的过程
				interspaceNum++;
				continue;
			}
			if(interspaceNum>0){//上方的色球往下掉
				mc.moveBallDown(interspaceNum);
				mc.addTweenListener(this);
				if(mc.index!=8){
					retMoveObj.push({w:num, h:mc.hIndex});
				}else{//如果球是屎色,就不要添加进去活动的球(activeBalls)当中去
					var len:Number	=	shitBalls.length;
					var sObj:Object	=	null;
					var sBall:Ball	=	null;
					for(var ii:Number=0;ii<len;ii++){
						sObj	=	shitBalls[ii];
						sBall	=	sObj.mc;
						if(sBall==mc){//在shtBalls中找到了自己的位置
							sObj.h	=	sBall.hIndex;//位置要相应的减少
							break;
						}
					}
				}
				movableBalls.push(mc);
			}
		}
		horizonHeight[num]	=	heightNum-interspaceNum;
		//trace("第"+num+"纵列活动的球: "+moveMC.length);
		return retMoveObj;
	}
	/**
	 * 检查此球八个方向的球,是否有满足的条件,如果找到要消失的球,返回真,否则返回假
	 * @param ball
	 * @return 
	 */
	private function checkShitBall(ball:Ball):Boolean{
		var retValue:Boolean	=	false;
		var arr:Array			=	getAroundBalls(ball);
		var len:Number			=	arr.length;
		var aBall:Ball			=	null;
		//trace(ball._name+"球周围的数量: "+arr.length+" 个球.");
		for(var i:Number=0;i<len;i++){
			aBall	=	arr[i];
			//trace("周围的球有: "+aBall._name+" onEnterFrame: "+aBall.onEnterFrame);
			if(aBall.state==1){
				retValue	=	true;
				break;
			}
			
		}
		return retValue;
	}
	
	/**
	 * 得到此球周末的球,如果球存在的话.
	 * @param ball
	 * @return 
	 */
	private function getAroundBalls(ball:Ball):Array{
		var retValue:Array		=	[];
		var aBall:Ball			=	null;
		var w:Number			=	null;		var h:Number			=	null;
		//trace(["得到此球周围的球: "+ball._name,ball.wIndex, ball.hIndex]);
		for(var ww:Number=-1;ww<2;ww++){
			for(var hh:Number=-1;hh<2;hh++){
				if(ww==0){
					if(hh==0){//跳过自己的判断
						continue;
					}
				}
				w	=	ball.wIndex+ww;
				h	=	ball.hIndex+hh;
				//trace(["in for",w,h]);
				if(w>=0){
					if(w<widthNum){
						if(h>=0){
							if(h<heightNum){//在指定的边界内
								//aBall	=	matrix[w][h].mc;
								//trace("around ball: "+aBall._name+" isBall: "+(aBall instanceof Ball)+
								//	" color: "+aBall.index+" w: "+w+" h: "+h);
								if(matrix[w][h].mc instanceof Ball){
									aBall	=	matrix[w][h].mc;
									if(aBall.state>0){//不会是已经消失.
										retValue.push(aBall);
									}
								}
							}
						}
					}
				}
			}
		}
		
		return retValue;
	}
	
	//当某个影片移动完成,删除在movableBalls当的对象
	private function onMotionFinished(tw:Tween):Void{
		tw.removeListener(this);//只执行一次,
		tw.obj.state	=	0;
		var len:Number	=	movableBalls.length;
		for(var i:Number=0;i<len;i++){
			if(movableBalls[i]==tw.obj){
				movableBalls.splice(i, 1);//删除掉
				break;
			}
		}
		//移动的球掉下来后,再次检查是否还有可消失的球...
		if(movableBalls.length==0){
			//trace("第二次判断是否有可消失的球");
			var arr:Array	=	checkBall(false);
			meltBall(arr);//把横竖斜同色的方块溶解掉
		}
	}
	
	//得到指定颜色值的数组对象
	private function getArrayObjByColor(index:Number):Array{
		var retValue:Array	=	[];//	结构{h,w}
		if(index==8){//如果闪光星的下方是屎,则只会消失闪光星
			return retValue;
		}
		var obj:Object		=	null;
		var mc:Ball			=	null;
		for(var w:Number=0;w<widthNum;w++){
			for(var h:Number=0;h<heightNum;h++){
				obj	=	matrix[w][h];
				if(obj.mc instanceof Ball){
					mc	=	obj.mc;
					if(mc.index==index){//把相符的色球添加进要消除的数组中
						retValue.push({w:mc.wIndex, h:mc.hIndex});
					}
				}else{
					break;
				}
			}
		}
		return retValue;
	}
	////////////////////////[PUBLIC METHOD]\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	/**
	 * 游戏开始
	 */
	public function startGame(){
		createNew();
		this.onEnterFrame=_onEnterFrame;
	}
	
	/**
	 * 游戏停止
	 */
	public function stopGame(){
		this.onEnterFrame=null;
	}
	
	/**
	 * 游戏继续
	 */
	public function resumeGame(){
		this.onEnterFrame=_onEnterFrame;
	}
	
	/**
	 * 定义游戏难度级别
	 * @param level
	 * @param speed [optional]
	 */
	public function setLevel(level:Number, speed:Number){
		this.gameLevel.setGameLevel(level);
		this.level		=	level;
		if(speed!=null){
			speedY	=	speed;
		}
	}
	/**
	 * 改变球的样式,每一关的,不同的样式
	 * @param frame
	 */
	public function changeBallIndexFrame(frame:Number):Void{
		curBall.changeBallIndexFrame(frame);
		//for(var w:Number=0;w<widthNum;w++){
			//for(var h:Number=0;h<heightNum;h++){
				//matrix[w][h].mc.ball_mc.gotoAndStop(frame);
			//}
		//}
	} 
	//////////////////////[STATIC METHOD]\\\\\\\\\\\\\\\\\\\\\\\\\\
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
	
	public static function cloneMatrix(mat:Array):Array{
		var retMat:Array	=	[];
		var widthNum:Number	=	mat.length;
		var heightNum:Number=	mat[0].length;
		var matW:Array		=	null;
		for(var w:Number=0;w<widthNum;w++){
			matW	=	mat[w];
			var retMatW:Array	=	[];
			for(var h:Number=0;h<heightNum;h++){
				var matWH:Object	=	matW[h];
				retMatW.push({mc:matWH.mc, index:matWH.index});
			}
			retMat.push(retMatW);
		}
		return retMat;
	}
}