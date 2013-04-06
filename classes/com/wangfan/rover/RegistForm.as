//******************************************************************************
//	name:	RegistForm 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Sep 18 10:17:42 GMT+0800 2006
//	description: This file was created by "photo.fla" file.
//		
//******************************************************************************


import mx.utils.Delegate;
import com.wangfan.data.Form;
import com.wangfan.rover.GlobalProperty;
/**
 * 用户注册的类.<p></p>
 * 有各个字段的判断
 */
class com.wangfan.rover.RegistForm extends MovieClip{
	//NOTE: set Debug class in classpath first.
	//public static var tt:Function = com.idescn.utils.Debug.tt;
	private var _dateTXT:TextField				=	null;
	private var _realNameTXT:TextField			=	null;
	private var _emailPrefixTXT:TextField		=	null;
	private var _emailSuffixTXT:TextField		=	null;
	private var _emailPrefix2TXT:TextField		=	null;
	private var _emailSuffix2TXT:TextField		=	null;
	private var _passwordTXT:TextField		=	null;
	private var _password2TXT:TextField	=	null;
	private var _idCardTXT:TextField		=	null;
	private var _mobileTXT:TextField		=	null;
	private var _addressTXT:TextField		=	null;
	private var _zipCodeTXT:TextField		=	null;

	private var _submitBTN:Button			=	null;
	private var _resetBTN:Button			=	null;
	private var _hintsMC:MovieClip			=	null;
	
	private var _form:Form					=	null;
	/**提交地址的前缀*/
	//static public var SITE_HOST:String	=	"http://61.152.93.107/process/";//http://wangfan-newrex:1011
	
	private var _returnLV:LoadVars		=	null;
	
	private var curGender:MovieClip	=	null;
	private var curAge:MovieClip		=	null;
	private var curCareer:MovieClip	=	null;
	private var curIncome:MovieClip	=	null;
	private var curHowKnow:MovieClip	=	null;
	private var curFavor:MovieClip		=	null;
	
	private var genderArr:Array		=	["m", "f"];
	private var ageArr:Array		=	["<18岁", "18-25岁", "26-35岁", "36-45岁",
												"45岁以上"];
	private var careerArr:Array		=	["服务行业", "工程师", "制造业", "计算机业",
				"兼职", "教育", "培训", "金融业", "销售/广告/市场", "学生", 
				"医疗行业", "政府部门", "失业中", "其他"];
	private var incomeArr:Array		=	["2000元以下", "2000-4999元", "5000-7999元",
				"8000-9999元", "10000-15000元", "15000元以上"];
	private var howKnowArr:Array	=	["网络广告", "电视广告", "朋友推荐", "其他"];
	private var favorArr:Array		=	["时尚", "促销信息", "汽车", "旅游", "体育",
				"休闲与娱乐", "游戏", "音乐", "互联网", "教育", "金融与投资", 
				"经营与管理", "房地产", "家庭", "卫生与健康"];
	
	
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * Create a class BY [new DataForm(this);]
	 * @param target target a movie clip
	 */
	public function RegistForm(){
		_dateTXT			=	this["date_txt"];
		_realNameTXT		=	this["realName_txt"];
		_emailPrefixTXT		=	this["emailPrefix_txt"];
		_emailSuffixTXT		=	this["emailSuffix_txt"];
		_emailPrefix2TXT	=	this["emailPrefix2_txt"];
		_emailSuffix2TXT	=	this["emailSuffix2_txt"];
		_passwordTXT		=	this["password_txt"];
		_password2TXT		=	this["password2_txt"];
		_idCardTXT			=	this["idCard_txt"];
		_addressTXT			=	this["address_txt"];
		_mobileTXT			=	this["mobile_txt"];
		_zipCodeTXT			=	this["zipCode_txt"];
		_submitBTN			=	this["submit_btn"];
		_resetBTN			=	this["reset_btn"];
		_hintsMC			=	this._parent["hints_mc"];
		init();
		//_root.personInfo	=	{};
	}
	
