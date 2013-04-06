//******************************************************************************
//	name:	Form 1.3
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Jan 20 13:14:28 2006
//	description: 表单,输入框内按回车或按tab切换,当到最后一项时,直接执行onRelease
//				一个swf中只能存在一个form,因为按键事件
//			邮件不能为以下字符 *|,\":<>[]{}`';()&$#%
//			增加身份证号生日与最后一位的验证.
//			修改了身份验证,先验出生日期,再验最后一位验证码.
//******************************************************************************

[IconFile("Form.png")]
/**
* form for input textField
* <p>
* </p>
* put all input textfield in form instance, user could press ENTER skip next <br>
* </br>
* input textfield.<br>
* </br>
* email_txt.restrict = "A-Za-z0-9\\-_.@";
* phone_txt.restrict = "0-9\\-"	;
* <pre>
* <b>eg:</b>
* Form.hintText	=	hints_txt;
* var form	=	Form.getInstance();
* form.addItem(name_txt);
* form.addItem(password_txt);
* form.build(true);
* </pre>
* 
*/
class com.idescn.data.Form extends Object{
	
	private var _item:Array		=	null;
	
	/**
	* set the hint text, when some info wanna hint.<br></br>
	* this is a textfield embed font that you wannna hint.
	*/
	public  static var hintText:TextField	=	null;
	
	private static var interFadeOut:Number	=	null;
	private static var interID:Number		=	null;
	private static var _form:Form			=	null;
	
	/**
	* contruct function.<br></br>
	* in stage, it just only one form instance, so you could not create instance
	* by this function. you must create instance by Form.getInstance();
	* 
	* @param keyCode [optional]the default is 13[ENTER]
	*/
	private function Form(){
		this._item		=	[];
	}
	
	/**
	* create only one form.<br></br>
	* this class no contruct function, you only create instance by the method.
	* @param keyCode
	* @return the only form you could create.
	*/
	public static function getInstance():Form{
		_form.destroy();//把原来的key事件去除,
		_form	=	new Form();
		return _form;
	}
	
	//******************[PRIVATE METHOD]******************//
	/**
	* 
	* when user press keyCode, skip next input textfield or release button.
	*/
	private function onKeyDown():Void{
		if(Key.getCode()==Key.ENTER){
			var curItem:Object		=	Selection.getFocus();
			var nextItem:Object	=	this.nextItem(curItem);
			
			if(nextItem instanceof TextField){
				if(nextItem.multiline==false){
					Selection.setFocus(nextItem);
				}
			}else if(nextItem instanceof Button || 
										nextItem instanceof MovieClip){
				nextItem.onRelease();
			}else if(nextItem instanceof Function){
				nextItem();
			}
			
		}
	};
	
	
	/**
	* seek next button or input textfield
	* @param  current text or button
	* @return next text or button
	*/
	private function nextItem(item:Object):Object{
		var i:Number	=	this._item.length;
		item			=	eval(item);
		while(i--){
			if(this._item[i]==item){
				return	this._item[i+1];
			};
		};
		return null;
	};
	
	/**
	* destroy this Form
	*/
	private function destroy(){
		this._item	=	null;
		Key.removeListener(this);
	}
	
	//******************[PUBLIC METHOD]******************//
	/**
	* add textfield or button or movieclip.<br></br>
	* if out of textfield or button, it would throw a error.
	* @param item textfield or button.
	* @throws Error if there is a failure in not textfield or button or movieclip of typeof item.
	*/
	public function addItem(item:Object):Void{
		//trace(typeof item)
		if(item instanceof TextField || item instanceof Button || 
												item instanceof MovieClip){
			this._item.push(item);
		}else{
			throw new Error("the item that you addItem is not "+
										"supported. [("+_item.length+".) "+
										typeof(item)+"], last item is ["+
										_item[_item.length-1]+"]");
		}
	}
	
	/**
	* build listen event, when add all item in this, you ought to build to start
	* listen the user action.
	* 
	* @param enabled if true, could skip next input textfield by press keyCode.
	*/
	public function build(enabled:Boolean):Void{
		var i:Number	=	this._item.length;
		var obj:Object	=	null;
		while(i--){
			obj	=	this._item[i];
			obj.tabIndex	=	i;
		}
		
		if(enabled){
			Key.addListener(this);
		}
		
		Selection.setFocus(obj);
	}
	
	/**
	* reset all input textfield
	*/
	public function resetTextField():Void{
		var len:Number	=	_item.length;
		var txt:Object	=	null;
		for(var i:Number=0;i<len;i++){
			txt	=	_item[i];
			if(txt instanceof TextField){
				txt.text	=	"";
			}
		}
	}
	
	
	
	/**
	* show this class name
	* @return class name
	*/
	public function toString():String{
		return "Form 1.3";
	}
	
	
	//**************[static function]*********//
	/**
	* check email,<br></br>
	* olny [restrict = "A-Za-z0-9\\-_.@"]
	* @param mailStr eamil address
	* @return true or false
	*/
	public static function checkEmail(mailStr:String):Boolean{
		var mailLen:Number	=	mailStr.length;
		if(mailLen<=5){
			return false;
		}
		
		var mailArr:Array = mailStr.split("@");
		if(mailArr.length==1){
			return false;
		}
		if(mailArr[0].length<1 || mailArr[1].length<1){
			return false;
		}
		
		var mailDotArr:Array = mailArr[1].split(".");
		if(mailDotArr.length==1){
			return false;
		}
		if(mailDotArr[0].length<1 || mailDotArr[1].length<1){
			return false;
		}
		return true;
	}
	
