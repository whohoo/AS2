//******************************************************************************
//	name:	IObject3D 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Aug 29 17:32:23 2006
//	description: 
//******************************************************************************

/**
 * 在chevroler游戏中3D物体所要implement的类
 * <p></p>
 * 在3D物体类中所implement的方法有:<br></br>
 * 
 * <ul>
 * <li>moveTo</li>
 * <li>render</li>
 * <li>drawMC</li>
 * <li>toString</li>
 * </ul>
 * 除此之外,还有addEventListener与removeEventListener两广播事件
 * 
 */
interface  com.wlash.games.chevroler.IObject3D{

	/**
	 * 在三维方向的三个方向移动的距离
	 * @param x X轴方向的移动距离
	 * @param y Y轴方向的移动距离
	 * @param z Z轴方向的移动距离
	 */
	public function moveTo(x:Number, y:Number, z:Number):Void;
	
	/**
	 * 把物体的3D位置转为2D的位置,然后并在屏幕上显示出来
	 */
	public function render():Void;
	
	/**
	 * 把3D物体的外框显示表现出来.<p></p>
	 * 主要是程序测试时使用.
	 */
	public function drawMC():Void;
	
	/**
	 * 显示当前物体的3D座标
	 */
	public function toString():String;
}

