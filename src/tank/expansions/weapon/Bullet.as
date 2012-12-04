package tank.expansions.weapon 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import tank.expansions.Container;
	import tank.Tank;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Bullet extends Sprite implements IBullet
	{
		private var _vector:Point = new Point(7, -4);
		private var _gravity:Point = new Point(0, 0.098);
		private var _wind:Point = new Point(-0.05, 0);
		private var _position:Point;
		private var _damage:int;
		
		public function Bullet() 
		{
			var shootSound:Sound = new Sound(new URLRequest("sound/single_shot.mp3"));
			shootSound.play();
		}
		public function init(posX:Number, posY:Number, damage:int, stage:Stage):void
		{
			_damage = damage;
			_position = new Point(posX, posY);
			graphics.beginFill(0);
			graphics.drawCircle(0, 0, _damage / 2);
			graphics.endFill();
			this.x = _position.x;
			this.y = _position.y;
		}
		
		public function update():void
		{
			_position = _position.add(_vector);
			_vector = _vector.add(_gravity);
			_vector = _vector.add(_wind);
			this.x = _position.x;
			this.y = _position.y;
		}
		
		/* INTERFACE tank.expansions.weapon.IBullet */
		
		public function collision(toTank:Tank):Boolean 
		{
			for (var i:int = 0; i < toTank.containers.length; i++) 
			{
				var container:Container = toTank.containers[i];
				if (container.block != null)
				{
					var rect:Rectangle = container.block.blockRectangle.clone();
					rect.offset(container.block.x, container.block.y);
					if (rect.containsPoint(_position)) 
					{
						container.block.currentHealth -= 5;
						return true;
					}
				}
			}
			return false;
		}
		
		public function makeFromString(str:String):void 
		{
			var x:Number = stage.stageHeight - str.split(",")[1];
			_wind.x *= -1;
			_vector.x *= -1;
			var y:Number = str.split(",")[2];
			init(x, y, str.split(",")[3], null);
		}
		
		public function createString():String 
		{
			return getQualifiedClassName(this) + "," + x + "," + y + "," + _damage;
		}
	}
}