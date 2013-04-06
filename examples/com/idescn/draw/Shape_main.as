//******************************************************************************
//	name:	Shape
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 25 10:59:54 GMT+0800 2006
//	description: 
//******************************************************************************

import com.idescn.draw.Shape;

var depth:Number	=	this.getNextHighestDepth();
var emptyMC:MovieClip	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
emptyMC.beginFill(0x990000, 80);
Shape.drawRect(emptyMC, 10, 10, 100, 100, 10);
emptyMC.endFill();


depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
emptyMC.beginFill(0x006600, 80);
Shape.drawCircle(emptyMC, 150, 150, 100);
emptyMC.endFill();


depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x009900,100);
Shape.drawCurve3Pts(emptyMC, 200, 10, 250, 150, 300, 10);
emptyMC.endFill();


depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawShape(emptyMC, {x:200,y:10}, {x:250, y:150}, {x:300, y:10});
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawShape(emptyMC, [{x:210,y:11}, {x:270, y:160}, {x:310, y:20}]);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawOval(emptyMC, 300, 200, 50, 80);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.dashTo(emptyMC, 150, 50, 350, 450, 5, 2);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawArc(emptyMC, 150, 450, 150, 370, 0, 10);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawBurst(emptyMC, 250, 350, 20, 40, 10, 10);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawGear(emptyMC, 300, 450, 20, 40, 10, 10);
emptyMC.endFill();


depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawStar(emptyMC, 400, 450, 5, 40, 10, 10);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawWedge(emptyMC, 450, 200, 0, 40, 100,200);
emptyMC.endFill();

depth	=	this.getNextHighestDepth();
emptyMC	=	this.createEmptyMovieClip("mcEmpty"+depth, depth);
//emptyMC.beginFill(0x000066, 80);
emptyMC.lineStyle(1, 0x000099,100);
Shape.drawPoly(emptyMC, 450, 200, 5, 40, 0);
emptyMC.endFill();