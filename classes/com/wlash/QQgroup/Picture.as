//************************************************//	name:	Picture 1.0//	author:	whohoo//	email:	whohoo@21cn.com//	date:	Fri Dec 30 22:05:37 2005//	description: 管理整个图片的加载, 排放,点击,切换等
//			还没完成的功能,颜色管理,loading显示//************************************************
import flash.filters.*;
import com.wlash.QQgroup.*;
import mx.transitions.Tween;
class com.wlash.QQgroup.Picture{
	
	private var target:MovieClip	=	null;
	private var bPicture:MovieClip	=	null;//用来显示大图[2006]
	private var baseUrl:String		=	null;
	private var stageWidth:Number	=	null;
	private var stageHeight:Number	=	null;
	
	private var picXML:PictureXML	=	null;//所有的xml数据类
	public	var	curPicXML:Array		=	null;//当前的xml数据
	private var curPage:Number		=	null;
	private var amountPage:Number	=	null;//当前数据下的总页数
	private var curPicBoxCopy:Array	=	[];//下一页当前数据下,pic box的复制
	private var nextPageNodes:Array	=	[];//下一页要显示的数据
	
	private var headerHeight:Number	=	20;//stage抬头留边
	private var bottomHeight:Number	=	0;
	private var spacing:Number			=	10;
	private var BOX_WIDTH:Number	=	170;//小这框大小
	private var BOX_HEIGHT:Number	=	130;
	private var widthNum:Number	=	null;//横的方向有多少个
	private var heightNum:Number	=	null;
	private var amountNum:Number	=	null;//有多少个thumb
	private var curPicBox:Array		=	[];//当前页面大小下可以显示图片
											//的thumb box movieclip
	private var switchID:Number		=	null;
	private var switchSpeed:Number		=	-1;//自动切换图片的速度
	private var timeoutID:Number		=	null;//timeout延时,如果有延时,先停掉
												//当需要快速切换
	private var setTimeout:Function	=	null;
	
	public 	var curColor:Number		=	0x990000;//这个应另外做成一个类管理颜色
	private var navButton:NavButton		=	null;//被创建在PictureXML,也就是数据
											//加载完成时mcLeft[2002]mcRight[2004]
	//dubug
	public static var tt:Function	=	null;
	
	/**
	* 构建函数
	* @param target
	* @param baseUrl
	*/
	public function Picture(target:MovieClip, baseUrl:String){
		this.target		=	target;
		this.baseUrl	=	baseUrl;
		bPicture		=	target.createEmptyMovieClip("picture",2006);
		bPicture.createEmptyMovieClip("mcLoadPic",10);//加载大图的mc
		OnLoadThumb.picture		=	this;
		OnLoadPicture.picture	=	this;
		OnTweenStrong.picture	=	this;
		OnTweenNone.picture		=	this;
		
		Stage.scaleMode	=	"noScale";
		Stage.addListener(this);
		setTimeout	=	_global["setTimeout"];
		init();
	}
	
	/**
	* 初始化
	*/
	private function init():Void{
		onResize();
		picXML		=	new PictureXML(baseUrl+"picture.xml",this);
	}
	
	/**
	* 设置当前数据及分多少页,并显示第一页,
	* @param data
	* @param isFirstPage 如果是真,显示第一页,否则显示最后一页
	*/
	public function setCurData(data:Array,isFirstPage:Boolean):Void{
		curPicXML	=	data;
		amountPage	=	Math.ceil(data.length/amountNum);
		var page:Number	=	isFirstPage ? 0 : amountPage-1;
		showPage(page);
	}
	
	/**
	* 按页加载图片到场景中
	* @param page
	*/
	public function showPage(page:Number):Void{
		curPage	=	Math.abs(amountPage + page)%amountPage;
		curPicBoxCopy	=	curPicBox.slice();
		//curPicBoxCopy.shuffle();
		shuffleChildNodes(page);
		//当快速显示完一页后，执行慢速切换图片
		autoSwitch(200,"onFinishShowPage");
		navButton.setEnabled(false);
	}
	
