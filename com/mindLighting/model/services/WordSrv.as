package com.mindLighting.model.services
{
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.base.DataBase;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.Words;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;

	/**
	 * namely, word service Class.  
	 * @author AlanHero
	 * 
	 */	
	public class WordSrv extends DataBase
	{
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------	
		public function WordSrv()
		{
			super();
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		protected override function onConnectionOpen(e:SQLEvent):void
		{
			createWordsTable();	
		}
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public function addWords(words:Vector.<Word>):void
		{
			if(! _connection)init( addWords, words );
			if(words.length == 0) return;
			var sqlSelect:String;
			var q:String =  "INSERT INTO words ('mTitle','mType') SELECT '" + 
				words[0].title + "' AS 'mTitle', '" + 
				words[0].type + "' AS 'mType' ";
			
			for each (var word:Word in words) {
				q += "union select '" + word.title + "','" + word.title + "' ";
			}				
			executeStatement( q, [], [], onWordsAdd );
		}
		public function addCountbyID(word:Word):void
		{
			if (! _connection) init( addCountbyID, word );
			var q:String= "update words set mView = (mView + 1) " +
				"where id = '" + word.id + "'";	
			executeStatement( q, [], [], onWordAddCount );
		}
		public function addCountbyTitle(word:Word):void
		{
			var q:String= "update words set mView = (mView + 1) " +
				"where mTitle = '" + word.title + "'";			
			executeStatement( q, [], [], onWordAddCount );
			if (! _connection) init( addCountbyTitle, word );
		}
		public function addCountByTitles(words:Vector.<Word>):void
		{
			if (! _connection) init( addCountByTitles, words);
			if(words.length == 0) return; 
			var q:String="";
			q += "update words set mView = (mView + 1) " +
				" WHERE mTitle = 'tokenXXXXXXtoken' ";
			for each (var word:Word in words)
			{				
				q += "or mTitle = '" +word.title + "'";
			}			
			executeStatement( q, [], [], onWordsAddCount );
		}
		public function updateWordType(wordID:uint,type:String):void
		{
			if (! _connection) init( updateWordType, [wordID,type] );
			var q:String = "UPDATE words SET " +
				"mType='" + type + "'," +
				"mView=(mView + 1)," +
				"uDate = CURRENT_TIMESTAMP " +
				"WHERE id=" + wordID + ";";			
			executeStatement( q, [], [], onWordTypeUpdate );
		}
		public function addWord( word:Word ):void
		{
			if (! _connection) init( addWord, word );
			var q:String = "INSERT INTO words (id,mTitle,mType)VALUES(NULL,'" + 
				word.title  + "','"
				+ word.type + "');";
			executeStatement( q, [], [], onWordAdd );
		}
		public function modifyWord( word:*):void
		{
			if (! _connection) init( modifyWord, word );
			var q:String = "UPDATE words SET " +
				"mTitle='" + word.title + "'," +
				"mType='" + word.type + "'," +
				"mView=(mView + 1)," +
				"uDate = CURRENT_TIMESTAMP " +
				" WHERE id=" + word.id + ";";				
			
			executeStatement( q, [], [], onWordModify );
		}
		public function getWords(limit:int=0, char:String=null, offset:int=0, type:String=null):void
		{
			if(! _connection) init( getWords,limit,char,offset,type );
			var q:String="";
			var whereTagToken:Boolean = false;
			
			q = "SELECT * FROM words ";
			if(char)
			{
				whereTagToken ? q += "mTitle like '%" + char + "%'" :
					q += " where mTitle like '%" + char + "%'";
				whereTagToken = true;
			}
			
			if(type)
			{
				whereTagToken ? q += " and mType = '" + type + "'" :
					q += " where mType = '" + type + "'";
				whereTagToken = true;
			}
			
			if(offset!=0 && limit !=0 )
			{
				q +=" LIMIT " + offset + ',' + limit ;
			}
				
			else if(limit!=0 )
			{
				q +=" order by uDate desc LIMIT " + limit 
			}
			executeStatement( q, [], [], onWordGetALL );
		}
		public function removeWord(id:int):void
		{
			if (! _connection) init( removeWord, id );
			var q:String = "DELETE FROM words WHERE id =" + id + ";";
			executeStatement( q, [], [], onWordRemove );
		}
		
		public function getWord(id:int):void
		{
			if (! _connection) init( getWord, id );
			var q:String = "SELECT * FROM words WHERE id =" + id + ";";
			executeStatement( q, [], [], onWordGet );
		}
		
		public function getTopWords(type:String,limit:int):void
		{
			if (! _connection)init( getTopWords, type, limit );
			var q:String;
			if(type)
			{
				q = "SELECT * FROM words where mType='" + type + 
					"'  order by mView desc limit " + limit + ";";
			}
			else
			{
				q = "SELECT * FROM words order by mView desc limit " + limit + ";";
			}
			executeStatement( q, [], [], onGetTopWords );
		}
		public function getCount(type:String=null,due:String=null):void
		{
			if (! _connection) init( getCount, type );
			var q:String;
			if(type)
			{
				q = "select  count() as count, cDate as 'due' " +
					"from    words   where mType ='" + type +
					"' GROUP BY strftime(cDate);";
			}
			else
			{
				q = "select  count() as count, cDate as 'due' " +
					"from    words    GROUP BY strftime(cDate);";					
			}
			executeStatement( q, [], [], onGetCountByTime );
		}
		public function getWordRows():void
		{
			if (! _connection) init( getWordRows );
			var q:String = "SELECT count() as rows FROM words";				
			executeStatement( q, [], [], ongetWordRows );
		}
		public function isExistInDB(title:String):void
		{
			if (! _connection) init( isExistInDB, title );
			var q:String = "SELECT * FROM words WHERE mTitle like '" + title + "' ";
			executeStatement( q, [], [], onCheckWord );
		}
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		private function onWordsAdd( event:SQLEvent ):void
		{
			//TODO
		}
		private function onWordAddCount( event:SQLEvent ):void
		{
			//TODO
		}
		private function onWordsAddCount( event:SQLEvent ):void
		{
			trace("WordSrv.onWordsAddCount(event)");
			//TODO
		}
		private function onWordTypeUpdate( event:SQLEvent ):void
		{
			trace("WordSrv.onWordTypeUpdate(event)");
			//TODO
		}
		private function onWordGetALL( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();
			var words:Words = new Words();
			if(result.data)
			{
				var word:Word;
				for each (var obj:Object in result.data) {
					word = new Word();
					word.id = obj.id;
					word.title = obj.mTitle;
					word.type = obj.mType;
					word.times = obj.mView;
					word.createDate = obj.cDate;
					word.lastDate = obj.uDate;
					words.addWord(word);
				}
			}
			dispatch(new ActorEvent(ActorEvent.WORDS_RETURN,words));
		}
		private function onWordAdd( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();
			getWord(result.lastInsertRowID);			
		}
		private function onWordModify( e:SQLEvent ):void
		{
			//TODO		
			trace("WordSrv.onWordModify(e)");
		}
		private function onWordRemove( e:SQLEvent ):void
		{
			//TODO	
			trace("WordSrv.onWordRemove(e)");
		}
		private function onWordGet( e:SQLEvent ):void
		{
			//TODO	
			
		}
		private function onGetTopWords( e:SQLEvent ):void
		{
			//TODO
		}
		private function onGetCountByTime( e:SQLEvent ):void
		{
			//TODO
		}

		private function ongetWordRows( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();
			dispatch(new ActorEvent(ActorEvent.WORD_COUNT, result.data[0]));
		}
		private function onCheckWord( e:SQLEvent ):void
		{
			//TODO
		}
		private function onCreateWordTable( e:SQLEvent ):void
		{
			callBack();
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		protected function createWordsTable():void
		{
			var q:String = "CREATE TABLE IF NOT EXISTS words (" +
				"id    INTEGER    PRIMARY KEY," +
				"mTitle    VARCHAR    NOT NULL," +
				"mType    VARCHAR  DEFAULT 'unminded'  NOT NULL," +
				"mView	  INTEGER DEFAULT 1 NOT NULL," +
				"cDate     DATETIME DEFAULT CURRENT_TIMESTAMP," +
				"uDate	   DATETIME DEFAULT CURRENT_TIMESTAMP);";
			executeStatement( q, [], [], onCreateWordTable );
		}
	}
}