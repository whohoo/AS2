//******************************************************************************
//	name:	GuessNumber 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 24 21:25:26 GMT+0800 2006
//	description: This file was created by "rover_法国1.fla" file.
//		
//******************************************************************************



import mx.utils.Delegate;

/**
 * 猜数字游戏.<p></p>
 * 10到30的数字中,随机出现一个数字,此数字不能被4整除.
 * 用户在三个数字中猜出一个,然后电脑给出你猜的数字后一个或两个或三个数字,
 * 然后你继续猜数字,直到最后让电脑说出随机数的结果.<br>
 * 提示:把随机数连续减4,直到最后结果为1,或2或3.每次连续减4得到的数字就是
 * 游戏胜利的关键数字,如果你没选中关键数字,被电脑选中,那你这一局是输定了,
 * 因为电脑会选着关键数字不放.
 */
class com.wangfan.rover.GuessNumber extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _opponentBox:Array		=	null;
	private var _selfBox:Array			=	null;
	
	private var _aimNum:Number			=	null;
	//private var _opponentNum:Array		=	[];//历史的数字
	//private var _selfNum:Array			=	[];
	private var _currNum:Number		=	0;
	private var _gamePath:Array			=	null;
	private var _aimTXT:TextField		=	null;
	/**出现最大的数值*/
	public  var maxNum:Number			=	30;
	/**出现最小数值*/
	public  var minNum:Number			=	10;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new GuessNumber(this);]
	 * @param target target a movie clip
	 */
	public function GuessNumber(target:MovieClip){
		this._target	=	target;
		this._aimTXT	=	target.aim_txt;
		
		_opponentBox	=	[target.opponent0,
							target.opponent1,
							target.opponent2
							];
		_selfBox		=	[target.self0,
							target.self1,
							target.self2
							];
		init();
		//_target._x	+=	300;_target._y	+=	300;
	}
	
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		for(var i:Number=0;i<3;i++){
			initSelf(_selfBox[i]);
		}
	}
	
	private function initSelf(mc:MovieClip):Void{
		mc.onRelease=Delegate.create(mc, onSelfRelease);
		mc.pClass	=	this;
	}
	
	private function onSelfRelease():Void{
		var pClass:Object	=	this["pClass"];
		pClass.givenNumber(Number(this["num_txt"].text));
		pClass.countResult();
	}
	//得到游戏成功的关键数字路径
	private function getGamePath():Void{
        _gamePath	=	[];
        var aimNum:Number	=	_aimNum - 1;
		var len:Number	=	Math.round(_aimNum / 4);
		for(var i:Number=0;i<len;i++){
			_gamePath.push(aimNum - i*4);
		}
        _gamePath.reverse();
		trace(_aimNum+" : "+_gamePath);
    }
	//电脑假设的数字
	private function givenNumber(num:Number):Void{
        var hasKeyNum:Boolean	=	false;
        var nextKeyNum:Number	=	-1;
		var len:Number			=	null;
		for(var i:Number=0;i<3;i++){
			_opponentBox[i].num_txt.text	=	"";
			len		=	_gamePath.length;
			for(var j:Number=0;j<len;j++){
				//trace([num+i+1, _gamePath[j]])
				if ((num + i+1) == _gamePath[j]) {
                    nextKeyNum	=	num + i+1;
                    hasKeyNum	=	true;
                }
			}
		}
        //trace("hasKeyNum: "+hasKeyNum);
        if (hasKeyNum) {//如果对手有唯一达到终点的关键数字，就始终占住（拥有）
			len	=	nextKeyNum - num;
			//trace("len: "+len);
			for(j=0;j<len;j++){
				_opponentBox[j].num_txt.text	=	String(num + j+1);
			}
			_currNum	=	Number(_opponentBox[j-1].num_txt.text);
        } else {
            if (num + 2 <= _aimNum) {
                len = random(2)+1;
            } else if (num + 1 <= _aimNum) {
                len = 1;
            }
			//定义电脑可显示的数字（一个或两个），不包括关键数字
			for(j=0;j<len;j++){
				_opponentBox[j].num_txt.text	=	String(num + j+1);
			}
			_currNum	=	Number(_opponentBox[j-1].num_txt.text);
           
        }
        postNumber(_currNum+1);
    }
	//定义我方显示的数字
	private function postNumber(num:Number):Void{
		//trace("nextNumber: "+num);
		var aimNum:Number	=	_aimNum;
		var selfMC:MovieClip	=	null;
		for(var i:Number=0;i<3;i++){
			var selfMC	=	_selfBox[i];
			if(num+i<aimNum){
				selfMC.num_txt.text	=	num + i;
				selfMC.enabled		=	true;
			}else{
				selfMC.num_txt.text	=	"";
				selfMC.enabled		=	false;
			}
		}
	}
	//每次按键结束后计算是否游戏成功
	private function countResult():Void {
		var givenNum:Number	=	Number(_opponentBox[0].num_txt.text);
        if(givenNum == _aimNum){
            stopGame(true);
        }else{
            var isLost:Boolean	=	false;
			var aimNum:Number	=	_aimNum-1;
			for(var i:Number=0;i<3;i++){
				givenNum	=	Number(_opponentBox[i].num_txt.text);
				if(givenNum==aimNum){
					isLost	=	true;
					break;
				}
			}
			if(isLost){
				stopGame(false);
			}
        }
    }
	
	//得到随机数字
	private function getRandomAimNumber():Void{
		var tempNum:Number	=	null;
		while(true){
			tempNum	=	random(maxNum-minNum+1)+minNum;
			if(tempNum!=_aimNum){//保证不与上次数值现同
				if(tempNum%4 != 1){//tempNum-1的余数不能为0
					_aimNum	=	tempNum;
					break;
				}
			}
		}
		//_aimNum	=	12;//debug
		_aimTXT.text	=	_aimNum.toString();
	}
	
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 游戏开始
	*/
	public function startGame():Void{
		getRandomAimNumber();
		getGamePath();
		_currNum	=	0;
		postNumber(1);
		for(var i:Number=0;i<3;i++){
			_opponentBox[i].num_txt.text	=	"";
		}
	}
	/**
	* 游戏结束
	* @param	isWin
	*/
	public function stopGame(isWin:Boolean):Void{
		if(isWin){
			_target._parent.gotoAndPlay("成功");
		}else{
			_target._parent.gotoAndStop("失败");
		}
		//reset state
		for(var i:Number=0;i<3;i++){
			_selfBox[i].gotoAndStop(1);
		}
	}
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "GuessNumber 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.



