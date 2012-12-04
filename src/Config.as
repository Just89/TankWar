package  
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class Config
	{
		public static var DEAD_SPACE:int = 50;
		public static var CLICK_TIME:int = CONFIG::debug ? 200 : 400;
		public static var FULL_SCREEN:Boolean = true;
		
		//LEVEL ZOOM
		public static var LEVEL_ZOOMED_OUT:Number = 1;
		public static var LEVEL_ZOOMED_IN:Number = 4;
		
		//CLOUDS
		public static const NUMBER_OF_CLOUDS:int = 9;
		public static const NUMBER_OF_CLOUDS_IN_LEVEL:int = 20;
		
		//CATUSSUS
		public static const MAX_NUMBER_OF_CACTUSSUS:int = 3;
		
		
		public static function get format():TextFormat
		{
			return new TextFormat("Verdana");
		}
		
		public static var _textFieldTracer:TextField = new TextField();
		public static var _stage:Stage;
		
		public static function t(what:String):void
		{
			_textFieldTracer.x = _textFieldTracer.y = 0;
			_textFieldTracer.width = _textFieldTracer.height = 500;
			_textFieldTracer.height = 200;
			var tempError:Error = new Error();
			var stackTrace:String = tempError.getStackTrace();
			var traceString:String = "2:/** [Start trace]\n" + '2:Traced from: ' + stackTrace + "\n4:" + what + "\n2:[End trace] **/";
			if ( CONFIG::debug )
			{
				trace(traceString);
			}
			else
			{
				if (_textFieldTracer.parent == null) _stage.addChild(_textFieldTracer);
				_textFieldTracer.appendText(traceString);
				_textFieldTracer.scrollV = _textFieldTracer.maxScrollV;
			}
			
		}
	}
}