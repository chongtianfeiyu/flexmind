package com.mindLighting
{
	import com.mindLighting.control.commands.system.PrepControlCommand;
	import com.mindLighting.control.commands.system.PrepModelCommand;
	import com.mindLighting.control.commands.system.PrepViewCommand;
	import com.mindLighting.control.commands.system.StartupCommand;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * Main Context.
	 * Is all here, please fork on helpself
	 */	
	public class MainContext extends Context
	{
		//--------------------------------------------------------------------------
		//
		// Initialization
		//
		//--------------------------------------------------------------------------
		public function MainContext(contextView:DisplayObjectContainer=null)
		{
			super(contextView);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function startup():void
		{
			trace("appliction startup.");
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, PrepModelCommand, ContextEvent,true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, PrepViewCommand, ContextEvent,true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, PrepControlCommand, ContextEvent);						
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCommand, ContextEvent,true);

			super.startup();
		}
	}
}