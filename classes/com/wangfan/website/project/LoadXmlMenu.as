//******************************************************************************
//	name:	LoadXmlMenu 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		
//******************************************************************************



import com.wangfan.website.LoadXML;

/**
 * 在project.swf中的动态菜单.<p></p>
 * 菜单XML数据
 */
class com.wangfan.website.project.LoadXmlMenu extends LoadXML{

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
	public function LoadXmlMenu(target:MovieClip){
		super(target, "/process/getProject.aspx");
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
/*<Projects>
* <2006>
* <project id="4" profile_pic="/images/project_profile_pics/2006/rover.jpg" issue_date="2006-12-1" title="rover" worker="many peoples"><description>rover online game.</description><pic url="/images/project_profile_pics/2006/rover_20061114_101549.jpg" /><pic url="/images/project_profile_pics/2006/rover_20061114_101556.jpg" /></project><project id="7" profile_pic="/images/project_profile_pics/2006/this_is_a_test.jpg" issue_date="2006-11-13" title="this is a test" worker="asdf"><description>aaa</description><pic url="/images/project_profile_pics/2006/this_is_a_test_20061113_205716.jpg" /><pic url="/images/project_profile_pics/2006/this_is_a_test_20061114_101523.jpg" />
* <pic url="/images/project_profile_pics/2006/this_is_a_test_20061114_101534.jpg" />
* </project></2006></Projects>
*/ 
