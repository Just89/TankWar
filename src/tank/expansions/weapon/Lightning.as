package tank.expansions.weapon 
{
	import com.greensock.easing.Bounce;
	import com.greensock.motionPaths.RectanglePath2D;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import tank.Tank;
	
	/**
	 * ...
	 * @author Jens Kooij
	 */
	public class Lightning extends Sprite implements IBullet 
	{
		private var _damage:int;
		private var _collisionDetect:Boolean = false;
		private var _thisRectangle:Rectangle = new Rectangle();
		
		public function Lightning() 
		{
			var shootSound:Sound = new Sound(new URLRequest("sound/lazer beam.mp3"));
			shootSound.play();
		}
		
		/* INTERFACE tank.expansions.weapon.IBullet */
		
		public function update():void 
		{
			
		}
		
		public function collision(tankk:Tank):Boolean 
		{
			if (_collisionDetect == false)
			{
				return false;
			}
			
			for (var i:int = 0; i < tankk.containers.length; i++) 
			{
				if (tankk.containers[i].block != null)
				{
					var rect:Rectangle = tankk.containers[i].block.blockRectangle;
						rect = rect.clone();
						rect.offset(tankk.containers[i].block.x, tankk.containers[i].block.y);
						
					if (rect.intersection(parent.getBounds(this)) == true)
					{
						tankk.containers[i].block.currentHealth -= _damage;
						_collisionDetect = false;
					}
				}
			}
			
			
			return false;
		}
		
		public function makeFromString(str:String):void 
		{
			var x:Number = stage.stageHeight - str.split(",")[1];
			init(x, 0, str.split(",")[3], null);
		}
		
		public function createString():String 
		{
			return getQualifiedClassName(this) + "," + x + "," + y + "," + _damage;
		}
		
		public function init(posX:Number, posY:Number, damage:int, stage:Stage):void 
		{
			_damage = damage;
			
			if (stage != null)
			{
				posX = (stage.stageHeight / 2 * Math.random()) + stage.stageHeight / 2;
			}
			
			TweenLite.to(this, 2, { scaleX: "40", delay: 2, onComplete: addEffects } );
			
			this.x = posX;
			
			this.y = 0;
			
			_thisRectangle.x = x - 2;
			_thisRectangle.y = 0;
			_thisRectangle.width = 4;
			_thisRectangle.height = 2000;
			
			graphics.lineStyle(2, 0x54C6F1, 0.8);
			graphics.lineTo(0, 2000);
		}
		
		private function addEffects():void
		{
			_collisionDetect = true;
			TweenLite.to(this, 3, {blurFilter: { blurX:20, blurY:20 }, glowFilter: { color:0x0066ff, alpha:1, blurX:54, blurY:57, strength:1.5 }, ease:Bounce.easeInOut } );
			TweenLite.to(this, 1, {delay:3, alpha:0, onComplete:removeComplete } );
		}
		
		private function removeComplete():void 
		{
			_collisionDetect = false;
			parent.removeChild(this);
		}
	}
}