//******************************************************************************
//	name:	MenuB 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		
//******************************************************************************



import com.wangfan.website.lab.SuperMenu;
/**
 * 动态菜单的第二层菜单项.<p></p>
 * 设置数据，及画线出现。
 */
class com.wangfan.website.lab.MenuB extends SuperMenu{
	
	//************************[READ|WRITE]************************************//
	/**文字的颜色 */
	function get textColor():Number{
		var tColor:Number	=	null;
		if(_parent.item_mc.name_mc.name_txt.text=="DOWNLOAD"){
			tColor	=	_textColorArr[0];
		}else{
			tColor	=	_textColorArr[1];
		}
		
		return tColor;
	}
	
	//************************[READ ONLY]*************************************//
	
	private function MenuB(){
		super();
		lineAlpha	=	80;
	}
	//************************[PRIVATE METHOD]********************************//
	//overwrite
	private function onExpandEnd():Void{//_level0.menuRoot_mc.mcMenu0.mcSubMenu0.mcSub2Menu0
		if(_parent._parent.isAutoExpand){//如果是按第一级菜单的，自动展开第一项默认的内容。
			this["mcSub2Menu0"].item_mc.onRelease();
			//_parent._parent.isAutoExpand	=	false;//这个判断已移到当图片加载完成后，
								//如果是按第一级菜单，然后自动打开默认的内容，则跳转。
		}
		
	}
	//overwrite
	private function onCollapseEnd():Void{
		
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 定义菜单条的顺序号及名称
	* @param name
	*/
	public function setData(name:String):Void{
		var txt:TextField	=	item_mc.name_mc.name_txt;
		txt.text	=	name;
		//var fmt:TextFormat	=	txt.getTextFormat();
		//fmt.color	=	textColor;
		//txt.setTextFormat(fmt);
		//trace([this._name, textColor])
	}
	
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
