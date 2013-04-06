//******************************************************************************
//	name:	LoadTileImageEvents 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Dec 14 15:26:57 2005
//	description: 当加载一个tile时,执行加载过程的代码,显示加载过程栏
//				此加载事件按时间间隔被调用.
//******************************************************************************


import com.idescn.loader.zoomImage.LoadProgress;

class com.idescn.loader.zoomImage.LoadTileImageEvents{
	
	private var zoomImage:Object			=	null;
	
	private var loadProgress:LoadProgress	=	null;
	
	
	
	/**
	 * 构造函数
	 * 
	 * @usage   
	 * @param   zoomImage   
	 * @param   hasNextTile 
	 * @return  
	 */
	public function LoadTileImageEvents(zoomImage:Object){
		this.zoomImage		=	zoomImage;
		
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
		
		zoomImage.loadTile()
		
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * 显示类名称
	 * 
	 * @usage   
	 * @return  
	 */
	public function toString():String{
		return "LoadTileImageEvents 1.1";
	}
	
}