	//************************[PRIVATE METHOD]********************************//
	private function init():Void{
		var now:Date	=	new Date();
		var fmt:TextFormat		=	_dateTXT.getTextFormat();
		_dateTXT.setNewTextFormat(fmt);
		_dateTXT.text	=	now.getFullYear()+" "+//年
						("0"+(now.getMonth()+1)).substr( -2)+" "+//月
						("0"+now.getDate()).substr( -2);//日
		
		initGender();
		initAge();
		initCareer();
		initIncome();
		initHowKnow();
		initFavor();
		initAgreen();
		initTextField();
		
		_submitBTN.onRelease=Delegate.create(this, onSubmitRelease);
		_resetBTN.onRelease=Delegate.create(this, onResetRelease);
		_addressTXT.restrict		=	
		_realNameTXT.restrict		=	"^'";
		_emailPrefixTXT.restrict	=
		_emailPrefix2TXT.restrict	=	
		_emailSuffixTXT.restrict	=
		_emailSuffix2TXT.restrict	=	"A-Za-z0-9\\-_.^'";
		_idCardTXT.restrict			=	"0-9X";
		_mobileTXT.restrict			=	"0-9";
		_zipCodeTXT.restrict		=	"0-9";
		
		_submitBTN.enabled			=	false;
		//判断手机号码,如果是以零开头的,则长度为12位,否则是12位.
		_mobileTXT.onChanged=Delegate.create(this, onMobileChanged);
		//TODO  debug only.
		test();
		this._x	+=	500;this._y	+=	350;
	}
	
	private function onMobileChanged():Void{
		if(_mobileTXT.text.substr(0, 1)=="0"){
			_mobileTXT.maxChars	=	12;
		}else{
			_mobileTXT.maxChars	=	11;
		}
	}
	
