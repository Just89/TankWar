
package ui.pages 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Automaticoo
	 */
	public class BaseScreen extends Sprite 
	{
		private var _name:String;
		
		[Embed(source = "../../../lib/next.png")]
		private var Next:Class;
		private var _next:Bitmap;

		private var _nextButton:Sprite = new Sprite();

		
		public function BaseScreen(name:String) 
		{
			_name = name;	
			
			_next = new Next();
			
			
			addChild(_nextButton);
			_nextButton.addEventListener(MouseEvent.CLICK, onClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function destroy():void
		{
			
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);

			_next.x = stage.stageWidth - 20 - 250 - _next.width;
			_next.y = stage.stageHeight - 20 - _next.height;
			_nextButton.addChild(_next);
			
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth - 250, stage.stageHeight);
			graphics.endFill();
			fadeIn();
		}
		
		private function onClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function fadeOut():void
		{
			TweenLite.to(this, 1, {y:-stage.stageHeight, onComplete:onComplete});
		}
		
		public function fadeIn():void 
		{
			this.y = stage.stageHeight;
			TweenLite.to(this, 1, {y:0});
		}
		
		private function onComplete():void 
		{
			parent.removeChild(this);
		
		}
		
		override public function get name():String 
		{
			return _name;
		}		
	}
}