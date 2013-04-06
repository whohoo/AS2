//******************************************************************************
//	class:	MusicBox 1.0
//	author:	whohoo
//	email:	whohoo@21cn var com
//	date:	Wed Nov 02 11:06:34 2005
//	description:	把FMuicBox 1 var 0转为AS2
//******************************************************************************


import mx.events.EventDispatcher;

[IconFile("musicBox.png")]
/**
* COMPONENT [MusicBox].<br></br>
* playing sound by mousic note.
* <p></p>
* * you could drag musicBox from component panel(Ctrl+F7) in flash to stage<br></br>
* and define properties in Parameters panel(Alt+F7).<br></br>
* <b>Parameters:</b>
* <ul>
* <li><b>autoStart:</b> true of false</li>
* <li><b>baseNote:</b> the base note, must use absolute scale </li>
* <li><b>loopTimes:</b> loop times of playing, negative for nonstop</li>
* <li><b>noteInterval:</b> the time interval between two notes in the sound (in milliseconds)</li>
* <li><b>noteList:</b> the list of notes that the sound contains, must use absolute scale</li>
* <li><b>noteTail:</b>the time length of the note's fade out tail (in milliseconds)</li>
* <li><b>tempo:</b> the tempo of the music (paces per minute)</li>
* <li><b>vaolume:</b> default volume</li>
* </ul>
* <p></p>
* there are few of dispatchEvents, you could add those events by addEventListener(event,handler)<br>
* <ul>
* <li>onPlayNote({note,len}): when playing </li>
* <li>onPlay({}): when start play </li>
* <li>onPause({}): when pause </li>
* <li>onStop({}): when stop </li>
*/
class com.idescn.sound.MusicBox extends MovieClip{
	
	private var Container:MovieClip	=	null;//音符影片在里边
	private var _music:String			=	"";//store play music note
	private var _baseNote:Number		=	13;//the base note, must use absolute scale
	private var _tempo:Number			=	100;//the tempo of the music (paces per minute)
	private var _autoStart:Boolean		=	true;//if automatically start playing when music is changed
	private var _loopTimes:Number		=	0;//loop times of playing, negative for nonstop
	private var _noteSoundId:String	=	"DefaultNotes";//the id of the sound that contains all the notes
	private var _noteList:Object		=	{};//the list of notes that the sound contains, must use absolute scale
	private var _noteInterval:Number	=	4800;//the time interval between two notes in the sound (in milliseconds)
	private var _noteTail:Number		=	200;//the time length of the note's fade out tail (in milliseconds)
	private var _volume:Number			=	100;//default volume
	
	//the notes array parsed from music string
	private var _notes:Array			=	[];
	//time of one pace (in milliseconds)
	private var _paceTime:Number		=	600;
	//the sound object that controls the music
	private var _sound:Sound			=	null;
	//temp autoStart parameter
	private var _tempAutoStart:Boolean	=	true;
	//depth of the new created note container movie clip
	private var _noteDepth:Number		=	0;
	//current note index of playing
	private var _curNote:Number		=	0;
	//current loop index of playing
	private var _curLoop:Number		=	0;
	//current delay time before next note plays (in milliseconds)
	private var _curDelay:Number		=	0;
	//timer used for playing
	private var _timer:Number			=	0;
	//if it is currently playing
	private var _playing:Boolean		=	false;
	
	//the note names
	static var noteNames:Array			=	["1", "1#", "2", "2#", "3", "4", "4#", "5", "5#", "6", "6#", "7"];
	//the note values of the normal notes
	static var noteValues:Object		=	{n1:1, n2:3, n3:5, n4:6, n5:8, n6:10, n7:12};
	
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
	private static var __mixinFED =	EventDispatcher.initialize(MusicBox.prototype);
	
	//*************属性存取方法************//
	
