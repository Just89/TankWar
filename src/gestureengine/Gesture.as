package gestureengine 
{
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jens Kooij
	 */
	public class Gesture extends Sprite
	{
		private var _point1:Point = new Point();
		private var _point2:Point = new Point();
		private var _finalPoint:Point = new Point();
		private var _wayPoints:Array = new Array();
		private var _currenntWayPoint:int = 0;
		private var _game:Game;
		
		public function Gesture(maxX:int, maxY:int, game:Game) 
		{
			_game = game;
			GeneratePoints(maxX, maxY);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			CONFIG::debug
			{
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseDown);
				_game.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			this.addEventListener(TouchEvent.TOUCH_MOVE, onMouseDown);
			_game.addEventListener(TouchEvent.TOUCH_END, onMouseUp);
		}
		
		private function onMouseUp(e:Event):void 
		{
			stopListening();
		}
		
		private function stopListening():void 
		{
			for each (var wp:WayPoint in _wayPoints)
			{
				wp.removeEventListener(Event.COMPLETE, onWayPointComplete);
				wp.reset();
			}
			_currenntWayPoint = 0;
		}
		
		private function onMouseDown(e:Event):void 
		{
			startListening();
		}
		
		private function startListening():void 
		{
			for each (var wp:WayPoint in _wayPoints)
			{
				wp.addEventListener(Event.COMPLETE, onWayPointComplete);
			}
			_wayPoints[_currenntWayPoint].activate();
		}
		
		private function onWayPointComplete(e:Event):void 
		{
			e.stopImmediatePropagation();
			if (_currenntWayPoint == (_wayPoints.length - 1) )
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else 
			{
				_currenntWayPoint++;
				_wayPoints[_currenntWayPoint].activate();
			}
		}
		
		public function CreateShape():void
		{
			_point2 = _point1.clone();
			// Create circle
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawCircle(_point1.x, _point1.y, 10);
			// Draw the line
			TweenLite.to(_point2,1,{x:_finalPoint.x, y:_finalPoint.y, onUpdate: drawLine, onComplete: onComplete});
		}
		
		private function onComplete():void 
		{
			// Draw circle
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawCircle(_point2.x, _point2.y, 10);
		}
		
		private function imDone():void 
		{
			dispatchEvent(new Event(Event.COMPLETE, true));
			TweenLite.to(this, 1, { alpha: 0 } );
		}
		
		private function drawLine():void
		{
			this.graphics.moveTo(_point1.x, _point1.y);
			this.graphics.lineTo(_point2.x, _point2.y);
		}
		
		private function GeneratePoints(maxX:int, maxY:int):void 
		{
			_point1.x = GetRandomBetween(maxX);
			_point1.y = GetRandomBetween(maxY);
			_finalPoint.x = GetRandomBetween(maxX);
			_finalPoint.y = GetRandomBetween(maxY);
		}
		
		private function GetRandomBetween(max:int, min:int = 0):int 
		{
			return min + (max - min) * Math.random();
		}
		
		public function doGesture():void
		{
			CreateShape();
			AddWayPoints();
			CheckMouse();
		}
		
		private function AddWayPoints():void 
		{
			// Calculate points
			var middlePoint:Point = Point.interpolate(_point1, _finalPoint, 0.5);
			var point25:Point = Point.interpolate(_point1, middlePoint, 0.5);
			var point75:Point = Point.interpolate(middlePoint, _finalPoint, 0.5);
			// Add to array
			_wayPoints.push(new WayPoint(_point1.x, _point1.y));
			_wayPoints.push(new WayPoint(point25.x, point25.y));
			_wayPoints.push(new WayPoint(middlePoint.x, middlePoint.y));
			_wayPoints.push(new WayPoint(point75.x, point75.y));
			_wayPoints.push(new WayPoint(_finalPoint.x, _finalPoint.y));
			// Add them to the stage
			for each (var value:* in _wayPoints)
			{
				addChild(value);
			}
		}
		
		private function CheckMouse():void 
		{
			// Mouse == checked
			
		}
		
		public override function toString():String
		{
			return 'GesturePoint1(' + _point1.x + ', ' + _point1.y + ') - Point2(' + _finalPoint.x + ', ' + _finalPoint.y + ')';
		}
		
	}

}