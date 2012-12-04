package events 
{
	import air.update.utils.VersionUtils;
	import flash.events.Event;
	import tank.Tank;
	
	/**
	 * ...
	 * @author Just
	 */
	public class GameSettingEvent extends Event 
	{
		static public const COMPLETE:String = "complete"
		;
		private var _time:int;
		private var _round:int;
		private var _tank1:Tank;
		private var _tank2:Tank;
		private var _points:int;
		public var game:int;

		public function GameSettingEvent(type:String, time:int, round:int, points:int, tank1:Tank, tank2:Tank, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_points = points;
			_time = time;
			_round = round;
			_tank1 = tank1;
			_tank2 = tank2;
			super(type, bubbles, cancelable);
		} 
		
		public function invert():void
		{
			var tank:Tank = _tank2;
			
			_tank2 = _tank1;
			_tank1 = tank;
		}
		
		public override function clone():Event 
		{ 
			return new GameSettingEvent(type, time, round, points, tank1, tank2, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameSettingEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}		
		public function get time():int 		{	return _time;	}		
		public function get round():int 	{	return _round;	}		
		public function get tank1():Tank 	{	return _tank1;	}		
		public function get tank2():Tank 	{	return _tank2;	}		
		public function get points():int 	{	return _points;	}
	}
}