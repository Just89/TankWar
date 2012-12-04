package tank 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Lever extends Sprite 
	{		
		private var touchID:int = 0;
		private var circle:Sprite;
		private var sound:Sound;
		private var _game:int;
		
		public function Lever(game:int) 
		{
			this._game = game;
			circle = new Sprite();
			circle.graphics.beginFill(0xFFFF00, 0);
			circle.graphics.drawCircle(0, 0, 160);
			circle.graphics.endFill();
			
			graphics.beginFill(0x000000);
			graphics.drawRect(-3, 0, 6, 80);
			graphics.endFill();
			addChild(circle);
			
			rotation = 180;
			
			CONFIG::debug{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			CONFIG::debug{
				parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
			this.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, leverRotation);
			TweenLite.to(this, 1, { shortRotation: { rotation:180 }} );
			circle.visible = true;
		}
		private function onTouchBegin(e:TouchEvent):void 
		{
			touchID = e.touchPointID;
			circle.visible = false;
		}
		private function onTouchMove(e:TouchEvent):void 
		{
			if (touchID == e.touchPointID)
			{
				var pnt:Point = new Point();
				if (_game == 1)
				{
					pnt.x = 0;
					pnt.y = stage.stageHeight / 2;
				}
				else
				{
					pnt.x = stage.stageWidth;
					pnt.y = stage.stageHeight /2;
				}
				var dx:Number = pnt.x - e.stageX;
				var dy:Number = pnt.y - e.stageY;
				var alpha:Number = Math.atan2(dy,dx); // in Rads
				var degrees:Number = alpha*180/Math.PI; // in Degrees
				
				if (_game == 2)
				{
					degrees -= 180;
				}
				
				this.rotation = degrees;				
				
				if (rotation < 110 && rotation > 0)
				{
					rotation = 110;
				}
				if (rotation > -110 && rotation < 0)
				{
					rotation = -110;
				}
			}			
		}
		
		private function onTouchEnd(e:TouchEvent):void 
		{
			if (touchID == e.touchPointID)
			{
				touchID = e.touchPointID;
				TweenLite.to(this, 1, { shortRotation: { rotation:180 }} );
				circle.visible = true;
			}			
		}
		private function onMouseDown(e:MouseEvent):void 
		{
			this.addEventListener(Event.ENTER_FRAME, leverRotation);
			circle.visible = false;
		}	
		
		private function leverRotation(e:Event):void 
		{
			var pnt:Point = new Point();
				if (_game == 1)
				{
					pnt.x = 0;
					pnt.y = stage.stageHeight / 2;
				}
				else
				{
					pnt.x = stage.stageWidth;
					pnt.y = stage.stageHeight /2;
				}
				var dx:Number=pnt.x-stage.mouseX;
				var dy:Number=pnt.y-stage.mouseY;
				var alpha:Number=Math.atan2(dy,dx); // in Rads
				var degrees:Number=alpha*180/Math.PI; // in Degrees
				
				trace(degrees);
				
				if (_game == 2)
				{
					degrees -= 180;
				}
				
				this.rotation = degrees;
						
			if (rotation < 110 && rotation > 0)
			{
				rotation = 110;
			}
			if (rotation > -110 && rotation < 0)
			{
				rotation = -110;
			}
		}
	}
}