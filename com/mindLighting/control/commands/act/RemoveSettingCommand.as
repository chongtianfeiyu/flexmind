package com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.services.SettingSrv;
	
	import org.robotlegs.mvcs.Command;
	
	public class RemoveSettingCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var controlEvent:ControlEvent;
		[Inject]
		public var settingSrv:SettingSrv;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("RemoveSettingCommand.execute()");
			settingSrv.removeSetting(controlEvent.body as String);
		}
	}
}