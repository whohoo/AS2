//***************************************
//	class:	PlayingCard 1.0
// 	author:	whohoo
// 	email:	whohoo@21cn.com
// 	date:	Tue Aug 09 18:05:11 2005
//	description: 扑克牌游戏引擎
//***************************************

/**
* a base playing card game engine
* <p></p>
* there are not test this class.
*/
class com.idescn.games.PlayingCard{
	//default cards
	private var _suits:Array		=	["Spade","Heart","Club","Diamond"];
	private var _cardNames:Array	=	["2","3","4","5","6","7","8","9","10","J","Q","K","A"];
	private var _joker:Array		=	["A","B"];
	private var _deck:Array			=	[];
	private var _isJoker:Boolean	=	false;
	////属性存取方法
	[Inspectable(defaultValue="" type=String)]
	function set suits(s:Array):Void{
		if(s.length!=4){
			throw new Error("Error: length is wrong!["+s+"]");
		}
		var str:String	=	s.join("");
		if(str.indexOf("s") && str.indexOf("h") && str.indexOf("c") && str.indexOf("d")){
			throw new Error("Error: length is wrong!["+s+"]");
		}
		_suits	=	s.slice();
		init();
	}
	function get suits():String{
		
		return ""
	}
	
	/**
	* contruct function.
	*/
	public function PlayingCard(){
		init();
	}
	
	//******************[PRIVATE METHOD]******************//
	/**
	 * initialize
	 */
	private function init():Void{
		var suits:Array		=	_suits;
		var cardNames:Array	=	_cardNames;
		var len0:Number	=	suits.length;
		var len1:Number	=	cardNames.length;
		var i:Number		=	0;
		var k:Number		=	0;
		
		while(i<len0){
			k	=	0;
			while(k<len1){
				_deck.push([k,i]);
				k++;
			}
			i++;
		}
		
		if(_isJoker){
			_deck.push([0],[1]);
		}
	}
	
	//******************[PUBLIC METHOD]******************//
	/**
	* shuffle the cards
	* 
	*/
	public function shuffle():Void{
		var deck:Array	=	_deck;
		var i:Number	=	deck.length;
		var temp:Array	=	null;
		var ran:Number	=	null;
		
		while(i--){
			temp	=	deck[i];
			ran		=	Math.round(Math.random()*i);
			deck[i]	=	deck[ran];
			deck[ran]	=	temp;
		}
	}
	/**
	* get the card name 
	* @param index
	* @throws Error if there is a failure in not cards in game
	* @return card name
	*/
	public function getCard(index:Number):String{
		var deck:Array	=	_deck;
		var n:Number	=	Math.max(0,Math.min(deck.length,index));
		var card:Array	=	deck[n];
		if(card.length==1){
			return	_joker[card[0]];
		}else if(card.length==2){
			return	_cardNames[card[0]]+"_"+_suits[card[1]];
		}else{
			throw new Error("ERROR: wrong card : "+card);
		}
	}
	
	/**
	* list all card name
	* @return all card name
	*/
	public function listAllCard():String{
		var out:String	=	"";
		var len:Number	=	_deck.length;
		var i:Number	=	0;

		while(i<len){
			out	+=	getCard(i)+", ";
			i++;
		}
		return out;
	}
	
	/**
	 * show this class name
	 * @return  class name
	 */
	public function toString():String{
		return "[Playing Card Game]";
	}
}