/////////////////////////////////////////////
//	name:	collect client info
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 07 11:28:43 2005
//	description:	post info of flash platform.
////////////////////////////////////////////

class com.wlash.utils.AddFlashPlatformInfo{
	private var target:MovieClip	=	null;
	private	var name:String		=	null;
	private	var host:String		=	"";//default path
	private var otherInfo:String	=	"";
	
	function AddFlashPlatformInfo(target:MovieClip,name:String,host:String,
					otherInfo:String){
		
		this.target	=	target==null? _root : target;
		
		if(name==null){
			throw new Error("undefined NAME");
		}else{
			this.name	=	name;
		}
		if(host!=null){
			this.host	=	host;
		}
		if(otherInfo!=null){
			this.otherInfo	=	otherInfo;
		}
		init();
	}
	
	private function init():Void{
		var __lv:LoadVars		=	new LoadVars();
		//name属性必指定唯一的名字,最好用项目名称来定,
		__lv.name	=	name;
		//other为可选的附加信息
		__lv.other	=	otherInfo;
		__lv.URL	=	escape(target._url);
		
		__lv.sendAndLoad(host+ "website/AddFlashPlatformInfo?"+
						System.capabilities["serverString"], __lv, "post");
		
		__lv.onData=function(d){
			trace(d)
		}
	}
}
