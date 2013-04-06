/*utf8*/
//**********************************************************************************//
//	name:	SimpleMC2 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sat Nov 22 2008 23:32:28 GMT+0800
//	description: This file was created by "createClass3.fla" file.
//		
//**********************************************************************************//



package com {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.media.Video;
	import com.wlash.loader.ContentLoader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * SimpleMC2.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SimpleMC2 extends MovieClip {
		
		public var g_b_btn:SimpleButton;//LAYER NAME: "Layer 1", FRAME: [1-6], PATH: SimpleMC2/graphic|0
		public var g_a1_mc:MovieClip;//LAYER NAME: "Layer 1", FRAME: [1-6], PATH: SimpleMC2/graphic|0
		public var g_ccb:Sprite;//LAYER NAME: "Layer 1", FRAME: [1-6], PATH: SimpleMC2/graphic|0
		public var cccBtn_btn:SimpleButton;//LAYER NAME: "graphic", FRAME: [1-6], PATH: SimpleMC2
		public var a2_btna:MovieClip;//LAYER NAME: "graphic", FRAME: [1-6], PATH: SimpleMC2
		public var expor:ExportMCmoveInOutSymbol;//LAYER NAME: "Layer 4", FRAME: [1-6], PATH: SimpleMC2
		public var ccca:Sprite;//LAYER NAME: "Layer 4", FRAME: [1-6], PATH: SimpleMC2
		public var b_mc:Sprite;//LAYER NAME: "Layer 3", FRAME: [1-6], PATH: SimpleMC2
		public var input_a:TextField;//LAYER NAME: "Layer 3", FRAME: [1-4], PATH: SimpleMC2
		public var aa_video:Video;//LAYER NAME: "Layer 3", FRAME: [1-4], PATH: SimpleMC2
		public var a2_mc:MovieClip;//LAYER NAME: "Layer 3", FRAME: [1-4], PATH: SimpleMC2
		public var loader_mc:ContentLoader;//LAYER NAME: "Layer 5", FRAME: [1-6], PATH: SimpleMC2
		public var b_txt:TextField;//LAYER NAME: "Layer 2", FRAME: [1-6], PATH: SimpleMC2
		public var a_txt:TextField;//LAYER NAME: "Layer 2", FRAME: [4-6], PATH: SimpleMC2
		public var a_mc:Sprite;//LAYER NAME: "Layer 1", FRAME: [4-6], PATH: SimpleMC2

		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SimpleMC2();]
		 */
		public function SimpleMC2() {
			
			init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function init():void {
			_initBtnEvents();
		}
		
		/**
		 * initialize SimpleButton events.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _initBtnEvents():void {
			g_b_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			g_b_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false, 0, false);
			g_b_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false, 0, false);
			
			cccBtn_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			cccBtn_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false, 0, false);
			cccBtn_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false, 0, false);
			
		};
		
		/**
		 * SimpleButton click event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onClickBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "g_b_btn" : 
					trace('eventType: ' + e.type + ', name: ' + g_b_btn.name);
				break;
				case "cccBtn_btn" : 
					trace('eventType: ' + e.type + ', name: ' + cccBtn_btn.name);
				break;
			};
		};
		
		/**
		 * SimpleButton rollover event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOverBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "g_b_btn" : 
					trace('eventType: ' + e.type + ', name: ' + g_b_btn.name);
				break;
				case "cccBtn_btn" : 
					trace('eventType: ' + e.type + ', name: ' + cccBtn_btn.name);
				break;
			};
		};
		
		/**
		 * SimpleButton rollout event.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOutBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "g_b_btn" : 
					trace('eventType: ' + e.type + ', name: ' + g_b_btn.name);
				break;
				case "cccBtn_btn" : 
					trace('eventType: ' + e.type + ', name: ' + cccBtn_btn.name);
				break;
			};
		};

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class
//This template is created by whohoo. ver 1.2.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="1", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;


*/
