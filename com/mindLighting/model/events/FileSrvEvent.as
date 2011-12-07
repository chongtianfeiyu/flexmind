package com.mindLighting.model.events
{
    import flash.events.Event;

    public class FileSrvEvent extends Event
    {    	
    	public static const COPIED:String = "xmlFileCopied";
    	public static const NOT_FOUND:String = "xmlFileNotFound";
        public static const XML_FILE_WRITTEN:String = "xmlFileWritten";
        public static const LOADED:String = "xmlLoaded";
		public static const ERROR:String = "xmlError";
		
        private var _xmlResults:XML;
		private var _message:String;
		
        public function FileSrvEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false )
        {
            super( type, bubbles, cancelable );
        }
		
        public function get xml():XML
        {
            return _xmlResults;
        }
		
        public function set xml( val:XML ):void
        {
            _xmlResults = val;
        }
        
        public function get message():String
        {
        	return _message;
        }	
        
        public function set message( val:String ):void
        {
        	_message = val;
        }
    }
}