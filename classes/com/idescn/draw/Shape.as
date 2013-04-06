//******************************************************************************
//	class:	Shape 1.0
// 	author:	whohoo
// 	email:	whohoo@21cn.com
// 	date:	Thu May 25 14:49:22 2006
//******************************************************************************


/**
* a set of methods of draw in movieclip.
* <p>
* </p>
* there are no instance in this class. you can't create instance by new Shape().<br></br>
* this is simple shape. the more and advanced method in ExShape.
* <pre>
* <b>eg:</b>
* blank_mc.beginFill(0x009900,80);
* Shape.drawRect(blank_mc, 0, 0, 100, 100);
* blank_mc.endFill();
* </pre>
* 
*/
class com.idescn.draw.Shape extends Object{
	/**
	 * draw a rectenge that you could defined contour in half edges on 
	 * the boundary of a shape.
	 * 
	 * @param   mc a movieclip that drawing shape to 
	 * @param   x  x position. left-up point
	 * @param   y  y position. left-up point
	 * @param   w  width 
	 * @param   h  height
	 */
	public static function drawRect(mc:MovieClip,x:Number,y:Number,w:Number,
																h:Number):Void{
		if (arguments.length<5) 	return;
		
		mc.moveTo(x, y);
		mc.lineTo(x+w, y);
		mc.lineTo(x+w, y+h);
		mc.lineTo(x, y+h);
		mc.lineTo(x, y);
	}
	
	/**
	 * there are not contruct function
	 */
	private function Shape(){
		
	}
}