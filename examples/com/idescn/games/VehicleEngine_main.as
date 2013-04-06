//******************************************************************************
//	name:	VehicleEngine
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Jun 05 18:02:26 GMT+0800 2006
//	description: 
//******************************************************************************



//create by JSFL | author whohoo@21cn.com
//#include "\\server\code\flash\debug.as"
import com.idescn.games.VehicleEngine;

var testClass:VehicleEngine	=	new VehicleEngine(vehicle_mc);
testClass.addEventListener("onMove", onMove);

function onMove(eventObj:Object):Void{
	var vehicle:MovieClip	=	eventObj.target.vehicle;
	var mcBox	=	null;
	for(var i=0;i<5;i++){
		mcBox	=	box_mc["box"+i+"_mc"];
	
		if(vehicle.hitTest(mcBox)){
			trace("hit");
		}
	}
}
//testClass.active	=	true;
//end//
