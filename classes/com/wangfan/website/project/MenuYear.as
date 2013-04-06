//******************************************************************************
//	name:	MenuYear 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Dec 07 10:30:40 GMT+0800 2006
//	description: This file was created by "project.fla" file.
//		
//******************************************************************************



/**
 * 在project中年份菜单.<p></p>
 * 
 */
class com.wangfan.website.project.MenuYear extends MovieClip{
	private var year_txt:TextField		=	null;
	/**年份右边的线，用来分隔符。当为最右边项时，不要显示分隔符。*/
	public  var line_mc:MovieClip		=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * CANNOT Create a class BY [new MenuYear();]
	 */
	private function MenuYear(){
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		
	}
	
	private function onRelease():Void{
		_parent._parent._parent.showProjectList(this);
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义标签的名称
	* @param name
	*/
	public function setData(name:String):Void{
		//year_txt.autoSize	=	"left";
		//year_txt.text		=	name;
		//setYearColor(0xff9900);
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
