//******************************************************************************
//	Name:	Oscillogram 1.1.0
//	Author:	whohoo
//	Email:	whohoo@21cn.com
//	Date:	Wed Jul 20 15:13:57 2005
//******************************************************************************



import com.idescn.draw.Shape;
import mx.events.EventDispatcher;

[IconFile("Oscillogram.png")]
/**
* draw line like oscillogram
* <p></p>
* * you could drag ImageBox from component panel(Ctrl+F7) in flash to stage<br></br>
* and define properties in Parameters panel(Alt+F7).<br></br>
* <b>Parameters:</b>
* <ul>
* <li><b>axisColor:</b> color value, eg: 0xFFFFFF</li>
* <li><b>backgroundColor:</b> color value, eg: 0xFFFFFF</li>
* <li><b>lineColor:</b> color value, eg: 0xFFFFFF</li>
* <li><b>offset:</b> a positive number</li>
* <li><b>showGrid:</b> a positive number of alpha</li>
* <li><b>showHint:</b> true of false</li>
* </ul>
* <p></p>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onMaxValueInAll({value, position}): the max value in all points </li>
* <li>onMinValueInAll({value, position}): the min value in all points </li>
* <li>onMaxValue({value}): the max value </li>
* <li>onMinValue({value}): the min value </li>
* 
* </ul>
* 
*/
class com.idescn.graphics.Oscillogram extends MovieClip{
	private var _mcBg:MovieClip	=	null;
	private var _mcAxis:MovieClip	=	null;
	private var _mcDraw:MovieClip	=	null;
	private var _mcGrid:MovieClip	=	null;
	private var _mcLine:MovieClip	=	null;
	private var _mcSuper:MovieClip	=	null;
	private var _mcSub:MovieClip	=	null;
	
	private var _widthBox:Number	=	100;
	private var _heightBox:Number	=	100;
	private var _colBg:Number		=	0x000000;
	private var _colLine:Number	=	0xFFFF00;
	private var _colAxis:Number	=	0xFFFFFF;
	private var _showHint:Boolean	=	true;
	private var _gridAlpha:Number	=	0;
	private var _curPoint:Number	=	0;
	private var _data:Array			=	null;
	private var _offset:Number		=	0;
	private var _maxValue:Number	=	null;
	private var _minValue:Number	=	null;
	private var _pointsAxisX:Number	=	null;
	private var _isPoint:Boolean	=	false;
	private var _isLine:Boolean	=	true;
	
	[Inspectable(defaultValue="minY:1,maxY:100,scaleX:5,scaleY:5", type=Object, name="Axis properties")]
	private var _objAxis:Object	=	{	minY:1,maxY:100,
											scaleX:5,scaleY:5};
											
	/////////////////event
	/**
	* <b>In fact</b>, addEventListener(event:String, handler) is method.<br></br>
	* add a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public  var addEventListener:Function;
	/**
	* <b>In fact</b>, removeEventListener(event:String, handler) is method.<br></br>
	* remove a listener for a particular event<br></br>
	* parameters event the name of the event ("click", "change", etc)<br></br>
	* parameters handler the function or object that should be called
	*/
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	private static var __mixinFED =	EventDispatcher.initialize(Oscillogram.prototype);
	
	
	function set dataProvider(d:Array):Void{
		_data		=	d.slice();
		_curPoint	=	0;
		_maxValue	=	_objAxis.minY;
		_minValue	=	_objAxis.maxY;
		update();
	}
	/**dataProvider is a array include points	 */
	function get dataProvider():Array{
		return _data.slice();
	}

	function set minY(n:Number):Void{
		_objAxis.minY	=	n;
		update();
	}
	/**the min Y axis*/
	function get minY():Number{
		return _objAxis.minY;
	}
	
	function set maxY(n:Number):Void{
		_objAxis.maxY	=	n;
		update();
	}
	/**the max Y axis*/
	function get maxY():Number{
		return _objAxis.maxY;
	}
	
	function set scaleX(n:Number):Void{
		_objAxis.scaleX	=	n;
		resize(_widthBox,_heightBox);
	}
	/**the scale of x*/
	function get scaleX():Number{
		return _objAxis.scaleX;
	}
	