	[Inspectable(defaultValue="", type=String )]
	function set music(value:String):Void{
		parseMusic(value);
	}
	/**the music string	*/
	function get music():String{
		return _music;
	}
	
	
	[Inspectable(defaultValue="B1", type=String)]
	function set baseNote(value:String):Void{
		var baseChange:Number	= noteToValue(String(value)) - _baseNote;
		if (baseChange > 0 || baseChange < 0) {
			var notes:Array		= _notes;
			for (var i in notes) {
				if (notes[i].note != 0) notes[i].note += baseChange;
			}
			_baseNote	+= baseChange;
		}
		
	}
	/**the base note*/
	function get baseNote():String{
		return valueToNote(_baseNote);
	}
	
	[Inspectable(defaultValue=100, type=Number)]
	function set tempo(value:Number):Void{
		if (!(value > 0)){
			return;
		}
		_tempo			= Number(value);
		_paceTime		= 60000 / _tempo;
	}
	/**the tempo of the music*/
	function get tempo():Number{
		return _tempo;
	}
	
	[Inspectable(defaultValue=true, type=Boolean)]
	function set autoStart(value:Boolean):Void{
		_autoStart		=	value;
		if(_autoStart){
			if(!_playing){
				playMusic(0);
			}
		}
	}
	/**if automatically start playing when music is changed	*/
	function get autoStart():Boolean{
		return _autoStart;
	}
	
	[Inspectable(defaultValue=0, type=Number)]
	function set loopTimes(value:Number):Void{
		_loopTimes	=	Math.round(value);
	}
	/**loop times of playing*/
	function get loopTimes():Number{
		return _loopTimes;
	}
	
	[Inspectable(defaultValue=100, type=Number, verbose=1)]
	function set volume(value:Number):Void{
		_volume		=	value;
		_sound.setVolume(value);
	}
	/**volume of the music	*/
	function get volume():Number{
		return _volume;
	}
	
	[Inspectable(defaultValue="DefaultNotes", type=String, verbose=1)]
	function set noteSoundId(value:String):Void{
		_noteSoundId	=	value;
	}
	/**the id of the sound that contains all the notes	*/
	function get noteSoundId():String{
		return _noteSoundId;
	}
	
	[Inspectable(defaultValue="A5,A6,A7,B1,B2,B3,B4,B5,B6,B7,C1,C2,C3,C4,C5,C6,C7,D1", type=String, verbose=1)]
	function set noteList(value:Object):Void{
		_noteList		= {};
		if (typeof(value) == "string"){
			value = value.split(",");
		}
		for (var i:String in value) {
			var note:Number	= noteToValue(value[i]);
			_noteList[note]		= Math.round(Number(i));
		}
		
	}
	/**the list of notes that the sound contains*/
	function get noteList():Object{
		var noteList		= [];
		for (var i:String in _noteList){
			noteList[_noteList[i]] = valueToNote(Number(i));
		}
		return	noteList;
	}
	
	
	[Inspectable(defaultValue=4800, type=Number, verbose=1)]
	function set noteInterval(value:Number):Void{
		_noteInterval = Math.round(value);
	}
	/**the time interval between two notes in the sound	*/
	function get noteInterval():Number{
		return _noteInterval;
	}
	
	
	[Inspectable(defaultValue=200, type=Number, verbose=1)]
	function set noteTail(value:Number):Void{
		_noteTail =		Math.round(value);
	}
	/**the time length of the note's fade out tail	*/
	function get noteTail():Number{
		return _noteTail;
	}
	
	//*****************只读属性**************//
	/**the notes in the music	*/
	function get notes():Array{
		return _notes;
	}
	/**total number of notes	*/
	function get totalNotes():Number{
		return _notes.length;
	}
	/**current note index of playing	*/
	function get curNote():Number{
		return !_playing ? _curNote : _curNote==0 ? _notes.length-1 : _curNote-1;
	}
	/**current loop index of playing	*/
	function get curLoop():Number{
		return _curLoop - (_playing && _curNote==0) ? 1 : 0;
	}
	/**if it is currently playing	*/
	function get isPlaying():Boolean{
		return _playing && onEnterFrame != null;
	}
	/** if it is currently paused	*/
	function get isPaused():Boolean{
		return _playing && onEnterFrame == null;
	}
	
	
	/**
	* contruct function.
	*/
	private function MusicBox(){
		init();
		if (_autoStart){
			playMusic(0);
		}
	}
	
