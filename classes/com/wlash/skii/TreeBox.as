//******************************************************************************
//	name:	TreeBox 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Thu May 10 16:04:24 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "fish_sk2.fla" file.
//		
//******************************************************************************


import com.wlash.skii.Tree3D
import com.idescn.as3d.Vector3D;
/**
 * annotate here for this class.<p></p>
 * 
 */
class com.wlash.skii.TreeBox extends MovieClip{
	private var _trees:Array			=	null;
	private var emptyPoints:Array		=	null;//可以跳到的点.
	private var interID:Number			=	null;
	private var autoMoveIndex:Number	=	null;
	/**view point*/
	public  var viewPoint3D:Vector3D	=	null;
	
	public static var spacePos:Array	=	null;
	//************************[READ|WRITE]************************************//
	
	
	//************************[READ ONLY]*************************************//
	
	
	/**
	 * Construction function.<br></br>
	 */
	public function TreeBox(){
		spacePos	=	[new Vector3D(0, 0, -300),
						new Vector3D(-480, 160, -50),
						new Vector3D(1710, 360, 870),
						new Vector3D(-1910, -1190, 1590),
						new Vector3D(730, -380, 100),
						new Vector3D(1010, -1700, 1770),
						new Vector3D(-310, -540, 230),
						new Vector3D(840, 580, 330)
						];
		
		viewPoint3D	=	new Vector3D(0,0,300);
		init();
	}
	
	//************************[PRIVATE METHOD]********************************//
	/**
	 * Initializtion this class
	 * 
	 */
	private function init():Void{
		autoMoveIndex	=	0;
		_trees			=	[];
		emptyPoints		=	[];
		var mc:Tree3D	=	null;
		var len:Number	=	spacePos.length;
		var posArr:Array	=	getRamdomArray(len-1);
		
		for(var i:Number=0;i<4;i++){
			mc	=	this["tree"+i];
			_trees.push(mc);
			mc.pointIndex	=	posArr.pop()+1;
			mc.v3d			=	spacePos[mc.pointIndex].getClone();
			mc.lastPoint	=	spacePos[mc.pointIndex].getClone();
			mc._alpha		=	0;
			mc.onRelease=function(){
				if(!this.useHandCursor)	return;
				//_root.debug_txt.text	+=	
				//("treeName: "+this._name+" ("+
				//this.v3d.x+", "+this.v3d.y+", "+this.v3d.z+"), index:"+this.pointIndex+" \r");
				this.useHandCursor	=	false;
				_parent._parent.curTree.useHandCursor	=	true;
				this._parent.moveAllTrees(this);
				
				_parent._parent.curTree	=	this;
			}
			mc.onRollOver=function():Void{
				this.tree_mc.menu_mc.moveIn();
				this.menuFollowMouse();
			}
			mc.onRollOut=mc.onReleaseOutside=function():Void{
				this.tree_mc.menu_mc.moveOut();
				this.stopMenuFollow();
			}
		}
		len	=	posArr.length;
		for(var i:Number=0;i<len;i++){
			emptyPoints[i]	=	posArr[i]+1;
		}
		//delay
		this.onEnterFrame=function(){
			var mc:Tree3D;
			for(var i:Number=0;i<4;i++){
				mc	=	_trees[i];
				mc.initShow();
				
			}
			autoMove();//一开始自动运动.
			delete this.onEnterFrame;
		}
	}
	
	private function moveAllTrees(tree:Tree3D):Void{
		var mc:Tree3D			=	null;
		var lastMC:Tree3D		=	tree;
		var aimPoint:Vector3D	=	null;
		var randomArr:Array	=	getRamdomArray(4);
		var randomIndex:Number	=	null;
		var availableIndex:Number	=	null;
		emptyPoints.push(tree.pointIndex);
		for(var i:Number=0;i<4;i++){
			mc	=	this["tree"+randomArr[i]];
			if(mc==tree){
				mc.pointIndex	=	0;
			}else{
				randomIndex		=	random(emptyPoints.length);
				availableIndex	=	emptyPoints[randomIndex];
				//trace("emptyPoints: "+emptyPoints)
				if(mc==_parent.curTree){
					emptyPoints.splice(randomIndex, 1);
				}else{
					emptyPoints[randomIndex]	=	mc.pointIndex;
				}
				mc.pointIndex	=	availableIndex;
			}
			
			aimPoint	=	spacePos[mc.pointIndex];
			mc.move2Point(aimPoint);
			
			lastMC	=	mc;
		}
		//重新计算自动功能.
		autoMove();
	}
	
	private function getRamdomArray(num:Number):Array{
		var retArr:Array	=	[];
		for(var i:Number=0;i<num;i++){
			retArr.push(i);
		}
		var tempNum:Number;
		var tempIndex:Number;
		for(i=0;i<num;i++){
			tempIndex	=	random(num);
			tempNum		=	retArr[tempIndex];
			//retArr[tempIndex]	=	retArr[i];
			//retArr[i]	=	tempNum;
		}
		return retArr;
	}
	
	private function _autoMove():Void{
		var mc:MovieClip	=	_trees[autoMoveIndex++%4];
		if(mc==_parent.curTree){
			mc	=	_trees[autoMoveIndex++%4];
		}
		var randomIndex:Number		=	random(emptyPoints.length);
		var availableIndex:Number	=	emptyPoints[randomIndex];
		emptyPoints[randomIndex]	=	mc.pointIndex;
		mc.pointIndex				=	availableIndex;
		
		var aimPoint:Vector3D	=	spacePos[mc.pointIndex];
		mc.move2Point(aimPoint);
		autoMove();
	}
	
	private function autoMove():Void{
		clearInterval(interID);
		interID=_global.setTimeout(this, "_autoMove", random(200)*10+3000);
	}
	//***********************[PUBLIC METHOD]**********************************//
	public function startMove():Void{
		
	}
	
	public function enableTree(enabled:Boolean):Void{
		var mc:Tree3D;
		for(var i:Number=0;i<4;i++){
			mc	=	_trees[i];
			mc.enabled	=	enabled;
			
		}
	}
	//***********************[STATIC METHOD]**********************************//
	
}//end class
//This template is created by whohoo.

//below code were remove from above.
/*

*/
