package ui.sidebar 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import ui.pages.BaseScreen;
	
	/**
	 * ...
	 * @author Automaticoo
	 */
	public class SideBar extends Sprite 
	{
		private var screens:Vector.<BaseScreen>;
		private var _labels:Vector.<SideBarLabel>;
		
		public function SideBar(screens:Vector.<BaseScreen>) 
		{
			_labels = new Vector.<SideBarLabel>();
			this.screens = screens;
			
			for (var i:int = 0; i < screens.length; i++) 
			{
				var label:SideBarLabel = new SideBarLabel(screens[i].name);
				label.y = i * 100;
				addChild(label);
				_labels.push(label);
			}
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			graphics.beginFill(0xC0C0C0);
			graphics.drawRect(0, 0, 250, stage.stageHeight);
			graphics.endFill();
		}
		
		public function get labels():Vector.<SideBarLabel> 
		{
			return _labels;
		}
		
		public function set labels(value:Vector.<SideBarLabel>):void 
		{
			_labels = value;
		}
	}
}