package gestureengine 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	/**
	 * ...
	 * @author Jens Kooij
	 */
	public class WayPoint extends Sprite
	{
		
		private var _active:Boolean  = false;
		private var _touched:Boolean = false;
		private var _alpha:Number = 0.4;
		
		public function WayPoint(x:int, y:int) 
		{
			this.graphics.beginFill(0xFF0000, _alpha);
			this.x = x;
			this.y = y;
			this.graphics.drawCircle(0, 0, 20);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onTouchOver(e:TouchEvent):void 
		{
			touchMe();
		}
		
		private function touchMe():void 
		{
			if (_active)
			{
				_active  = false;
				_touched = true;
				CONFIG::debug
				{
					this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					this.removeEventListener(TouchEvent.TOUCH_OVER, onTouchOver);
				}
				this.graphics.clear();
				this.graphics.beginFill(0x00CC00, _alpha);
				this.graphics.drawCircle(0, 0, 20);
				dispatchEvent(new Event(Event.COMPLETE, false));
			}
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			touchMe();
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function get touched():Boolean 
		{
			return _touched;
		}
		
		public function activate():void 
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFCC00, _alpha);
			this.graphics.drawCircle(0, 0, 20);
			CONFIG::debug
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}
			this.addEventListener(TouchEvent.TOUCH_OVER, onTouchOver);
			this._active = true;
		}
		
		public function reset():void
		{
			_touched = false;
			_active  = false;
			CONFIG::debug 
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}
			this.removeEventListener(TouchEvent.TOUCH_OVER, onTouchOver);
			this.graphics.clear();
			this.graphics.beginFill(0xFF0000, _alpha);
			this.graphics.drawCircle(0, 0, 20);
		}
	}

}