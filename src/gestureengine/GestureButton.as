package gestureengine 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import tank.expansions.weapon.Bullet;
	import tank.expansions.weapon.IBullet;
	import tank.expansions.weapon.Weapon;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GestureButton extends Sprite
	{		
		private var _weapon:Weapon;
		private var _originalWeapon:Weapon;
		private var _game:Game;
		private var _fireTime:Number = -1000000;
		
		public function GestureButton(wea:Weapon, game:Game) 
		{
			_game = game;
			_weapon = wea.clone() as Weapon;
			_originalWeapon = wea;
			
			addChild(_weapon);
			addEventListener(TouchEvent.TOUCH_TAP, onTap);
			CONFIG::debug
			{
				addEventListener(MouseEvent.CLICK, onClick);
			}
			this.filters = [new GlowFilter(0xFFFFFF)];
		}
		
		private function onTimerComplete():void 
		{
			this.filters = [new GlowFilter(0xFFFFFF)];
			this.alpha = 1;
		}
		
		private function onComplete(e:Event):void 
		{
			var BulletClass:Object = getDefinitionByName(_originalWeapon.className);
			var bullet:IBullet = new BulletClass();
				bullet.init(originalWeapon.x, _originalWeapon.y, _originalWeapon.damage, stage);
			_game.level.addChild(bullet as DisplayObject);
			_game.addBullet(bullet);
			
		}
		
		private function fireGesture():void
		{
			if (_fireTime + _weapon.cd * 1000 < getTimer())
			{
				_fireTime = getTimer();
				var gestureSequence:GestureSequence = new GestureSequence(_originalWeapon.gestureLines, _originalWeapon.gestureTime, _game.widthLelijk-40, _game.heightLelijk-120, _game);
					gestureSequence.DoSequence();
					gestureSequence.x = 20;
					gestureSequence.y = 100;
					gestureSequence.addEventListener(Event.COMPLETE, onComplete);
				_game.addChild(gestureSequence);
				this.filters = [];
				this.alpha = 0.2;
				TweenLite.to(this, _weapon.cd, {alpha:0.8, onComplete:onTimerComplete } );
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			fireGesture();
		}
		private function onTap(e:TouchEvent):void 
		{
			fireGesture();
		}
		
		public function get weapon():Weapon 
		{
			return _weapon;
		}
		
		public function get originalWeapon():Weapon 
		{
			return _originalWeapon;
		}
	}
}