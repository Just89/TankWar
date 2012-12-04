package ui.pages 
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import ui.Slider;
	/**
	 * ...
	 * @author Just
	 */
	public class GameSettingScreen extends BaseScreen
	{		
		private var _labels:Array = [
									["Round Time (minutes): 	" , 0, 15],
									["Round Limit: 				", 1, 1],
									//["Damage Limit: 			", _damageLimit, 1, 200],
									["Points to spend:			",2500, 7500]
									];
		
		public function GameSettingScreen(name:String) 
		{
			super(name);	
			
			for (var i:int = 0; i < _labels.length; i++) 
			{
				var textField:TextField = new TextField();
					textField.y = i * 50 + 20;
					textField.x = 10
					textField.selectable = false;
					textField.width = 500;
					textField.defaultTextFormat = Config.format;
					textField.text = _labels[i][0];
				addChild(textField);
				
				_labels[i].push(textField);
					
				 var slider:Slider = new Slider(_labels[i][1], _labels[i][2]);
						slider.y = i * 50 + 20;
						slider.x = 400;
					addChild(slider);
					
				_labels[i].push(slider);
			}
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void 
		{
			for (var i:int = 0; i < _labels.length; i++) 
			{
				_labels[i][3].text = _labels[i][0] + _labels[i][4].value;
			}
		}
		
		override public function fadeIn():void
		{
			return;
		}
		
		public function get gameTime():int 
		{
			return _labels[0][4].value;
		}
	
		public function get roundLimit():int 
		{
			return _labels[1][4].value;
		}
		public function get points():int 
		{
			return _labels[2][4].value;
		}
	}

}