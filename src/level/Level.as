package level 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import tank.Tank;
	
	/**
	 * ...
	 * @author Automatic
	 */
	public class Level extends Sprite 
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _tapTime:int;
		
		private var _tank:Tank;
		
		private var _clouds:Clouds;
		[Embed(source = "../../lib/berg.png")]
		private var Mountain:Class;
		
		private var _mountain:Bitmap;
		
		[Embed(source = '../../lib/DeadSpace.png')]
		private var DeadSpaceAsset:Class;
			
		private var _sprite:Sprite = new Sprite();
		
		private var _cactussus:Array = new Array();
		
		public function Level(width:Number, height:Number, _tank:Tank) 
		{
			this._tank = _tank;
			_height = height;
			_width = width;
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			
			scaleX = scaleY = Config.LEVEL_ZOOMED_OUT;
			
			graphics.beginFill(0x0080C0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			_sprite.graphics.beginBitmapFill(new DeadSpaceAsset().bitmapData);
			_sprite.graphics.drawRect(0, height - Config.DEAD_SPACE, width, Config.DEAD_SPACE);
			_sprite.graphics.endFill();
			
			addChild(_sprite);
			
			spawnCactusses();
			
			_mountain = new Mountain();
			_mountain.width = width / 4;
			_mountain.height = height / 4;
			_mountain.smoothing = true;
			_mountain.x = width / 2 - (_mountain.width / 2);
			_mountain.y = height - (_mountain.height - 30);
			addChild(_mountain);
			
			_clouds = new Clouds(width, height);
			addChild(_clouds);
			
			_tank.addEventListener(TouchEvent.TOUCH_TAP, onTap);
			
			CONFIG::debug
			{
				_tank.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ 
											_tank.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_TAP, true, false, 0, false, e.localX, e.localY))
										});
			}
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
		}
		
		private function onKeydown(e:KeyboardEvent):void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			dancingCactussus();
		}
		
		public function dancingCactussus():void 
		{
			var mySound:Sound = new Sound();
				mySound.load(new URLRequest("Mexican Music.mp3"));
				mySound.play();
			for each (var value:Cactus in _cactussus)
			{
				value.dance();
			}
		}
		
		private function spawnCactusses():void 
		{
			var numberOfCactussus:int = Math.round(Math.random() * Config.MAX_NUMBER_OF_CACTUSSUS) + 1;
			
			for (var i:int = 0; i < numberOfCactussus; i++)
			{
				var tmpCactus:Cactus = new Cactus();
				tmpCactus.x = (Math.random() * _width);
				tmpCactus.y = height - (tmpCactus.height-15) - Config.DEAD_SPACE;
				_cactussus.push(tmpCactus);
				addChild(tmpCactus);
			}
		}
		
		private function onTap(e:TouchEvent):void 
		{
			if (_tapTime != 0 && getTimer() - _tapTime < Config.CLICK_TIME)
			{
				if (scaleX == Config.LEVEL_ZOOMED_OUT)
				{
					scaleX = scaleY = Config.LEVEL_ZOOMED_IN;
				}
				else
				{
					scaleX 	= scaleY 	= Config.LEVEL_ZOOMED_OUT;
				}
				
				_tapTime = 0;
			}
			_tapTime = getTimer();
		}
		
		public function repositionLevel():void
		{
			if (scaleX == Config.LEVEL_ZOOMED_IN)
			{
				x = -(_tank.x * scaleX - (_width / 2 - ((_tank.tankImage.width / 2) * scaleX)));
				if (x > 0)
				{
					x = 0;
				}
				if (x < -(_width * scaleX) + _width)
				{
					x = -(_width * scaleX) + _width;
				}
				
				y = ((scaleY * _tank.y) - (scaleY * (_tank.y * scaleY))) / scaleY - /*LELIJK*/48;
			}
			else
			{
				x 		= y 		= 0;
			}
		}
		
		public function get bounds():Rectangle
		{
			var x:Number = -(_width * scaleX) + _width;
			var y:Number = -(_height * scaleY) + _height;
			
			var rectangle:Rectangle = new Rectangle();
				rectangle.width =  - x;
				rectangle.height =  - y;
				rectangle.x = x;
				rectangle.y = y;
			return rectangle;
		}
	}
}