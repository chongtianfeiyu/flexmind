package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ScreenMouseEvent;
	
	import flashx.textLayout.elements.GlobalSettings;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;
	
	public class CreateMenuCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Embed(source="/assets/icon/word_016.png")]
		private static var dockIcon:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("CreateMenuCommand.execute()");
			var nativeMenu:NativeMenu = new NativeMenu();
			var home:NativeMenuItem = nativeMenu.addItem( new NativeMenuItem("Home") );
			home.addEventListener( Event.SELECT , onMenuClick );
			home.name = "home";
			
			nativeMenu.addItem( new NativeMenuItem("Seperator2", true ) );
			var btnSetting:NativeMenuItem = nativeMenu.addItem( new NativeMenuItem("Settings") );
			btnSetting.addEventListener( Event.SELECT , onMenuClick );
			btnSetting.name = "set";
			
			var btnClose:NativeMenuItem = nativeMenu.addItem( new NativeMenuItem("Exit") );
			btnClose.addEventListener( Event.SELECT , onMenuClick );
			btnClose.name = "close";
			
			if(NativeApplication.supportsSystemTrayIcon)
			{
				SystemTrayIcon( NativeApplication.nativeApplication.icon ).menu = nativeMenu;
				SystemTrayIcon( NativeApplication.nativeApplication.icon ).addEventListener(ScreenMouseEvent.CLICK,iconClick);
			}
			else
			{
				DockIcon( NativeApplication.nativeApplication.icon ).menu = nativeMenu;
				DockIcon( NativeApplication.nativeApplication.icon ).addEventListener(Event.ACTIVATE,iconClick);
				
			}
			
			// apply dock icon
			NativeApplication.nativeApplication.icon.bitmaps =[( new dockIcon() ).bitmapData];			
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function iconClick(e:ScreenMouseEvent):void
		{
			FlexGlobals.topLevelApplication.nativeWindow.visible= true;
			FlexGlobals.topLevelApplication.nativeWindow.activate();
			//TODO determine autoHIDE
		}
		
		protected  function onMenuClick(e:Event):void
		{
			switch(e.target.name)
			{
				case 'home':
				{
					dispatch(new ControlEvent(ControlEvent.CHANGE_STATE, MainModel.STATE_MENU));				
					break;
				}
				case 'set':
				{
					dispatch(new ControlEvent(ControlEvent.CHANGE_STATE, MainModel.STATE_SETTING));				
					break;
				}
				case 'close':
				{
					NativeApplication.nativeApplication.exit();
					break;
				}
			}
		}
	}
}