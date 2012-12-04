package ui
{
	import air.update.descriptors.StateDescriptor;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Just
	 */
	public class Slider extends Sprite
	{
		private static const SLIDER_BAR_LENGTH:int = 200;
		
		private var touchID:int = 0;
		private var _sliderButton:Sprite;
		private var _sliderRect:Rectangle;
		
		private var min:int;
		private var max:int;
		
		public function Slider(min:int, max:int)
		{
			this.max = max;
			this.min = min;
			
			graphics.lineStyle(2, 0x000000);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRoundRect(0, 0, SLIDER_BAR_LENGTH + 50, 25, 25, 25);
			graphics.endFill();
			
			/*graphics.lineStyle(25, 0xFFFFFF);
			graphics.moveTo(0, 0);
			graphics.lineTo(SLIDER_BAR_LENGTH, 0);*/
			
			_sliderRect = new Rectangle(0, 0, SLIDER_BAR_LENGTH);
			
			_sliderButton = new Sprite();
			_sliderButton.graphics.beginFill(0x5d7988);
			_sliderButton.graphics.drawRoundRect(0, 0, 50, 25, 25, 25);
			_sliderButton.graphics.endFill();
			
			addChild(_sliderButton);
			

			_sliderButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);

			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	
			
			/*_sliderButton.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);*/
		}
	
		private function onMouseDown(e:Event):void
		{
			_sliderButton.addEventListener(Event.ENTER_FRAME, moveSlider);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_sliderButton.stopDrag();
			_sliderButton.removeEventListener(Event.ENTER_FRAME, moveSlider);
		}
		
		public function get value():int
		{
			var percentMoved:Number = _sliderButton.x / SLIDER_BAR_LENGTH;
			var range:Number = max - min;
			return Math.ceil(range * percentMoved + min);

		}
		
		/*private function onTouchBegin(e:TouchEvent):void
		{
			touchID = e.touchPointID;
		}
		
		private function onTouchMove(e:TouchEvent):void
		{
			if (touchID == e.touchPointID)
			{
				
				_sliderButton.x = e.localX;
			}
		}
		
		private function onTouchEnd(e:TouchEvent):void
		{
			if (touchID == e.touchPointID)
			{
				touchID = e.touchPointID;
			}
		}*/
		
		private function moveSlider(e:Event):void
		{
			_sliderButton.startDrag(false, _sliderRect);
		}
	
	}

}