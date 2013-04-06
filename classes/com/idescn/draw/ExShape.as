//******************************************************************************
//	class:	ExShape 1.0
// 	author:	whohoo
// 	email:	whohoo@21cn.com
// 	date:	Thu May 25 14:49:22 2006
//******************************************************************************


/**
* a set of methods of draw in movieclip.
* <p>
* </p>
* there are no instance in this class. you can't create instance by new Shape().<br></br>
* <pre>
* <b>eg:</b>
* blank_mc.beginFill(0x009900,80);
* Shape.drawRect(blank_mc, 0, 0, 100, 100, 10);
* blank_mc.endFill();
* </pre>
* 
*/
class com.idescn.draw.ExShape extends Object{
	
	/**
	 * a method for creating regular polygons. <br></br>
	 * Negative values for sides will draw the
	 * polygon in the reverse direction, which allows for
	 * creating knock-outs in masks.
	 * 
	 * @param   mc     a movieclip that drawing shape to 
	 * @param   x      center of polygon
	 * @param   y      center of polygon
	 * @param   sides  number of sides (Math.abs(sides) must be > 2)
	 * @param   radius radius of the points of the polygon from the center
	 * @param   angle  [optional] starting angle in degrees. (defaults to 0)
	 */
	public static function drawPoly(mc:MovieClip, x:Number, y:Number, 
						sides:Number, radius:Number, angle:Number):Void {
		if (arguments.length<5) {
			return;
		}
		// convert sides to positive value
		var count:Number = Math.abs(sides);
		// check that count is sufficient to build polygon
		if (count>2) {
			// init vars
			var step:Number, start:Number, dx:Number, dy:Number;
			// calculate span of sides
			step = (Math.PI*2)/sides;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			mc.moveTo(x+(Math.cos(start)*radius), y-(Math.sin(start)*radius));
			// draw the polygon
			for (var n:Number=1; n<=count; n++) {
				dx = x+Math.cos(start+(step*n))*radius;
				dy = y-Math.sin(start+(step*n))*radius;
				mc.lineTo(dx, dy);
			}
		}
	};

	
	/**
	 * a method for drawing pie shaped	wedges. <br></br>
	 * Very useful for creating charts.
	 * 
	 * @param   mc         a movieclip that drawing shape to 
	 * @param   x          center point of the wedge.
	 * @param   y          center point of the wedge.
	 * @param   startAngle starting angle in degrees.
	 * @param   arc        sweep of the wedge. Negative values draw clockwise.
	 * @param   radius     radius of wedge. If [optional] yRadius is defined, 
	 * then radius is the x radius.
	 * @param   yRadius    y radius for wedge.
	 */
	public static function drawWedge(mc, x, y, startAngle, arc, radius, yRadius):Void {
		
		if (arguments.length<6) {
			return;
		}
		// move to x,y position
		mc.moveTo(x, y);
		// if yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// Init vars
		var segAngle:Number, theta:Number, angle:Number, angleMid:Number,
				segs:Number, ax:Number, ay:Number, bx:Number, by:Number, 
				cx:Number, cy:Number;
		// limit sweep to reasonable numbers
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment.
		segAngle = arc/segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians.
			theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(startAngle/180)*Math.PI;
		// draw the curve in segments no larger than 45 degrees.
		if (segs>0) {
			// draw a line from the center to the start of the curve
			ax = x+Math.cos(startAngle/180*Math.PI)*radius;
			ay = y+Math.sin(-startAngle/180*Math.PI)*yRadius;
			mc.lineTo(ax, ay);
			// Loop for drawing curve segments
			for (var i:Number = 0; i<segs; i++) {
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*radius;
				by = y+Math.sin(angle)*yRadius;
				cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				mc.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center
			mc.lineTo(x, y);
		}
	};

	/**
	 * a method for drawing star shaped	polygons.<br></br>
	 * Note that the stars by default 'point' to
	 * the right. This is because the method starts drawing
	 * at 0 degrees by default, putting the first point to
	 * the right of center. Negative values for points
	 * draws the star in reverse direction, allowing for
	 * knock-outs when used as part of a mask.
	 * 
	 * @param   mc          a movieclip that drawing shape to 
	 * @param   x           center of star
	 * @param   y           center of star
	 * @param   points      number of points (Math.abs(points) must be > 2)
	 * @param   innerRadius radius of the indent of the points
	 * @param   outerRadius radius of the tips of the points
	 * @param   angle       [optional] starting angle in degrees. (defaults to 0)
	 */
	public static function drawStar(mc:MovieClip, x:Number, y:Number, points:Number,
				innerRadius:Number, outerRadius:Number, angle:Number):Void {
		if(arguments.length < 6) {
			return;
		}
		var count:Number = Math.abs(points);
		if (count>2) {
			// init vars
			var step:Number, halfStep:Number, start:Number,dx:Number, dy:Number;
			// calculate distance between points
			step = (Math.PI*2)/points;
			halfStep = step/2;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			mc.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
			// draw lines
			for (var n:Number=1; n<=count; n++) {
				dx = x+Math.cos(start+(step*n)-halfStep)*innerRadius;
				dy = y-Math.sin(start+(step*n)-halfStep)*innerRadius;
				mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				mc.lineTo(dx, dy);
			}
		}
	};
	
	/**
	 *  a method that draws gears...<br></br>
	 * you know, cogs with teeth and a hole in the middle where
	 * the axle goes? Okay, okay... so nobody *needs* a
	 * method to draw a gear. I know that this is probably
	 * one of my least useful methods. But it was an easy
	 * adaptation of the polygon method so I did it anyway.
	 * Enjoy. FYI: if you modify this to draw the hole
	 * polygon in the opposite direction, it will remain
	 * transparent if the gear is used for a mask.
	 * 
	 * @param   mc          a movieclip that drawing shape to 
	 * @param   x           center of gear.
	 * @param   y           center of gear.
	 * @param   sides       number of teeth on gear. (must be > 2)
	 * @param   innerRadius radius of the indent of the teeth.
	 * @param   outerRadius outer radius of the teeth.
	 * @param   angle       [optional] starting angle in degrees. Defaults to 0.
	 * @param   holeSides   [optional] draw a polygonal hole with this many sides (must be > 2)
	 * @param   holeRadius  [optional] size of hole. Default = innerRadius/3.
	 */
	public static function drawGear(mc:MovieClip, x:Number, y:Number, sides:Number, 
							innerRadius:Number, outerRadius:Number, angle:Number, 
								holeSides:Number, holeRadius:Number):Void {
		if(arguments<6) {
			return;
		}
		if (sides>2) {
			// init vars
			var step:Number, qtrStep:Number, start:Number,dx:Number, dy:Number;
			// calculate length of sides
			step = (Math.PI*2)/sides;
			qtrStep = step/4;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			mc.moveTo(x+(Math.cos(start)*outerRadius), 
											y-(Math.sin(start)*outerRadius));
			// draw lines
			for (var n:Number=1; n<=sides; n++) {
				dx = x+Math.cos(start+(step*n)-(qtrStep*3))*innerRadius;
				dy = y-Math.sin(start+(step*n)-(qtrStep*3))*innerRadius;
				mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n)-(qtrStep*2))*innerRadius;
				dy = y-Math.sin(start+(step*n)-(qtrStep*2))*innerRadius;
				mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n)-qtrStep)*outerRadius;
				dy = y-Math.sin(start+(step*n)-qtrStep)*outerRadius;
				mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				mc.lineTo(dx, dy);
			}
			// This is complete overkill... but I had it done already. :)
			if (holeSides>2) {
				if(holeRadius == undefined) {
					holeRadius = innerRadius/3;
				}
				step = (Math.PI*2)/holeSides;
				mc.moveTo(x+(Math.cos(start)*holeRadius), 
											y-(Math.sin(start)*holeRadius));
				for (n=1; n<=holeSides; n++) {
					dx = x+Math.cos(start+(step*n))*holeRadius;
					dy = y-Math.sin(start+(step*n))*holeRadius;
					mc.lineTo(dx, dy);
				}
			}
		}
	};

	/**
	 * a method for drawing bursts (rounded	star shaped ovals often seen in advertising).<br></br>
	 * This	seemingly whimsical method actually had a serious
	 * purpose. It was done to accommodate a client that
	 * wanted to have custom bursts for 'NEW!' and
	 * 'IMPROVED!' type elements on their site...
	 * personally I think those look tacky, but it's hard
	 * to argue with a paying client. :) This method also
	 * makes some fun flower shapes if you play with the
	 * input numbers. 
	 * 
	 * @param   mc          a movieclip that drawing shape to 
	 * @param   x           center of burst
	 * @param   y           center of burst
	 * @param   sides       number of sides or points
	 * @param   innerRadius radius of the indent of the curves
	 * @param   outerRadius radius of the outermost points
	 * @param   angle       [optional] starting angle in degrees. (defaults to 0)
	 */
	public static function drawBurst(mc:MovieClip, x:Number, y:Number, sides:Number,
					 innerRadius:Number, outerRadius:Number, angle:Number):Void {
		
		if(arguments<6) {
			return;
		}
		if (sides>2) {
			// init vars
			var step:Number, halfStep:Number, qtrStep:Number, start:Number; 
			var dx:Number, dy:Number, cx:Number, cy:Number;
			// calculate length of sides
			step = (Math.PI*2)/sides;
			halfStep = step/2;
			qtrStep = step/4;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			mc.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
			// draw curves
			for (var n:Number=1; n<=sides; n++) {
				cx = x+Math.cos(start+(step*n)-(qtrStep*3))*(innerRadius/Math.cos(qtrStep));
				cy = y-Math.sin(start+(step*n)-(qtrStep*3))*(innerRadius/Math.cos(qtrStep));
				dx = x+Math.cos(start+(step*n)-halfStep)*innerRadius;
				dy = y-Math.sin(start+(step*n)-halfStep)*innerRadius;
				mc.curveTo(cx, cy, dx, dy);
				cx = x+Math.cos(start+(step*n)-qtrStep)*(innerRadius/Math.cos(qtrStep));
				cy = y-Math.sin(start+(step*n)-qtrStep)*(innerRadius/Math.cos(qtrStep));
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				mc.curveTo(cx, cy, dx, dy);
			}
		}
	};
	
	/**
	 *  method for drawing regular and eliptical 
	 * arc segments. <br></br>
	 * This method replaces one I originally 
	 * released to the Flash MX beta group titled arcTo and contains
	 * several optimizations based on input from the following 
	 * people: Robert Penner, Eric Mueller and Michael Hurwicz.
	 * 
	 * @param   mc         a movieclip that drawing shape to 
	 * @param   x          This must be the current pen position... other values
	 * will look bad
	 * @param   y          This must be the current pen position... other values
	 * will look bad
	 * @param   radius     radius of Arc. If [optional] yRadius is defined, 
	 * then r is the x radiusarc = sweep of the arc. Negative values draw clockwise.
	 * @param   arc        sweep of the arc. Negative values draw clockwise.
	 * @param   startAngle starting angle in degrees.
	 * @param   yRadius    [optional] y radius of arc. 
	 * @return  end point<br></br>
	 *  In the native draw methods the user must specify the end point
	 *  which means that they always know where they are ending at, but
	 *  here the endpoint is unknown unless the user calculates it on their 
	 *  own. Lets be nice and let save them the hassle by passing it back. 
	 */
	public static function drawArc(mc:MovieClip, x:Number, y:Number, radius:Number, 
					arc:Number, startAngle:Number, yRadius:Number):Object {
		if (arguments.length<6) {
			return;
		}
		// if yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// Init vars
		var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number;
		var  ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
		// no sense in drawing more than is needed :)
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment
		segAngle = arc/segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians. 
		theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(startAngle/180)*Math.PI;
		// find our starting points (ax,ay) relative to the secified x,y
		ax = x-Math.cos(angle)*radius;
		ay = y-Math.sin(angle)*yRadius;
		// if our arc is larger than 45 degrees, draw as 45 degree segments
		// so that we match Flash's native circle routines.
		if (segs>0) {
			mc.moveTo(x,y)
			// Loop for drawing arc segments
			for (var i:Number = 0; i<segs; i++) {
				// increment our angle
				angle += theta;
				// find the angle halfway between the last angle and the new
				angleMid = angle-(theta/2);
				// calculate our end point
				bx = ax+Math.cos(angle)*radius;
				by = ay+Math.sin(angle)*yRadius;
				// calculate our control point
				cx = ax+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = ay+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				// draw the arc segment
				mc.curveTo(cx, cy, bx, by);
			}
		}
		// In the native draw methods the user must specify the end point
		// which means that they always know where they are ending at, but
		// here the endpoint is unknown unless the user calculates it on their 
		// own. Lets be nice and let save them the hassle by passing it back. 
		return {x:bx, y:by};
	};
	
	/**
	 * a metod for drawing dashed (and dotted) lines. I made this to extend the 
	 * lineTo function because itdoesn have the cutom line types that the in 
	 * programline tool has. To make a dotted line, specify a dash length 
	 * between .5 and 1.
	 * @param   mc     a movieclip that drawing shape to 
	 * @param   startx beginning of dashed line
	 * @param   starty beginning of dashed line
	 * @param   endx   end of dashed line
	 * @param   endy   end of dashed line
	 * @param   len    length of dash
	 * @param   gap    length of gap between dashes
	 */
	public static function dashTo(mc:MovieClip, startx:Number, starty:Number, 
					endx:Number,endy:Number, len:Number, gap:Number):Void{
		// if too few arguments, bail
		if (arguments.length < 7) {
			return;
		}
		// init vars
		var seglength:Number, deltax:Number, deltay:Number, segs:Number;
		var cx:Number, cy:Number, radians:Number, delta:Number;
		// calculate the legnth of a segment
		seglength = len + gap;
		// calculate the length of the dashed line
		deltax = endx - startx;
		deltay = endy - starty;
		delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
		// calculate the number of segments needed
		segs = Math.floor(Math.abs(delta / seglength));
		// get the angle of the line in radians
		radians = Math.atan2(deltay,deltax);
		// start the line here
		cx = startx;
		cy = starty;
		// add these to cx, cy to get next seg start
		deltax = Math.cos(radians)*seglength;
		deltay = Math.sin(radians)*seglength;
		// loop through each seg
		for (var n:Number = 0; n < segs; n++) {
			mc.moveTo(cx,cy);
			mc.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
			cx += deltax;
			cy += deltay;
		}
		// handle last segment as it is likely to be partial
		mc.moveTo(cx,cy);
		delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
		if(delta>len){
			// segment ends in the gap, so draw a full dash
			mc.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
		} else if(delta>0) {
			// segment is shorter than dash so only draw what is needed
			mc.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
		}
		// move the pen to the end position
		mc.moveTo(endx, endy);
	};
	
	/**
	 * creating circles and	ovals.<br></br>
	 * mc.drawOval() - by Ric Ewing (ric@formequalsfunction.com) - version 1.1 - 4.7.2002
	 * @param   mc      a movieclip that drawing shape to 
	 * @param   x       center of oval
	 * @param   y       center of oval
	 * @param   radius  radius of ovalIf [optional] yRadius is defined, r is the x radius.
	 * @param   yRadius [optional]  y radius of oval.
	 */
	public static function drawOval(mc:MovieClip, x:Number, y:Number, 
										radius:Number, yRadius:Number):Void {
		if (arguments.length<4) {
			return;
		}
		// init variables
		var theta:Number, xrCtrl:Number, yrCtrl:Number, angle:Number, angleMid:Number;
		var px:Number, py:Number, cx:Number, cy:Number;
		// if only yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// covert 45 degrees to radians for our calculations
		theta = Math.PI/4;
		// calculate the distance for the control point
		xrCtrl = radius/Math.cos(theta/2);
		yrCtrl = yRadius/Math.cos(theta/2);
		// start on the right side of the circle
		angle = 0;
		mc.moveTo(x+radius, y);
		// this loop draws the circle in 8 segments
		for (var i = 0; i<8; i++) {
			// increment our angles
			angle += theta;
			angleMid = angle-(theta/2);
			// calculate our control point
			cx = x+Math.cos(angleMid)*xrCtrl;
			cy = y+Math.sin(angleMid)*yrCtrl;
			// calculate our end point
			px = x+Math.cos(angle)*radius;
			py = y+Math.sin(angle)*yRadius;
			// draw the circle segment
			mc.curveTo(cx, cy, px, py);
		}
	}
	
	/**
	 * draw path with second or more parameter.<br></br>
	 * if the second parameter are array, it would loop the array draw all.
	 * {x:number, y:number}
	 * @param   mc a movieclip that drawing shape to 
	 */
	public static function drawShape(mc:MovieClip):Void{
		
		var point			=	null;
		var arr:Array		=	null;
		if(arguments[1] instanceof Array){
			if (arguments.length<2) 	return;
			arr		=	arguments[1];
		}else{
			if (arguments.length<3) 	return;
			arguments.shift();
			arr		=	arguments[1];
		}
		
		point	=	arr[0];
		var len:Number		=	arr.length;
		
		mc.moveTo(point.x, point.y);
		for(var i:Number=1;i<len;i++){
			point	=	arr[i];
			mc.lineTo(point.x, point.y);
		}
	}

	/**
	 * draw a curve path.<br></br>
	 * this medthod from Robert Penner.
	 * 
	 * @param   mc a movieclip that drawing shape to 
	 * @param   xStart x position 
	 * @param   yStart y position
	 * @param   x x position
	 * @param   y y position
	 * @param   xEnd x position
	 * @param   yEnd y position
	 */
	public static function drawCurve3Pts(mc:MovieClip, xStart:Number, yStart:Number,
							x:Number, y:Number, xEnd:Number, yEnd:Number):Void{
		if (arguments.length<7) 	return;
		
		mc.moveTo (xStart, yStart);
		mc.curveTo (2*x-.5*(xStart+xEnd), 2*y-.5*(yStart+yEnd), xEnd, yEnd);
	}
	
	/**
	 * draw a circle in movieclip.
	 * 
	 * @param   mc a movieclip that drawing shape to 
	 * @param   x  x position
	 * @param   y  y position
	 * @param   r  radius
	 */
	public static function drawCircle(mc:MovieClip, x:Number,y:Number,
																r:Number):Void{
		if (arguments.length<4) 	return;
		
		mc.moveTo(x+r, y);
		mc.curveTo(r+x, 0.4142*r+y, 0.7071*r+x, 0.7071*r+y);
		mc.curveTo(0.4142*r+x, r+y, x, r+y);
		mc.curveTo(-0.4142*r+x, r+y, -0.7071*r+x, 0.7071*r+y);
		mc.curveTo(-r+x, 0.4142*r+y, -r+x, y);
		mc.curveTo(-r+x, -0.4142*r+y, -0.7071*r+x, -0.7071*r+y);
		mc.curveTo(-0.4142*r+x, -r+y, x, -r+y);
		mc.curveTo(0.4142*r+x, -r+y, 0.7071*r+x, -0.7071*r+y);
		mc.curveTo(r+x, -0.4142*r+y, r+x, y);
	}
	
	/**
	 * draw a rectenge that you could defined contour in half edges on 
	 * the boundary of a shape.
	 * 
	 * @param   mc a movieclip that drawing shape to 
	 * @param   x  x position. left-up point
	 * @param   y  y position. left-up point
	 * @param   w  width 
	 * @param   h  height
	 * @param   c  contour 
	 */
	public static function drawRect(mc:MovieClip,x:Number,y:Number,w:Number,
													h:Number,c:Number):Void{
		if (arguments.length<4) 	return;	
		
		if (c>0) {
			// init vars
			var THETA:Number	=	Math.PI/4;
			var THETA1:Number	=	Math.PI/8;
			var angle:Number;
			var cx:Number;
			var cy:Number;
			var px:Number;
			var py:Number;
			// make sure that w + h are larger than 2*c
			if (c>Math.min(w, h)/2) {
				c = Math.min(w, h)/2;
			}

			// draw top line
			mc.moveTo(x+c, y);
			mc.lineTo(x+w-c, y);
			
			//angle is currently 90 degrees
			angle = -Math.PI/2;
			// draw top right corner in two parts
			cx = x+w-c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+w-c+(Math.cos(angle+THETA)*c);
			py = y+c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			angle += THETA;
			cx = x+w-c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+w-c+(Math.cos(angle+THETA)*c);
			py = y+c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			
			// draw right line
			mc.lineTo(x+w, y+h-c);
			
			// draw bottom right corner
			angle += THETA;
			cx = x+w-c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+h-c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+w-c+(Math.cos(angle+THETA)*c);
			py = y+h-c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			angle += THETA;
			cx = x+w-c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+h-c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+w-c+(Math.cos(angle+THETA)*c);
			py = y+h-c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			
			// draw bottom line
			mc.lineTo(x+c, y+h);
			
			// draw bottom left corner
			angle += THETA;
			cx = x+c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+h-c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+c+(Math.cos(angle+THETA)*c);
			py = y+h-c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			angle += THETA;
			cx = x+c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+h-c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+c+(Math.cos(angle+THETA)*c);
			py = y+h-c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			
			// draw left line
			mc.lineTo(x, y+c);
			
			// draw top left corner
			angle += THETA;
			cx = x+c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+c+(Math.cos(angle+THETA)*c);
			py = y+c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
			angle += THETA;
			cx = x+c+(Math.cos(angle+(THETA1))*c/Math.cos(THETA1));
			cy = y+c+(Math.sin(angle+(THETA1))*c/Math.cos(THETA1));
			px = x+c+(Math.cos(angle+THETA)*c);
			py = y+c+(Math.sin(angle+THETA)*c);
			mc.curveTo(cx, cy, px, py);
		} else {
			mc.moveTo(x, y);
			mc.lineTo(x+w, y);
			mc.lineTo(x+w, y+h);
			mc.lineTo(x, y+h);
			mc.lineTo(x, y);
		}
	}
	
	/**
	 * there are not contruct function
	 */
	private function ExShape(){
		
	}
}