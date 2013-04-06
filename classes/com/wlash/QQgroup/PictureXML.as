//************************************************
//	name:	PictureXML 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sun Jan 15 23:15:17 2006
//	description: 管理着xml数据
//************************************************

import mx.xpath.XPathAPI;
import com.wlash.QQgroup.NavButton;

class com.wlash.QQgroup.PictureXML{
	/**
	* 指向影片本身
	*/
	private var picture:Object		=	null;
	private var curGroupNum:Number	=	-1;
	private var amountNum:Number	=	null;//有多少个分组
	
	/**
	* 所有的xml数据
	*/
	public var data:Object		=	{};
	public var dataName:Array	=	[];
	/**
	* 构造函数
	* @param urlPath
	* @param picture
	*/
	public function PictureXML(urlPath:String,picture:Object){
		this.picture		=	picture;
		var pic_xml:XML		=	new XML();
		pic_xml.ignoreWhite	=	true;
		pic_xml.load(urlPath);
		var _this:Object	=	this;
		pic_xml.onLoad=function(s:Boolean):Void{
			if(s && this.status=="0"){
				_this.groupXML(this.firstChild);
				picture.navButton	=	new NavButton(picture);
			}
		}
	}
	
	/**
	* 把xml数据分组
	* @param xmlNode
	*/
	private function groupXML(xmlNode:XMLNode):Void{
		var len:Number	=	groupName(xmlNode);
		var xPath_str:String	=	null;
		for(var i:Number=0;i<len;i++){
			xPath_str	=	"/files/item[@dir='"+dataName[i]+"']";
			data[dataName[i]]	=	XPathAPI.selectNodeList(xmlNode, xPath_str);
			
		}
		
		//picture.navButton.setVisible(true);
		amountNum	=	len;
		nextGroup();
	}
	
	/**
	* 下一组的数据
	*/
	public function nextGroup():Void{
		var num:Number	=	null;
		curGroupNum	=	(curGroupNum+1)%amountNum;
		picture.setCurData(data[dataName[curGroupNum]],true);//显示此组的第一页
		
		///导航条
		/*var navBtn:Object	=	picture.navButton;
		num	=	Math.abs(amountNum + curGroupNum-1)%amountNum;
		var text:String	=	dataName[num];
		navBtn.setText(navBtn.bLeft, text);//显示上一组的名称
		
		if(picture.amountPage>1){
			text	=	"下一页 [1/"+picture.amountPage+"]";
		}else{//如果只有一页,则显示下一组的名称
			num	=	Math.abs(curGroupNum+1)%amountNum;
			text	=	dataName[num];
		}
		navBtn.setText(navBtn.bRight, text);
		*/
		//trace("next curGroupNum : "+curGroupNum);
	}
	
	/**
	* 上一组的数据
	*/
	public function prevGroup():Void{
		var num:Number	=	null;
		
		curGroupNum	=	Math.abs(amountNum + curGroupNum-1)%amountNum;
		picture.setCurData(data[dataName[curGroupNum]],false);//显示此组最后一页
		
		///导航条
		/*var navBtn:Object	=	picture.navButton;
		num	=	(curGroupNum+1)%amountNum;
		var text:String	=	dataName[num];
		navBtn.setText(navBtn.bRight, text);//显示下一组的名称
		
		if(picture.amountPage>1){
			text	=	"上一页 ["+picture.curPage+"/"+picture.amountPage+"]";
		}else{
			num	=	Math.abs(amountNum + curGroupNum-1)%amountNum;
			text	=	dataName[num];
		}
		navBtn.setText(navBtn.bLeft, text);*/
		//trace("prev curGroupNum : "+curGroupNum);
	}
	
	/**
	* 下一组的名称
	* @return 名称
	*/
	public function nextGroupName():String{
		return dataName[(curGroupNum+1)%amountNum];
	}
	/**
	* 上一组的名称
	* @return 名称
	*/
	public function prevGroupName():String{
		return dataName[Math.abs(amountNum + curGroupNum-1)%amountNum];
	}
	
	
	/**
	* 所有的分类名称
	* @param xmlNode
	* @return length
	*/
	private function groupName(xmlNode:XMLNode):Number{
		var child:XMLNode	=	xmlNode.firstChild;
		var name:String	=	null;
		var lastName:String	=	null;
		var seekOkay:Boolean	=	false;
		while(child!=null){
			name	=	child.attributes.dir;
			if(name==lastName){
				child	=	child.nextSibling;
				continue;
			}else{//如果不匹配上一次的名称,则从数组里找,如果找不到,就是新的.
				seekOkay	=	false;
				for(var i:Number=0;i<dataName.length;i++){
					if(name==dataName[i]){//如果此名已经在数组里,跳过
						seekOkay	=	true;
						break;
					}
				}
				if(!seekOkay){
					dataName.push(name);
				}
			}
			lastName	=	name;
			child	=	child.nextSibling;
		}
		return dataName.length;
	}
	
	/**
	* 显示名称
	* @return name
	*/
	public function toString():String{
		return "pictrueXML 1.0";
	}
}