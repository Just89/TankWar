package tank.expansions
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Just
	 */
	public class Block extends Sprite
	{
		private var _blokRectangle:Rectangle;
		
		protected var _lock:Boolean = false;
		protected var _error:Error = new Error("Lock Error: Can't change this object it is locked");
		
		private var _id:int;
		private var _title:String;
		private var _health:int;
		private var _currentHealth:int;
		private var _fileName:String;
		protected var _bitmapDatas:Vector.<BitmapData>;
		private var _bitmap:Bitmap;
		
		protected var _cost:int;
		
		private var _files:int;
		
		public function Block()
		{
			//dont use constructor yourself clone a existing block from the ExpansionLibary if you need one
			
			_blokRectangle = new Rectangle(0, 0, 14, 14);
			
			_bitmap = new Bitmap(null, "auto", true);
			_bitmap.scaleX = _bitmap.scaleY = 0.1;
			addChild(_bitmap);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			currentHealth -= 1;
		}
		
		protected function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			_bitmap.bitmapData = _bitmapDatas[0];
			
			_currentHealth = health;
		}
		
		public function lock():void
		{
			_lock = true;
		}
		
		public function clone():Block
		{
			var block:Block = new Block();
				block.id = id;
				block.title = title;
				block.health = health;
				block.fileName = fileName;
				block.files = files;
				block.cost = _cost;
				block.bitmapDatas = _bitmapDatas;
			return block;
		}
		
		public function load():void 
		{
			_bitmapDatas = new Vector.<BitmapData>(files, true);
			
			for (var i:int; i < files; i++)
			{
				_bitmapDatas[i] = new BitmapData(140, 140, true, 0x000000);
				
				var file:File = File.applicationDirectory.resolvePath("assets\\blocks\\" + fileName + i.toString() + ".png");
				var loader:Loader = new Loader();
					loader.name = i.toString();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
					loader.load(new URLRequest(file.nativePath));
			}
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			trace(e);
		}
		
		private function onComplete(e:Event):void 
		{
			e.target.loader.removeEventListener(Event.COMPLETE, onComplete);
			var number:int = int(e.target.loader.name);
			
			var source:BitmapData = e.target.content.bitmapData as BitmapData;
			_bitmapDatas[number].draw(source);
			
			source.dispose();
		}
		
		public function get blockRectangle():Rectangle					{	return _blokRectangle;									}
		public function get id():int 									{	return _id;												}
		public function get title():String 								{	return _title;											}				
		public function get health():int 								{	return _health;											}		
		public function get fileName():String 							{	return _fileName;										}
		public function get files():int 								{	return _files;											}	
		public function get currentHealth():int 						{	return _currentHealth;									}
		public function get cost():int 									{	return _cost;											}
		
		public function set title(value:String):void 					{	if (!_lock){ _title = value;} else{ throw(_error) }		}	
		public function set health(value:int):void 						{	if (!_lock){ _health = value;} else{ throw(_error) }	}		
		public function set fileName(value:String):void 				{	if (!_lock){ _fileName = value;} else{ throw(_error) }	}		
		public function set id(value:int):void 							{	if (!_lock){ _id = value;} else{ throw(_error) }		}		
		public function set files(value:int):void 						{	if (!_lock){ _files = value;} else{ throw(_error) }		}		
		public function set bitmapDatas(value:Vector.<BitmapData>):void {	_bitmapDatas = value;									}
		public function set cost(value:int):void 						{	if (!_lock) { _cost = value;} else { throw(_error) }		}
		
		public function set currentHealth(value:int):void 				
		{	
			_currentHealth = value;
			
			if (_currentHealth > 0)
			{
				var spriteNumber:int = files - Math.ceil((_currentHealth / _health) * files);
				_bitmap.bitmapData = _bitmapDatas[spriteNumber];
			}
			else
			{
				//remove block
				dispatchEvent(new Event(Event.REMOVED, true));
				if (parent)
				{
					parent.removeChild(this);
				}
			}			
		}
		
		override public function toString():String
		{
			return "/***\n" + "\tBlock (#" + _id + ")\n" + "\tCost: " + _cost + "\n" + "\tHealth: " + _health + "\n" + "***/\n";
		}
	}
}