//******************************************************************************
//	name:	MenuYear 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 22:12:19 2006
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;
//import com.wangfan.website.award.LoadXmlMenu;

/**
 * 在award.swf中的动态菜单（上方的年份菜单）.<p></p>
 * 根据加载的XML数据生成菜单。
 */
class com.wangfan.website.award.MenuYear extends MovieClip{
	private var year_txt:TextField		=	null;
	
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
		_parent._parent.showAward(this);
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义标签的名称
	* @param name
	*/
	public function setData(name:String):Void{
		year_txt.autoSize	=	"left";
		year_txt.text		=	name+" Awards";
		setYearColor(0xff9900);
	}
	/**
	* 定义标签年份的颜色值
	* @param value
	*/
	public function setYearColor(value:Number):Void{
		var fmt:TextFormat	=	year_txt.getTextFormat();
		fmt.color	=	value;
		year_txt.setTextFormat(0, 4, fmt);
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
