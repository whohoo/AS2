//******************************************************************************
//	name:	export MoveMap 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Mar 27 15:27:08 2007
//	description: 把类输出到组件,方便flash调用.
//		
//******************************************************************************

import com.wangfan.rover.MoveMap;

class com.wlash.classes.ExportMoveMap extends MovieClip{
	public var mm:MoveMap	=	null;
	public var dd:Number	=	21;
	
	private function ExportMoveMap(){
		mm	=	new MoveMap(this);
	}
	
	public function addNum(num:Number):Number{
		trace(dd+num);
		return dd+num;
	}
}