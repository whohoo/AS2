//******************************************************************************
//	name:	LoadXML 1.3
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Oct 30 11:00:41 2006
//	description: 
//		不在构造方法中执行init()方法.
//		增加下载百分比
//******************************************************************************


import mx.utils.Delegate;

/**
 * XML数据加载父类.<p/>
 * 各个加载XML数据的子类继承此类的方法与属性。
 */
class com.wangfan.website.LoadXML extends Object{
	
	private var _target:MovieClip		=	null;
	private var _dataXML:XML			=	null;
	private var _dataUrl:String			=	null;
	private var _paramBox:Array			=	[];//包含URL地址后参数
	private var _retryNum:Number		=	0;
	private var _isLocal:Boolean		=	false;
	
	/**是否强制更新数据,当再次更新时*/
	public  var isForceUpdate:Boolean	=	true;
	/**如果加载数据出错，重试的次数*/
	public  var retryTimes:Number		=	3;
	/**是否加载完成*/
	public  var isLoaded:Boolean		=	null;
	/**网址的domain*/
	static public var DOMAIN:String	=	"www.wangfan.com";
	/**网址的前缀*/
	static public var WEB_SITE:String	=	"";
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new SlotMachineMain(this);]
	 * @param target target a movie clip
	 * @param dateUrl 加载XML数据的地址。
	 * @param isLocal [可选]如果为真，就忽略DOMAIN的值。默认值为假
	 */
	public function LoadXML(target:MovieClip, dataUrl:String, isLocal:Boolean){
		this._target	=	target;
		this._dataUrl	=	dataUrl;
		this._isLocal	=	isLocal==null ? false : isLocal;
		
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		_dataXML	=	new XML();
		_dataXML.ignoreWhite	=	true;
		_dataXML.onLoad=Delegate.create(this, onDataLoaded);
		if(!_isLocal){
			System["security"].allowDomain(DOMAIN);
			System["security"].allowInsecureDomain(DOMAIN);
		}
		loadData();
		
	}
	
	private function loadData():Void{
		var param:String	=	null;
	
		if(_isLocal){//如果只是本地测试，侧不会加前缀与参数
			WEB_SITE	=	
			param		=	"";
		}else{//
			WEB_SITE	=	_root._url.indexOf("file:///")==0 ? ("http://"+DOMAIN) : "";
			WEB_SITE	+=	"";//程序放在此目录下。
			param		=	getParams();
		}
		//trace(WEB_SITE + _dataUrl + param);
		isLoaded		=	false;
		_dataXML.load(WEB_SITE + _dataUrl + param);
	}
	
	private function onDataLoaded(success:Boolean):Void{
		if(success){
			if(_dataXML.status==0){
				isLoaded	=	true;
				onXMLLoaded(_dataXML.firstChild);
			}else{
				trace("parse XML error: [status="+_dataXML.status+"]");
			}
		}else{//如果加载数据出错，重新加载
			retryLoad();
		}
	}
	
	private function retryLoad():Void{
		if(++_retryNum>=retryTimes){
			trace("error after try to load 3 times: ["+_dataUrl+"]");
		}else{
			loadData();
		}
	}
	
	private function getParams():String{
		var len:Number			=	_paramBox.length;
		var retStr:String		=	"";
		var isParam:Boolean	=	false;
		if(isForceUpdate){
			isParam	=	true;
			retStr	=	"?r="+random(0xffffff).toString(36);
		}else if(len>0){
			isParam	=	true;
			retStr	=	"?r=0";
		}
		
		var paramObj:Object	=	null;
		for(var i:Number=0;i<len;i++){
			paramObj	=	_paramBox[i];
			retStr	+=	"&";
			retStr	+=	escape(paramObj.name);
			retStr	+=	"=";
			retStr	+=	escape(paramObj.value);
		}
		
		return retStr;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 当XML数据加载完成，并且成功解析无错误
	* @param child
	*/
	public function onXMLLoaded(child:XMLNode):Void{
		//empty method
	}
	
	/**
	 * 更新数据，把XML数据重新加载
	 * 
	 */
	public function refresh():Void{
		isForceUpdate	=	true;
		loadData();
	}
	
	/**
	 * 添加参数进提交的地址
	 * 
	 * @param   name  
	 * @param   value 
	 * @return  如果是新添加成功，返回true，如果是修改原来的参数，返回false
	 */
	public function addParams(name:String, value:String):Boolean{
		var len:Number	=	_paramBox.length;
		var isFinded:Boolean	=	false;
		for(var i:Number=0;i<len;i++){
			if(_paramBox[i].name==name){
				_paramBox[i].value	=	value;
				isFinded	=	true;
				break;
			}
		}
		if(!isFinded){
			_paramBox.push({name:name, value:value});
		}
		return !isFinded;
	}
	
	/**
	 * 得到XML根目录下的第一个xml节点
	 * 
	 * @return  如果没有完成，返回null值
	 */
	public function getFirstChild():XMLNode{
		if(!isLoaded)	return null;
		return _dataXML.firstChild;
	}
	
	/**
	 * 得到下载的百分比值
	 * @return 百分比
	 */
	public function getPercent():Number{
		return _dataXML.getBytesLoaded()/_dataXML.getBytesTotal();
	}
	
	/**
	 * Show class name.
	 * @return class name
	 */
	public function toString():String{
		return "LoadXML 1.0\r"+_dataXML;
	}
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
