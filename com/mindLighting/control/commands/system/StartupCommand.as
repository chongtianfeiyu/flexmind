package com.mindLighting.control.commands.system
{
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command
	{

		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("StartupCommand.execute()");
			commandMap.execute(CenterViewCommand);
			commandMap.execute(CreateMenuCommand);
			commandMap.execute(AutoHideCommand);
//			commandMap.execute(OpenViewCommand);
			commandMap.execute(PrepDropCommand);
			commandMap.execute(PrepExistCommand);
		}
		
	}
}