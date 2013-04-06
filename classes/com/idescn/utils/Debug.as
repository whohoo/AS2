//******************************************************************************
//	name:	Debug 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri May 19 15:02:43 2006
//	description: debug code,
//******************************************************************************

[IconFile("Debug.png")]
/*
* a method can intead of _global.trace(obj)
* <p></p>
* to use this method, you must import com.idescn.utils.Debug,<br></br>
* and Debug.tt(obj); all informations would show in Output panel(F2)
* <p>
* <b>this class only use TEST your code, recommend you delete it after complete code</b>
* </p>
* this last trace information would save Debug.outMsg.
*/
class com.idescn.utils.Debug extends Object{
	
	/**
	* the output messages.<br></br>
	* and last output message would save here.
	*/
	public static var outMsg:String	=	null;
	
	/**
	 * the only public method in this class, you could trace object with "Debug.tt(obj);"<br>
	 * @usage   
	 * @param   obj 
	 */
	public static function tt(obj):Void{
		new Debug(obj);
	}
	
	/**
	 * this Contruct function is private, so you can't new Debug() to get a instance.
	 * 
	 * @usage   
	 * @param   obj 
	 * @param   isTrace if false all resutl would not show in trace panel, or any value would show.
	 */
	private function Debug(obj){
		init(obj);
	}
	
	/**
	 * initialize this class when user Debug.tt();
	 * 
	 * @usage   
	 * @param   obj 
	 */
	private function init(obj):Void{
		outMsg	=	"";
		traceObj(obj, "", "");
		trace(toString());
	}
	
	/**
	 * parse obj 
	 * 
	 * @usage   
	 * @param   obj   
	 * @param   name  
	 * @param   space 
	 */
	private function traceObj(obj:Object, name:String, space:String):Void{
		switch(true){
			case typeof(obj)=="string" :
			case typeof(obj)=="number" :
			case typeof(obj)=="boolean" :
			case typeof(obj)=="movieclip" :
				traceOut(space+"["+typeof(obj)+"] "+name+": "+obj);
				break;
			case obj instanceof Button :
				traceOut(space+"[Button] "+name+obj);
				break;
			case obj instanceof TextField :
				traceOut(space+"[TexField] content : "+name+
													obj.text.substr(0,100));
				break;
			case obj instanceof Video :
				traceOut(space+"[Video] "+name+obj);
				break;
			case obj instanceof XML :
				traceOut(space+"[XML] "+name+obj);
				break;
			case obj instanceof Date :
				traceOut(space+"[Date] "+name+obj);
				break;
			case obj instanceof Sound :
				if(isNaN(obj.position)){
					traceOut(space+"[Sound] Empty : "+name+
											"have not attachSound or loadSound");
				}else{
					traceOut(space+"[Sound] Current position : "+
						name+obj.position/1000+"/"+obj.duration/1000+" (sec)");
				}
				break;
			case obj instanceof Color :
				traceOut(space+"[Color] "+name+" : 0x"+
								("00000"+obj.getRGB().toString(16)).substr(-6));
				break;
			case obj instanceof Array :
				traceOut(space+"[Array] Length "+name+obj.length);
				ttObject(obj, space);
				break;
			case obj instanceof Object || typeof(obj)=="object" :
				traceOut(space+"[Object] "+name+obj.toString());
				ttObject(obj, space);
				break;
			case typeof(obj)!="object" :
				if(obj===null){
					traceOut(space+name+"null");
				}else if(obj===undefined){
					traceOut(space+name+"undefined");
				}else{
					traceOut("*****unknow type***** : "+obj);
				}
			break;
			default :
				traceOut("*****unknow type***** : "+obj);
		}
		
	}
	
	/**
	 * loop obj, and get all properties and value
	 * 
	 * @usage   
	 * @param   obj   
	 * @param   space 
	 */
	private function ttObject(obj:Object, space:String):Void{
		for(var prop:String in obj){
			traceObj(obj[prop], prop, space+"   ");
		}
	}
	
	/**
	 * put output string to outMsg and add a new line
	 * 
	 * @usage   
	 * @param   str 
	 */
	private function traceOut(str:String):Void{
		outMsg	+=	str+"\r";
	}
	/**
	 * get the last output value
	 * 
	 * @return  last output string
	 */
	private function toString():String{
		return outMsg;
	}
}