	function set scaleY(n:Number):Void{
		_objAxis.scaleY	=	n;
		resize(_widthBox,_heightBox);
	}
	/**the scale of y*/
	function get scaleY():Number{
		return _objAxis.scaleY;
	}
	
	[Inspectable(defaultValue=0 ,type=Number, name="grid alpha")]
	function set showGrid(n:Number):Void{
		_gridAlpha	=	n;
		if(n>0){
			drawGrid();
		}else{
			_mcGrid.removeMovieClip();
		}
	}
	/**grid alpha value*/
	function get showGrid():Number{
		return _gridAlpha;
	}
	
	[Inspectable(defaultValue=true, type=Boolean)]
	function set showHint(n:Boolean):Void{
		_showHint	=	n;
		update()
	}
	/** is show hint when the max or min value are*/
	function get showHint():Boolean{
		return _showHint;
	}
	
	
	[Inspectable(defaultValue="#FFFFFF", type=Color)]
	function set axisColor(bc:Number):Void{
		_colAxis = bc;
		(new Color(_mcAxis)).setRGB(bc);
	}
	/**the color of axis*/
	function get axisColor():Number{
		return _colAxis;
	}
	
	[Inspectable(defaultValue="#FFFF00", type=Color)]
	function set lineColor(bc:Number):Void{
		_colLine = bc;
		(new Color(_mcLine)).setRGB(bc);
		_mcBg._visible	=	!(bc==_colBg);
	}
	/**the color of line*/
	function get lineColor():Number{
		return _colLine;
	}
	
	[Inspectable(defaultValue="#000000", type=Color)]
	function set backgroundColor(bc:Number):Void{
		_colBg = bc;
		(new Color(_mcBg)).setRGB(bc);
		_mcBg._visible	=	!(bc==_colLine);
		
	}
	/**the color of background*/
	function get backgroundColor():Number{
		return _colBg;
	}
	
	function set widthBox(bc:Number):Void{
		_widthBox = bc;
		resize(bc,_heightBox);
	}
	/**width of box*/
	function get widthBox():Number{
		return _widthBox;
	}
	
	function set heightBox(bc:Number):Void{
		_heightBox = bc;
		resize(_widthBox,bc);
	}
	/**height of box*/
	function get heightBox():Number{
		return _heightBox;
	}
	
	[Inspectable(defaultValue=0, type=Number)]
	function set offset(of:Number):Void{
		_offset = of;
		update();
	}
	/**the offset's value*/
	function get offset():Number{
		return _offset;
	}
	//***************构建方法********************//
	/**
	 * contruct function.<br></br>
	 * you not use new Oscillogram() to constrruct. you ought to drag Oscillogram from<br></br>
	 * Component panel(Ctrl+F7) to stage.
	 */
	public function Oscillogram(){
		init(this._width, this._height);
		this._xscale	=	this._yscale	=	100;
	}
	
	//***************[PRIVATE METHOD]*****************//
	/**
	 * initialize
	 * @param   w width
	 * @param   h heihgt
	 * 
	 */
	private function init(w:Number,h:Number):Void{
		_mcBg	=	this.createEmptyMovieClip("mcBackground",0);
		_mcBg.beginFill(_colBg,100);
		Shape.drawRect(_mcBg,0,0,w,h);
		_mcBg.endFill();
		_mcBg._visible	=	!(_colBg==_colLine);
		_mcAxis	=	this.createEmptyMovieClip("mcAxis",10);
		_mcDraw	=	this.createEmptyMovieClip("mcDraw",20);
		_mcLine	=	_mcDraw.createEmptyMovieClip("mcLine",0);
		_mcSuper=	this.createEmptyMovieClip("mcSuper",1000);
		_mcSub	=	this.createEmptyMovieClip("mcSub",1002);
		_curPoint	=	0;
		_data	=	[];
		_maxValue	=	_objAxis.minY;
		_minValue	=	_objAxis.maxY;
		createHints();
		resize(w,h);
	}
	