	/**
	* 当调用showPage(page)后,图片快速切换显示完成后执行
	*/
	private function onFinishShowPage():Void{
		var text:String	=	null;
		setNavButtonName();
		setAutoSwitch();
		navButton.setEnabled(true);
	}
	
	/**
	* n秒后自动执行autoSwitch(2000,onNextPage);
	* @param second 默认为3秒
	* @param scope
	*/
	private function setAutoSwitch(second:Number,scope:Picture):Void{
		second	=	second==null ? (3+random(5))*1000 : second;
		scope	=	scope==null ? this : scope;
		scope.autoSwitch(-1);//先停掉原来的loop
		//2000表示2秒,onNextPage为当完成一页是要执行的代码
		timeoutID	=	setTimeout(scope,"autoSwitch",second,  3000,"onNextPage");
	}
	
	/**
	* 自动切换下一页的图片,显示完一页后,继续下一页.
	* @param second 当值等于0时,表示第一页,当值小于0侧停止loop
	* @param func 函数的字串名,
	* @param scope 执行的函数所在的范围,默认为this
	*/
	public function autoSwitch(second:Number,func:String,scope:Object):Void{
		clearInterval(switchID);
		clearInterval(timeoutID);
		
		switchSpeed	=	second;
		//trace("second : "+second);
		if(second<0){
			return;
		};
		//trace("curPage = "+curPage);
		scope	=	scope==null ? this : scope;
		
		var len:Number	=	curPicXML.length;
		switchID=setInterval(function():Void{
				//trace(scope.curPicBoxCopy.length)
				if(scope.curPicBoxCopy.length==0){
					scope.curPicBoxCopy	=	scope.curPicBox.slice();
					scope.curPicBoxCopy.shuffle();
					//trace("scope.curPage :"+scope.curPage);
					scope.shuffleChildNodes((scope.curPage+1)%scope.amountPage);
				};
				var num:Number	=	scope.nextPageNodes.shift()%len;
				//trace("num :"+num)
				scope.loadThumbPic(scope.curPicBoxCopy.shift(),
													scope.curPicXML[num]);
				// num%obj.len是为了不让数值超出curPicXML的范围
				if(scope.nextPageNodes.length==0){
					func!=null ? scope[func]() : null;
				};
			},second);
	}
	
	/**
	* 下一页,如果是在慢速切换图片时,快速显示完这一页,
	* 如果是在快速切换一页时,直接跳到一下页,而不等这一页显示完成
	*/
	public function nextPage():Void{
		if(switchSpeed<1000 && switchSpeed >0){
			showPage(curPage+1);
			//trace("quick");
		}else{
			autoSwitch(300,"onNextPage2");
			navButton.setEnabled(false);
			//trace("slow");
		}
	}
	
	/**
	* 上一页,重新加载上一页数据显示
	*/
	public function prevPage():Void{
		showPage(curPage-1);
	}
	
	
	/**
	* 根据屏幕大小确定横坚多少个图片
	*/
	private function countPicNumber():Void{
		var width:Number	=	stageWidth;
		var height:Number	=	stageHeight-headerHeight-bottomHeight;
		widthNum	=	Math.floor(width/(BOX_WIDTH+spacing));
		heightNum	=	Math.floor(height/(BOX_HEIGHT+spacing));
		amountNum	=	widthNum*heightNum;
		//trace("amountNum = "+amountNum);
	}
	/**
	* 放置pictureBox到stage上
	*/
	private function attachPictureBox():Void{
		var i:Number		=	0;
		var mc:MovieClip	=	null;
		curPicBox			=	[];
		//实际上的平均间隔
		var wSpacing:Number	=	(stageWidth-widthNum*BOX_WIDTH)/(widthNum+1);
		var hSpacing:Number	=	(stageHeight-headerHeight-bottomHeight-
										heightNum*BOX_HEIGHT)/(heightNum+1);
		
		for(var h:Number=0;h<heightNum;h++){
			for(var w:Number=0;w<widthNum;w++){
				mc	=	target.attachMovie("pictureBox","mcPic"+i,i,
							{_x:w*(BOX_WIDTH+wSpacing)+BOX_WIDTH/2+wSpacing,
							_y:h*(BOX_HEIGHT+hSpacing)+BOX_HEIGHT/2+hSpacing+
																headerHeight});
				mc.createEmptyMovieClip("mcLoadPic0",0);//小图在还没加载完成时
				mc.createEmptyMovieClip("mcLoadPic1",1);//小图被加载完成后放进这里

				curPicBox.push(mc);
				OnLoadPicture.setButtonEvents(mc);
				mc._visible	=	false;
				mc.enabled	=	false;
				i++;
			}
		}
	}
	/**
	* 得到当前分辨率下的影片的宽与高
	* 使_root往左上角对齐
	*/
	private function updateStageSize():Void{
		stageWidth	=	Stage.width;
		stageHeight	=	Stage.height;
		target._x	=	-(stageWidth/2-400);
		target._y	=	-(stageHeight/2-400);
		countPicNumber();
		removePictureBox();
		attachPictureBox();
		if(curPicXML!=null){
			showPage(curPage);
		}
	}
	