	/**
	* check mobile number,<br>
	* </br>
	* olny for china
	* @param mobileNum mobile number
	* @return false if invaild.
	*/
	public static function checkMobile(mobileNum:Object):Boolean{
		var mobileStr:String	=	(mobileNum).toString();
		var mobileLen:Number	=	mobileStr.length;
		var prefix:String		=	null;
		//var vaildNum:Array	=	["0130"]
		if(mobileLen==11){
			mobileStr	=	"0"+mobileStr;
			mobileLen	=	12;
		}
		
		if(mobileLen==12){
			prefix	=	mobileStr.substr(0,3);
			if (prefix != "013") {
				switch(mobileStr.substr(0,4)){
					case "0159" :
					case "0158" :
						return true;
					default :
						return	false;
				}
			}
		}else{
			return false;
		}
		return true;
	}
	
	/**
	* 
	* check date valid
	* @param dateStr format[yyyy-MM-dd hh:mm:ss]
	*/
	public static function checkDate(dateStr:String):Boolean{
		var dateStrArr:Array	=	dateStr.split(" ", 19);
		var dateStrArrLen:Number	=	dateStrArr.length;
		var timeArr:Array		=	["12", "00", "00"];//default time
		var dateArr:Array;
		switch (dateStrArrLen) {
			case 2://time
				timeArr		=	dateStrArr[1].split(":", 8);
			case 1://date
				dateArr		=	dateStrArr[0].split("-", 10);
				break;
			default:
				return false;
		}

		if (dateArr.length != 3)	return false;//达不到YYYY-MM-DD的格式
		var year:Number			=	Number(dateArr[0]);
		var month:Number		=	Number(dateArr[1])-1;
		var day:Number			=	Number(dateArr[2]);
		
		var hour:Number;
		var minute:Number;
		var second:Number	=	0;//default value
		switch (timeArr.length) {
			case 3:
				second	=	Number(timeArr[2]);
			case 2:
				hour	=	Number(timeArr[0]);
				minute	=	Number(timeArr[1]);
				break;
			default://达不到HH-MM格式,最后的SS可以省略.
				return false;
		}
		
		var dateTime:Date	=	new Date(year, month, day, hour, minute, second, 0);
		
		if(year!=dateTime.getFullYear()){
			return false;
		}else if(month!=dateTime.getMonth()){
			return false;
		}else if(day!=dateTime.getDate()){
			return false;
		};
		
		if(hour!=dateTime.getHours()){
			return false;
		}else if(minute!=dateTime.getMinutes()){
			return false;
		}else if(second!=dateTime.getSeconds()){
			return false;
		}
		return true;
	}
	
	/**
	* check id number valid
	* @param id a string of id number.
	* @return true if it is valid.
	*/
	public static function checkID(id:String):Boolean{
		var idStr:String	=	null;
		var idLen:Number	=	id.length;
		if(idLen==15){
			idStr	=	id.substr(0, 6)+"19"+id.substr(6);
		}else if(idLen==18){
			idStr	=	id.substr(0,17);
		}else{
			return false;
		}
		
		//////检查出生日期的正确性
		var dateStr:String	=	idStr.substr(6, 4)+"-"+idStr.substr(10, 2)+"-"+
															idStr.substr(12, 2);
		if (!checkDate(dateStr)) {
			return false;
		}else if (idLen == 15) {//如果是15位长度的旧版ID号,
			return true;
		}//18位的继续检查最后一位验证码是否正确.
		
		//检查最后一位数字,如果是18位的身分证号
		var arr:Array	=	idStr.split("");
		var WI:Array	=	[7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
		var VERIFYCODE:String	=	"10X98765432";
		var s:Number	=	0;
		for(var i:Number=0;i<17;i++){
			s	+=	Number(arr[i])*WI[i];
		}
		var y:Number	=	s%11;
		var lastDigit:String	=	VERIFYCODE.charAt(s%11);
		
		return id.substr(17, 1) == lastDigit;
	}
	
	/**
	* 
	* hints, you must embed font in that textfield or you would not see the words,<br>
	* </br>
	* because the textfield display by fade in.
	* 
	* @param text show text
	* @param second invisble after second
	* @param txt point out another textfiled to show words, the default one is defalut
	*    by Form.hintText.
	*/
	public static function showHint(text:String,second:Number,
														txt:TextField):Void{
		//不管如何,先停掉原来的loop
		clearInterval(interFadeOut);
		clearInterval(interID);
		
		if(txt instanceof TextField){
			hintText	=	txt;
		}else if(hintText!=null){
			txt			=	hintText;
		}else{
			return;
		}
		second	=	second==null ? 4 : second;
		txt.text	=	text;
		txt._alpha	=	100;

		interID=setInterval(function(){//只执行一次
					interFadeOut=setInterval(function(){
							txt._alpha	-=	5;
							if(txt._alpha<=0 || !txt instanceof TextField){
								clearInterval(interFadeOut);
								txt.text	=	"";
							}
						},30);
					clearInterval(interID);
				}, second*1000);
	}
	
	
}