//******************************************************************************
//	name:	FlyIn 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Nov 17 15:00:34 GMT+0800 2006
//	description: This file was created by "cliente.fla" file.
//		
//******************************************************************************

import com.wangfan.rover.MoveMap;
import mx.utils.Delegate;

/**
 * 客户列表，有文字列表与图片列表.<p></p>
 * 每一行逐步出现。如果超出可显示范围，就根据根据mouse移动。
 */
class com.wangfan.website.cliente.FlyIn extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	private var _curIndex:Number		=	null;
	private var _totalNum:Number		=	null;//有多少条的总数
	
	private var _moveMap:MoveMap		=	null;
	
	/**要attachMovie影片的ID名*/
	public  var itemID:String			=	null;
	/**两行之间的距离*/
	public  var lineSpace:Number		=	0;
	/**两行出现的间隔的帧数*/
	public  var intervalFrame:Number	=	0;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new FlyIn(this);]
	 * @param target target a movie clip
	 */
	public function FlyIn(target:MovieClip){
		this._target	=	target;
		
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_target.mask_mc._width	=	_target._width;
		_target.mask_mc._height	=	_target._height;
		_target._yscale	=	
		_target._xscale	=	100;
	}
	
	private function _onShowPoints():Void{
		var interTimes:Number	=	intervalFrame;//多少次onEnterFrame后执行一次以下代码。
		if(_curIndex%interTimes==0){
			var mc	=	_target.content_mc["mcItem"+_curIndex/interTimes];
			mc.moveIn();
			mc._visible	=	true;
			if(_curIndex==_totalNum*interTimes){
				_target.onEnterFrame	=	null;
			}
		}
		_curIndex++;
	}
	
	private function _checkImageLoading():Void{
		var percent:Number	=	getImageLoading();
		if(percent>=1){//所有图片加载完成后
			var mc:MovieClip	=	null;
			var mcPrev			=	{_y:0, _height:lineSpace};
			for(var i:Number=0;i<_totalNum;i++){
				mc	=	_target.content_mc["mcItem"+i];
				mc._y	=	mcPrev._y+mcPrev._height-lineSpace;
				mcPrev	=	mc;
			}
			delete _target.onEnterFrame;
			_target.onEnterFrame=Delegate.create(this, _onShowPoints);
			_target.loading_txt.text	=	"";
			checkMoving();
		}else{
			_target.loading_txt.text	=	"Loading... "+
						Math.round(percent*100)+"%";
		}
	}
	
	private function getImageLoading():Number{
		var mc:MovieClip	=	null;
		var bytesLoaded:Number	=	0;
		var bytesTotal:Number	=	0;
		for(var i:Number=0;i<_totalNum;i++){
			mc	=	_target.content_mc["mcItem"+i].pic_mc;
			bytesTotal	+=	mc.getBytesTotal();
			bytesLoaded	+=	mc.getBytesLoaded();
		}
		//trace([bytesLoaded, bytesTotal, mc._name])
		if(bytesLoaded>10){
			return bytesLoaded/bytesTotal;
		}else{
			return 0;
		}
		
	}
	//判断是否超出可显示范围。
	private function checkMoving():Void{
		//如果超出mask可显示的范围，可根据mouse位置移动。
		if(_target.content_mc._height>_target.mask_mc._height){
			_moveMap	=	new MoveMap(_target.content_mc, _target.mask_mc);
			
			_moveMap.isMoveY	=	true;
			_moveMap.isMoveX	=	false;
			_moveMap.startMove();
			_target.content_mc._y	=	_target.mask_mc._y;
		}else{//上对齐.
			
		}
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 根据XML数据显示文本文字
	 * 
	 * @param   child 
	 */
	public function createText(child:XMLNode):Void{
		child	=	child.firstChild;
		var i:Number		=	0;
		var mc:MovieClip	=	null;
		var mcPrev			=	{_y:0, _height:lineSpace};
		while(child!=null){
			mc	=	_target.content_mc.attachMovie(itemID, "mcItem"+i, i, 
						{_y:mcPrev._y+mcPrev._height-lineSpace});
			mc.cliente_txt.text	=	child.firstChild.nodeValue;
			mc._visible	=	false;
			mc.stop();
			mcPrev	=	mc;
			i++;
			child	=	child.nextSibling;
		}
		_totalNum	=	i;
	}
	
	/**
	 * 根据XML数据显示文本文字
	 * 
	 * @param   child 
	 */
	public function createImage(child:XMLNode):Void{
		child	=	child.firstChild;
		var i:Number		=	0;
		var mc:MovieClip	=	null;
		var mcPrev			=	{_y:0, _height:lineSpace};
		var url:String		=	null;
		while(child!=null){
			mc	=	_target.content_mc.attachMovie(itemID, "mcItem"+i, i, 
						{_y:mcPrev._y+mcPrev._height-lineSpace});
			url	=	child.attributes.url;
			mc.pic_mc.loadMovie(url);
			
			mc._visible	=	false;
			mc.stop();
			mcPrev	=	mc;
			i++;
			child	=	child.nextSibling;
		}
		_totalNum	=	i;
	}
	/**
	* 把已生成好的数据格式慢慢显示出来。
	*/
	public function showImage():Void{
		_curIndex	=	0;
		_target.onEnterFrame=Delegate.create(this, _checkImageLoading);
		//_target.onEnterFrame=Delegate.create(this, _onShowPoints);
	}
	
	/**
	* 把已生成好的数据格式慢慢显示出来。
	*/
	public function showText():Void{
		_curIndex	=	0;
		_target.onEnterFrame=Delegate.create(this, _onShowPoints);
		checkMoving();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "FlyIn 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
