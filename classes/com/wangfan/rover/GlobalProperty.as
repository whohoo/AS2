//******************************************************************************
//	name:	GlobalProperty 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Dec 25 11:44:37 2006
//	description: 
//		
//******************************************************************************




/**
 * rover网站全局定义的属性.<p></p>
 * 这包括所有数据指向地址
 */
class com.wangfan.rover.GlobalProperty extends Object{
	/**提交的全局地址*/
	public static var SITE_HOST:String				=	"";
	/**此对象的唯一实例名称,保证只执行一次*/
	public static var singlone:GlobalProperty		=	new GlobalProperty();
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	/**
	* 定义全局属性
	*/
	private function GlobalProperty(){
		//只执行一次
		init();
	}
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		/////////网络数据提交地址
		var domain:String	=	"61.152.93.107";//61.152.93.107 | 109
		//domain	=	"rover.wangfan.com"
		if(_root._url.indexOf("file:///")==0){
			SITE_HOST	=	"http://"+domain+"/process/";
		}else{
			SITE_HOST	=	"/process/";
		}
		//////////////数据存储
		_root.personInfo	=	{idCard:null,//身分证号
							mobile:null,//手机号码
							realName:null,//真实姓名
							province:null,//省份
							address:null,//地址
							roleNum:null,//角色数值0罗福,1福尔摩斯,2憨豆
							gameLevel:null, //当前游戏进度
							award:null,//用户曾经得到的奖品.
							coin:null	//钱币数量
							};
	}
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	* 返回此对象的参数
	*@return 
	*/
	public function toString():String{
		return "GlobalProperty 1.0";
	}
	
	
	//***********************[STATIC METHOD]**********************************//
	/**
	* 得到唯一实例名。
	*/
	public static function getInstance():GlobalProperty{
		if(singlone==null){
			singlone	=	new GlobalProperty();
		}
		return singlone;
	}
}//end class
//This template is created by whohoo.
