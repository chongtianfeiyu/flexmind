package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.commands.GetFirstLightCommand;
	import com.mindLighting.control.commands.GetNextLightCommand;
	import com.mindLighting.control.commands.LoadXMLFileCommand;
	import com.mindLighting.control.commands.ReadFileCommand;
	import com.mindLighting.control.commands.SaveFileCommand;
	import com.mindLighting.control.commands.StartReadFormatCommand;
	import com.mindLighting.control.commands.act.AddLogCommand;
	import com.mindLighting.control.commands.act.AddSettingCommand;
	import com.mindLighting.control.commands.act.AddSettingsCommand;
	import com.mindLighting.control.commands.act.AddWordCommand;
	import com.mindLighting.control.commands.act.AddWordsCommand;
	import com.mindLighting.control.commands.act.GetSettingsCommand;
	import com.mindLighting.control.commands.act.GetWordsCommand;
	import com.mindLighting.control.commands.act.GetWordsOneByOneCommand;
	import com.mindLighting.control.commands.act.RemoveSettingCommand;
	import com.mindLighting.control.commands.act.RemoveWordCommand;
	import com.mindLighting.control.commands.act.UpdateWordCommand;
	import com.mindLighting.control.commands.act.UpdateWordTypeCommand;
	import com.mindLighting.control.events.ControlEvent;
	
	import org.robotlegs.mvcs.Command;

	public class PrepControlCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("PrepControlCommand.execute()");
			//system 
			commandMap.mapEvent(ControlEvent.READ_FILE, ReadFileCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.SAVE_XML_FILE, SaveFileCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.GET_XML_FILE, LoadXMLFileCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.DROP_IN_OBJECT, PrepDropObjectCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.CHANGE_STATE, ChangeStateCommand, ControlEvent);
			// word
			commandMap.mapEvent(ControlEvent.GET_WORDS_ONE_BY_ONE, GetWordsOneByOneCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.GET_WORDS, GetWordsCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.ADD_WORDS, AddWordsCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.ADD_WORD, AddWordCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.UPDATE_WORD, UpdateWordCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.UPDATE_WORD_TYPE, UpdateWordTypeCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.REMOVE_WORD, RemoveWordCommand, ControlEvent);
			// settings
			commandMap.mapEvent(ControlEvent.GET_SETTINGS, GetSettingsCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.ADD_SETTINGS, AddSettingsCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.ADD_SETTING, AddSettingCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.REMOVE_SETTING, RemoveSettingCommand, ControlEvent);
			// writer
			commandMap.mapEvent(ControlEvent.ADD_LOG, AddLogCommand, ControlEvent);
			// lights
			commandMap.mapEvent(ControlEvent.GET_FIRST_LIGHT, GetFirstLightCommand, ControlEvent);
			commandMap.mapEvent(ControlEvent.GET_NEXT_LIGHT, GetNextLightCommand, ControlEvent);
			// reader
			commandMap.mapEvent(ControlEvent.START_FORMART, StartReadFormatCommand, ControlEvent);
		}
		
	}
}