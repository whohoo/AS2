//******************************************************************************//	name:	LoadTilesInfoXML 1.0//	author:	whohoo//	email:	whohoo@21cn.com//	date:	Tue Dec 20 16:01:37 2005//	description: default load tilesInfo.xml file and parse
//				当xml成功加载后,根据最低层的大小加载背景图,并定义zoomImage最大
//				放大的尺寸及默认当前的尺寸.//******************************************************************************

//import com.idescn.loader.ZoomImage;
class com.idescn.loader.zoomImage.LoadTilesInfoXML{
	
	private var tiles_xmlnode:XMLNode	=	null;
	private var zoomImage:Object		=	null;
	public	var isLoaded:Boolean		=	false;
	
	/**
	* 构建函数
	* @param xmlUrl
	* @param zoomImage
	*/
	public function LoadTilesInfoXML(xmlUrl:String,zoomImage:Object){
		this.zoomImage		=	zoomImage;
		var _xml:XML		=	new XML();
		_xml.ignoreWhite	=	true;
		_xml.load(xmlUrl);
		var _this:Object	=	this;
		_xml.onLoad=function(s:Boolean):Void{
			if(s && this.status=="0"){//当加载xml成功后
				_this.tiles_xmlnode	=	this.firstChild;
				var attri:Object	=	this.firstChild.attributes;
				_this.isLoaded		=	true;
				var xmlProp:Object	=	_this.tiles_xmlnode.lastChild.attributes;
				var maxL:Number	=	_this.tiles_xmlnode.childNodes.length;
				var tileSize:Number	=	Number(attri.tileSize);
				var zImage:Object	=	_this.zoomImage;
				if(!isNaN(tileSize)){//如果tileSize为数值,就定义tileSize,
									//否则为默认的100,也就是tile的长宽值
					zImage.tileSize	=	tileSize;
				}
				zImage.zoomLevelMax	=	maxL-1;
				zImage.curLevel		=	maxL-1;
				
				var minWidth:Number	=	xmlProp.width;
				var minHeight:Number	=	xmlProp.height;
				//为了得到最大size的,此变量暂时用不到
				xmlProp	=	_this.tiles_xmlnode.firstChild.attributes
				//横坚各有多少个tiles
				zImage.TILES_WIDTH_NUMBER	=	Math.ceil(minWidth/zImage.tileSize);
				zImage.TILES_HEIGHT_NUMBER	=	Math.ceil(minHeight/zImage.tileSize);
				zImage.MIN_WIDTH			=	minWidth;
				zImage.MAX_WIDTH			=	xmlProp.width;
				zImage.MIN_HEIGHT			=	minHeight;
				zImage.MAX_HEIGHT			=	xmlProp.height;

				//加载背景图片,并缩放背景图片为最小缩放值的尺寸大小.
				//当背景图片被加载完成时,缩放到此值大小
				_this.zoomImage.loadBottomImage(attri.fileName, minWidth, 
																	minHeight);
			}else{
				zImage.state	=	-1;//表示不能正确加载xml数据
			}
		}
	}
	
	/**
	* 得到指定的层,也是放大系数的图片宽或其它属性
	* @param depth
	* @param prop
	* @return number
	*/
	public function getImageProp(depth:Number, prop:String):Number{
		return tiles_xmlnode.childNodes[depth].attributes[prop];
	}
	
	
	/**
	* 输入该类名称
	* @return 
	*/
	public function toString():String{
		return "LoadTilesInfoXML 1.0";
	}
}