	private function initGender():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<2;i++){
			mc	=	this["gender"+i];
			mc.onRelease=Delegate.create(mc, onGenderRelease);
			mc.index	=	i;
		}
	}
	private function initAge():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<5;i++){
			mc	=	this["age"+i];
			mc.onRelease=Delegate.create(mc, onAgeRelease);
			mc.index	=	i;
		}
	}
	private function initCareer():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<14;i++){
			mc	=	this["career"+i];
			mc.onRelease=Delegate.create(mc, onCareerRelease);
			mc.index	=	i;
		}
	}
	private function initIncome():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<6;i++){
			mc	=	this["income"+i];
			mc.onRelease=Delegate.create(mc, onIncomeRelease);
			mc.index	=	i;
		}
	}
	private function initHowKnow():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<15;i++){
			mc	=	this["howKnow"+i];
			mc.onRelease=Delegate.create(mc, onHowKnowRelease);
			mc.index	=	i;
		}
	}
	private function initFavor():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<15;i++){
			mc	=	this["favor"+i];
			mc.onRelease=Delegate.create(mc, onFavorRelease);
		}
	}
	private function initAgreen():Void{
		var mc:MovieClip	=	null;
		for(var i:Number=0;i<1;i++){
			mc	=	this["agreen"+i];
			mc.onRelease=Delegate.create(mc, onAgreenRelease);
		}
		
	}
	
	private function onGenderRelease():Void{
		if(this._parent.curGender==this)	return;
		this._parent.curGender.gotoAndStop(1);
		this.gotoAndStop(2);
		this._parent.curGender	=	this;
	}
	private function onAgeRelease():Void{
		if(this._parent.curAge==this)	return;
		this._parent.curAge.gotoAndStop(1);
		this.gotoAndStop(2);
		this._parent.curAge	=	this;
	}
	private function onCareerRelease():Void{
		if(this._parent.curCareer==this)	return;
		this._parent.curCareer.gotoAndStop(1);
		this.gotoAndStop(2);
		this._parent.curCareer	=	this;
	}
	private function onIncomeRelease():Void{
		if(this._parent.curIncome==this)	return;
		this._parent.curIncome.gotoAndStop(1);
		this.gotoAndStop(2);
		this._parent.curIncome	=	this;
	}
	private function onHowKnowRelease():Void{
		if(this._parent.curHowKnow==this)	return;
		this._parent.curHowKnow.gotoAndStop(1);
		this.gotoAndStop(2);
		this._parent.curHowKnow	=	this;
	}
	////////多选
	private function onFavorRelease():Void{
		this.gotoAndStop(this._currentframe%2+1);
	}
	
	private function onAgreenRelease():Void{
		//var curFrame:Number	=	this._currentframe;
		if(this._currentframe==1){
			this._parent._submitBTN.enabled	=	true;
			this.gotoAndStop(2);
		}else{
			this._parent._submitBTN.enabled	=	false;
			this.gotoAndStop(1);
		}
		
	}
	
	private function initTextField():Void{
		var fmt:TextFormat		=	_idCardTXT.getTextFormat();
		_idCardTXT.setNewTextFormat(fmt);
		_idCardTXT.text			=	"";
		fmt						=	_mobileTXT.getTextFormat();
		_mobileTXT.setNewTextFormat(fmt);
		_mobileTXT.text			=	"";
		fmt						=	_zipCodeTXT.getTextFormat();
		_zipCodeTXT.setNewTextFormat(fmt);
		_zipCodeTXT.text		=	"";
		
		_form	=	Form.getInstance(Key.ENTER);
		_form.addItem(_realNameTXT);
		_form.addItem(_emailPrefixTXT);
		_form.addItem(_emailSuffixTXT);
		_form.addItem(_emailPrefix2TXT);
		_form.addItem(_emailSuffix2TXT);
		_form.addItem(_passwordTXT);
		_form.addItem(_password2TXT);
		_form.addItem(_realNameTXT);
		_form.addItem(_idCardTXT);
		_form.addItem(_addressTXT);
		_form.addItem(_mobileTXT);
		_form.addItem(_zipCodeTXT);
		_form.addItem(_submitBTN);
		_form.build(true);
		
	}
	
	
	private function onSubmitRelease():Void{
		if(_realNameTXT.length<2){
			_hintsMC.showMsg("真实姓名必须两字以上");
			Selection.setFocus(_realNameTXT);
			return;
		}else if(curGender==null){
			_hintsMC.showMsg("请选择性别");
			return;
		}else if(curAge==null){
			_hintsMC.showMsg("请选择年龄");
			return;
		}else if(_emailPrefixTXT.length<1){
			_hintsMC.showMsg("邮件地址不正确");
			Selection.setFocus(_emailPrefixTXT);
			return;
		}else if(_emailSuffixTXT.length<4){
			_hintsMC.showMsg("邮件地址不正确");
			Selection.setFocus(_emailSuffixTXT);
			return;
		}else if(_emailPrefixTXT.text!=_emailPrefix2TXT.text){
			_hintsMC.showMsg("邮件地址不正确");
			Selection.setFocus(_emailPrefix2TXT);
			return;
		}else if(_emailSuffixTXT.text!=_emailSuffix2TXT.text){
			_hintsMC.showMsg("邮件地址不正确");
			Selection.setFocus(_emailSuffix2TXT);
			return;
		}else if(_passwordTXT.length<6){
			_hintsMC.showMsg("密码长度必须六位以上");
			Selection.setFocus(_passwordTXT);
			return;
		}else if(_passwordTXT.text!=_password2TXT.text){
			_hintsMC.showMsg("密码前后不一致");
			Selection.setFocus(_password2TXT);
			return;
		}else if(false){//!Form.checkID(_idCardTXT.text)
			_hintsMC.showMsg("身分证号不正确");
			Selection.setFocus(_idCardTXT);
		}else if(_mobileTXT.length<11){//因为包含小灵通号码,所以不能以13开头来
			_hintsMC.showMsg("手机号码不正确");//判断是否为手机号码
			Selection.setFocus(_mobileTXT);
			return;
		}else if(_addressTXT.length<1){
			_hintsMC.showMsg("联系地址不能为空");
			Selection.setFocus(_zipCodeTXT);
			return;
		}else if(_zipCodeTXT.length!=6){
			_hintsMC.showMsg("邮政区号位数不正确");
			Selection.setFocus(_zipCodeTXT);
			return;
		}else if(curCareer==null){
			_hintsMC.showMsg("请选择您的职业");
			return;
		}else if(curIncome==null){
			_hintsMC.showMsg("请选择您的收入");
			return;
		}else if(curHowKnow==null){
			_hintsMC.showMsg("请选择您的了解途径");
			return;
		}
		var lv:LoadVars	=	_form.getLoadVars();
		lv.email	=	lv.emailPrefix+"@"+lv.emailSuffix;
		lv.realname	=	lv.realName;
		lv.zipcode	=	lv.zipCode;
		lv.mobilephone	=	lv.mobile;
		lv.idnum	=	lv.idCard;
		lv.gender	=	genderArr[this["curGender"].index];
		lv.age		=	ageArr[this["curAge"].index];
		lv.career	=	careerArr[this["curCareer"].index];
		lv.income	=	incomeArr[this["curIncome"].index];
		lv.province	=	"none";
		lv.howtoknow	=	howKnowArr[this["curHowKnow"].index];
		var mc:MovieClip	=	null;
		var favorStr:String	=	"";
		for(var i:Number=0;i<15;i++){
			mc	=	this["favor"+i];
			if(mc._currentframe==2){
				favorStr	+=	favorArr[i]+",";
			}
		}
		lv.interest				=	favorStr.substr(0, -1);
		
		lv.checkCode			=	_root.checkCode;
		lv.introducer_mobile	=	_root.introducer_mobile;
		
		delete lv.emailPrefix;
		delete lv.emailSuffix;
		delete lv.realName;
		delete lv.zipCode;
		delete lv.mobile;
		delete lv.idCard;
		//listLV(lv);
		_returnLV	=	lv;
		
		lv.sendAndLoad(GlobalProperty.SITE_HOST+"regUserInfo.aspx", lv, "POST");
		//trace("GlobalProperty.SITE_HOST: "+GlobalProperty.SITE_HOST)
		lv.onLoad=Delegate.create(this, onReturnLoad);
		//lv.onData=Delegate.create(this, onReturnData);
		_submitBTN.enabled	=	false;
		_hintsMC.showMsg("信息提交中...");
	}
	
	private function onReturnLoad(success:Boolean):Void{
		_submitBTN.enabled	=	true;
		//trace(_returnLV)
		if(success){
			switch(_returnLV.returnValue){
				case "0":
					_hintsMC.showMsg("注册失败");
					break;
				case "1"://TODO 注册成功
					_root.personInfo.idCard		=	_returnLV.idnum;
					_root.personInfo.mobile		=	_returnLV.mobilephone;
					_root.personInfo.realName	=	_returnLV.realname;
					_root.personInfo.province	=	_returnLV.province;
					_root.personInfo.address	=	_returnLV.address;
					_root.personInfo.lockTime	=	0;
					_root.personInfo.gameLevel	=	0;
					_root.personInfo.coin		=	Number(_returnLV.money);
					//add by V2, 老虎机得奖的统计，及用户登录时，服务器的时间。
					_root.personInfo.award	=	[changeAward(_returnLV.award),//曾经得过的奖品，此内容不再使用。
											_returnLV.award1count,//老虎机第一个奖项
											_returnLV.award2count,//老虎机第二个奖项
											_returnLV.award3count,//老虎机第三个奖项
											_returnLV.award4count//老虎机第四个奖项
												];
					
					var nowStr:Array	=	_returnLV.lastlogin.split(" ");//2006-11-13 15:00:09
					var nowDate:Array	=	nowStr[0].split("-");
					var nowTime:Array	=	nowStr[1].split(":");
					_root.personInfo.sevTime	=	new Date(nowDate[0], nowDate[1]-1, nowDate[2],
														nowTime[0], nowTime[1], nowTime[2]);
					//TODO debug
					//_root.personInfo.sevTime	=	new Date();//DEBUG ONLY!
					//trace([_root.personInfo.sevTime, _root.personInfo.award])
					com.wangfan.rover.CountTimer.runningServerTime();
					_parent._parent.gotoAndPlay("a1");//消失
					break;
				case "101":
					_hintsMC.showMsg("手机号码重复");
					break;
				case "102":
					_hintsMC.showMsg("电子邮件重复");
					break;
				case "103":
					_hintsMC.showMsg("身份证号码重复");
					break;
				default:
					_hintsMC.showMsg("网络出错,稍后再试");
			}
		}else{
			_hintsMC.showMsg("网络出错,稍后再试");
		}
	}
	
	private function onReturnData(d:String):Void{
		trace(d);
	}
	
	private function onResetRelease():Void{
		_form.resetTextField();
	}
	
	private function changeAward(award:String):Array{
		var retArr:Array	=	[];
		var awardArr:Array	=	award.split(",");
		var len:Number		=	awardArr.length;
		var awardID:Number	=	null;
		for(var i:Number=0;i<len;i++){
			awardID	=	Number(awardArr[i]);
			if(retArr[awardID]==undefined){
				retArr[awardID]	=	1;
			}else{
				retArr[awardID]++;
			}
		}
		return retArr;
	}
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * 正式发布时不应存在这个方法,主要是方便测试
	 */
	public function test():Void{
		//trace(_emailPrefixTXT)
		_realNameTXT.text		=	"真名"+random(0xffffff).toString(36);
		_emailPrefixTXT.text	=	"test"+random(0xffffff).toString(36);
		_emailSuffixTXT.text	=	"test.com";
		_emailPrefix2TXT.text	=	_emailPrefixTXT.text;
		_emailSuffix2TXT.text	=	"test.com";
		_passwordTXT.text		=	"123456";
		_password2TXT.text		=	"123456";
		_idCardTXT.text			=	"4501031978"+random(1000);
		_addressTXT.text		=	"池塘边";
		_mobileTXT.text			=	"13761031"+random(999);
		_zipCodeTXT.text		=	"200001";
		this["gender"+random(2)].onRelease();
		this["age"+random(5)].onRelease();
		this["career"+random(14)].onRelease();
		this["income"+random(6)].onRelease();
		this["howKnow"+random(4)].onRelease();
		this["favor"+random(15)].onRelease();
		this["agreen"+random(1)].onRelease();
	}
	/**
	 * 正式发布时不应存在这个方法,主要是方便测试
	 */
	public function listLV(lv:LoadVars):Void{
		var i:Number	=	0;
		for(var prop:String in lv){
			trace(i+". "+prop+" = "+lv[prop]);
			i++;
		}
	}
	
	
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.
