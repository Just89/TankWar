package tank
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import network.Package;
	import network.PackageInterface;
	import network.PackageManager;
	import tank.expansions.Block;
	import tank.expansions.Container;
	
	/**
	 * ...
	 * @author Just
	 */
	public class Tank extends Sprite implements PackageInterface
	{
		private var _width:Number = 8;
		private var _height:Number = 4;
		
		[Embed(source="../../lib/tank_fill.png")]
		private var TankAsset:Class;
		
		[Embed(source="../../lib/tank_fill2.png")]
		private var TankAsset2:Class;
		
		private var _tankImage:Bitmap;
		private var _containers:Vector.<Container>;
		
		private var _grid:Sprite;
		private var _packageManager:PackageManager;
		
		private var _airBornBlock:Vector.<Block> = new Vector.<Block>();
		
		public function Tank(enemy:Boolean = false, packageManag:PackageManager = null)
		{
			_packageManager = packageManag;
			
			_grid = new Sprite();
			
			if (enemy == false)
			{
				_tankImage = new TankAsset();
			}
			else
			{
				_tankImage = new TankAsset2();
			}
			
			_tankImage.smoothing = false;
			_tankImage.scaleX = _tankImage.scaleY = 0.2;
			addChild(_tankImage);

			_grid.visible = false;
			addChild(_grid);
			
			_containers = new Vector.<Container>();
			if (enemy)
			{
				for (var x:int = _width; x > 0; x--)
				{
					for (var y:int = 0; y < _height; y++)
					{
						var container:Container = new Container();
						container.x =  - 7 + x * 14;
						container.y = -13 - y * 14;
						container.rectangle.offset(container.x, container.y);
						_grid.addChild(container);
						
						_containers.push(container);
					}
				}
			}
			else
			{
				for (x = 0; x < _width; x++)
				{
					for (y = 0; y < _height; y++)
					{
						container = new Container();
						container.x = 7 + x * 14;
						container.y = -13 - y * 14;
						container.rectangle.offset(container.x, container.y);
						_grid.addChild(container);
						
						_containers.push(container);
					}
				}
			}			
		}
		
		public function onDragBlock(block:Block):void
		{
			_grid.visible = true;
		}
		
		public function onStopDragBlock(block:Block):Boolean
		{
			_grid.visible = false;
			
			var possibleContainer:Container;
			var fromContainer:int = -1;
			var toContainer:int = -1;
			var overlap:Rectangle;
			
			for (var x:int = 0; x < _containers.length; x++)
			{
				if (_containers[x].block == block)
				{
					fromContainer = x;
					_containers[x].block = null;
				}
				
				var containerRect:Rectangle = Rectangle(_containers[x].rectangle).clone();
				containerRect.offset(this.x, this.y);
				
				var blockRect:Rectangle = block.blockRectangle.clone();
				blockRect.offset(block.x, block.y);
				
				if (containerRect.intersects(blockRect))
				{
					if (_containers[x].block == null || _containers[x].block.stage == null)
					{
						var possibleOverlap:Rectangle = containerRect.intersection(blockRect);
					
						if (overlap == null || (possibleOverlap.size.length > overlap.size.length))
						{
							possibleContainer = _containers[x];
							overlap = possibleOverlap;
							toContainer = x;
						}
					}					
				}
			}
			if (possibleContainer != null)
			{
				block.x = possibleContainer.x + this.x;
				block.y = possibleContainer.y + this.y;
				possibleContainer.block = block;
				
				if (fromContainer != -1 && toContainer != -1)
				{
					if (_packageManager != null)
					{
						_packageManager.sendMessage("Tank:repos", fromContainer + "," + toContainer);
					}
				}
				if (fromContainer == -1 && toContainer != -1)
				{
					var arrayPosition:int;
					for (var i:int; i < _airBornBlock.length; i++)
					{
						if (_airBornBlock[i] == block)
						{
							arrayPosition = i;
							_airBornBlock.splice(i, 1);
							break;
						}
					}
					if (_packageManager != null)
					{
						_packageManager.sendMessage("Tank:inTank", toContainer + "," + arrayPosition);
					}					
				}
				return true;
			}
			else
			{
				if (fromContainer != -1)
				{
					if (_packageManager != null)
					{
						_packageManager.sendMessage("Tank:offTank", fromContainer + "," + block.x + "," + block.y);
						_airBornBlock.push(block);
						TweenLite.to(block, 1, {y:(stage.stageWidth/2) - Config.DEAD_SPACE - block.height});
					}					
				}
				
				return false;
			}
		}
		
		override public function set scaleX(value:Number):void 
		{
			super.scaleX = value;
			
			_tankImage.x -= width;
			_grid.x -= width;	
		}
		
		public function receiveMessage(msg:Package):void
		{
			if (msg.type == "Tank:x")
			{
				this.x = stage.stageHeight - _tankImage.width - (Number(msg.message));
			}
			if (msg.type == "Tank:repos")
			{
				var fromContainer:int = msg.message.split(",")[0];
				var toContainer:int = msg.message.split(",")[1];
				
				if (fromContainer != -1 && toContainer != -1)
				{
					var block:Block = _containers[fromContainer].block;
					
					_containers[fromContainer].block = null;
					
					_containers[toContainer].block = block;
					
					_containers[toContainer].block.x = _containers[toContainer].x + this.x;
					_containers[toContainer].block.y = _containers[toContainer].y + this.y;
				}
			}
			if (msg.type == "Tank:offTank")
			{
				fromContainer = msg.message.split(",")[0];
				var offTankBlock:Block = _containers[fromContainer].block;
				
				var toX:int = stage.stageHeight - offTankBlock.width - msg.message.split(",")[1];
				var toY:int = msg.message.split(",")[2];
				
				_containers[fromContainer].block = null;
				
				offTankBlock.x = toX;
				offTankBlock.y = toY;
				TweenLite.to(offTankBlock, 1, {y:(stage.stageWidth/2) - Config.DEAD_SPACE - offTankBlock.height});
				_airBornBlock.push(offTankBlock);
			}
			if (msg.type == "Tank:inTank")
			{
				toContainer = msg.message.split(",")[0];
				var arrayPosition:int = msg.message.split(",")[1];
				
				var inTankBlock:Block = _airBornBlock[arrayPosition];
					inTankBlock.x = _containers[toContainer].x + this.x;
					inTankBlock.y = _containers[toContainer].y + this.y;
					
				_containers[toContainer].block = inTankBlock;
				
				_airBornBlock.splice(arrayPosition, 1);
			}
		}
		
		public function removeBlock(block:Block):void 
		{
			/*for (var i:int = 0; i < _containers.length; i++) 
			{
				if (_containers[i].block != null && _containers[i].block == block)
				{
					_containers[i].block = null;
				}
			}*/
		}
		
		public function updateBlock(cabine:Block, possibleContainer:Container):void 
		{
			cabine.x = possibleContainer.x + this.x;
			cabine.y = possibleContainer.y + this.y;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			
			for (var x:int = 0; x < _containers.length; x++)
			{
				if (_containers[x].block != null)
				{
					_containers[x].block.x = _containers[x].x + this.x;
				}
			}
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			
			for (var x:int = 0; x < _containers.length; x++)
			{
				if (_containers[x].block != null)
				{
					_containers[x].block.y = _containers[x].y + this.y;
				}
			}
		}
		
		public function get tankImage():Bitmap
		{
			return _tankImage;
		}
		
		public function set tankImage(value:Bitmap):void 
		{
			_tankImage = value;
		}
		
		public function get containers():Vector.<Container> 
		{
			return _containers;
		}
	}
}