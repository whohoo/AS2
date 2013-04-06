//******************************************************************************
//	name:	MenuRoot 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Oct 31 22:12:19 2006
//	description: 
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.website.award.MenuContentMask;
import com.wangfan.rover.MoveMap;

/**
 * 在award.swf中的动态菜单（根目录）.<p></p>
 * 根据加载的XML数据生成菜单。
 */
class com.wangfan.website.award.MenuRoot extends MovieClip{
	private var _visibleHeight:Number		=	null;//可显示内容的最大高度
	private var year_mc:MovieClip			=	null;
	private var maskYear_mc:MovieClip		=	null;
	private var content_mc:MovieClip		=	null;
	private var maskContent_mc:MovieClip	=	null;
	private var mcLineUp:MovieClip			=	null;//年份上方的粗线条
	private var mcLineMid:MovieClip		=	null;//年份下方的细线条
	private var mcLineDown:MovieClip		=	null;//最下方的粗线条
	
	private var _isShowLines:Boolean		=	null;//线是否已经显示？
	private var _interShowLine:Number		=	null;//出现线的间隔
	private var _curShowLineIndex:Number	=	null;//第N条出现的线.
	private var _curYear:MovieClip			=	null;
	private var _nextYear:MovieClip			=	null;//当关闭完成后，下一个打开的年份。
	private var menuItemYearID:String		=	"menu year";
	private var menuItemYearSplitID:String	=	"yearSplit";
	private var menuItemContentID:String	=	"awardContent";
	private var menuItemMovingLine:String	=	"moving line";
	
	private var _maxMaskContentHeight:Number	=	0;
	private var _moveMap:MoveMap			=	null;
	private var _moveYear:MoveMap			=	null;
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * CANNOT Create a class BY [new MenuRoot();]
	 */
	private function MenuRoot(){
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		_isShowLines	=	false;
		_moveMap	=	new MoveMap(content_mc, maskContent_mc);
		_moveMap.isMoveX	=	false;//x轴方向不要移动。
		_moveMap.stopMove();
		_moveYear	=	new MoveMap(year_mc, maskYear_mc);
		_moveYear.isMoveY	=	false;//y轴方向不要移动。
		_moveYear.stopMove();
	}
	
	
	private function setLineSize(mcLine:MovieClip, width:Number, height:Number):Void{
		mcLine._width	=	width/1000;
		mcLine._height	=	height;
		mcLine.gotoAndStop(1);
	}
	
	//生成年份下的内容。
	private function createContent(child:XMLNode):Void{
		//var len:Number	=	child.childNodes.length;
		child	=	child.firstChild;
		var mc:MovieClip	=	null;
		var mcPrev:Object	=	{_y:0, _height:0};
		content_mc.mcContent.removeMovieClip();
		var mcContent:MovieClip	=	content_mc.createEmptyMovieClip(
																"mcContent", 0);
		
		var i:Number		=	0;
		while(child!=null){
			mc		=	mcContent.attachMovie(menuItemContentID, 
										"content"+i, i*2, {_x:123});
			mc.content_txt.autoSize	=	"left";
			mc.content_txt.htmlText	=	child.firstChild.nodeValue;
			mc.content_txt.text		+=	"\r issuer: "+child.attributes.issuer;
			mc.content_txt.text		+=	"\r client: "+child.attributes.client;
			mc.content_txt.text		+=	"\r date: "+child.attributes.issue_date;
			mc.detailURL		=	child.attributes.detailURL;
			if(mc.detailURL!="none"){
				mc.onRelease=function(){
					//trace(this.detailURL)
					getURL(this.detailURL, "award");
				}
			}
			mc._y	=	mcPrev._y+mcPrev._height+4;
			mcPrev	=	mc;
			//生成细线条
			if(i!=0){//第一条记录前不用细钱。
				//trace(content_mc["line1"])
				mc	=	content_mc.attachMovie(menuItemMovingLine, "line"+i, 
												i*2+1, {_y:mcPrev._y});
				
				setLineSize(mc, 500, 1);
			}
			
			
			i++;
			child	=	child.nextSibling;
		}
		mcContent.itemTotal	=	i;//年份下有多少条记录
		//mcContent._visible	=	false;
	}
	//得到可视范围的高度，这决定了一页可显示多少条award.
	private function getMaskHeight():Void{
		var pos:Object	=	{x:content_mc._x, y:content_mc._y};
		localToGlobal(pos);
		_parent._parent.globalToLocal(pos);
		_visibleHeight	=	 Stage.height-180-pos.y;
	}
	
