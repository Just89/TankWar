package ui.pages 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tank.expansions.Block;
	import tank.expansions.ExpansionLibrary;
	import tank.Tank;
	import ui.pages.BaseScreen;
	/**
	 * ...
	 * @author Just
	 */
	public class BuildTankScreen extends BaseScreen
	{
		private var _tank:Tank;
		private var _currentBlock:Block;
		private var _sprite:Sprite;
		private var _totalPoints:int;

		private var textFormat:TextFormat;
		private var totalPointsText:TextField;
		
		public function BuildTankScreen(name:String) 
		{
			super(name);

			if (this.name == "Player 2")
			{
				_tank = new Tank(true);
			}else {
				_tank = new Tank(false);
			}

			addEventListener(Event.ADDED_TO_STAGE, onStage);
			
			_sprite = new Sprite();
			addChild(_sprite);
			
			_sprite.scaleX = _sprite.scaleY = Config.LEVEL_ZOOMED_IN;
			
			_sprite.addChild(_tank);
			
			var allBlocks:Vector.<Block> = ExpansionLibrary.instance.blocks.concat(ExpansionLibrary.instance.weapons);
			var i:int = 0;
			for each(var block:Block in allBlocks)
			{
				if (block.title == "cabine")
				{
					continue;
				}
				block = block.clone();
				block.x = 10;
				block.y = 10 + i * 14;
				
				if (i > 4)
				{
					block.x = 100;
					block.y = -60 + i * 14;
				}
				textFormat = Config.format;
				textFormat.size = 4;
				
				// Add a textfield with the block title
				var titleField:TextField = new TextField();
					titleField.defaultTextFormat = textFormat;
					titleField.text = block.title;
					titleField.x = block.x + 18;
					titleField.y = block.y;
					titleField.selectable = false;
				_sprite.addChild(titleField);

				// Add a textfield with the block health and cost
				var popField:TextField = new TextField();
					popField.defaultTextFormat = textFormat;
					popField.text = "Costs: " + block.cost + " - Health: " + block.health;
					popField.x = block.x + 18;
					popField.y = block.y + 5;
					popField.selectable = false;
				_sprite.addChild(popField);
				
				_sprite.addChild(block);	
				
				block.addEventListener(MouseEvent.CLICK, onClick);
				block.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				i++;
			}
			
			var cabine:Block = ExpansionLibrary.instance.blocks[5];
				cabine.x = _tank.containers[4].x;
				cabine.y = _tank.containers[4].y;
			_tank.containers[4].block = cabine;
			
			_tank.updateBlock(cabine, _tank.containers[4]);
			
			_sprite.addChild(cabine);
			
			addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function offStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, offStage);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			if (_currentBlock != null)
			{
				_currentBlock.removeEventListener(MouseEvent.MOUSE_DOWN, onCloneDown);
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		private function onUp(e:MouseEvent):void 
		{
			//stopdrag
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			_currentBlock.stopDrag();
			
			if (_tank.onStopDragBlock(_currentBlock) == false)
			{
				_sprite.removeChild(_currentBlock);
				
			}else {
				_currentBlock.addEventListener(MouseEvent.MOUSE_DOWN, onCloneDown);
				
				totalPointsText.text = "Points left: " + (_totalPoints - _currentBlock.cost);
				_totalPoints = _totalPoints - _currentBlock.cost;
			}
		}
		
		private function onCloneDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);

			_currentBlock = e.currentTarget as Block;
	
			_currentBlock.startDrag();
			_tank.onDragBlock(_currentBlock);
		
			totalPointsText.text = "Points left: " + (_totalPoints + _currentBlock.cost);
			_totalPoints = _totalPoints + _currentBlock.cost;
			
		}
		
		private function onDown(e:MouseEvent):void 
		{
			if (_totalPoints < e.currentTarget.cost)
			{
				return;
			}
			_currentBlock = (e.currentTarget).clone();
			_currentBlock.x = Block(e.currentTarget).x;
			_currentBlock.y = Block(e.currentTarget).y;
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_sprite.addChild(_currentBlock);
			
			_currentBlock.startDrag();
			
			_tank.onDragBlock(_currentBlock);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			(_currentBlock.title, _currentBlock.health);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			totalPointsText = new TextField();
			totalPointsText.defaultTextFormat = textFormat;
			totalPointsText.text = String("Points left: " + _totalPoints);
			totalPointsText.autoSize = TextFieldAutoSize.LEFT;
			totalPointsText.x = 10;
			totalPointsText.y = 0;
			_sprite.addChild(totalPointsText);
			
			_tank.x = (stage.stageWidth / 2 - 250 - _tank.tankImage.width) / 4;
			_tank.y = (stage.stageHeight - stage.stageHeight / 4) / 4;
		}
		
		public function get tank():Tank {	return _tank;	}
		
		public function set totalPoints(value:int):void 
		{
			_totalPoints = value;
		}
	}

}