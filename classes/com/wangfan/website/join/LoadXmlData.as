//******************************************************************************
//	name:	LoadXmlData 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		
//******************************************************************************



import com.wangfan.website.LoadXML;

/**
 * 在join.swf中的动态菜单.<p></p>
 * 抛出的XML数据
 */
class com.wangfan.website.join.LoadXmlData extends LoadXML{

	/**_target对象是否停止了播放。如果停止播放等候加载数据，则当数据加载完成时
	* 要继续播放_target对象。
	* 而如果还没到停止点就把数据加载完成后，则直接跳过停止点，继续播放。
	*/
	public  var isStopped:Boolean	=	false;
	
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoadXmlMenu4Lab(this);]
	 * @param target target a movie clip
	 */
	public function LoadXmlData(target:MovieClip){
		super(target, "/process/getRecruit.aspx");
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
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "LoadXmlMenu 1.0\r"+_dataXML;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
/*
LoadXmlMenu 1.0
<Recruits>
<recruit id="1" title="website designer" submit_email="luren@wangfan.com">
<request>Qualification

1, skillfully use Photoshop, Flash and other graphics processing software;

Dreamweaver and other web design software，can skillfully use Javascript.

2, solid and strict work, a strong sense of responsibility, is the spirit of teamwork and dedication to the work style.

3, with the use of POP by computer software or Cartoon Drawing enthusiast preferred.

</request><description>Several insurgents website designers, using the most innovative tactics, planning and design of a comprehensive independent website,timely fashion elements into the design, show to the customer a unique, perfect website.</description></recruit><recruit id="3" title="Senior website designer" submit_email="rex@wangfan.com"><request>- More than three years experience in web design and interactive design

- Understanding of the latest technology trends and interactive website

- Effective organizational structure and site design, attention to detail

- Proficient in Photoshop, Flash, Dreamweaver or related web site design software

- Master basic Flash AS

- Please provide the latest designs</request>
<description>Several insurgents Senior website designer.</description>
</recruit>
</Recruits>

*/
