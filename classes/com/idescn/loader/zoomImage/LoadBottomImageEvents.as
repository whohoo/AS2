//******************************************************************************
//	name:	LoadBottomImageEvents 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Dec 14 15:26:57 2005
//	description: 当zoomImage加载背景图后,要所要定义的参数.
//			根据背景图片的大小,及tileSize的大小,来定义横竖要有多少个tile排列
//			并根据初始化参数来初始化tiles的位置
//			1.1增加了加载图片过程
//******************************************************************************

import com.idescn.utils.DynamicRegistration;
//import com.idescn.loader.ZoomImage;
import com.idescn.loader.zoomImage.LoadProgress;

class com.idescn.loader.zoomImage.LoadBottomImageEvents{
	
	private var zoomImage:Object	=	null;
	public	var bWidth:Number		=	0;//当图片加载完成后要放大到宽度大小
	public	var bHeight:Number		=	0;
	private var loadProgress:LoadProgress	=	null;
	
	/**
	 * 构建函数
	 * 
	 * @usage   
	 * @param   zoomImage 指向zoomImage
	 * @return  
	 */
	public function LoadBottomImageEvents(zoomImage:Object){
		this.zoomImage	=	zoomImage;
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	* MovieClipLoader class event
	* when the bottom image are show
	* put this image to center
	* @param target_mc bottomImage
	*/
	private function onLoadInit(target_mc:MovieClip):Void{
		zoomImage.initOnLoaded();
		var target:MovieClip		=	zoomImage.target;
		zoomImage.bImageOriginWidth	=	target_mc._width;
		target_mc._width	=	bWidth;
		target_mc._height	=	bHeight;
		var width:Number	=	bWidth/2;
		var height:Number	=	bHeight/2;
		
		DynamicRegistration.initialize(target_mc);
		
		zoomImage.LEFT_UP_POINT		=	{x:-width, y:-height};
		target.localToGlobal(zoomImage.LEFT_UP_POINT);

		//**因为初始curPosX与curPosY被设置为0,0.所以要加上width与height**//
		zoomImage.moveImageTo(bWidth,bHeight);
		//////初始化设定的参数
		var initX:Number		=	zoomImage.initParam.x;
		var initY:Number		=	zoomImage.initParam.y;
		var initLevel:Number	=	zoomImage.initParam.level;
		
		if(!isNaN(initX)){
			if(!isNaN(initY)){//如果x,y不为空,
				if(!isNaN(initLevel)){//如果级别不为空,就缩放
					zoomImage.zoom2Level(initLevel,false);
					zoomImage.moveImageTo(initX,initY);
				}else{//如果级别为空,则为默认的级别
					zoomImage.moveImageTo(initX,initY);
				}
			}
		}
		
		var mcMask:MovieClip	=	target.createEmptyMovieClip("mcMaskImage",10000);
		mcMask.beginFill(0x00ff00,5);
		
		com.idescn.loader.zoomImage.ImageNavigation.drawRect(mcMask, 0, 0,
																bWidth, bHeight);
		mcMask.endFill();
		target.setMask(mcMask);
		//zoomImage.maskMC	=	mcMask;
		//////背景图位置固定后,加载tiles**不再需要此方法,因为moveImageTo已经调用
		//zoomImage.loadTiles(zoomImage.curLevel);
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
	}
	
	/******************[PUBLIC METHOD]******************/
	/**
	 * 显示类名称
	 * 
	 * @usage   
	 * @return  
	 */
	public function toString():String{
		return "LoadBottomImageEvents 1.1";
	}
}