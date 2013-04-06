//************************************************
//	name:	NavButton 1.0 
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Jan 19 00:46:56 2006
//	description: 影片上方的导航条,左右按键
//************************************************


class com.wlash.QQgroup.NavButton{
	/**
	* 指向影片本身
	*/
	public	var picture:Object		=	null;
	public 	var bLeft:MovieClip	=	null;
	public 	var bRight:MovieClip	=	null;
	
	
	/**
	* 构造函数
	* @param picture
	*/
	public function NavButton(picture:Object){
		this.picture	=	picture;
		init();
	}
	
	/**
	* 初始化
	*/
	private function init():Void{
		var mc:MovieClip	=	picture.target;
		bLeft	=	mc.attachMovie("arrow button left","mcLeft",2002,
													{_y:10,_visible:true});
		bRight	=	mc.attachMovie("arrow button right","mcRight",2004,
													{_y:10,_visible:true});
		setPosition();
		setButtonEvents();
		setEnabled(false);
		
		bLeft.text_mc.arrow_txt.autoSize	=	"left";
		bRight.text_mc.arrow_txt.autoSize	=	"right";
		
	}
	
	/**
	* 放置button在上方左右两边
	*/
	public function setPosition():Void{
		bRight._x	=	picture.stageWidth;
	}
	
	/**
	* 设置左右按键是否可用
	* @param enabled
	*/
	public function setEnabled(enabled:Boolean):Void{
		bLeft.enabled=bRight.enabled	=	enabled;
	}
	
	/**
	* 显示或隐藏左右button
	* @param enabled
	*/
	public function setVisible(enabled:Boolean):Void{
		bLeft._visible=bRight._visible	=	enabled;
	}
	
	/**
	* 设置button名称
	* @param target which button bLeft or bRight
	* @param text
	*/
	public function setText(target:MovieClip,text:String):Void{
		var txt:TextField	=	target.text_mc.arrow_txt;
		txt.text		=	text;
		txt.textColor	=	picture.curColor;
		drawHotArea(target);
	}
	
	/**
	* 定义button事件
	*/
	private function setButtonEvents():Void{
		var pic:Object	=	this.picture;
		bLeft.onRollOver=function():Void{
			this.moveIn(10);
		}
		bLeft.onRollOut=function():Void{
			this.moveIn(null,function(target:MovieClip):Void{
								target.gotoAndStop(1);
							});
		}
		bLeft.onRelease=function():Void{
			var text:String	=	this.text_mc.arrow_txt.text;
			if(text.substr(-3)==("上一页")){
				pic.prevPage();
			}else{
				pic.picXML.prevGroup();
			}
			this.onRollOut();
		}
		bLeft.onReleaseOutside=bLeft.onRelease;
		
		bRight.onRollOver=function():Void{
			this.moveIn(10);
		}
		bRight.onRollOut=function():Void{
			this.moveIn(null,function(target:MovieClip):Void{
								target.gotoAndStop(1);
							});
		}
		bRight.onRelease=function():Void{
			var text:String	=	this.text_mc.arrow_txt.text;
			if(text.substr(0,3)==("下一页")){
				pic.nextPage();
			}else{
				pic.picXML.nextGroup();
			}
			this.onRollOut();
		}
		bRight.onReleaseOutside=bRight.onRollOut;
	}
	
	/**
	* 画左右按键的响应区
	* @param target bLeft or bRight
	*/
	public function drawHotArea(target:MovieClip):Void{
		var bound:Object	=	target.getBounds();
		target.clear();
		target.beginFill(0xff0000,0);
		drawRect(target,bound.xMin,bound.yMin,bound.xMax,bound.yMax);
		target.endFill();
	}
	
	/**
	* 画个矩形,从[x,y]点开始划个宽为width,高为height的矩形
	* @param target
	*/
	public static function drawRect(target:MovieClip,x:Number,y:Number,
											width:Number,height:Number):Void{
		target.moveTo(x,y);
		target.lineTo(width,y);
		target.lineTo(width,height);
		target.lineTo(x,height);
		target.lineTo(x,y);
	}
	
	/**
	* 显示名称
	* @return 名称
	*/
	public function toString():String{
		return "NavButton 1.0";
	}
}