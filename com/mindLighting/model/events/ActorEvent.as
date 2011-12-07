package   com.mindLighting.model.events
{
	import flash.events.Event;
	
	/**
	 * No comments here. Basic stuff.
	 */	
	public class ActorEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class Properties
		//
		//--------------------------------------------------------------------------
		public static const WORDS_RETURN:String = "returnWordList";
		public static const WORDS_RETURN_ONE_BY_ONE:String = "loadedSessionWords";
		public static const WORD_RETURN:String = "returnAnWord";
		public static const WORDS_ADDED:String = "wordsAdded";
		public static const WORD_ADDED:String = "wordAdd";
		public static const WORD_MODIFY:String = "wordModify";
		public static const WORD_GETCOUNTBYTIME:String = "getWordCountInTime";
		public static const WORD_GETTOP:String = "topWordRetrieve";
		public static const WORD_COUNT:String = "wordCount";
		public static const WORD_REMOVE:String = "wordRemoved";
		public static const WORD_COMPARED:String = "wordCompared";		
		public static const WORD_EXIST_CHECK:String = "existWordCheck";		
		public static const SETTINGS_RETURN:String = "returnSettings";		
		public static const SETTING_RETURN:String = "returnSetting";		
		public static const SETTING_ADD:String = "addSetting";		
		public static const SETTING_MODIFY:String = "updateSetting";		
		public static const SETTING_REMOVED:String = "removeAnSetting";	
		//system
		public static const DROP_IN:String = "dropinData";
		public static const FILE_READ:String = "read_File";
		//loader
		public static const LIGHT_RETURN:String = "returnNextLightingTitle";
		//reader
		public static const READER_FORMATUP:String = "readerFormaterUp";
		
		//writer
		public static const LOGS_RETRUN:String = 'returnAlllogs';
		public static const LOG_RETURN:String = 'returnAnLog';
		public static const LOG_ADDED:String = 'addedAnLog';
		public static const TAGS_RETURN:String = 'returnAllTags';
		public static const TAG_RETURN:String = 'returnAnTag';
		public static const TAG_ADDED:String = 'addAnTag';
		public static const DAYlOGS_RETURN:String = 'returnDaylyLogs';
		public static const WEEKLOGS_RETURN:String = 'returnWeekenLogs';
		public static const MONTHLOGS_RETURN:String = 'returnMonthLogs';
		public static const SEARCHLOGS_RETURN:String = "returnQueryTogs";
		
		//xmlfilesrv
		public static const XML_FILE_COPIED:String = "xmlFileCopied";
		public static const XML_FILE_NOT_FOUND:String = "xmlFileNotFound";
		public static const XML_FILE_WRITTEN:String = "xmlFileWritten";
		public static const XML_FILE_LOADED:String = "xmlLoaded";
		public static const XML_FILE_ERROR:String = "xmlError";
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected var _body:*;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		public function ActorEvent(type:String, body:* = null)
		{
			super(type);
			
			_body = body;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters and setters
		//
		//--------------------------------------------------------------------------
		public function get body():*
		{
			return _body;
		}
		
		//--------------------------------------------------------------------------
		//
		// Overridden API
		//
		//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new ActorEvent(type, body);
		}
	}
}