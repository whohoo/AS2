//******************************************************************************
//	name:	ScrollFactory 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon May 22 13:37:31 2006
//	description: 
//******************************************************************************

/**
 * scroll interface,[Deprecated]
 * <p></p>
 * In first, all scroll implement this ScrollFactory,
 * but i create a simple ScrollBar, other scroll would extend that class.<br></br>
 * 
 * 
 */
interface  com.idescn.utils.scroll.ScrollFactory{

	/**
	 * the targetObj are scrolled by scrollBar.<p>
	 * </p>
	 * this is only abstract method. you must implement the method.
	 *  
	 */
	public function update():Void;
	
	/**
	 * render bar_mc size and position, <br>
	 * only when textField maxscroll number change bar_mc size.<br></br>
	 * if percent is null, just render bar_mc size.<p>
	 * </p>
	 * this is only abstract method. you must implement the method.
	 */
	public function render(percent:Number):Void;
	
}

