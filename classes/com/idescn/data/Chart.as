//********************************************
//	class:	Chart 1.0
// 	author:	whohoo
// 	email:	whohoo@21cn.com
// 	date:	Mon Jun 20 13:59:54 2005
//	description:	把原来FChart 1.0转为AS2
//********************************************

/*
* don't remember what it is ?
*/
class com.idescn.data.Chart{

	private var _dataValues:Array		= [];		//dataValues
	private var _dataSum:Number		= 0;		//sum of datas
	private var _dataAddUp:Array		= [];		//data add-up list
	private var _updating:Boolean		= true;		//if updating
	private var _needUpdate:Array		= [];		//list of the elements need to be updated
	
	//读写属性
	function set dataValues(value:Array):Void{
		_assignData("_dataValues", value, "number") 
	}
	function get dataValues():Array{
		return _dataValues;
	}
	
	//只读属性

	function get dataSum():Number{
		return _dataSum;
	}

	
	function get isUpdating():Boolean{
		return _updating;
	}


	/**
	* 构造函数
	*/
	function Chart(){
		
	}
	
	/**
	* 初始化
	*/
	function init():Void{
		endUpdate();
	}
	
	/**
	* assign data
	*/
	private function _assignData(name:String, value:Object, type:String):Void{
		//check data mode
		if (value == null || value == "") {
			this[name]		= null;
		} else if (value instanceof Array) {
			this[name]		= value.slice(0);
		} else if (typeof(value) == "string") {
			var char:String	= value.substr(0, 1);
			if (char == "[") {
				this[name]	= value=="[]" ? [] : value.substr(1, value.indexOf("]")-1).split(",");
			} else if (char == "{") {
				value		= value.substr(1, value.indexOf("}")-1).split(":");
				//var ds:Object		= this.getTarget(value[0], FDataSource);
				var ds:Object	=	null;
				if (ds == null) {
					trace("Error: The target data source '" + value[0] + "' does not exist!");
					return;
				}
				ds.addListener(value[1], this, {name:name, type:type});
				this[name]	= ds.getColumn(value[1]);
			} else {
				this[name]	= type=="number" ? Number(value) : type=="color" ? (parseInt(value)&0xffffff) : value;
			}
		} else {
			this[name]		= type=="number" ? Number(value) : type=="color" ? (parseInt(value)&0xffffff) : String(value);
		}

		//adjust data type
		if (name == "_dataValues") {
			if (_dataValues == null) {
				_dataValues	= [];
			} else if (!(_dataValues instanceof Array)) {
				_dataValues	= [_dataValues];
			} else {
				for (var i:String in _dataValues) _dataValues[i] = Number(_dataValues[i]);
			}
			_pretreatData();
		} else if (this[name] instanceof Array) {
			value			= this[name];
			if (type == "number") {
				for (var i:String in value) value[i] = Number(value[i]);
			} else if (type == "color") {
				for (var i:String in value) value[i] = parseInt(value[i]) & 0xffffff;
			} else {
				for (var i:String in value) value[i] = String(value[i]);
			}
			_isArray[name]		= true;
		} else {
			_isArray[name]		= false;
		}
		refreshAll();
	};
	
	/**
	* pretreat data (add them up by default)
	*/
	private function _pretreatData():Void {
		this._dataSum			= 0;
		this._dataAddUp			= [];
		var num					= this._dataValues.length;
		for (var i = 0; i < num; i++) {
			this._dataAddUp[i]	= this._dataSum;
			this._dataSum		+= this._dataValues[i];
		}
	};

	/**
	* update data (for data source callback)
	*/
	private function updateData(id:Object, column:String):Void{
		_assignData(id.name, column, id.type);
	};
	
	/**
	* begin update settings
	*/
	public function beginUpdate():Void {
		_updating		= true;
	};

	/**
	* end update settings and refresh view
	*/
	public function endUpdate():Void {
		_updating		= false;
		refresh();
	};

	/**
	* refresh view (virtual, must be overrided)
	*/
	public function refresh():Void{
		
	}

	/**
	* refresh all
	*/
	public function refreshAll(pretreatData:Boolean):Void {
		_needUpdate	= "all";
		if (pretreatData){
			_pretreatData();
		}
		refresh();
	};
}