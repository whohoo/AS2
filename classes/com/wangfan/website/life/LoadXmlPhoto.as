//******************************************************************************
//	name:	LoadXmlPhoto 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-11-6 15:00
//	description: 
//		
//******************************************************************************



import com.wangfan.website.LoadXML;

/**
 * 在award.swf中的动态菜单.<p></p>
 * 菜单XML数据
 */
class com.wangfan.website.life.LoadXmlPhoto extends LoadXML{

	/**_target对象是否停止了播放。如果停止播放等候加载数据，则当数据加载完成时
	* 要继续播放_target对象。
	* 而如果还没到停止点就把数据加载完成后，则直接跳过停止点，继续播放。
	*/
	public  var isStopped:Boolean	=	false;
	
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoadXmlMenu4Award(this);]
	 * @param target target a movie clip
	 */
	public function LoadXmlPhoto(target:MovieClip){
		super(target, "/process/getOurlife.aspx");
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//

	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 当XML数据加载完成，并且成功解析无错误
	* @param child
	*/
	public function onXMLLoaded(child:XMLNode):Void{
		if(isStopped){
			_target.play();
		}
		//trace(isStopped);
	}
	
	/**
	* 数据未回加载完成，停止下来等候加载数据。
	*/
	public function waitLoading():Void{
		if(!isLoaded){
			isStopped	=	true;
			_target.stop();
		}
	}
	/**
	* 得到多少个分类
	* @return
	*/
	public function getCategroies():Number{
		return _dataXML.firstChild.childNodes.length;
	}
	/**
	* 得到某类别的颜色
	* @param	index
	* @return
	*/
	public function getCategroyColor(index:Number):Number{
		return Number(_dataXML.firstChild.childNodes[index].attributes.color);
	}
	/**
	* 得到某类别下的所有图片的数量.
	* @param	index
	* @return
	*/
	public function getCategroyTotal(index:Number):Number{
		return Number(_dataXML.firstChild.childNodes[index].childNodes.length);
	}
	
	/**
	* 得到某类别下的ID名称
	* @param	index
	* @return
	*/
	public function getCategroyID(index:Number):String{
		return (_dataXML.firstChild.childNodes[index].attributes.id);
	}
	
	/**
	* 得到某类别下的名称
	* @param	index
	* @return
	*/
	public function getCategroyName(index:Number):String{
		return (_dataXML.firstChild.childNodes[index].attributes.name);
	}
	
	/**
	* 得到某类别下的名称的宽度
	* @param	index
	* @return
	*/
	public function getCategroyWidth(index:Number):Number{
		return Number(_dataXML.firstChild.childNodes[index].attributes.width);
	}
	
	/**
	* 得到某个类别下具体某张图片的地址.
	* @param	cateIndex
	* @param	itemIndex
	* @return
	*/
	public function getPhotoUrl(cateIndex:Number, itemIndex:Number):String{
		return WEB_SITE+
			_dataXML.firstChild.childNodes[cateIndex].childNodes[itemIndex].attributes.url;
	}
	
	/**
	* 得到某个类别下具体某张图片的标题.
	* @param	cateIndex
	* @param	itemIndex
	* @return
	*/
	public function getPhotoTitle(cateIndex:Number, itemIndex:Number):String{
		return _dataXML.firstChild.childNodes[cateIndex].childNodes[itemIndex].attributes.title;
	}
	/**
	* 得到某个类别下具体某张图片的内容介绍.
	* @param	cateIndex
	* @param	itemIndex
	* @return
	*/
	public function getPhotoContent(cateIndex:Number, itemIndex:Number):String{
		return _dataXML.firstChild.childNodes[cateIndex].childNodes[itemIndex].firstChild.nodeValue;
	}
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "LoadXmlPhoto 1.0\r"+_dataXML;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
