package  com.mindLighting.model.services
{
    import com.mindLighting.model.events.ActorEvent;
    import com.mindLighting.model.events.FileSrvEvent;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import mx.controls.Alert;
    
    import org.robotlegs.mvcs.Actor;

    public class XMLFileSrv extends Actor
    {
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected var _file:File;
        protected var _fileStream:FileStream;
        protected var _fileName:String;

		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
        public function loadXMLFileFromStorage( fileName:String ):void
        {
            _file = File.applicationStorageDirectory.resolvePath( fileName );
			
			if( !_file.exists )
        	{
        		dispatch(new ActorEvent(ActorEvent.XML_FILE_NOT_FOUND));
        		return;
        	}
        	
            _fileStream = new FileStream();
            _fileStream.addEventListener( Event.COMPLETE, onXMLFileLoadComplete );
            _fileStream.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
            _fileStream.openAsync( _file, FileMode.READ );
        }

        public function saveXMLFileToStorage( fileName:String , data:XML ):void
        {
            var xml_encoding:String = "<?xml version='1.0' encoding='utf-8'?>\n"; 
            var xml_toWrite:String = xml_encoding + data.toXMLString();

            _file = File.applicationStorageDirectory.resolvePath( fileName );

            _fileStream = new FileStream();
            _fileStream.addEventListener( Event.CLOSE, onXMLFileWriteComplete );
            _fileStream.openAsync( _file, FileMode.WRITE );
            _fileStream.writeUTFBytes( xml_toWrite );
            _fileStream.close();
        }
        
		public function copyXMLFileFromApplicationDirectoryToStorage( fileName:String ):void
        {
        	var sourceFile:File = File.applicationDirectory.resolvePath( fileName );
        
        	if( !sourceFile.exists )
        	{
        		dispatch(new ActorEvent(ActorEvent.XML_FILE_NOT_FOUND));
        		return;
        	}
        	
        	var resultsFile:File = File.applicationStorageDirectory.resolvePath( fileName );
        	
        	sourceFile.addEventListener( IOErrorEvent.IO_ERROR , errorHandler );
        	sourceFile.addEventListener( Event.COMPLETE , onXMLFileCopyComplete );
        	sourceFile.copyToAsync( resultsFile , true );
        }

		//--------------------------------------------------------------------------
        //
        //  EventHandling
        //
        //--------------------------------------------------------------------------
		private function onXMLFileCopyComplete( event:Event ):void
		{
			dispatch(new ActorEvent(ActorEvent.XML_FILE_COPIED));
		}

        private function onXMLFileLoadComplete( event:Event ):void
        {
    		var xml:XML = XML( _fileStream.readUTFBytes( _fileStream.bytesAvailable ) );
            _fileStream.removeEventListener( Event.COMPLETE, onXMLFileLoadComplete );
            _fileStream.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			_fileStream.close();
            dispatch(new ActorEvent(ActorEvent.XML_FILE_LOADED, xml));
        }
	
        private function onXMLFileWriteComplete( event:Event ):void
        {
			
            dispatch(new ActorEvent(ActorEvent.XML_FILE_WRITTEN));
        }

        private function errorHandler( event:IOErrorEvent ):void
        {
        	var errorMessage:String = "Error Loading File "+event.text+" FILE ERROR";
                      trace( errorMessage );
            dispatch(new ActorEvent(ActorEvent.XML_FILE_ERROR, errorMessage));
		
			Alert.show( errorMessage );
        }

		//--------------------------------------------------------------------------
		//
		//  Get&Seter
		//
		//--------------------------------------------------------------------------
        public function get file():File
        {
            return _file;
        }

        public function set file( val:File ):void
        {
            _file = val;
        }
    }
}