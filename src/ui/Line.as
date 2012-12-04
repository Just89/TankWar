package ui 
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Line extends Sprite 
	{
		
		public function Line() 
		{
			graphics.lineStyle(4);
			graphics.lineTo(0, 10000);
		}
		
	}

}