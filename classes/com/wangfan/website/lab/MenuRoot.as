//******************************************************************************
//	name:	MenuRoot 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 22:12:19 2006
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;
//import com.wangfan.website.lab.LoadXmlMenu;

/**
 * 在lab.swf中的动态菜单（根目录）.<p></p>
 * 根据加载的XML数据生成菜单。
 */
class com.wangfan.website.lab.MenuRoot extends MovieClip{
	private var load_mcl:MovieClipLoader	=	null;
	private var _loadUrl:String			=	null;//加载内容的路径。
	private var _isFirstTimeOpen:Boolean	=	null;
	/**此菜单下子菜单的数组引用.*/
	public  var subMenuArr:Array		=	null;
	/**指明是否自动展开所有了子所项。*/
	public  var isAutoExpand:Boolean	=	null;
	/**当前打开的menu项*/
	public var curMenu:MovieClip		=	null;
	/**在库中的menu linkage name, 第一级菜单。*/
	public  var menuItemA:String		=	"MenuA";
	/**在库中的menu linkage name, 第二级菜单。*/
	public  var menuItemB:String		=	"MenuB";
	/**在库中的menu linkage name, 第三级菜单。*/
	public  var menuItemC:String		=	"MenuC";
	/**在库中的menu linkage name, 第三级菜单下的内容。*/
	public  var menuItemCC:String		=	"MenuC_content";
	/**第一级菜单menu item的高度*/
	public  var menuItemAHeight:Number	=	26;
	/**第二级菜单menu item的高度*/
	public  var menuItemBHeight:Number	=	20;
	/**第三级菜单menu item的高度*/
	public  var menuItemCHeight:Number	=	18;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 */
	public function MenuRoot(){
		subMenuArr	=	[];
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		load_mcl	=	new MovieClipLoader();
		load_mcl.addListener(this);
		_isFirstTimeOpen	=	true;
	}
	//第三级菜单的点击事件。加载内容。
	private function onClickSubMenu2(evtObj:Object):Void{
		//trace([evtObj.swfUrl]);
		_loadUrl	=	evtObj.swfUrl;
		
		if(_parent.loadContent_mc._totalframes>1){//先退场
			_parent.loadContent_mc.gotoAndPlay("end");
		}else{//这里只执行一次。就是第一加载时。
			load_mcl.loadClip(evtObj.swfUrl, _parent.loadContent_mc);
		}
		//trace(_parent._parent._parent._parent.loadContent_mc);//_root.loadContent_mc
	}
	
	private function onLoadStart(target_mc:MovieClip):Void{
		_parent.loadBar_mc._visible		=	true;
		dropDown(_parent.loadBar_mc);
	}
	private function onLoadProgress(target_mc:MovieClip, loaded:Number, total:Number):Void{
		var percent:Number	=	Math.round(loaded/total*100);
		_parent.loadBar_mc.loading_txt.text	=	"loading "+percent+" ......";
		_parent.loadBar_mc.percent	=	percent;
		dropDown(_parent.loadBar_mc);
	}
	
	private function onLoadComplete(target_mc:MovieClip):Void{
		_parent.loadBar_mc.loading_txt.text	=	"";
		_parent.loadBar_mc._visible		=	false;
		if(isAutoExpand){
			moveMenu(curMenu.item_mc.name_mc.name_txt.text);
			if(_isFirstTimeOpen){//如果是第一次打开此菜单，则不会在上层做菜单移动的动画
				_isFirstTimeOpen	=	//而是直接打开可显示的内容。
				isAutoExpand		=	false;
			}
		}
	}
	private function onLoadInit(target_mc:MovieClip):Void{
		//trace("onLoadInit: "+target_mc)
		target_mc._visible	=	true;
		if(isAutoExpand){//先不要显示，等上层做菜单移动到指定位置时再做显示。
			isAutoExpand	=	false;
		}else{
			target_mc.gotoAndPlay(2);
		}
	}
	
	private function moveMenu(text:String):Void{
		var len:Number	=	subMenuArr.length;
		var mc:MovieClip	=	null;
		var colorNum:Number	=	null;
		if(text=="DOWNLOAD"){
			colorNum	=	curMenu._textColorArr[0];
			for(var i:Number=0;i<len;i++){
				mc	=	subMenuArr[i];
				mc.item_mc.no_mc.no_txt.textColor		=
				mc.item_mc.name_mc.name_txt.textColor	=	colorNum;
				new Color(mc.line0).setRGB(colorNum);
				new Color(mc.line1).setRGB(colorNum);
			}
			_parent.moveOut(51);
		}else{
			colorNum	=	curMenu._textColorArr[1];
			for(var i:Number=0;i<len;i++){
				mc	=	subMenuArr[i];
				mc.item_mc.no_mc.no_txt.textColor		=
				mc.item_mc.name_mc.name_txt.textColor	=	colorNum;
				new Color(mc.line0).setRGB(colorNum);
				new Color(mc.line1).setRGB(colorNum);
			}
			_parent.moveIn(73);
		}
	}
	
