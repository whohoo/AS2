//******************************************************************************
//	name:	LoadProgress 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Apr 21 13:06:27 GMT+0800 2006
//	description: 当影片被加载过程中,显示加载
//******************************************************************************



class com.idescn.loader.zoomImage.LoadProgress extends Object{
	
	private var _target:MovieClip			=	null;
	private var _progressMC:MovieClip		=	null;
	private var _progressTXT:TextField		=	null;//显示加载过程的字窜
	private var _progressBarMC:MovieClip	=	null;
	
	public  var color:Number			=	0x009900;
	//[DEBUG]//your can remove it before finish this CLASS!
	public static var tt:Function		=	null;
	
	//private var _value:String		=	null;
	
	/******************[READ|WIDTH]******************/
	/*[Inspectable(defaultValue="", verbose=1, type=String)]
	function set value(value:String):Void{
		
	}
	function get value():String{
		return _value;
	}*/
	
	
	/**
	 * construction function
	 * @param target target a movie clip
	 */
	public function LoadProgress(target:MovieClip){
		this._target	=	target;
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_progressMC		=	_target.createEmptyMovieClip("mcProgress",
												_target.getNextHighestDepth());
		createTXT();
		
		
		//_progressBarMC	=	_progressMC.attachMovie("progressBar", "mcProgressBar",
		//									_progressMC.getNextHighestDepth());
		//trace(_progressBarMC)
	}
	
	/**
	 * 生成一个文本框显示加载过程
	 * 
	 * @usage   
	 * @return  
	 */
	private function createTXT():Void{
		_progressMC.createTextField("txtProgress", _progressMC.getNextHighestDepth(),
								-40,-10,80,20);
		_progressTXT				=	_progressMC.txtProgress;
		_progressTXT.selectable		=	false;
		//_progressTXT.border		=	true;
		
		var fmt:TextFormat	=	new TextFormat();
		fmt.size	=	9;
		fmt.align	=	"right";
		fmt.color	=	color;
		_progressTXT.setNewTextFormat(fmt);
	}
	
	/**
	 * 格式化数值输入出字串
	 * 
	 * @usage   
	 * @param   num 
	 * @return  
	 */
	private function formatBytes(num:Number):String{
		var outStr:String	=	"";
		switch(true){
			case num<1024:		//1024 1K
				outStr	=	num+" B";
				break;
			case num<1048576:	//1024*1024 1M
				//num	/=	10.24;
				outStr	=	Math.round(num/10.24)/100+" K";
				break;
			default :
				//num	/=	10485.76;
				outStr	=	Math.round(num/10485.76)/100+" M";
		}
		return outStr;
	}
	
	/**
	 * 画进程线条
	 * 
	 * @usage   
	 * @param   percent 
	 * @return  
	 */
	
	private function drawLine(percent:Number):Void{
		_progressMC.clear();
		//由弱慢慢变成后再变弱
		_progressMC.lineStyle(.2, color, (1-Math.abs(2*percent-1))*60);
		_progressMC.moveTo(-40, 10);
		_progressMC.lineTo(80*percent-40, 10);
	}
	/******************[PUBLIC METHOD]******************/
	/**
	 * 当被加载过程中
	 * 
	 * @usage   
	 * @param   loadedBytes 
	 * @param   totalBytes  
	 * @return  
	 */
	public function loading(loadedBytes:Number,totalBytes:Number):Void{
		if(_progressTXT._visible){
			_progressTXT.text	=	formatBytes(loadedBytes)+"/"+
													formatBytes(totalBytes);
		}
		//trace([loadedBytes,totalBytes])
		drawLine(loadedBytes/totalBytes);
	}
	
	/**
	 * 是否显示文本框
	 * 
	 * @usage   
	 * @param   visible 
	 * @return  
	 */
	public function showTEXT(visible:Boolean):Void{
		_progressTXT._visible	=	visible;
	}
	
	public function setPosition(x:Number, y:Number):Void{
		_progressMC._x	=	x;
		_progressMC._y	=	y;
	}
	
	/**
	 * 删除显示进程的对象
	 * 
	 * @usage   
	 * @return  
	 */
	public function destroy():Void{
		_progressMC.removeMovieClip();
	}
	
	/**
	 * show class name
	 * @return class name
	 */
	public function toString():String{
		return "LoadProgress 1.0";
	}
}