/*
//for(i=0;i<len;i++){
				
				if (len== 3) {
					for(j=0;j<3;j++){
						_opponentBox[j].num_txt.text	=	String(num + j+1);
					}
                    _currNum = Number(_opponentBox[2].num_txt.text);
                } else if (len == 2) {
                    for(j=0;j<2;j++){
						_opponentBox[j].num_txt.text	=	String(num + j+1);
					}
                    _currNum = Number(_opponentBox[1].num_txt.text);
					
                } else {
                    _opponentBox[0].num_txt.text	=	String(num + 1);
                    _currNum = Number(_opponentBox[0].num_txt.text);
                }
				
			//}
*/
 /*
			if (len == 2) {
				for(i=0;i<2;i++){
					_opponentBox[i].num_txt.text	=	String(num + i+1);
				}
                
                _currNum = Number(_opponentBox[1].num_txt.text);
            } else {
                _opponentBox[0].num_txt.text = String(num + 1);
                _currNum = Number(_opponentBox[0].num_txt.text);
				
			}
			*/
			
/*
        if (num + 2 <= aimNum) {
			for(i=0;i<3;i++){
				_selfBox[i].num_txt.text	=	num + i;
				_selfBox[i].enabled			=	true;
			}
        } else if (num + 1 <= aimNum) {
			for(i=0;i<2;i++){
				_selfBox[i].num_txt.text	=	num + i;
				_selfBox[i].enabled			=	true;
			}
        } else if (num + 2 <= aimNum) {
            _selfBox[0].num_txt.text	=	num;
			_selfBox[0].enabled			=	true;
            
        } */