package  tank.expansions
{
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Just
	 */
	public class Container extends Sprite
	{
		private var _block:Block;
		private var _rectangle:Rectangle;
		
		public function Container() 
		{
			_rectangle = new Rectangle(0, 0, 14, 14);
			
			graphics.lineStyle(2,0x000000,1,false,LineScaleMode.NONE);
			graphics.moveTo(0,0);
			graphics.lineTo(0, 13);
			graphics.lineTo(13,13);
			graphics.lineTo(13, 0);
			graphics.lineTo(0, 0);
			
		//	this.filters = [new BlurFilter(4, 4, 3)];
		}
		
		public function get block():Block 
		{
			return _block;
		}
		
		public function set block(value:Block):void 
		{
			_block = value;
		}
		
		public function get rectangle():Rectangle 
		{
			return _rectangle;
		}
	}
}