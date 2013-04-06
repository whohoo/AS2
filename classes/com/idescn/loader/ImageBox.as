//******************************************************************************
//	class:	ImageBox 1.0
// 	author:	whohoo
// 	email:	whohoo@21cn.com
// 	date:	Mon Jun 20 13:59:54 2005
//	description:	把原来ImageBox 1.0转为AS2
//******************************************************************************


import com.idescn.draw.Shape;
import mx.events.EventDispatcher;

[IconFile("ImageBox.png")]
/**
* <b>COMPONENT [ImageBox].</b>
* <p></p>
* you could drag ImageBox from component panel(Ctrl+F7) in flash to stage<br></br>
* and define properties in Parameters panel(Alt+F7).<br></br>
* <b>Parameters:</b>
* <ul>
* <li><b>algin:</b> C,T,B,R,L,TR,TL,BR,BL</li>
* <li><b>borderColor:</b> color value, eg: 0xFFFFFF</li>
* <li><b>borderThick:</b> a positive number</li>
* <li><b>fadeInFrames:</b> a positive number</li>
* <li><b>fitMode:</b> scale,width,height,both,none</li>
* <li><b>imageUrl:</b> a image path</li>
* </ul>
* <p></p>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onLoadStart({}): same to MovieClipLoader </li>
* <li>onLoadProgress({loadedBytes,totalBytes}): same to MovieClipLoader </li>
* <li>onLoadComplete({}): same to MovieClipLoader </li>
* <li>onLoadInit({}): same to MovieClipLoader </li>
* <li>onLoadError({errorCode}): same to MovieClipLoader </li>
* <li>onImageShow({}): after fadeIn image</li>
* 
* </ul>
*/
class com.idescn.loader.ImageBox extends MovieClip{
	
	private var _imageUrl:String		=	"";
	private var _boxWidth:Number		=	0;
	private var _boxHeight:Number		=	0;
	private var _borderThick:Number	=	0;
	private var _borderColor:Number	=	0x000000;
	private var _imageWidth:Number		=	100;
	private var _imageHeight:Number	=	100;
	private var _fitMode:String		=	"scale";
	private var _align:String			=	"";
	private var _curFr:Number			=	0;
	private var _fr:Number				=	15;
	private var _events:Object			=	{};
	private var _imageLoaded:Boolean	=	true;
	private var _imageLoader:MovieClipLoader;
	//
	private var mcImage:MovieClip		=	null;
	private var mcBorder:MovieClip		=	null;
	
	/////////////////event
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* @param event the name of the event ("click", "change", etc)<br></br>
	* @param handler the function or object that should be called
	*/
	public  var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	EventDispatcher.initialize(ImageBox.prototype);
	////////loader事件
	private function onLoadStart(target):Void{
		dispatchEvent({type:"onLoadStart"});
	}
	private function onLoadProgress(target,loadedBytes ,totalBytes ):Void{
		dispatchEvent({type:"onLoadProgress",loadedBytes:loadedBytes,
														totalBytes:totalBytes});
	}
	private function onLoadComplete(target):Void{
		dispatchEvent({type:"onLoadComplete"});
	}
	private function onLoadInit(target):Void{
		_imageLoaded	=	true;
		fitImage();
		showImage();
		dispatchEvent({type:"onLoadInit"});
	}
	private function onLoadError(target,errorCode):Void{
		dispatchEvent({type:"onLoadError",errorCode:errorCode});
	}
	
	////属性存取方法
	[Inspectable(defaultValue="", type=String)]
	function set imageUrl(url:String):Void{
		loadImage(url);
	}
	/**a url of image.*/
	function get imageUrl():String{
		return _imageUrl;
	}
	
	[Inspectable(defaultValue=0, type=Number)]
	function set borderThick(bt:Number):Void{
		_borderThick = bt < 0 ? 0 : bt;
		drawBorder();
	}
	/**border thick value, the value must >0*/
	function get borderThick():Number{
		return _borderThick;
	}
	
	[Inspectable(defaultValue="#000000", type=Color)]
	function set borderColor(bc:Number):Void{
		_borderColor = bc;
		drawBorder();
	}
	/**if border thick value >0, the border color.*/
	function get borderColor():Number{
		return _borderColor;
	}
	
	[Inspectable(defaultValue="scale", type=String, enumeration="scale,width,height,both,none")]
	function set fitMode(fm:String):Void{
		_fitMode = fm.toLowerCase();
		fitImage();
	}
	/**the fit mode, value are [scale,width,height,both,none]*/
	function get fitMode():String{
		return _fitMode;
	}
	
	
	[Inspectable(defaultValue="C", verbose=1, type=List, enumeration="C,T,B,R,L,TR,TL,BR,BL")]
	function set align(al:String):Void{
		_align = al.toUpperCase();
		fitImage();
	}
	/**align mode, value are [C,T,B,R,L,TR,TL,BR,BL]*/
	function get align():String{
		return _align;
	}
	
	[Inspectable(defaultValue=15, type=Number )]
	function set fadeInFrames(fr:Number):Void{
		_fr	=	fr;
	}
	/**the fade in frames.*/
	function get fadeInFrames():Number{
		return _fr;
	}
	
	function set boxWidth(bw:Number):Void{
		resize(bw);
	}
	/**width of box*/
	function get boxWidth():Number{
		return _boxWidth;
	}
	
	function set boxHeight(bh:Number):Void{
		resize(null,bh);
	}
	/**height of box*/
	function get boxHeight():Number{
		return _boxHeight;
	}
	/////只读属性
	/**width of image*/
	function get imageWidth():Number{
		return	_imageWidth;
	}
	/**height of image*/
	function get imageHeight():Number{
		return	_imageHeight;
	}
	
