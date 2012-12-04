package ui.sidebar 
{
	import air.update.utils.StringUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Just
	 */
	public class SideBarLabel extends Sprite
	{
		private var _labelHeight:int = 100;
		private var _labelWidth:int = 250
		private var _active:Boolean;
		private var _labelText:TextField;
		
		public function SideBarLabel(name:String) 
		{	
			var textFormat:TextFormat = Config.format;
			textFormat.align = "center";
			textFormat.size = 18;
			
			_labelText = new TextField;
			_labelText.text = name;
			_labelText.x = _labelWidth / 2 - _labelText.width;
			_labelText.y = _labelHeight / 2 - /*_labelText.height / 2 = */12.5;
			_labelText.autoSize = TextFieldAutoSize.LEFT;
			_labelText.selectable = false;
			_labelText.setTextFormat(textFormat);
			
			addChild(_labelText);
		}
		
		public function set active(value:Boolean):void 
		{
			if (value == true)
			{
				graphics.clear();
				graphics.beginFill(0x5d7988);
				graphics.drawRect(0, 0, _labelWidth, _labelHeight);
				graphics.endFill();
				_labelText.textColor = 0x000000;
				
			} 
			else
			{
				graphics.clear();
				graphics.beginFill(0xe0eaee);
				graphics.drawRect(0, 0, _labelWidth, _labelHeight);
				graphics.endFill();
				_labelText.textColor = 0x94afbd;
			}
			_active = value;
		}
	}
}