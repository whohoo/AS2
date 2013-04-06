//******************************************************************************
//	name:	ColorPanel 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu Sep 13 23:48:55 GMT+0800 2007
//	description: This file was created by "paint.fla" file.
//		
//******************************************************************************


import com.wlash.kfc.ToolLeft;
import com.wlash.kfc.ModifyMC;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.kfc.PaintAction extends Object{
	private var _action:Array;
	private var _undoAction:Array;
	private var _toolLeft;
	
	private var HIDEN_DEPTH:Number	=	8000;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 * drop this MovieClip to stage form Library.
	 */
	public function PaintAction(toolLeft){
		_toolLeft	=	toolLeft;
		init();
	
	}
	private function init():Void{
		clearAll();
	}
	//************************[PRIVATE METHOD]********************************//
	
	//***********************[PUBLIC METHOD]**********************************//
	/**
	 * add action
	 * 
	 * @param   obj {mc, act}
	 */
	public function addAction(obj:Object):Void{
		_action.push(obj);
		var len:Number	=	_undoAction.length;
		var obj2:Object;//对于要redo动作里的操作.
		for(var i:Number=0;i<len;i++){
			obj2	=	_undoAction[i];
			switch(obj2.act){
				case "add":

					//break;
				case "del":
				
					_toolLeft.removeMC(obj2.mc);//true delete
					break;
				case "modify":
					
					break;
				default:
					trace("ERROR: addAction: obj2= "+obj2+", obj2.act: "+obj2.act);
			}
		}
		_undoAction	=	[];
		//trace(" addAction|_action.length: "+_action.length)
	}
	
	public function undo():Number{
		//trace("undo|_action.length: "+_action.length)
		if(_action.length<=0)	return -1;
		var obj:Object	=	_action.pop();
		var mc:MovieClip	=	obj.mc;
		var len:Number;
		

		switch(obj.act){
			case "add":

				mc._visible	=	false;
				break;
			case "del":
				mc._visible	=	true;
				break;
			case "modify":
				switch(mc.type){
					case "pencil":
					case "pen":
					case "line":
					case "brush":
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "lineColor":
									mc.color.setRGB(obj.changeProp[prop].oldValue);
									break;
								case "lineAlpha":
									mc._alpha	=	obj.changeProp[prop].oldValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].oldValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					case "rent":
					case "oval":
						var propretyObj:Object	=	mc.propretyObj;
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "lineColor":
								case "shapeColor":
								case "lineAlpha":
								case "shapeAlpha":
								case "thickness":
									propretyObj[prop]	=	obj.changeProp[prop].oldValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						_toolLeft["draw_"+mc.type+"ByObj"](mc, propretyObj);
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "lineColor":
								case "shapeColor":
								case "lineAlpha":
								case "shapeAlpha":
								case "thickness":
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].oldValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					case "word":
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "shapeColor":
									var fmt:TextFormat	=	mc.txt.getTextFormat();
									fmt.color	=	obj.changeProp[prop].oldValue;
									mc.txt.setTextFormat(fmt);
									break;
								case "shapeAlpha":
									mc._alpha	=	obj.changeProp[prop].oldValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].oldValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					case "element"://bugs: 如果用户更改了颜色，必影响整个对像
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "shapeColor":
									var fmt:TextFormat	=	mc.txt.getTextFormat();
									fmt.color	=	obj.changeProp[prop].oldValue;
									mc.txt.setTextFormat(fmt);
									break;
								case "shapeAlpha":
									mc._alpha	=	obj.changeProp[prop].oldValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].oldValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					default:
						trace("ERROR: what type of "+mc+" | "+mc.type);
				}
				
				break;
			default:
				trace("ERROR: undo: obj= "+obj+", obj.act: "+obj.act);
		}
		_undoAction.push(obj);
		return _action.length;
	}
	
	public function redo():Number{
		if(_undoAction.length<=0)	return -1;
		var obj:Object	=	_undoAction.pop();
		var mc:MovieClip	=	obj.mc;
		var len:Number;
		switch(obj.act){
			case "add":

				obj.mc._visible	=	true;
				break;
			case "del":
				obj.mc._visible	=	false;
				break;
			case "modify":
				switch(mc.type){
					case "pencil":
					case "pen":
					case "line":
					case "brush":
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "lineColor":
									mc.color.setRGB(obj.changeProp[prop].newValue);
									break;
								case "lineAlpha":
									mc._alpha	=	obj.changeProp[prop].newValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].newValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					case "rent":
					case "oval":
						var propretyObj:Object	=	mc.propretyObj;
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "lineColor":
								case "shapeColor":
								case "lineAlpha":
								case "shapeAlpha":
								case "thickness":
									propretyObj[prop]	=	obj.changeProp[prop].newValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						_toolLeft["draw_"+mc.type+"ByObj"](mc, propretyObj);
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "lineColor":
								case "shapeColor":
								case "lineAlpha":
								case "shapeAlpha":
								case "thickness":
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].newValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					case "word":
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "shapeColor":
									var fmt:TextFormat	=	mc.txt.getTextFormat();
									fmt.color	=	obj.changeProp[prop].newValue;
									mc.txt.setTextFormat(fmt);
									break;
								case "shapeAlpha":
									mc._alpha	=	obj.changeProp[prop].newValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].newValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					case "element"://bugs: 如果用户更改了颜色，必影响整个对像
						for(var prop:String in obj.changeProp){
							switch(prop){
								case "shapeColor":
									var fmt:TextFormat	=	mc.txt.getTextFormat();
									fmt.color	=	obj.changeProp[prop].newValue;
									mc.txt.setTextFormat(fmt);
									break;
								case "shapeAlpha":
									mc._alpha	=	obj.changeProp[prop].newValue;
									break;
								case "_x2":
								case "_y2":
								case "_xscale2":
								case "_yscale2":
								case "_rotation2":
									mc[prop]	=	obj.changeProp[prop].newValue;
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
						}
						break;
					default:
						trace("ERROR: what type of "+mc+" | "+mc.type);
				}
				break;
			default:
				trace("ERROR: redo: obj= "+obj+", obj.act: "+obj.act);
		}
		_action.push(obj);
		return _undoAction.length;
	}
	
	public function getUndoStep():Number{
		return _action.length;
	}
	
	public function clearAll():Void{
		_action		=	[];
		_undoAction	=	[];
	}
	//***********************[STATIC METHOD]**********************************//

	
}//end class
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*
for(var prop:String in obj.prop){
					switch(mc.type){
						case "pencil":
						case "pen":
						case "line":
						case "brush":
							switch(prop){
								case "lineColor":
									
									break;
								case "lineAlpha":
									
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
							break;
						case "rent":
						case "oval":
							switch(prop){
								case "lineColor":
								case "lineAlpha":
									
									break;
								default:
									trace("error PROP: mc= "+mc+"type= "+mc.type+
												"prop= "+prop);
							}
							break;
						case "word":
							
							break;
						case "element"://bugs: 如果用户更改了颜色，必影响整个对像
							
							break;
						default:
							trace("ERROR: what type of "+editMC+" | "+editMC.type);
					}
				}
*/
