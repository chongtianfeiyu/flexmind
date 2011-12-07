package com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.services.SettingSrv;
	import com.mindLighting.model.services.WordSrv;
	import com.mindLighting.model.vo.Word;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetSettingsCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var settingSrc:SettingSrv;
		[Inject]
		public var systemEvent:ControlEvent;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("GetSettingsCommand.execute()");
			settingSrc.getSettings();
		}
	}
}