	//***************[PRIVATE METHOD]*****************//
	/**
	* initialize
	*/
	private function init():Void{
		var mc:MovieClip	=	this["icon_mc"];
		mc.swapDepths(11000);
		mc.removeMovieClip();
		Container	=	this.createEmptyMovieClip("mcContainer",100);
		_sound		=	new Sound(this);
	}
	
	/**
	* onEnterFrame event handler of note container movie clip
	*/
	private function _noteEnterFrame():Void{
		var note_mc:MovieClip		=	this;//Contantor内的各音符影片
		var time:Number			=	getTimer()- note_mc.timer;
		if (time <= note_mc.len){
			return;
		}
		if (time >= note_mc.len + note_mc.tail) {
			note_mc.snd.stop();
			note_mc.removeMovieClip();
		} else {
			note_mc.snd.setVolume((note_mc.len+note_mc.tail-time) / note_mc.tail * 100);
		}
	};

	/**
	* onEnterFrame event handler of music playing
	*/
	private function _onEnterFrame():Void{
		var timer:Number	=	getTimer();
		_curDelay			-=	timer - _timer;
		_timer				=	timer;
		while (_curDelay <= 0) {
			if (_loopTimes>=0) {
				if(_curLoop>_loopTimes){
					_curNote	= 0;
					_curLoop	= 0;
					_playing	= false;
					delete this.onEnterFrame;
					dispatchEvent({type:"onStop"});
					return;
				}
			}
			var note		= _notes[_curNote++];
			_curDelay	+= note.delay * _paceTime;
			if (_curNote >= _notes.length) {
				_curNote	= 0;
				_curLoop++;
			}
			playNote(note);
		}
	};
	
	//***************[PUBLIC METHOD]*****************//
	/**
	* note value to note name (in absolute scale)
	* @param	value 
	* @return	note
	*/
	public function valueToNote(value:Number):String{
		value	=	Math.round(value);
		if (value >= 1) {
			if(value <= 312){
				return String.fromCharCode(Math.round((value-1)/12)+65) + 
						MusicBox.noteNames[(value-1)%12];
			}
		} else {
			return "0";
		}
	};

	/**
	* note name (in absolute scale) to note value
	* @param	note
	* @return	value
	*/
	public function noteToValue(note:String):Number {
		var value:Number	= 0;
		var c:Number		= note.charCodeAt(0);
		if (c >= 65 && c <= 90) {
			value	= (c-65) * 12;
			note	= note.substr(1);
		}
		var char:String		= note.charAt(1);
		return value + (char=="b" ? -1 : char=="#" ? 1 : 0) + 
					MusicBox.noteValues["n"+note.charAt(0)];
	};