	/**xscale of image*/
	function get imageXscale():Number{
		return	mcImage._xscale;
	}
	/**yscale of image*/
	function get imageYscale():Number{
		return	mcImage._yscale;
	}
	
	//////////构造/////////////////
	/**
	 * Construct Function.<br></br>
	 * you not use new ImageBox() to constrruct. you ought to drag ImageBox from<br></br>
	 * Component panel(Ctrl+F7) to stage.
	 */
	private function ImageBox(){
		_imageLoader	=	new MovieClipLoader();
		_imageLoader.addListener(this);
		
		init();
		
		loadImage(_imageUrl);
		drawBorder();
		fitImage();
		
		var mc:MovieClip	=	this["assets_mc"];
		mc.swapDepths(791011);
		mc.removeMovieClip();
	}
	
	//***************[PRIVATE METHOD]*****************//
	/**
	 * initiate this class
	 * 
	 */
	private function init():Void{
		_boxWidth		= this._xscale;
		_boxHeight		= this._yscale;
		this._xscale	= 100;
		this._yscale	= 100;
	}
	
	/**
	 * draw border
	 */
	private function drawBorder():Void{
		if (_borderThick>0){
			mcBorder	=	this.createEmptyMovieClip("border_mc",10);
			mcBorder.lineStyle(_borderThick, _borderColor, 100);
			Shape.drawRect(mcBorder,0,0,_imageWidth,_imageHeight);
			mcBorder.endFill();
		}else{
			mcBorder.removeMovieClip();
		}
	}
	
	/**
	 * fade in this image
	 * @return  
	 */
	private function fadeIn():Void{
		_curFr++;
		if (_curFr >= _fr) {
			mcImage._alpha	= 100;
			delete this.onEnterFrame;
			dispatchEvent({type:"onImageShow"});
		} else {
			mcImage._alpha	= _curFr / _fr * 100;
		}
	};
	
	//***************[PUBLIC METHOD]*****************//
	/**
	* load a image to show by paramenet point out.
	* @param url url is URL that a jpg or swf address
	*/
	public function loadImage(url:String):Void{
		_imageWidth			=	0;
		_imageHeight		=	0;
		_imageUrl			=	url;
		mcBorder.removeMovieClip();
		mcImage._visible	=	false;
		mcImage	=	this.createEmptyMovieClip("image_mc", 0);
		if (url != "" && url != null) {
			_imageLoaded	=	false;
			_imageLoader.loadClip(url,mcImage);
		}
	};
	
	/**
	* adjust this image that be loaded to show, you could set value of 
	* both, scale ,width, height or none
	* @param fitMode fitMode is a value of both, scale ,width, height or none
	*/
	public function fitImage(fitMode:String):Void{
		if(!_imageLoaded)	return;
		if (fitMode == null) fitMode = _fitMode;
		mcImage._xscale			= 100;
		mcImage._yscale			= 100;
		var width				= mcImage._width;
		var height				= mcImage._height;
		if (fitMode == "both") {
			fitMode				= width * _boxHeight >= _boxWidth * height ? "width" : "height";
		};
		switch (fitMode) {
			case "scale":
				_imageWidth		= _boxWidth;
				_imageHeight	= _boxHeight;
				break;
			case "width":
				_imageWidth		= _boxWidth;
				_imageHeight	= width == 0 ? 0 : _imageWidth / width * height;
				break;
			case "height":
				_imageHeight	= _boxHeight;
				_imageWidth		= height == 0 ? 0 : _imageHeight / height * width;
				break;
			default:
				_imageWidth		= width;
				_imageHeight	= height;
		}
		mcImage._width	=	_imageWidth;
		mcImage._height	=	_imageHeight;
		drawBorder();
		alignImage();
	}
	
	/**
	* adjust this image algin,
	* @param align align value of T, B, R, L, TR, TL, BR, BL or ""
	*/
	public function alignImage(align:String):Void{//默认为居中
		_align		= align == null ? _align : (String(align).toUpperCase());
		
		if (_align.indexOf("L") >= 0) {
			mcImage._x	= 0;
		} else if (_align.indexOf("R") >= 0) {
			mcImage._x	= _boxWidth - _imageWidth;
		} else {
			mcImage._x	= _boxWidth/2 - _imageWidth/2;
		};
		
		if (_align.indexOf("T") >= 0) {
			mcImage._y	= 0;
		} else if (_align.indexOf("B") >= 0) {
			mcImage._y	= _boxHeight - _imageHeight;
		} else {
			mcImage._y	= _boxHeight/2 - _imageHeight/2;
		};
		
		mcBorder._x		= mcImage._x;
		mcBorder._y		= mcImage._y;
	}
	
	/**
	* resize the image 
	* @param w width of image
	* @param h height of image
	*/
	public function resize(w:Number, h:Number):Void {
		if (w != null) _boxWidth = w > 0 ? Number(w) : 0;
		if (h != null) _boxHeight = h > 0 ? Number(h) : 0;
		fitImage();
	};
	
	/**
	* show this image when loading is finish,and it would fade in
	*  alpha show image in defined fr
	* @param fr after frame show image.
	*/
	public function showImage(fr:Number):Void{
		if (fr != null) 		_fr	=	fr;
		if (!_imageLoaded)		return;
		
		if (_fr < 0) {
			mcImage._visible		= false;
			delete this.onEnterFrame;
		} else if (_fr < 1) {
			mcImage._alpha			= 100;
			mcImage._visible		= true;
			delete this.onEnterFrame;
		} else {
			_curFr					= 0;
			mcImage._alpha			= 0;
			mcImage._visible		= true;
			this.onEnterFrame		= fadeIn;
		}
		
	}
	
	/**
	 * show this class name
	 * @return  class name
	 */
	public function toString():String{
		return	"ImageBox 1.0";
	}
	
}