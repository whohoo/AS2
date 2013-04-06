//******************************************************************************
//	name:	ExSound
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Jun 22 16:51:59 GMT+0800 2006
//	description: 原来是想增加cue点的,但因为如果机器过于负载,则时间对不上,所以这个
//		类的实用性不是很大,故暂时停止开发,
//******************************************************************************




//created by JSFL | author whohoo@21cn.com
import com.idescn.sound.ExSound;
//var tt:Function	=	ExSound["tt"];//Debug.tt(obj);
var testClass:ExSound	=	new ExSound(this);
testClass.loadSound("bell40.mp3", false);

testClass.onLoad=function(s:Boolean):Void{
	if(s){
		this.start();
		_root.t	=	getTimer();
	}
}

/*
var cEvtObj:Object	=	{};
cEvtObj.onCuePoint=function(eventObj:Object):Void{
	var sec:Number	=	eventObj.target.position;
	trace([sec, sec-getTimer()+_root.t]);
	
}
testClass.addEventListener("onCuePoint", cEvtObj);*/
//tt(com.idescn.sound.ExSound);
//end//
/*
this.onEnterFrame=function(){
	var i	=	10000;
	while(i--){
		var ii	=	100;
		while(ii--){
			
		}
	}
}*/
/*
* [2000,2000,2000,2000,2000,
											2000,2000,2000,2000,2000,
											2000,2000,2000,2000,2000,
											2000,2000,2000,2000,2000]*/