package  com.mindLighting.model.services.base
{

    
    import flash.data.SQLConnection;
    import flash.data.SQLStatement;
    import flash.events.SQLErrorEvent;
    import flash.events.SQLEvent;
    import flash.filesystem.File;
    
    import org.robotlegs.mvcs.Actor;
    
	/**
	 * Base implementation sqlite operator
	 * 
	 */	
    public class DataBase extends Actor
    {
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------     
        private static const DB:String = "alanhero.db";
        private var _dbFile:File;
        protected var _connection:SQLConnection;
        private var _initCallback:Function;
        private var _initCallbackArgs:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------	
		/**
		 * call back init here.
		 * @param args
		 * 
		 */        
		protected function init(...args):void
        {
            _initCallback = args[0];
			if(args.length > 1)
			{
	            _initCallbackArgs = args.splice(1,args.length);
			}
            _dbFile = File.applicationStorageDirectory.resolvePath( DB );
            _connection = new SQLConnection();
            _connection.addEventListener( SQLEvent.OPEN, onConnectionOpen );
            _connection.addEventListener( SQLErrorEvent.ERROR, onConnectionError );
            _connection.open( _dbFile );
        }
        
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 * Need customization? Do it here.
		 *  
		 */		
        protected function onConnectionOpen( evt:SQLEvent ):void{}   
  
		/**
		 * should be fire in sub case.
		 *  
		 */		
		protected function callBack():void
		{
			if( _initCallback != null )
			{
				
				if( _initCallbackArgs)
				{	
					_initCallback.apply(null,_initCallbackArgs);			
				}
				else
					_initCallback();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Execute a sql.
		 * @param query
		 * @param paramNames
		 * @param paramValues
		 * @param resultHandler
		 * 
		 */        
		protected function executeStatement(query:String, paramNames:Array, 
		paramValues:Array, resultHandler:Function ):void
        {
            var newStatement:SQLStatement = new SQLStatement();
            newStatement.sqlConnection = _connection;
            newStatement.addEventListener( SQLEvent.RESULT, resultHandler );
            newStatement.addEventListener( SQLErrorEvent.ERROR, onQueryError );
            newStatement.text = query;
            
            for( var i:int = 0; i < paramNames.length; i++ )
                newStatement.parameters[paramNames[i]] = paramValues[i];

            newStatement.execute();
        }
		
		private function onQueryError( event:SQLErrorEvent ):void
		{
			//TODO
		}
		
		private function onConnectionError( event:SQLErrorEvent ):void
		{
			//TODO
		}
   }
}