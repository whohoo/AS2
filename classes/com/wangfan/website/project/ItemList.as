//******************************************************************************
//	name:	ItemList 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Dec 07 10:30:40 GMT+0800 2006
//	description: This file was created by "project.fla" file.
//		
//******************************************************************************



/**
 * 在project中年份下项目内容菜单.<p></p>
 * 
 */
class com.wangfan.website.project.ItemList extends MovieClip{
	private var title_txt:TextField		=	null;
	private var title_mc:MovieClip			=	null;
	
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * CANNOT Create a class BY [new MenuYear();]
	 */
	private function ItemList(){
		title_txt	=	title_mc.title_txt;
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		onReleaseOutside=onRollOut;
	}
	
	private function onRelease():Void{
		_parent._parent._parent.showProjectDetail(this);
	}
	
	private function onRollOver():Void{
		this["moveIn"]();
	}
	private function onRollOut():Void{
		this["moveOut"]();
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义标签的名称
	* @param name
	*/
	public function setData(name:String):Void{
		title_txt.text	=	name;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
