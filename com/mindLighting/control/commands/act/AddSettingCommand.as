package com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.SettingSrv;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddSettingCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var settingSrv:SettingSrv;
		[Inject]
		public var systemEvent:ControlEvent;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("AddSettingCommand.execute()");
			eventDispatcher.addEventListener(ActorEvent.SETTINGS_RETURN,onReturnSettings);
			dispatch(new ControlEvent(ControlEvent.GET_SETTINGS));
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnSettings(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.SETTINGS_RETURN,onReturnSettings);
			var settings:Settings= (e.body as Settings);
			var setting:Setting = systemEvent.body as Setting;
			
			(settings.hasKey(setting.key)) ? settingSrv.modifySetting(setting) :
			settingSrv.addSetting(setting);
		}
		
		
	}
}