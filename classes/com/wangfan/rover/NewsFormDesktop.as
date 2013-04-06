//******************************************************************************
//	name:	LoginFormDesktop 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2006-10-24 15:00
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.rover.GlobalProperty;

/**
 * 用户登录程序,应用于桌面程序.<p></p>
 * 登录成功后,返回用户的基本信息.
 */
class com.wangfan.rover.NewsFormDesktop extends Object{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	
	private var _target:MovieClip		=	null;
	
	private var _newsXML:XML			=	null;
	private var _newsXML2:XMLNode		=	null;
	private var _interID:Number			=	null;
	
	/**新闻的总数量*/
	public  var total:Number			=	null;
	/**表明是加载完成了*/
	public  var isLoaded:Boolean		=	false;
	/**自动更新新闻的时间间隔(分钟)*/
	public  var refreshInterval:Number	=	5;
	//static public var SITE_HOST:String	=	"http://rover.wangfan.com/process/";
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new LoginForm(this);]
	 * @param target target a movie clip
	 */
	public function NewsFormDesktop(target:MovieClip){
		this._target	=	target;
		
		//SITE_HOST	=	"";
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_newsXML	=	new XML();
		_newsXML.ignoreWhite	=	true;
		_newsXML.onLoad=Delegate.create(this, onNewsLoaded);
		refresh();
	}
	
	private function onNewsLoaded(success:Boolean):Void{
		if(success){
			if(_newsXML.status==0){
				total		=	_newsXML.firstChild.childNodes.length;
				
				if(_target.firstNews_mc.isStop==true){
					_target.firstNews_mc.gotoAndPlay(2);
				}
				isLoaded	=	true;
				_newsXML2	=	_newsXML.cloneNode(true);
				_interID=setInterval(Delegate.create(this, refresh), refreshInterval*60*1000);
			}else{
				trace("XML status: "+_newsXML.status);
			}
		}
	}
	
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 得到某条新闻的详细
	* @param	index
	* @return
	*/	
	public function getNewsAt(index:Number):Object{
		if(index>=total)	return	{id:null, date:"", title:"", content:""};
		var child:XMLNode	=	_newsXML2.firstChild.childNodes[index];
		
		return {id:child.attributes.id,
				date:child.attributes.pr_date,
				title:child.attributes.subject,
				content:child.firstChild.nodeValue
				};
	}
	/**
	* 再次更新
	*/
	public function refresh():Void{
		isLoaded	=	false;
		_newsXML.load(GlobalProperty.SITE_HOST+"getNewsList.aspx?r="+random(0xffffff));
		clearInterval(_interID);
	}
	
	/**
	* 数据已经准备好了,可以执行以下动作
	*/
	public function dataReady():Void{
		
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "NewsFormDesktop 1.0";
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