	private function drawLine():Void{
		var data:Array		=	_data;
		var col:Number		=	_colLine;
		var n:Number		=	_pointsAxisX;
		
		var start:Number	=	0;
		var curP:Number	=	_curPoint;
		
		var offset:Number	=	_offset;
		var len0:Number	=	null;
		if(data.length-offset>n){
			len0	=	data.length-offset;
		}else if(data.length>n){
			len0	=	n;
		}else{
			len0	=	data.length;
		}
		//d为得到要显示的数据大小
		var d:Array			=	data.slice(-n-offset,len0);
		var mc:MovieClip	=	_mcLine;
		//debug....
		//trace("len: "+d.length+" ["+d+"]");
		//trace("len: "+data.length+" ["+data+"]\r");
		
		var max0:Number	=	_objAxis.minY;
		var min0:Number	=	_objAxis.maxY;
		
		mc.clear();
		mc.lineStyle(1,col,100);
		if(curP>=n){
			curP	=	0;
		};
		var pos:Object		=	dataToPos(d,start,curP);
		mc.moveTo(pos.x,pos.y);
		
		var d_len:Number	=	d.length;
		var s0:Number		=	null;//计算最高值所在数组的位置.
		// set hints position
		if(max0<pos.v){
			max0	=	pos.v;
			setHintsPos(_mcSuper,pos);
			if(max0>_maxValue){
				_maxValue	=	max0;
				s0	=	d_len-start;
				dispatchEvent({type:"onMaxValueInAll",value:max0,position:data.length-s0});
			}
		}
		if(min0>pos.v){
			min0	=	pos.v;
			setHintsPos(_mcSub,pos);
			
			if(min0<_minValue){
				_minValue	=	min0;
				s0	=	d_len-start;
				dispatchEvent({type:"onMinValueInAll",value:min0,position:data.length-s0});
			}
		}
		
		start++;
		curP++;
		
		while(start<d_len){
			if(curP==n){
				curP	=	0;
				pos	=	dataToPos(d,start,curP);
				mc.moveTo(pos.x,pos.y);
			}else{
				pos	=	dataToPos(d,start,curP);
				mc.lineTo(pos.x,pos.y);
			};
			// set hints position
			if(max0<pos.v){//trace(max0+" / "+_maxValue);
				max0	=	pos.v;
				setHintsPos(_mcSuper,pos);
				if(max0>_maxValue){
					_maxValue	=	max0;
					s0	=	d_len-start;
					dispatchEvent({type:"onMaxValueInAll",value:max0,position:data.length-s0});
				}
			}
			if(min0>pos.v){
				min0	=	pos.v;
				setHintsPos(_mcSub,pos);
				
				if(min0<_minValue){
					_minValue	=	min0;
					s0	=	d_len-start;
					dispatchEvent({type:"onMinValueInAll",value:min0,position:data.length-s0});
				}
			}
			
			start++;
			curP++;
		};
		
		dispatchEvent({type:"onMaxValue",value:max0});
		dispatchEvent({type:"onMinValue",value:min0});
		
		if(data.length>n){
			_curPoint	=	curP>=n ? 0 : curP;
		}
		
	}
	
	private function dataToPos(d:Array,i:Number,s:Number):Object{
		var obj:Object		=	_objAxis;
		var sx:Number		=	obj.scaleX;
		var diff:Number	=	obj.maxY-obj.minY;
		var h:Number		=	_heightBox;
		return	{x:sx*s,	y:h-(d[i]-obj.minY)*h/diff,	v:d[i]};
	}
	
	private function drawAxisY(w:Number,h:Number):Void{
		var mc	=	_mcAxis;
		mc.moveTo(0,0);
		mc.lineTo(0,h);
		var sy	=	_objAxis.scaleY;
		var i:Number	=	int(h/sy)+1;
		var d:Number	=	null;
		while(i--){
			d	=	h	-	i*sy;
			mc.moveTo(0,d);
			if(i%5==0){
				mc.lineTo(5,d);
			}else{
				mc.lineTo(3,d);
			}
		}
	}
	private function drawAxisX(w:Number,h:Number):Void{
		var mc	=	_mcAxis;
		mc.moveTo(0,h);
		mc.lineTo(w,h);
		var sx	=	_objAxis.scaleX;
		var i:Number	=	int(w/sx)+1;
		_pointsAxisX	=	i;
		var d:Number	=	null;
		while(i--){
			d	=	i*sx;
			mc.moveTo(d,h);
			if(i%5==0){
				mc.lineTo(d,h-5);
			}else{
				mc.lineTo(d,h-3);
			}
		}
	}
	
