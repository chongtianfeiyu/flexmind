package com.mindLighting.control.commands.system
{
	import flash.desktop.NativeApplication;
	
	import org.robotlegs.mvcs.Command;
	
	public class CloseWindowsCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		public override function execute():void
		{
			trace("CloseWindowsCommand.execute()");
			var opened:Array = NativeApplication.nativeApplication.openedWindows;
			for (var i:int = 0; i < opened.length; i ++) {
				opened[i].close();
			}
		}
	}
}