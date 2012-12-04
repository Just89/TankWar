package tank.expansions.weapon 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import tank.expansions.Block;
	/**
	 * ...
	 * @author Just
	 */
	public class Weapon extends Block
	{
		private var _wFileName:String;
		private var _wTitle:String;
		private var _wCost:int;
		private var _cd:int;
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		private var _gestureLines:int;
		private var _gestureTime:Number;
		private var _damage:int;
		private var _className:String;
		
		public function Weapon() 
		{			
			_bitmap = new Bitmap(null, "auto", true);
			_bitmap.scaleX = _bitmap.scaleY = 0.1;
			
			super();
			
			addChild(_bitmap);
		}
		
		override public function load():void
		{
			super.load();
			
			_bitmapData = new BitmapData(140, 140, true, 0x000000);
			
			var file:File = File.applicationDirectory.resolvePath("assets\\weapons\\" + _wFileName + ".png");
			var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.load(new URLRequest(file.nativePath));
		}
		
		override public function clone():Block
		{
			var weapon:Weapon = new Weapon();
				weapon.id = id;
				weapon.title = title;
				weapon.health = health;
				weapon.cd = _cd;
				weapon.fileName = fileName;
				weapon.files = files;
				weapon.bitmapDatas = _bitmapDatas; 	//blocks data
				weapon.bitmapData = _bitmapData;	//weapons data
				weapon.w_fileName = _wFileName;
				weapon.w_cost = _wCost;
				weapon.cost = _cost;
				weapon.w_title = _wTitle;
				weapon.gesturelines = _gestureLines;
				weapon.gesturetime = _gestureTime;
				weapon.damage = _damage;
				weapon.classname = _className;
			return weapon;
		}
		
		override protected function onStage(e:Event):void 
		{
			super.onStage(e);
			
			_bitmap.bitmapData = _bitmapData;
		}
		
		private function onComplete(e:Event):void 
		{
			e.target.loader.removeEventListener(Event.COMPLETE, onComplete);
			var source:BitmapData = e.target.content.bitmapData as BitmapData;
			_bitmapData.draw(source);			
			source.dispose();
		}
		
		public function set w_fileName(value:String):void 				{	if (!_lock) { _wFileName = value;	} else { throw(_error) 	}	}	
		public function set w_title(value:String):void					{	if (!_lock) { _wTitle = value;		} else { throw(_error) 	}	}
		public function set w_cost(value:int):void 						{	if (!_lock) { _wCost = value;		} else { throw(_error) 	}	}
		public function set blockid(value:int):void						{	if (!_lock) { 						} else { throw(_error) 	}	}		
		public function set bitmapData(value:BitmapData):void 			{	if (!_lock) { _bitmapData = value;	} else { throw(_error) 	}	}
		public function set cd(value:int):void 							{	if (!_lock) { _cd = value;			} else { throw(_error) 	}	}
		public function set gesturelines(value:int):void 				{	if (!_lock) { _gestureLines = value;} else { throw(_error) 	}	}
		public function set gesturetime(value:Number):void 				{	if (!_lock) { _gestureTime = value;	} else { throw(_error) 	}	}
		public function set damage(value:int):void 						{	if (!_lock) { _damage = value;		} else { throw(_error) 	}	}
		public function set classname(value:String):void 				{	if (!_lock) { _className = value;	} else { throw(_error) 	}	}
		
		override public function get cost():int 
		{	
			return super.cost + _wCost;	
		}
		
		public function get wTitle():String 
		{
			return _wTitle;
		}
		
		public function get cd():int 
		{
			return _cd;
		}
		
		public function get gestureTime():Number 
		{
			return _gestureTime;
		}
		
		public function get gestureLines():int 
		{
			return _gestureLines;
		}
		
		public function get damage():int 
		{
			return _damage;
		}
		
		public function get className():String 
		{
			return _className;
		}
	}
}