package level 
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Automatic
	 */
	public class Clouds extends Sprite 
	{
		private var _cloudBitmaps:Vector.<BitmapData>;
		private var _clouds:Vector.<Cloud>;
		private var _width:Number;
		private var _height:Number;
		
		public function Clouds(width:Number, height:Number) 
		{
			_height = height;
			_width = width;
			_cloudBitmaps = new Vector.<BitmapData>();
			_clouds = new Vector.<Cloud>(Config.NUMBER_OF_CLOUDS_IN_LEVEL, true);
			
			for (var i:int; i < Config.NUMBER_OF_CLOUDS; i++)
			{				
				var file:File = File.applicationDirectory.resolvePath("assets\\clouds\\cloud" + i.toString() + ".png");
				var loader:Loader = new Loader();
					loader.name = i.toString();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					loader.load(new URLRequest(file.nativePath));
			}
		}
		
		private function onComplete(e:Event):void 
		{
			var source:BitmapData = e.target.content.bitmapData as BitmapData;
			
			_cloudBitmaps.push(source);
			
			if (_cloudBitmaps.length == Config.NUMBER_OF_CLOUDS)
			{
				makeClouds();
			}
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void 
		{
			for (var i:int = 0; i < _clouds.length; i++) 
			{
				_clouds[i].update();
			}
		}
		
		private function makeClouds():void 
		{
			for (var i:int; i < Config.NUMBER_OF_CLOUDS_IN_LEVEL; i++)
			{
				var cloud:Cloud = new Cloud(_cloudBitmaps[Math.floor(Math.random() * _cloudBitmaps.length)], _width);
					cloud.x = -200 + (_width + 400) * Math.random();
					cloud.y = Math.random() * (_height - Config.DEAD_SPACE) - 100;
					cloud.scaleX = cloud.scaleY = Math.random() * 0.4 + 0.6;
				addChild(cloud);
				
				_clouds[i] = cloud;
			}
		}
		
		public function startAgain(tween:TweenLite):void 
		{
			tween.restart();
		}
	}
}