package tank.expansions.weapon 
{
	import flash.display.Stage;
	import tank.Tank;
	
	/**
	 * ...
	 * @author Automaticoo & Jens
	 */
	public interface IBullet 
	{
		function update():void;
		function collision(tank:Tank):Boolean;
		function makeFromString(str:String):void;
		function createString():String;
		function init(posX:Number, posY:Number, damage:int, stage:Stage):void;
		function get y():Number;
		function get x():Number;
	}	
}