	private function dropDown(mc:MovieClip):Void{
		var percent:Number	=	mc.percent;
		if(isNaN(percent)){
			percent	=	0;
		}
		mc.dropHeight	=	Stage.height*percent/100;
		mc._tempHeight	=	0;
		mc.onEnterFrame=Delegate.create(this, _onLoadingBarEnterFrame);
	}
	
	private function _onLoadingBarEnterFrame():Void{
		var mc:MovieClip	=	_parent.loadBar_mc;
		mc._tempHeight	=	(((mc._y-mc.dropHeight)*.7)+mc._tempHeight)*.5;
		mc._y	-=	mc._tempHeight;
		if(Math.abs(mc._tempHeight)<.1){
			if(mc.percent>=100){
				delete mc.onEnterFrame;
				return;
			}
			dropDown(mc);
		}
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 当一个内容退场结束后，调用的函数，也就是加载下一个内容。
	*/
	public function loadNext():Void{//trace("loadNext: "+_loadUrl)
		load_mcl.loadClip(_loadUrl, _parent.loadContent_mc);
	}
	/**
	* 创建主菜单
	*/
	public function createTopMenu(child:XMLNode):Void{
		var len:Number		=	child.childNodes.length;
		child	=	child.firstChild;
		
		var i:Number		=	0;
		var mc:MovieClip	=	null;
		var time:Number	=	0;
		while(child!=null){
			mc	=	this.attachMovie(menuItemA, "mcMenu"+i, i, 
							{_y:menuItemAHeight*i, index:i, _visible:false});
			mc.curHeight	=	
			mc.minHeight	=	0;
			mc.setData(child.attributes.name);
			
			createSubMenu(mc, child);
			subMenuArr.push(mc);
			
			i++;
			child	=	child.nextSibling;
		}
		
	}
	/**
	* 创建主菜单下的子菜单，二级菜单
	*/
	public function createSubMenu(mc0:MovieClip, child:XMLNode):Void{
		var len:Number		=	child.childNodes.length;
		child		=	child.firstChild;
		var i:Number		=	0;
		var mc:MovieClip	=	null;
		var time:Number	=	0;
		while(child!=null){
			mc	=	mc0.attachMovie(menuItemB, "mcSubMenu"+i, i,
							{_y:menuItemBHeight*i+menuItemAHeight, 
							index:i, _visible:false});
			mc.curHeight	=	
			mc.minHeight	=	0;
			mc.setData(child.attributes.name);
			
			createSubMenu2(mc, child);
			mc0.subMenuArr.push(mc);
			
			i++;
			child	=	child.nextSibling;
		}
		//展开最大位置
		mc0.maxHeight	=	len*menuItemBHeight;
	}
	
	/**
	* 创建主菜单下的子菜单的子菜单，三级菜单
	*/
	public function createSubMenu2(mc0:MovieClip, child:XMLNode):Void{
		var len:Number		=	child.childNodes.length;
		child		=	child.firstChild;
		var i:Number		=	0;
		var mc:MovieClip	=	null;
		var time:Number	=	0;
		while(child!=null){
			mc	=	mc0.attachMovie(menuItemC, "mcSub2Menu"+i, i,
							{_y:menuItemCHeight*i+menuItemBHeight, 
							index:i, _visible:false});
			mc.curHeight	=	
			mc.minHeight	=	0;
			mc.setData(child);
			createSubMenuContent(mc, child);//创建第三级菜单下的可显示内容
			mc0.subMenuArr.push(mc);
			mc.addEventListener("onClick", Delegate.create(this, onClickSubMenu2));
			
			i++;
			child	=	child.nextSibling;
		}
		//展开最大位置
		mc0.maxHeight	=	len*menuItemCHeight;
	}
	
	/**
	* 创建三级菜单下的内容,只有一项内容。
	*/
	public function createSubMenuContent(mc0:MovieClip, child:XMLNode):Void{
		//child		=	child.firstChild;
		var mc:MovieClip	=	null;
		if(child!=null){
			mc	=	mc0.attachMovie(menuItemCC, "mcSub2MenuContent"+0, 0,
							{_y:menuItemCHeight, _visible:true});
			mc.curHeight	=	
			mc.minHeight	=	0;
			mc.content_txt.autoSize	=	"left";
			mc.content_txt.htmlText	=	child.firstChild.nodeValue;
			//作品的作者。
			mc.worker_mc.worker_txt.autoSize	=	"left";
			mc.worker_mc.worker_txt.text	=	child.attributes.worker;
			mc.worker_mc._y	=	mc.content_txt._y+mc.content_txt._height+4;
			//作品作者背景条的的大小，随着文件的高度而变化。
			mc.worker_mc.height					=	
			mc.worker_mc.background_mc._height	=	mc.worker_mc.worker_txt._height-4;
			//不同的一级菜单内容，不同的作者背景颜色
			if(mc._parent._parent._parent.item_mc.name_mc.name_txt.text=="DOWNLOAD"){
				mc.worker_mc.gotoAndStop(1);
			}else{
				mc.worker_mc.gotoAndStop(2);
			}
			mc.mask_mc._height	=	0;//不可见
			mc.pClass		=	mc0;
			mc0.subContent	=	mc;
			//展开最大位置
			mc0.maxHeight	=	mc._height+12;//+号后的为此内容与下一项的距离。
		}else{
			mc0.maxHeight	=	0;
		}
	}
	
	/**
	 * 更新顶层菜单的位置，当顶层菜单被打开或收起来的时候。
	 * 
	 */
	public function renderMenu():Void{
		var arr:Array		=	subMenuArr;
		var len:Number		=	arr.length;
		var mc:MovieClip	=	null;
		var mcPrev:MovieClip	=	arr[0];
		var subMenuHeight:Number	=	null;//第二级菜单的高度。
		for(var i:Number=1;i<len;i++){
			mc		=	arr[i];
			subMenuHeight	=	renderSubMenu(mcPrev);
			mc._y	=	mcPrev.curHeight+mcPrev._y+menuItemAHeight+
														subMenuHeight;
			mcPrev	=	mc;
		}
		//render最后一组
		renderSubMenu(mcPrev);
	}
	
	/**
	 * 更新二级菜单的位置，当二级菜单被打开或收起来的时候。
	 * 除了返回本级菜单的高度外，还有本级菜单下的子菜单的高度。
	 */
	public function renderSubMenu(mc0:MovieClip):Number{
		var arr:Array		=	mc0.subMenuArr;
		var len:Number		=	arr.length;
		var mc:MovieClip	=	null;
		var mcPrev:MovieClip	=	arr[0];
		var retHeight:Number	=	mcPrev.curHeight;
		var subMenu2Height:Number	=	null;//第三级菜单的高度。
		//var distance:Number	=	0;//第一级菜单与第二级菜单之间的距离
		for(var i:Number=1;i<len;i++){
			mc		=	arr[i];
			subMenu2Height	=	renderSubMenu2(mcPrev);
			mc._y	=	mcPrev.curHeight+mcPrev._y+menuItemBHeight+
							subMenu2Height;
			retHeight	+=	(mc.curHeight+subMenu2Height);
			mcPrev	=	mc;
		}
		subMenu2Height	=	renderSubMenu2(mcPrev);
		retHeight	+=	subMenu2Height;
		return retHeight;
	}
	
	/**
	 * 更新三级菜单的位置，当三级菜单被打开或收起来的时候。
	 * 
	 */
	public function renderSubMenu2(mc0:MovieClip):Number{
		var arr:Array		=	mc0.subMenuArr;
		var len:Number		=	arr.length;
		var mc:MovieClip	=	null;
		var mcPrev:MovieClip	=	arr[0];
		var retHeight:Number	=	mcPrev.curHeight;
		//var distance:Number	=	0;//第二级菜单与第三级菜单打开内容之间的距离
		for(var i:Number=1;i<len;i++){
			mc		=	arr[i];
			mc._y	=	mcPrev.curHeight+mcPrev._y+menuItemCHeight;
			retHeight	+=	mc.curHeight;
			mcPrev	=	mc;
		}
		return retHeight;
	}
	
	/**
	* 显示主菜单
	*/
	public function showMenuTop():Void{
		var len:Number		=	subMenuArr.length;
		var time:Number	=	null;
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<len;i++){
			time	=	i/len;
			mc		=	subMenuArr[i];
			mc.show(time);
		}
		//默认是把最新的列表打开。
		//第一级菜单打开
		this["mcMenu0"].item_mc.onRelease();
		
		
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
