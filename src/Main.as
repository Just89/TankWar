package 
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.OverwriteManager;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import debug.Stats;
	import events.GameSettingEvent;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import level.Level;
	import tank.expansions.ExpansionLibrary;
	import tank.expansions.weapon.Bullet;
	import tank.expansions.weapon.Lightning;
	import tank.Tank;
	import ui.Line;
	import ui.pages.StartScreen;

	
	/**
	 * ...
	 * @author Automatic
	 */
	public class Main extends Sprite 
	{
		Bullet
		Lightning
		
		TweenPlugin.activate([ShortRotationPlugin, EndArrayPlugin, ColorMatrixFilterPlugin, GlowFilterPlugin, BlurFilterPlugin]);
		OverwriteManager.init(OverwriteManager.NONE);
		
		private var game1:Game;
		private var game2:Game;
		
		private var _startScreen:StartScreen;
		
		public function Main():void
		{
			Config._stage = stage;
			stage.displayState = Config.FULL_SCREEN ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			MonsterDebugger.initialize(this);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			_startScreen = new StartScreen();
			addChild(_startScreen);
				
			addEventListener(GameSettingEvent.COMPLETE, onComplete);
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
		}
		
		private function onComplete(e:GameSettingEvent):void 
		{
			removeEventListener(Event.COMPLETE, onComplete);
			removeChild(_startScreen);
			
			e.game = 1;
			game1 = new Game(stage.stageHeight, stage.stageWidth / 2, e);
			game1.rotation = 90;
			game1.x = stage.stageWidth / 2;
			addChild(game1);
			
			var mask:Sprite = new Sprite();
				mask.x = stage.stageWidth / 2;
				mask.graphics.beginFill(0);
				mask.graphics.drawRect(0, 0, stage.stageWidth / 2, stage.stageHeight);
			addChild(mask);
			var e:GameSettingEvent = e.clone() as GameSettingEvent;
			
			e.invert();
			
			e.game = 2;
			game2 = new Game(stage.stageHeight, stage.stageWidth / 2, e);
			game2.rotation = -90;
			game2.x = stage.stageWidth / 2;
			game2.y = stage.stageHeight;
			game2.mask = mask;
			addChild(game2);
			
			addChild(new Line()).x = stage.stageWidth/2;
			
			CONFIG::debug {
				//addChild(new Stats()).x = stage.stageWidth-70;
			}
		}
		private function onExit(e:Event):void 
		{
			ExpansionLibrary.instance.closeConnection();
		}
	}	
}