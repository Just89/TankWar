package  
{
	import com.greensock.TweenLite;
	import events.GameSettingEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import gestureengine.GestureButton;
	import level.Level;
	import network.Package;
	import network.PackageInterface;
	import network.PackageManager;
	import tank.expansions.Block;
	import tank.expansions.Container;
	import tank.expansions.weapon.Bullet;
	import tank.expansions.weapon.IBullet;
	import tank.expansions.weapon.Weapon;
	import tank.Lever;
	import tank.Tank;
	
	/**
	 * ...
	 * @author Automatic
	 */
	public class Game extends Sprite implements PackageInterface
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _level:Level;
		
		private var _packageManager:PackageManager;
		
		private var _tank:Tank;
		private var _enemyTank:Tank;
		private var _lever:Lever;
		
		private var _gestureButtons:Vector.<GestureButton> = new Vector.<GestureButton>();
		
		private var _bullets:Vector.<IBullet> = new Vector.<IBullet>();
		private var _enemyBullets:Vector.<IBullet> = new Vector.<IBullet>();
		
		private var _moveSound:Sound = new Sound(new URLRequest("sound/movement.mp3"));
		private var _moveSoundChannel:SoundChannel = new SoundChannel();;
		private var speed:Number;
		
		public function Game(width:int, height:int, e:GameSettingEvent) 
		{
			_packageManager = new PackageManager();
			_packageManager.registerObject(this);
			_height = height;
			_width = width;
			
			_tank = new Tank(false, _packageManager);
			_tank.y = _height - Config.DEAD_SPACE - _tank.tankImage.height;
			
			_enemyTank = new Tank(true, _packageManager);
			_enemyTank.y = _height - Config.DEAD_SPACE - _enemyTank.tankImage.height;
			_enemyTank.scaleX *= -1
			
			_packageManager.registerObject(_enemyTank);
			
			_level = new Level(width, height, _tank);
			addChild(_level);

			_level.addChild(_tank);
			_level.addChild(_enemyTank);
			
			_lever = new Lever(e.game);
			_lever.x = _width / 2;
			_lever.y = _height;
			
			addChild(_lever);

			copyTank(_tank, e.tank1);
			copyTank(_enemyTank, e.tank2);
			
			var x:int = 0;
			var y:int = 0;
			
			for (var i:int; i < _tank.containers.length; i++)
			{
				if (_tank.containers[i].block != null)
				{
					if (_tank.containers[i].block is Weapon)
					{
						if (i % 12 == 0)
						{
							x = 0;
							y++;
						}
						
						var gestureButton:GestureButton = new GestureButton(_tank.containers[i].block as Weapon, this);
							gestureButton.scaleX = gestureButton.scaleY = 3;
							//gestureButton.x = x * 50;
							//gestureButton.y = 2 + y * 50;
							
						addChild(gestureButton);
						
						_gestureButtons.push(gestureButton);
						x++
					}
				}
			}
			repositionGestureButtons();
			
			this.addEventListener(Event.REMOVED, onRemove);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onRemove(e:Event):void 
		{
			trace("removing");
			_tank.removeBlock(e.currentTarget as Block);
		}
		
		public function addBullet(bullet:IBullet):void 
		{
			_packageManager.sendMessage('Bullet:Shoot', bullet.createString());
			_bullets.push(bullet);
		}
		
		private function copyTank(copyTank:Tank, cloneTank:Tank):void 
		{
			for (var i:int; i < cloneTank.containers.length; i++)
			{
				if (cloneTank.containers[i].block != null)
				{
					var block:Block = cloneTank.containers[i].block.clone();
						block.x = copyTank.x + copyTank.containers[i].x;
						block.y = copyTank.y + copyTank.containers[i].y;
						CONFIG::debug
						{
							block.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
							block.addEventListener(MouseEvent.MOUSE_UP, onUp);
						}
						block.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
						block.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
						copyTank.containers[i].block = block;
					_level.addChild(block);
				}
			}
		}
		
		private function onTouchEnd(e:TouchEvent):void 
		{
			if (_level.scaleX == 4)
			{
				Block(e.currentTarget).stopTouchDrag(e.touchPointID);
				
				var wasOnTank:Boolean = false;
				for (var j:int = 0; j < _tank.containers.length; j++) 
				{
					if (_tank.containers[j].block != null && _tank.containers[j].block.name == Block(e.currentTarget).name)
					{
						wasOnTank = true;
					}
				}
				
				if (_tank.onStopDragBlock(e.currentTarget as Block) == false && e.currentTarget is Weapon)
				{
					for (var i:int; i < _gestureButtons.length; i++)
					{
						if (_gestureButtons[i].weapon.wTitle == Weapon(e.currentTarget).wTitle &&
							_gestureButtons[i].weapon.title == Weapon(e.currentTarget).title && 
							wasOnTank == true)
						{
							var gestureButton:GestureButton = _gestureButtons[i];
							removeChild(gestureButton);
							_gestureButtons.splice(i, 1)
							repositionGestureButtons();
							break;
						}
					}
				}
				else if(e.currentTarget is Weapon)
				{
					if (wasOnTank == false)
					{
						var gestureButton2:GestureButton = new GestureButton(e.currentTarget as Weapon, this);
							gestureButton2.scaleX = gestureButton2.scaleY = 3;
						_gestureButtons.push(gestureButton2);
						
						addChild(gestureButton2);
						repositionGestureButtons();
					}
				}
			}
		}
		
		private function onTouchBegin(e:TouchEvent):void 
		{
			if (_level.scaleX == 4)
			{
				Block(e.currentTarget).startTouchDrag(e.touchPointID);
				_tank.onDragBlock(e.currentTarget as Block);
			}
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (_level.scaleX == 4)
			{
				Block(e.currentTarget).stopDrag();
				
				var wasOnTank:Boolean = false;
				for (var j:int = 0; j < _tank.containers.length; j++) 
				{
					if (_tank.containers[j].block != null && _tank.containers[j].block.name == Block(e.currentTarget).name)
					{
						wasOnTank = true;
					}
				}
				
				if (_tank.onStopDragBlock(e.currentTarget as Block) == false && e.currentTarget is Weapon)
				{
					for (var i:int; i < _gestureButtons.length; i++)
					{
						if (_gestureButtons[i].weapon.wTitle == Weapon(e.currentTarget).wTitle &&
							_gestureButtons[i].weapon.title == Weapon(e.currentTarget).title && 
							wasOnTank == true)
						{
							var gestureButton:GestureButton = _gestureButtons[i];
							removeChild(gestureButton);
							_gestureButtons.splice(i, 1)
							repositionGestureButtons();
							break;
						}
					}
				}
				else if(e.currentTarget is Weapon)
				{
					if (wasOnTank == false)
					{
						var gestureButton2:GestureButton = new GestureButton(e.currentTarget as Weapon, this);
							gestureButton2.scaleX = gestureButton2.scaleY = 3;
						_gestureButtons.push(gestureButton2);
						
						addChild(gestureButton2);
						repositionGestureButtons();
					}
				}
			}
		}
		
		private function repositionGestureButtons():void 
		{
			var y:int = -1;
			var x:int = 0;
			for each(var gestureButton:GestureButton in _gestureButtons)
			{
				if (x % 12 == 0)
				{
					x = 0;
					y++;
				}
				gestureButton.x = 5 + x * 50;
				gestureButton.y = 5 + y * 50;
				x++
			}
		}
		
		private function onDown(e:MouseEvent):void 
		{
			if (_level.scaleX == 4)
			{
				Block(e.currentTarget).startDrag();
				_tank.onDragBlock(e.currentTarget as Block);
			}			
		}
		
		private function onFrame(e:Event):void 
		{
			_packageManager.sendMessage("Tank:x", String(_tank.x));
			if (_level.scaleX == Config.LEVEL_ZOOMED_IN)
			{
				_lever.visible = false;
			} else {
				_lever.visible = true;
			}
			_level.repositionLevel();
	
			speed = Math.abs(180 - Math.abs(_lever.rotation)) / 70;
			//Vooruit
			if (_lever.rotation > 0 && speed > 0.2)
			{
				_tank.x -= speed;
				if (_tank.x < 0)
				{
					_tank.x = 0;
				}
			}
			//Achteruit
			else if (_lever.rotation < 0 && speed > 0.2)
			{
				_tank.x += speed;
				if (_tank.x + _tank.tankImage.width > _width / 2 - 75)
				{
					_tank.x = _width / 2 - _tank.tankImage.width - 75;
				}
			}
			
			for (var i:int = 0; i < _bullets.length; i++) 
			{
				_bullets[i].update();
				if (_bullets[i].collision(_enemyTank) )
				{
					//sound
					_level.removeChild(_bullets[i] as DisplayObject);
					_bullets.splice(i, 1);
					
				} 
				else if (_bullets[i].y < 0) 
				{
					_level.removeChild(_bullets[i] as DisplayObject);
					_bullets.splice(i, 1);
				}
			}
			
			for (i = 0; i < _enemyBullets.length; i++) 
			{
				_enemyBullets[i].update();
				if (_enemyBullets[i].collision(_tank) )
				{
					_level.removeChild(_enemyBullets[i] as DisplayObject);
					_enemyBullets.splice(i, 1);
					
				} 
				else if (_enemyBullets[i].y < 0) 
				{
					_level.removeChild(_enemyBullets[i] as DisplayObject);
					_enemyBullets.splice(i, 1);
				}
			}
			
			var hasBlock:Boolean = false;
			for (var j:int = 0; j < _tank.containers.length; j++) 
			{
				if (_tank.containers[j].block != null)
				{
					hasBlock = true;
				}
			}
			if (hasBlock == false)
			{
				_packageManager.sendMessage("dance", "dance");
				removeEventListener(Event.ENTER_FRAME, onFrame);
			}
		}
		
		public function receiveMessage(pkg:Package):void
		{
			if (pkg.type == "dance")
			{
				_level.dancingCactussus();
				removeEventListener(Event.ENTER_FRAME, onFrame);
			}
			if (pkg.type == 'Bullet:Shoot')
			{				
				var ClassName:Object = getDefinitionByName(pkg.message.split(",")[0]);
				
				var bullet:IBullet = new ClassName();
				_level.addChild(bullet as DisplayObject);
				bullet.makeFromString(pkg.message);
				
				_enemyBullets.push(bullet);
			}
		}
		
		public function get heightLelijk():Number 
		{
			return _height;
		}
		
		public function get widthLelijk():Number 
		{
			return _width;
		}
		
		public function get level():Level 
		{
			return _level;
		}
		
	}
}