package debug 
{
	import flash.events.MouseEvent;
	import level.Level;
	import tank.expansions.Block;
	import tank.expansions.ExpansionLibrary;
	import tank.Tank;
	/**
	 * ...
	 * @author Automaticoo
	 */
	public class PredefineTank 
	{
		public static function define(tank:Tank, level:Level, onDown:Function, onUp:Function):void
		{
			var array:Array = [	[ExpansionLibrary.instance.blocks[0].clone(), 0],
								[ExpansionLibrary.instance.blocks[1].clone(), 1],
								[ExpansionLibrary.instance.blocks[2].clone(), 2],
								[ExpansionLibrary.instance.blocks[3].clone(), 3],
								[ExpansionLibrary.instance.blocks[4].clone(), 4],
								[ExpansionLibrary.instance.blocks[3].clone(), 5]
								];
								
			for (var i:int; i < array.length; i++)
			{
				var pos:int = array[i][1];
				var block:Block = array[i][0];
				
				block.x = Tank(tank).x + Tank(tank).containers[pos].x;
				block.y = Tank(tank).y + Tank(tank).containers[pos].y;
				Level(level).addChild(block);
				
				block.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				block.addEventListener(MouseEvent.MOUSE_UP, onUp);
				
				Tank(tank).onStopDragBlock(block);
			}
		}		
	}
}