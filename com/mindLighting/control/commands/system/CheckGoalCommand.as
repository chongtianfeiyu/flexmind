package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.SettingSrv;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	
	import org.robotlegs.mvcs.Command;
	
	public class CheckGoalCommand extends Command
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var settingSrv:SettingSrv; 
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			//listen settings
			//dipacth get settings
			//check if touch the goal setting
			eventDispatcher.addEventListener(new ActorEvent(ActorEvent.SETTINGS_RETURN, onReturnSettings));
			eventDispatcher.dispatchEvent(new ControlEvent(ControlEvent.GET_SETTINGS));
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnSettings(e:ActorEvent):void
		{
			var settings:Settings = (e.body as Settings);
			var mindWordRows:Number = settings.getSetting('mindWordRows');
			var currentGoal:Number = settings.getSetting('currentGoal');
			
			//determine if setup goal
			if((! settings.getSetting('currentGoal') ) ||
			   (! settings.getSetting('mindWordRows') ) return;
			//determine if touch goal
			if(mindWordRows > currentGoal)
			{
				(settings.hasKey('goalOk') ? 
					settingSrv.modifySetting(new Setting('goalOK',true));
					settingSrv.addSetting(new Setting('goalOK',true));
					
				if(settings.hasKey('showSucess'))
				{
					//TODO goto goal window		
				}
			}
		}
		
	}
}