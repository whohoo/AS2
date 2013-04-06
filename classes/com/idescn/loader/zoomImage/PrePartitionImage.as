//******************************************************************************//	name:	PrePartitionImage 1.0//	author:	whohoo//	email:	whohoo@21cn.com//	date:	Thu Dec 29 17:41:18 2005//	description: 在指定的级别下,用红线把图片切成小部分.
//			此类未完成,本想对一张图片进行预先切成一个可示范的//******************************************************************************class com.idescn.loader.zoomImage.PrePartitionImage{
	private var target:MovieClip;//在上边执行的影片
	
	private var scrWidth:Number;//图片的宽.
	private var scrHeight:Number;//图片的高
	private var iWidth:Number	=	500;//在flash显示的大小
	private var iHeight:Number	=	null;//根据长宽比计算出来
	private var image:MovieClip;//图片所在的影片

	private var defineValue:MovieClip	=	[];//定义的影片的值.
	
	public	var zoomLevel:Number	=	0.8;
	public	var minWidth:Number	=	400;
	
	/**
	* 构建函数
	* @param target
	* @param iWidth
	* @param iHeight
	* @param imageUrl
	*/
	public function PrePartitionImage(target:MovieClip,scrWidth:Number,
										scrHeight:Number,imageUrl:String){
		this.target		=	target;
		
		if(scrWidth==null){
			throw new Error("width is null");
		}
		if(scrHeight==null){
			throw new Error("height is null");
		}
		this.scrWidth		=	scrWidth;
		this.scrHeight		=	scrHeight;
		iHeight	=	scrHeight/scrWidth*iWidth;
		if(imageUrl==null){
			createRent();
		}else{
			loadImage(imageUrl);
		}
		
	}
	
	/**
	* create a rentangle movieclip
	*/
	private function createRent():Void{
		image	=	target.createEmptyMovieClip("mcImage",10);
		image.beginFill(0xcccccc,100);
		image.lineStyle(.1,0x00ff00,100);
		var w:Number	=	scrWidth/2;
		var h:Number	=	scrHeight/2;
		com.idescn.loader.zoomImage.ImageNavigation.drawRect(image,w,h,scrWidth,scrHeight);
		image.endFill();
		image._width	=	iWidth;
		image._height	=	iHeight;
	}
	
	/**
	* attach "define"影片到场景上
	*/
	private function attachMovie():Void{
		
	}
	
	
	
	/**
	* create a rentangle movieclip
	* @param imageUrl
	*/
	private function loadImage(imageUrl:String):Void{
		image	=	target.createEmptyMovieClip("mcImage",10);
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.loadClip(imageUrl,image);
		mcl.addListener(this);
	}
	
	/**
	* 当影片加载完成时
	* @param target 指向当前被加载的image
	*/
	private function onLoadInit(target:MovieClip):Void{
		target._width	=	iWidth;
		target._height	=	iHeight;
	}
	
	
	
}