	private function maskMaxHeight():Void{
		var mcContent:MovieClip	=	content_mc["mcContent"];
		var height:Number			=	mcContent._height+10;
		if(height>_visibleHeight){
			height	=	_visibleHeight;
		}
		//maskContent_mc._height	=	height;
		_maxMaskContentHeight	=	height;
		mcLineDown._y	=	_maxMaskContentHeight+maskContent_mc._y;
	}

	//当内容的mask伸长时。
	private function onExpanding(height:Number):Void{
		mcLineDown._y	=	maskContent_mc._y+height;
		var mc:MovieClip	=	content_mc["line"+_curShowLineIndex];
		
		if(mc==null){
			return;
		}
		if(mc._y<=maskContent_mc._height){
			mc.moveIn();
			_curShowLineIndex++;
		}
		
	}
	
	private function onCollapsing(height:Number):Void{
		mcLineDown._y	=	maskContent_mc._y+height;
	}
	//当mask伸长结束时。
	private function onExpandEnd():Void{
		mcLineDown._y	=	maskContent_mc._y+maskContent_mc._height;
		
		mcLineDown.moveIn();//底层粗线移动。
		var len:Number		=	content_mc.mcContent.itemTotal;
		var mc:MovieClip	=	null;
		for(var i:Number=_curShowLineIndex;i<len;i++){
			mc	=	content_mc["line"+i];
			mc.gotoAndStop(mc._totalframes);
		}
		_curShowLineIndex	=	i;
		//如果超出mask的高度，就使用moveMap
		if(maskContent_mc._height<content_mc._height){
			_moveMap.maskMC	=	maskContent_mc;
			_moveMap.map	=	content_mc;
			_moveMap.isMoveY	=	true;
			_moveMap.startMove();
			content_mc._y	=	maskContent_mc._y;
		}else{//上对齐.
			
		}
	}
	
	//当mask缩小结束时。
	private function onCollapseEnd():Void{
		mcLineDown._y	=	maskContent_mc._y+maskContent_mc._height;
		
		var len:Number	=	content_mc.mcContent.itemTotal;
		//把线条删除掉
		for(var i:Number=0;i<len;i++){
			content_mc["line"+i].removeMovieClip();
		}
		
		_curYear	=	null;
		_nextYear.onRelease();
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 生成菜单。
	* @param child
	*/
	public function createMenu(child:XMLNode):Void{
		getMaskHeight();
		//横向的年份得奖条。
		//var len:Number	=	child.childNodes.length;
		child	=	child.firstChild;
		var mc:MovieClip	=	null;
		var mcPrev:Object	=	{_x:0, _width:0};
		//年份上方的粗线条
		mc	=	attachMovie(menuItemMovingLine, "mcLineUp", 10);
		setLineSize(mc, 490, 3);
		//年份下方的细线条
		mc	=	attachMovie(menuItemMovingLine, "mcLineMid", 11);
		setLineSize(mc, 490, 1);
		mc._y	=	maskContent_mc._y;
		var i:Number		=	0;
		while(child!=null){
			mc		=	year_mc.attachMovie(menuItemYearID, "menuYearBar"+i, 2*i);
			mc._x	=	mcPrev._x+mcPrev._width+10;
			mc.setData(child.nodeName);
			//年份分隔符
			year_mc.attachMovie(menuItemYearSplitID,  "yearSplit"+i, 2*i+1,
						{_x:mc._x+mc._width+8});
			mc.index	=	i;
			//生成年份下的内容。
			mc.child	=	child;
			mcPrev	=	mc;
			i++;
			child	=	child.nextSibling;
		}
		
		//最下方的组线条
		mc	=	attachMovie(menuItemMovingLine, "mcLineDown", 12);
		setLineSize(mc, 490, 3);
		year_mc["menuYearBar0"].onRelease();
		//如果超过可显示范围，移动年份。
		if(year_mc._width>maskYear_mc._width){
			_moveYear.maskMC	=	maskYear_mc;
			_moveYear.map		=	year_mc;
			_moveYear.isMoveX	=	true;
			_moveYear.startMove();
		}
	}
	
	/**
	 * 显示英某年份下的award 
	 * 
	 * @param   year 
	 */
	public function showAward(year:MovieClip):Void{
		if(_curYear==year)	return;
		if(_curYear!=null){
			maskContent_mc.collapseContentMask();
			_nextYear	=	year;//当关闭完成后，下一个打开的年份。
			return;
		}
		_curYear	=	year;
		mcLineUp.moveIn();
		mcLineMid.moveIn();
		
		createContent(year.child);
		maskContent_mc._height	=	0;
		maskMaxHeight();
		_curShowLineIndex	=	1;
		maskContent_mc.expandContentMask(_maxMaskContentHeight);
		//内容上对齐
		_moveMap.isMoveY	=	false;
		_moveMap.stopMove();
		content_mc._y	=	maskContent_mc._y;
	}
	
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
