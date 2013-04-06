//******************************************************************************
//	name:	LoadTileImageEvents2 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Dec 14 15:26:57 2005
//	description: 显示tile加载过程,并当一个tile加载完成时,再加载下一个,如果可以显
//			示的tile都加载完成时,自动停止加载下一个tile.如果当加载的一个不存在的
//			图片或加载图片发生错误时,尝试重新加载,如果还是发生错误,跳过,继续加载
//******************************************************************************


import com.idescn.loader.zoomImage.LoadProgress;
import mx.events.EventDispatcher;

class com.idescn.loader.zoomImage.LoadTileImageEvents2{
	
	private var zoomImage:Object			=	null;
	private var wCount:Number				=	null;
	private var hCount:Number				=	null;
	private var loadProgress:LoadProgress	=	null;
	
	private var curTryTimes:Number			=	0;//当发生错误时,当前尝试的次数
	private var lastLoadParamX:Number		=	null;//上次加载图片的位置,用于当
	private var lastLoadParamY:Number		=	null;//加载发生错误时重新加载
	
	public  var tryTimes:Number			=	1;//默认尝试加载次数
	public  var tLayer:MovieClip			=	null;//正在进行加载过程的层
	public  var point:Object				=	null;
	public  var tileSize:Number			=	null;
	public  var wLen:Number				=	null;
	public  var hLen:Number				=	null;
	public  var _loadingFinish:Boolean		=	null;
	public  var lastLayer:MovieClip		=	null;
	public  var loadingCancel:Boolean		=	false;
	
	
	/////////////////event
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public	var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED	=	EventDispatcher.initialize(LoadTileImageEvents2.prototype);

	[Inspectable(defaultValue=0, verbose=1, type=Boolean)]
	function set loadingFinish(value:Boolean):Void{
		zoomImage.state	=	0;//表示正常显示状态
		dispatchEvent({type:"onLoaded", isFinish:value});
		_loadingFinish	=	value;
	}
	function get loadingFinish():Boolean{
		return _loadingFinish;
	}
	
	/**
	 * 构造函数
	 * 
	 * @usage   
	 * @param   zoomImage   
	 * @return  
	 */
	public function LoadTileImageEvents2(zoomImage:Object){
		this.zoomImage		=	zoomImage;
		//init();
	}
	
	/**
	 * 初始化
	 * 
	 * @usage   
	 * @return  
	 */
	public function init():Void{
		//如果没有loading完成就又加载,刚要重新指向curTilesLayer,且有删除原来因没
		//全部下载完成而删除的层.
		zoomImage.curTilesLayer	=	tLayer;
		lastLayer.removeMovieClip();
		lastLayer			=	tLayer;
		
		this.wCount			=	0;
		this.hCount			=	0;
		_loadingFinish		=	false;
	}
	
	/**
	* MovieClipLoader class event
	* 得出些tile的大小
	* 
	* @param target_mc this last load tile Image
	*/
	public function onLoadInit(target_mc:MovieClip):Void{
		//zoomImage.bImageEvents	=	null;//当加载完成后,把此类的引用删除,
		
	}
	
	/**
	 * 侦听器；在加载过程中每当将加载的内容写入磁盘时（即，
	 * 在MovieClipLoader.onLoadStart() 和 MovieClipLoader.onLoadComplete() 
	 * 之间）调用。您可以使用此方法以及使用 loadedBytes 和 totalBytes 参数，
	 * 显示与下载的进度有关的信息。
	 * @usage   
	 * @param   target_mc   通过 MovieClipLoader.loadClip() 方法加载的影片剪辑。
	 * @param   loadedBytes 在调用该侦听器时已加载的字节数。
	 * @param   totalBytes  在正加载的文件中的总字节数。
	 * @return  
	 */
	private function onLoadProgress(target_mc:MovieClip, loadedBytes:Number,
													totalBytes:Number):Void{
		loadProgress.loading(loadedBytes, totalBytes);
	}
	
	/**
	 * 侦听器；在对 MovieClipLoader.loadClip() 的调用已成功开始下载文件时调用。
	 * 
	 * @usage   
	 * @param   target_mc 通过 MovieClipLoader.loadClip() 方法加载的影片剪辑。
	 * @return  
	 */
	private function onLoadStart(target_mc:MovieClip):Void{
		loadProgress	=	new LoadProgress(target_mc);
		loadProgress.showTEXT(false);
		var tileCenter:Number	=	zoomImage.tileSize/2;
		loadProgress.setPosition(tileCenter,tileCenter);
	}
	
	/**
	 * 侦听器；在使用 MovieClipLoader.loadClip() 加载的文件已完全下载时调用。
	 * 			删除当开始时生成的类内的对象
	 * @usage   
	 * @param   target_mc target_mc 通过 MovieClipLoader.loadClip() 方法加载的影片剪辑。
	 * @return  
	 */
	private function onLoadComplete(target_mc:MovieClip):Void{
		loadProgress.destroy();
		loadProgress	=	null;
		if(_loadingFinish){//如果原来的正在加载过程中,然后再改变状态,又重新加载
					//则此时state会改变两次为0,因为一个影片加载过程bImageEvents
					//仍旧在执行中,所以当loadingFinish为真时,就会同时停止并执行
					//以下代码.
			
			return;
		}
		lastLoadParamX	=	point.x + wCount*tileSize;
		lastLoadParamY	=	point.y + hCount*tileSize;
		zoomImage.loadTile2(tLayer, lastLoadParamX, lastLoadParamY, false);
		curTryTimes	=	0;//加载成功,重置数值
		
		wCount++;
		if(wCount==wLen){
			hCount++;
			if(hCount==hLen){
				lastLayer.removeMovieClip();//release the old tiles
				lastLayer		=	null;
				zoomImage.curTilesLayer	=	tLayer;
				loadingFinish	=	true;
				
				return;
			}else{
				wCount	=	0;
			}
		}
	}
	
	/**
	 * 当使用 MovieClipLoader.loadClip() 加载的文件未能加载时调用。出于各种原因，
	 * 会调用此侦听器；例如服务器关闭、找不到文件或发生安全侵犯。
	 * 
	 * @usage   
	 * @param   target_mc  通过 MovieClipLoader.loadClip() 方法加载的影片剪辑。
	 * @param   errorCode   解释失败原因的字符串，为 "URLNotFound" 或 "LoadNeverCompleted"。
	 * @param   httpStatus （仅适用于 Flash Player 8）由服务器返回的 HTTP 状态代码。
	 * 例如，状态代码 404 表明服务器尚未找到请求的 URI 的任何匹配项。
	 * @return  
	 */
	private function onLoadError(target_mc:MovieClip, errorCode:String, 
															httpStatus:Number){
		//trace(errorCode);trace(httpStatus)
		if(_loadingFinish){
			zoomImage.state	=	0;//表示正常显示状态
			return;
		}
		
		if(curTryTimes++<tryTimes){
			zoomImage.loadTile2(tLayer, lastLoadParamX, lastLoadParamY, false);
			return;
		}else{
			onLoadComplete();
		}
		
	}


	/******************[PUBLIC METHOD]******************/
	/**
	 * 显示类名称
	 * 
	 * @usage   
	 * @return  
	 */
	public function toString():String{
		return "LoadTileImageEvents2 1.0";
	}
	
}