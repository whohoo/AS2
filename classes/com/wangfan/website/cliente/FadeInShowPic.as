//******************************************************************************
//	name:	FadeInShowPic 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Nov 28 15:26:39 GMT+0800 2006
//	description: This file was created by "cliente.fla" file.
//		
//******************************************************************************


import com.wangfan.rover.MoveMap;
/**
 * 加载图片logo进入，如果图片大过可显示范围，可移动.<p></p>
 * 
 */
class com.wangfan.website.cliente.FadeInShowPic extends MovieClip{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var content_mc:MovieClip		=	null;
	private var mask_mc:MovieClip			=	null;
	private var loading_txt:TextField		=	null;
	private var _mcl:MovieClipLoader		=	null;
	private var _moveMap:MoveMap			=	null;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new FadeInShowPic(this);]
	 * @param target target a movie clip
	 */
	public function FadeInShowPic(){
		//mask_mc._yscale	=	this._height;
		//this._yscale	=	100;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_mcl	=	new MovieClipLoader();
		_mcl.addListener(this);
		
	}
	
	private function onLoadProgress(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void{
		loading_txt.text	=	"loading..."+Math.random(bytesLoaded/bytesTotal*100)+"%";
	}
	
	private function onLoadComplete(mc:MovieClip):Void{
		loading_txt.text	=	"";
		mc._alpha	=	0;
	}
	private function onLoadInit(mc:MovieClip):Void{
		checkMoving();
		mc.onEnterFrame=function():Void{
			this._alpha	+=	10;
			if(this._alpha>=100){
				delete this.onEnterFrame;
			}
		}
	}
	
	private function checkMoving():Void{
		//如果超出mask可显示的范围，可根据mouse位置移动。
		if(content_mc._height>mask_mc._height){
			_moveMap	=	new MoveMap(content_mc, mask_mc);
			
			_moveMap.isMoveY	=	true;
			_moveMap.isMoveX	=	false;
			_moveMap.startMove();
			content_mc._y	=	mask_mc._y;
		}else{//上对齐.
			
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function loadPic(url:String):Void{
		_mcl.loadClip(url, content_mc);
	}
	
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "FadeInShowPic 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
