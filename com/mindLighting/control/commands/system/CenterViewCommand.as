package com.mindLighting.control.commands.system
{
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;
	
	public class CenterViewCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("SetViewLocateCommand.execute()");
			// Center main AIR app window on the screen
			FlexGlobals.topLevelApplication.stage.nativeWindow.x = 
				(Capabilities.screenResolutionX - FlexGlobals.topLevelApplication.stage.nativeWindow.width) / 2;
			FlexGlobals.topLevelApplication.stage.nativeWindow.y = 
				(Capabilities.screenResolutionY - FlexGlobals.topLevelApplication.stage.nativeWindow.height) / 2;
		}
		
	}
}