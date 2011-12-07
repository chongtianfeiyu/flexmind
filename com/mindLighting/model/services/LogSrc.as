package com.mindLighting.model.services
{
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.base.DataBase;
	import com.mindLighting.model.vo.log.Log;
	import com.mindLighting.model.vo.log.TagRelate;
	import com.mindLighting.model.vo.log.Tag;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLEvent;

	public class LogSrc extends  DataBase
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		protected override function onConnectionOpen(e:SQLEvent):void
		{
			createLogTable();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		protected function createLogTable():void{
			
			var q:String = 'CREATE TABLE IF NOT EXISTS "log" ' +
				'("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,' +
				' "title" TEXT, "perentID" INTEGER, ' +
				'"cDate" DATETIME DEFAULT CURRENT_TIMESTAMP, ' +
				'"uDate" DATETIME DEFAULT CURRENT_TIMESTAMP)';
			executeStatement( q, [], [], createLogTagTable );
		}
		protected function createLogTagTable(e:Event=null):void{
			
			var q:String = 'CREATE  TABLE IF NOT EXISTS "logTag" (' +
				'"id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , ' +
				'"type" VARCHAR(255), "cDate" DATETIME DEFAULT CURRENT_TIMESTAMP, ' +
				'"uDate" DATETIME DEFAULT CURRENT_TIMESTAMP)';
			executeStatement( q, [], [], createRelateTagLogTable );
		}
		protected function createRelateTagLogTable(e:Event=null):void{
			
			var q:String = 'CREATE  TABLE IF NOT EXISTS "logRelate" (' +
				'"id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , ' +
				'"logID" INTEGER, "tagID" INTEGER)';
			executeStatement( q, [], [], onRelateTagLogTableCreation );
		}
		
		protected function onRelateTagLogTableCreation(e:Event):void
		{
			callBack();
		}
		
		public function getLogsByTag(tagID:uint):void{		
			
			if(! _connection) init(getLogsByTag);
			var q:String = "select log.title,logTag.type from log " +
				"LEFT JOIN logTag ON log.id = logRelate.logID " +
				"LEFT JOIN logRelate ON logTag.id = logRelate.tagID " +
				"where logRelate.tagID = '" + tagID + "';";
			executeStatement( q, [], [], onGetLogsByTag );
		}
		
		public function getLogComments(logID:uint):void{
			if(! _connection) init(getLogComments);
			var q:String = "select * FROM 'log' where perentID = '" + logID + "';";
			executeStatement( q, [], [], onGetLogComments );
		}
		
		public function getDayLog(dateString:String):void{
			if(! _connection) init(getDayLog,dateString);
			var q:String = "select * FROM 'log' WHERE cDate like  '%" + dateString + "%' ;";
			executeStatement( q, [], [], onGetDayLog);
		}
		
		//basic CURD
		public function removeRelate(relateID:uint):void{
			if(! _connection) init(removeRelate,relateID);
			var q:String = "DELETE FROM 'logRelate' where id = " + relateID + ";";
			executeStatement( q, [], [], onRemoveRelate );	
		}
		
		public function addRelate(relateVO:TagRelate):void{
			if(! _connection) init(addRelate);
			var q:String = "INSERT INTO 'logRelate' ('logID','tagID')VALUES('" + relateVO.logID + "'," +
				"'" + relateVO.tagID + "')";
			executeStatement( q, [], [], onAddRelate );		
		}	
		
		public function addLog(log:Log):void{
			if(! _connection) init(addLog);
			var q:String = "INSERT INTO 'log' ('title') VALUES('" + log.title + "');";
			executeStatement( q, [], [], onAddLog );
		}
		
		public function updateLog(log:Log):void{
			if(! _connection) init(updateLog);
			var q:String = "UPDATE 'log' SET 'title' = '" + log.title + "' where id = " + log.id + ";)";
			executeStatement( q, [], [], onUpdateLog );
		}
		
		public function removeLog(logID:uint):void{			
			if(! _connection) init(removeLog);
			var q:String = "DELETE FROM 'log' where id = " + logID + ";";
			executeStatement( q, [], [], onRemoveLog );
		}
		
		public function updateTag(tag:Tag):void{
			if(! _connection) init(updateTag);
			var q:String = "UPDATE 'logTag' SET 'type' = '" + tag.type + "' where id = " + tag.id + ";)";
			executeStatement( q, [], [], onUpdateTag );
			
		}
		
		public function addTag(tag:Tag):void{
			if(! _connection) init(addTag);
			var q:String = "INSERT INTO 'logTag' ('type')VALUES('" +tag.type + "')";
			executeStatement( q, [], [], onAddTag );
		}
		
		public function removeTag(tagID:uint):void{
			if(! _connection) init(removeTag);
			var q:String = "DELETE FROM 'logTag' where id = " + tagID + ";";
			executeStatement( q, [], [], onRemoveTag );
		}
		
		public function getLogs():void{
			if(! _connection) init(getLogs);
			var q:String = "SELECT * FROM 'log'";
			executeStatement( q, [], [], onGetLogs );
		}
		
		public function getTags():void{
			if(! _connection) init(getTags);
			var q:String = "SELECT * FROM 'logTag'";
			executeStatement( q, [], [], onGetTags );			
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		private function onGetLogsByTag( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();			
			dispatch(new ActorEvent(ActorEvent.LOGS_RETRUN, result));
		}
		private function onGetLogComments( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();			
			dispatch(new ActorEvent(ActorEvent.LOGS_RETRUN, result));
		}
		private function onGetDayLog( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();			
			dispatch(new ActorEvent(ActorEvent.LOGS_RETRUN, result));
		}
		private function onGetLogs( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();			
			dispatch(new ActorEvent(ActorEvent.LOGS_RETRUN,result));
		}
		
		private function onGetTags( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();			
			dispatch(new ActorEvent(ActorEvent.TAGS_RETURN, result));
		}
		
		private function onAddLog( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();			
			dispatch(new ActorEvent(ActorEvent.LOG_ADDED, result));
		}
		
		private function onAddTag( e:SQLEvent ):void
		{
			//TODO
		}
		private function onAddRelate( e:SQLEvent ):void
		{
			//TODO	
		}
		private function onUpdateLog( e:SQLEvent ):void
		{
			//TODO	
			
		}
		private function onUpdateTag( e:SQLEvent ):void
		{
			//TODO	
			
		}
		private function onRemoveLog( e:SQLEvent ):void
		{
			//TODO	
		}
		private function onRemoveTag( e:SQLEvent ):void
		{
			//TODO	
			
		}
		private function onRemoveRelate( e:SQLEvent ):void
		{
			//TODO	
		
		}
	}
}