	/**
	* parse music string to notes array
	*/
	public function parseMusic(music:String):Void {
		if (typeof(music) != "string") return;
		_music		=	music;
		_notes		=	[];
		var base:Number	=	this._baseNote;
		var len:Number		=	music.length;
		var i:Number		=	 0;
		var j:Number		=	null;
		var b:Number		=	null;
		var c:Number		=	null;
		var char:String	=	null;
		var note:Object	=	null;//{value:number,len:number}
		
		while (i < len) {
			b			= base - 1;
			c			= music.charCodeAt(i++);
			if (c >= 65 && c <= 90) {
				b		= (c-65) * 12;
				c		= music.charCodeAt(i++);
			}
			if (c >= 48 && c <= 57) {
				note	= {value: c==48 ? 0 : b + MusicBox.noteValues["n"+(c-48)]};
				char	= music.charAt(i++);
				if (char == "b" || char == "#") {
					if (note.value != 0) note.value += char=="b" ? -1 : 1;
					char	= music.charAt(i++);
				}
				if (char=="-" || char=="_" || char=="=" || char==">") {
					note.len		= char=="-" ? 1 : 0;
					do {
						note.len	+= char=="-" ? 1 : char=="_" ? 1/2 : char=="=" ? 1/4 : 1/8;
						char			= music.charAt(i++);
					} while (char=="-" || char=="_" || char=="=" || char==">");
				} else {
					note.len		= 1;
				}
				if (char == "~") {
					note.delay		= 0;
				} else {
					note.delay		= note.len;
					i--;
				}
				_notes.push(note);
			} else if (c == 94 || c == 118) {
				base	+= c == 94 ? 12 : -12;
			} else if (c == 91) {
				j		= music.indexOf("]", i);
				if (j == -1) j = len;
				i		= j + 1;
			}
		}
		
		if (_autoStart){
			playMusic(0);
		}
	};
	
	/**
	* play note
	* @param	note note is the note that wanna play
	* @len	len len is the length of note.
	*/
	function playNote(note:Object,len:Number):Void{
		if (note == null){
			return;
		}
		if (typeof(note) == "string") {
			note		= noteToValue(note.toString());
		} else if (typeof(note) == "object") {
			len			= note.len;
			note		= note.value;
		}
		dispatchEvent({type:"onPlayNote",note:note,len:len});
		
		if (_noteList[note] == null){
			return;
		}
		
		var mc:MovieClip	= Container.createEmptyMovieClip("s"+String(_noteDepth), _noteDepth);
		_noteDepth++;
		mc.timer		= getTimer();
		mc.len			= len * _paceTime;
		if (mc.len > _noteInterval-200) mc.len = _noteInterval-200;
		mc.tail			= _noteTail;
		if (mc.len + mc.tail > _noteInterval-200){
			mc.tail = _noteInterval-200 - mc.len;
		}
		mc.onEnterFrame	= _noteEnterFrame;
		mc.snd			= new Sound(mc);
		mc.snd.attachSound(_noteSoundId);
		mc.snd.start(_noteList[note] * _noteInterval/1000);
	}
	
	/**
	* play the music from the specified note index
	* @param	noteIndex
	*/
	public function playMusic(noteIndex:Number):Void {
		if(Container==null){//如果init完成后,Container值不会为null)
			return;
		}
		
		if (noteIndex != undefined) {
			stopMusic();
			_curNote	= noteIndex>0 && noteIndex<_notes.length ? Math.round(noteIndex) : 0;
			_curLoop	= noteIndex >= _notes.length ? 1 : 0;
		}
		_curDelay		= 0;
		_timer			= getTimer();
		onEnterFrame	= _onEnterFrame;
		_playing		= true;
		//this.handleEvent("onPlay");
		dispatchEvent({type:"onPlay"});
		onEnterFrame();
	};

	/**
	* stop the music
	*/
	public function stopMusic():Void {
		for (var i:String in Container) {
			Container[i].snd.stop();
			Container[i].removeMovieClip();
		}
		_curNote		= 0;
		_curLoop		= 0;
		_playing		= false;
		delete onEnterFrame;
		dispatchEvent({type:"onStop"});
	};

	/**
	* pause the music
	* @param toggleMode
	*/
	public function pauseMusic(toggleMode:Boolean):Void{
		if (!_playing){
			return;
		}
		if (toggleMode && onEnterFrame == null) {
			playMusic();
		} else {
			for (var i:String in this.Container) {
				Container[i].snd.stop();
				Container[i].removeMovieClip();
			}
			delete onEnterFrame;
			dispatchEvent({type:"onPause"});
		}
	};
	
	/**
	* 显示类名称
	* @return	名称
	*/
	function toString():String{
		return	"MusicBox 1.0";
	}
}
