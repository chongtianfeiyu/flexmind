package  com.mindLighting.control.events
{
	import flash.events.Event;
	
	/**
	 * No comments here. Basic stuff.
	 *  
	 * @author Peter Lorent peter.lorent@gmail.com
	 * 
	 */	
	public class ControlEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class Properties
		//
		//--------------------------------------------------------------------------
		public static const GET_WORD:String = "getWord";
		public static const GET_WORDS:String = "getWords";
		public static const GET_WORDS_ONE_BY_ONE:String = "getWordsOneByOne";
		public static const ADD_WORDS:String = "addWords";
		public static const ADD_WORD:String = "addWord";
		public static const UPDATE_WORD:String = "updateWord";
		public static const REMOVE_WORD:String = "RemoveWord";
		public static const UPDATE_WORD_TYPE:String = "updateWordType";
		public static const GET_SETTINGS:String = "getSettings";
		public static const ADD_SETTING:String = "addSetting";
		public static const ADD_SETTINGS:String = "addSettings";
		public static const REMOVE_SETTING:String = "removeSetting";
		public static const DROP_IN_OBJECT:String = "dropInObject";
		public static const OPEN_WINDOW:String = "openWindow";
		public static const CHANGE_STATE:String = "changeMainState";

		public static const GET_XML_FILE:String = "loadXmlFile";
		public static const READ_FILE:String = "readAnFile";
		//lights
		public static const GET_FIRST_LIGHT:String = "getFirstTitle";
		public static const GET_NEXT_LIGHT:String = "getNextTitle";
		public static const START_FORMART:String = "startFormat";

		public static const SAVE_XML_FILE:String = "saveXMLFile";
		
		//writer
		public static const ADD_LOG:String = "mind addLog";
		public static const SEARCH_TAG:String = "queryTog";
		public static const GET_LOGS:String = "getLogs";
		public static const GET_TODAY_LOGS:String = "getDasyLogs";
		public static const GET_WEEKEN_LOGS:String = "getWeekendLogs";
		public static const GET_MONTH_LOG:String = "getMonthLogs";
		public static const GET_TAGS:String = "getTags";		
		public static const OPEN_LOG_WINDOW:String = "openLogWindow";
		
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
		public function ControlEvent(type:String, body:* = null)
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
			return new ControlEvent(type, body);
		}
	}
}