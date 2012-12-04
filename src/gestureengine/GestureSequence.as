package gestureengine 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Jens Kooij
	 */
	public class GestureSequence extends Sprite
	{
		private var _length:int;
		private var _time:int;
		private var _maxX:int;
		private var _maxY:int;
		private var _gestures:Array = new Array();
		private var _timer:Timer;
		private var _currentGesture:int = 0;
		private var _completeGestures:int = 0;
		private var _game:Game;
		
		/**
		 * 
		 * @param	length	Amount of gestures
		 * @param	time	Time to do the gestures (in seconds)
		 * @param	maxX	
		 * @param	maxY
		 */
		public function GestureSequence(length:int, time:int, maxX:int, maxY:int, game:Game) 
		{
			_game = game;
			_length = length;
			_time = time;
			_maxX = maxX;
			_maxY = maxY;
			init();
		}

		public function init():void
		{
			CreateGestures();
			_timer = new Timer((_time * 1000), 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			TracePoints();
		}
		
		private function onTimerComplete(e:TimerEvent = null):void 
		{
			TweenLite.to(this, 1, { alpha:0, onComplete: removeMe });
		}
		
		private function removeMe():void
		{
			if (this.parent != null) {
				parent.removeChild(this);
			}
		}
		
		private function onGestureComplete(e:Event):void 
		{
			_gestures[_currentGesture].removeEventListener(Event.COMPLETE, onGestureComplete);
			this.removeChild(_gestures[_currentGesture]);
			_currentGesture++;
			_completeGestures++;
			if (_currentGesture > (_gestures.length-1))
			{
				dispatchEvent(new Event(Event.COMPLETE));
				_timer.stop();
				onTimerComplete();
			}
			else 
			{
				_gestures[_currentGesture].doGesture();
				_gestures[_currentGesture].addEventListener(Event.COMPLETE, onGestureComplete);
			}
		}
		
		public function DoSequence():void
		{
			var checkSum:int = 0;
			_timer.start();
			_gestures[_currentGesture].doGesture();
			_gestures[_currentGesture].addEventListener(Event.COMPLETE, onGestureComplete);
		}
		
		private function TracePoints():void
		{
			for each (var value:* in _gestures)
			{
				trace(value);
			}
		}
		
		private function CreateGestures():void 
		{
			for (var i:int = 0; i < _length; ++i)
			{
				var tmpGesture:Gesture = new Gesture(_maxX, _maxY, _game);
				addChild(tmpGesture);
				_gestures.push(tmpGesture);
			}
		}
		
	}

}