	/**
	* 除去旧picture box
	*/
	private function removePictureBox():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<amountNum;i++){
			mc	=	curPicBox[i];
			mc.removeMovieClip();
		}

	}
	
	/**
	* 使picture box按键是否可用
	* @param enabled
	*/
	private function enabledPictureBox(enabled:Boolean):Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<amountNum;i++){
			mc	=	curPicBox[i];
			mc.enabled	=	enabled;
		}

	}
	
	/**
	* stage 事件
	*/
	private function onResize():Void{
		updateStageSize();
		navButton.setPosition();
		//如果当前是显示着图片,当场景大小变化时,滑去图片
		if(bPicture.mcLoadPic._url.substr(-3)=="jpg"){
			slipTo(-(stageWidth-800)/2-500);
		}
	}
	
	
	/**
	* 当自动切换图片完成一页时,继续一下页
	*/
	private function onNextPage():Void{
		//下一页已经显示完了,所以页数增加1
		//curPage	=	(curPage+1)%amountPage;
		curPage++;
		setNavButtonName();
		//trace("curPage: "+curPage);
	}
	
	/**
	* 当按执行nextPage时,如果是慢速浏览,加速完成后,curPage要+1,
	* 并要启动自动切换图片的功能.
	*/
	private function onNextPage2():Void{
		onNextPage();
		setAutoSwitch();
	}
	
	/**
	* 设置左右按键的名称,当页数变化时
	*/
	private function setNavButtonName():Void{
		var text:String	=	null;
		if(curPage==amountPage-1){
			text	=	picXML.nextGroupName();
		}else{
			text	=	"下一页 ["+(curPage+2)+"/"+amountPage+"]";
		}
		navButton.setText(navButton.bRight, text);
		
		if(curPage==0){
			text	=	picXML.prevGroupName();
		}else{
			text	=	"["+(curPage)+"/"+amountPage+"] 上一页 ";
		}
		navButton.setText(navButton.bLeft, text);
		navButton.setEnabled(true);
	}
	
	/**
	* 加载小图
	* @param index
	* @param child
	*/
	private function loadThumbPic(pic:MovieClip,child:XMLNode):Void{
		
		pic.picDir	=	child.attributes.dir;
		pic.picName	=	child.attributes.name;
		pic.date	=	child.attributes.date;
		pic.title	=	child.firstChild.nodeValue;
		
		var picLoad:MovieClip	=	pic.getInstanceAtDepth(0);
		picLoad._rotation		=	0;
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.loadClip(baseUrl+pic.picDir+"_thumb/"+pic.picName, picLoad);
		mcl.addListener(OnLoadThumb);
		pic.enabled	=	false;
	}
	
	/**
	* 加载大图
	* @param target
	*/
	private function loadPicture(target:MovieClip):Void{
		bPicture._x		=	(stageWidth-800)/2+800+400;//右边
		//bPicture._x		=	stageWidth/2;
		bPicture._y		=	(stageHeight)/2;//中间
		var mcl:MovieClipLoader	=	new MovieClipLoader();
		mcl.loadClip(baseUrl+target.picDir+target.picName, bPicture.mcLoadPic);
		mcl.addListener(OnLoadPicture);
		bPicture.title	=	target.title;
		bPicture.date	=	target.date;
		bPicture.mcTxt.removeMovieClip();
		bPicture.mcDate.removeMovieClip();
		autoSwitch(-1);//停掉自动切换图片
	}
	
	/**
	* 把传递的数组赋值,并打乱,从指定的值开始
	* @param page 准备显示的页码
	*/
	private function shuffleChildNodes(page:Number):Void{
		var sIndex:Number	=	page*amountNum;
		for(var i:Number=0;i<amountNum;i++){
			nextPageNodes[i]	=	(i+sIndex);
		}
		nextPageNodes.shuffle();
	}
	
	/**
	* 显示文字
	* @param text
	* @param x
	* @param y
	* @param name
	* @param depth
	*/
	private function showText(text:String,x:Number,y:Number,name:String,
															depth:Number):Void{
		var txt_mc:MovieClip	=	bPicture.createEmptyMovieClip(name,depth);
		txt_mc._x	=	x;
		txt_mc._y	=	y;
		txt_mc.createTextField("txtInfo",0,0,0,0,0);
		var txt:TextField	=	txt_mc.txtInfo;
		txt.autoSize	=	"left";
		txt.text		=	text;
		var filter:GlowFilter	=	new GlowFilter(0xffffff, .8, 5, 5, 2, 3, 
																false, false);
		var filterArray:Array	=	[filter];
		txt_mc.filters	=	filterArray;

	}
	
	/**
	* 慢慢显示大图,从右边滑出
	* @param x
	*/
	private function slipTo(x:Number):Void{
		//bPicture.blurX	=	200;
		var scope:Object	=	this;
		var tw:Tween	=	new Tween(bPicture,"_x",
								mx.transitions.easing.Strong.easeOut,
								bPicture._x,x,1,true);
		var tw1:Tween	=	new Tween(bPicture,"blurX",
								mx.transitions.easing.Strong.easeOut,
								200,8,1,true);
		tw.addListener(OnTweenStrong);
		
	}
	/**
	* 格式化时间
	* @param date [Fri Jul 15 11:31:16 CST 2005]
	* @return string [Jul,15 2005 11:31:16]
	*/
	private function formatDate(date:String):String{
		//var month:Array	=	["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Dec","Nov"];
		var date_arr:Array	=	date.split(" ");
		return date_arr[1]+","+date_arr[2]+" "+date_arr[5]+" "+date_arr[3];
	}
	
	/**
	* 画边框
	* @param width
	* @param height
	*/
	private function drawFrame(width:Number,height:Number):Void{
		var frame:MovieClip	=	bPicture.createEmptyMovieClip("mcFrame",0);
		var w:Number	=	width/2;
		var h:Number	=	height/2;
		frame.beginFill(0xffdddd,90);
		NavButton.drawRect(frame,-w,-h,w,h);
		frame.endFill();

	}
	
	/**
	* 显示当前类名称
	* @return name
	*/
	public function toString():String{
		return "picture 1.0";
	}
	
	/**
	* 加载xml数据
	
	private function loadXML():Void{
		var _xml:XML	=	new XML();
		_xml.ignoreWhite	=	true;
		_xml.load(baseUrl+"picture.xml");
		var scope:Object	=	this;
		_xml.onLoad=function(s:Boolean){
			if(s && this.status==0){
				scope.curPicXML	=	this.firstChild;
				scope.showPage(0);
			}
		};
		
	}
	*/
	/**
	* 加载小图片
	
	private function loadPic():Void{
		var index:Number	=	0;
		curPicBox.shuffle();
		
		var interID=setInterval(function(scope:Object){
				
				var pic:MovieClip	=	scope.curPicBox[index];
				var mcl:MovieClipLoader	=	new MovieClipLoader();
				mcl.loadClip(scope.baseUrl+pic.picDir+"_thumb/"+pic.picName, 
								pic.mcLoadPic0);
				mcl.addListener(OnLoadThumb);
				if(++index == scope.amountNum){
					//5second后自动开始
					scope.setAutoSwitch(1000);
					clearInterval(interID);
				}
			},300,this);
	}*/
}