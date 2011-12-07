package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.SettingSrv;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.WordType;
	import com.mindLighting.model.vo.Words;
	import com.mindLighting.model.vo.utils.SystemUtil;
	
	import org.robotlegs.mvcs.Command;
	
	public class SaveLastSettingCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var settingSrc:SettingSrv;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		public override function execute():void
		{
			trace("SaveLastSettingCommand.execute()");
			eventDispatcher.addEventListener(ActorEvent.WORDS_RETURN,onReturnWords);
			dispatch(new ControlEvent(ControlEvent.GET_WORDS));
		}
	
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		/**
		 *save client current settings.  
		 * 
		 */		
		public function onReturnWords(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.WORDS_RETURN,onReturnWords);
			var wordRows:Setting = new Setting();
			wordRows.key = 'wordRows';
			wordRows.value = (e.body as Words).getWords().length.toString();
			
			var mindWordRows:Setting = new Setting();
			mindWordRows.key = 'mindWordRows';
			mindWordRows.value  =  SystemUtil.getWordsByType((e.body as Words).getWords(),WordType.MIND).length;
			
			
			dispatch(new ControlEvent(ControlEvent.ADD_SETTINGS,[wordRows,mindWordRows]));
		}
	}
}