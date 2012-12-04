package ui.pages 
{
	import events.GameSettingEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tank.Tank;
	import ui.pages.BuildTankScreen;
	import ui.sidebar.SideBar;
	/**
	 * ...
	 * @author Just
	 */
	public class StartScreen extends Sprite
	{
		private var _currentScreen:int = -1;
		
		private var _screens:Vector.<BaseScreen> = Vector.<BaseScreen>([
			new GameSettingScreen("Game Settings"),
			new BuildTankScreen("Player 1"),	
			new BuildTankScreen("Player 2")
		]);
		private var sideBar:SideBar;
		
		public function StartScreen() 
		{
			sideBar = new SideBar(_screens);
			addChild(sideBar);
			
			nextScreen();
		}
		private function nextScreen(e:Event = null):void
		{
			if (_currentScreen != -1)
			{
				var fadeOutScreen:BaseScreen = _screens[_currentScreen];
					fadeOutScreen.removeEventListener(Event.COMPLETE, nextScreen);
					fadeOutScreen.fadeOut();
			}
			
			_currentScreen++;
			
			BuildTankScreen(_screens[1]).totalPoints = BuildTankScreen(_screens[2]).totalPoints = GameSettingScreen(_screens[0]).points;
			
			if (_currentScreen < _screens.length)
			{
				var fadeInScreen:BaseScreen = _screens[_currentScreen];
					fadeInScreen.x = 250;
					fadeInScreen.addEventListener(Event.COMPLETE, nextScreen);
				addChild(fadeInScreen);
			} 
			else
			{
				var roundLimit:int = GameSettingScreen(_screens[0]).roundLimit;
				var gameTime:int = GameSettingScreen(_screens[0]).gameTime;
				var points:int = GameSettingScreen(_screens[0]).points;
				var tank1:Tank = BuildTankScreen(_screens[1]).tank;
				var tank2:Tank = BuildTankScreen(_screens[2]).tank;
				
				for each(var screen:BaseScreen in _screens)
				{
					screen.destroy();
				}
				
				dispatchEvent(new GameSettingEvent(GameSettingEvent.COMPLETE, gameTime, roundLimit, points,  tank1, tank2, true, false));
				//TODO Dispatch
			}
			
			for (var i:int = 0; i < sideBar.labels.length; i++) 
			{
				sideBar.labels[i].active = false;
				if (_currentScreen == i)
				{
					sideBar.labels[i].active = true;
				}
			}
		}
		public function set currentScreen(value:int):void 
		{
			_currentScreen = value;
		}
	}
}