	private function drawGrid(alpha:Number):Void{
		if(!_mcGrid){
			_mcGrid	=	this.createEmptyMovieClip("mcGrid",12);
		}
		var mc:MovieClip	=	_mcGrid;
		mc.clear();
		mc.lineStyle(.1,_colAxis,alpha);
		var sx	=	_objAxis.scaleX;
		var sy	=	_objAxis.scaleY;
		var w	=	_widthBox;
		var h	=	_heightBox;
		var i0:Number	=	int(w/sx)+1;
		var k0:Number	=	int(h/sy)+1;
		
		for(var i=0;i<i0;i+=2){//X
			mc.moveTo(sx*i,0);
			mc.lineTo(sx*i,h);
		}
		
		for(var k=0;k<k0;k+=5){//Y
			mc.moveTo(0,sy*k);
			mc.lineTo(w,sy*k);
		}
	}
	
	private function createHints():Void{
		if(_showHint){
			var mc0:MovieClip	=	_mcSuper;
			var mc1:MovieClip	=	_mcSub;
			
			//super
			mc0.createTextField("txt",0,8,-24,0,20);
			var txt:TextField	=	mc0.txt;
			txt.autoSize	=	"left";
			//txt.border		=	true;
			txt.borderColor	=	0xff0000;
			txt.selectable	=	false;
			txt.textColor	=	_colAxis;
			//txt.variable	=	"_parent._maxValue";
			
			var fmt:TextFormat	=	txt.getTextFormat();
			var exWidth:Number	=	fmt.getTextExtent(_objAxis.maxY).width+10;
			//draw a line
			mc0.lineStyle(.1,_colAxis,100);
			mc0.lineTo(8,-8);
			mc0.lineTo(exWidth,-8);
			
			//sub
			mc1.createTextField("txt",0,8,-8,0,20);
			txt				=	mc1.txt;
			txt.autoSize	=	"left";
			//txt.border		=	true;
			txt.borderColor	=	0x00ff00;
			txt.selectable	=	false;
			txt.textColor	=	_colAxis;
			//txt.variable	=	"_parent._minValue";
			//draw a line
			mc1.lineStyle(.1,_colAxis,100);
			mc1.lineTo(8,8);
			mc1.lineTo(exWidth,8);
			
		}
	}
	
	private function setHintsPos(mc:MovieClip,p:Object):Void{
		if(_showHint){
			mc._x	=	p.x;
			mc._y	=	p.y;
			mc.txt.text	=	p.v;	
		}
		
	}
	
	//***************[PUBLIC METHOD]*****************//
	/**
	* add data to this oscillogram, and refresh it
	* @param data data that you want to add
	* 
	*/
	public function addData(data:Number):Void{
		_data.push(data);
		if(_data.length<=_pointsAxisX){
			_curPoint	=	0;
		}else{
			_curPoint++;
		}
		update();
	}
	
	/**
	* remove data from this oscillogram, and refresh it
	* @return the remove data
	* 
	*/
	public function removeData():Number{
		var n:Number	=	Number(_data.pop());
		if(_data.length<=_pointsAxisX){
			_curPoint	=	0;
		}else{
			_curPoint--;
		}
		update();
		return	n;
	}
	
	/**
	* refresh oscillogram's data
	* 
	*/
	public function update():Void{
		drawLine();
	}
	
	/**
	* resize the oscillogram size by this modeth.
	* @param w w means width
	* @param h h means height
	* 
	*/
	public function resize(w:Number,h:Number):Void{
		_mcBg._width	=	w;
		_mcBg._height	=	h;
		_widthBox		=	w;
		_heightBox		=	h;
		_mcAxis.clear();//清除原来的线条,重新绘制.
		_mcAxis.lineStyle(1,_colAxis,100);
		drawAxisY(w,h);		//draw Y axis
		drawAxisX(w,h);		//draw X axis
		drawGrid(_gridAlpha)
		_mcAxis.endFill();
	}
	
	/**
	* output this name
	* @return this name
	* 
	*/
	public function toString():String{
		return	"[Oscillogram] "+this._name;
	}
}

/**
* 1.1.0 (Mon Aug 01 14:37:48 2005)
* 增加偏移属性offset,默认为0是显示最后数据
* 1为显示前移一个单位的数据
*/