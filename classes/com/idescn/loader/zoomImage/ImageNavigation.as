//******************************************************************************//	name:	ImageNavigation 1.2//	author:	whohoo//	email:	whohoo@21cn.com//	date:	Fri Dec 23 12:42:44 2005//	description: 图片导航,
//				可定义颜色,移动导航条可以更新tiles
//				增加定义flag的点//******************************************************************************
//import com.idescn.loader.ZoomImage;
import com.idescn.loader.zoomImage.LoadProgress;
class com.idescn.loader.zoomImage.ImageNavigation{
	
	private var target:MovieClip	=	null;
	private var zoomImage:Object	=	null;
	private var navImage:MovieClip	=	null;//加载进来的导航图,depth:10
	private var navFrame:MovieClip	=	null;//导航图上的红色方框,depth:100
	private var pointsMC:MovieClip	=	null;//显示flag的点depth:20
	private var loadProgress:LoadProgress	=	null;
	//private var xPos:Number		=	null;
	//private var yPos:Number		=	null;
	public  var color:Number		=	0xff0000;//默认的色彩,红色
	public	var navWidth:Number	=	null;
	public	var navHeight:Number	=	null;
	
	/**
	* 构建函数
	* @param target 显示导航图的movie clip
	* @param imageUrl 显示的导航图地址
	*/
	public function ImageNavigation(target:MovieClip,imageUrl:String,
										zoomImage:Object){
		this.target		=	target;
		this.zoomImage	=	zoomImage;
		loadNavImage(imageUrl);
		init();
	}
	
	/******************[PRIVATE METHOD]******************/
	/**
	* 初始化,此方法好象也用不到.
	*/
	private function init():Void{
		pointsMC	=	target.createEmptyMovieClip("mcPoints",20);
		
	}
	
	/**
	* load nav image
	* @param url the load image url
	*/
	private function loadNavImage(url:String):Void{
		var mc:MovieClip	=	target.createEmptyMovieClip("mcNavImage",10);
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.loadClip(url, mc);
		mcl.addListener(this);
		//mc.loadMovie(url);
		navImage	=	mc;
	}
	
	/**
	* MovieClipLoader事件
	* 当导航图加载完后,使图片居中,然后再画个同大小的红色100%框表示
	* @param target 指向加载影片本身
	*/
	private function onLoadInit(target:MovieClip):Void{
		target._x	=	-target._width/2;
		target._y	=	-target._height/2;
		navWidth	=	target._width;
		navHeight	=	target._height;
		drawFrame();
		DNDaction();
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
	}
	
	/**
	* draw a red frame,以[0,0]点为中心的框
	* 默认一开始是与整个导航图大小一致.
	*/
	private function drawFrame():Void{
		var mc:MovieClip	=	target.createEmptyMovieClip("mcNavFrame",100);
		mc.lineStyle(0.1, color, 100);
		mc.beginFill(0xffffff,0);//填充一个透明的底,用来定义mouse拖放操作.
		drawRect(mc, 0, 0, navImage._width, navImage._height);
		mc.endFill();
		navFrame	=	mc;
	}
	
	/**
	* 定义mouse拖放导航块事件
	*/
	private function DNDaction():Void{
		var _this:Object	=	this;
		navFrame.onPress=function():Void{
			var width:Number	=	this._width/2;
			var height:Number	=	this._height/2;
			var width2:Number	=	_this.navWidth/2;
			var height2:Number	=	_this.navHeight/2;
			this.startDrag(false, -width2+width, -height2+height,
									width2-width, height2-height);
			//this.onMouseMove=function():Void{
				
			//}
		}
		
		navFrame.onRelease=function():Void{
			this.stopDrag();
			_this.updateZoomImage();
			//delete this.onMouseMove;
		}
		navFrame.onReleaseOutside=navFrame.onRelease;
	}
	
	/**
	 * 根据navFrame的座标更新zoomImage
	 * 
	 * @usage   
	 * @return  
	 */
	private function updateZoomImage():Void{
		zoomImage.moveImage(
						-navFrame._x*zoomImage.bottomImage._width/navWidth -
												zoomImage.curPosX, 
						-navFrame._y*zoomImage.bottomImage._height/navHeight -
												zoomImage.curPosY, false);
	}
	
	/******************[PUBLIC METHOD]******************/
	///////////zoom in or out
	/**
	* 缩放框架大小(过程)
	* 当图片被缩放时,ZoomImage会通过EventDispatcher事件调用此方法,
	* @param eventObj eventObj.scale
	*/
	public function onScale(eventObj:Object):Void{
		//如果是移动导航来更新tiles的,就不要再更新此导航条
		if(!eventObj.updateImageNav)	return;
		var scale:Number	=	eventObj.scale;
		scale	=	1/(1+scale);
		navFrame._xscale=navFrame._yscale	=	(scale)*navFrame._xscale;
	}
	
	/**
	* 缩放框架大小(目标)
	* 此该当好象用不到了....:(????
	* @param wScale
	* @param hScale
	*/
	public function zoomNavTo(wScale:Number,hScale:Number):Void{
		wScale	=	1/(1+wScale);
		navFrame._xscale=navFrame._yscale	=	wScale*100;
		//hScale	=	1/(1+hScale);
		//navFrame._yscale	=	wScale*100;trace(wScale);trace(hScale);
	}
	
	////////////move/////////////////
	/**
	* 移动过程,
	* 当图片被移动时,ZoomImage会通过EventDispatcher事件调用此方法,
	* @param eventObj [eventObj.x , eventObj.y]
	*/
	public function onMove(eventObj:Object):Void{
		if(!eventObj.updateImageNav)	return;
		navFrame._x	=	-eventObj.x*navWidth/(eventObj.width);
		navFrame._y	=	-eventObj.y*navHeight/(eventObj.height);

	}
	
	/**
	 * 根据remark类flag的标注,在导航图上标明小点
	 * 
	 * @usage   
	 * @param   point 
	 * @return  
	 */
	public function onAddPoint(eventObj:Object):Void{
		var point:Object	=	eventObj.point;
		var width:Number	=	zoomImage.tilesXML.getImageProp(point.level, 
																		"width");
		var scale:Number	=	navWidth/width;
		var x:Number	=	point.x*scale - target._width/2;
		var y:Number	=	point.y*scale - target._height/2;
		
		pointsMC.lineStyle(1,color,100);
		pointsMC.moveTo(x, y);
		pointsMC.lineTo(x+1, y);
		pointsMC.lineTo(x+1, y+1);
		pointsMC.lineTo(x, y+1);
		pointsMC.lineTo(x, y);
	}
	
	/**
	* 显示该类名称及位置
	* @return this class name.
	*/
	public function toString():String{
		return	"ImageNavigation 1.1";
	}
	
	

	/**
	* draw a rectangle center point(x,y)
	* @param mc
	* @param x
	* @param y
	* @param width
	* @param height
	*/
	public static function drawRect(mc:MovieClip,x:Number,y:Number,
											width:Number,height:Number):Void{
		width	/=	2;
		height	/=	2;
		mc.moveTo(x-width,y-height);
		mc.lineTo(x+width,y-height);
		mc.lineTo(x+width,y+height);
		mc.lineTo(x-width,y+height);
		mc.lineTo(x-width,y-height);
	}
}