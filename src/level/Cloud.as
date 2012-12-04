package level 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Automatic
	 */
	public class Cloud extends Sprite 
	{
		private var _speed:Number;
		private var _width:Number;
		
		public function Cloud(data:BitmapData, width:Number) 
		{
			_speed = Math.random();
			_width = width;
			
			var bmp:Bitmap = new Bitmap(data, "auto", true);
			addChild(bmp);
		}
		
		public function update():void 
		{
			this.x += _speed;
			if (this.x > _width)
			{
				this.x = 0 - this.width;
			}
		}
	}
}