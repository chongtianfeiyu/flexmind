package com.mindLighting.control.commands.system
{
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	public class PrepExistCommand extends Command
	{

		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			//Q why using FlexGlobals.topLevelApplication can not handle the existing event?
			//FlexGlobals.topLevelApplication
			//Let's debug to understand
			trace("PrepExistCommand.execute()");
			NativeApplication.nativeApplication.addEventListener(Event.EXITING,onExist);
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onExist(e:Event):void
		{
			trace('appliction existing...');
			commandMap.execute(SaveLastSettingCommand);
			commandMap.execute(SetAutoLounchCommand);
			commandMap.execute(CloseWindowsCommand);			
			commandMap.execute(UpdateCommand);			
			trace('appliction existed.');
		}
		
	}
}