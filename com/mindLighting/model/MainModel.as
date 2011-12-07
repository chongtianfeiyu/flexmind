package com.mindLighting.model
{
	import com.mindLighting.model.vo.Word;
	
	import designpattern.Iterator.Iterator;
	
	import flash.utils.Dictionary;

	/**
	 * Store windows Data, states name, etc. 
	 */	
	public class MainModel
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		public static const  STATE_MENU:String = "Menu";
		public static const  STATE_QUICK:String = "Quick";
		public static const  STATE_GOAL:String = "Goal";
		public static const  STATE_READ:String = "Read";
		public static const  STATE_WRITE:String = "Writ";
		public static const  STATE_MAN:String = "Man";
		public static const  STATE_REPORT:String = "Report";
		public static const  STATE_SETTING:String = "Setting";
		public static const  STATE_FEEDBACK:String = "Feedback";
		public static const  STATE_LIGHT:String = "Light";
		public static const  STATE_LOAD:String = "Load";
		
		protected var _words:Vector.<Word>;
		protected var _reportData:Vector.<Word>;
		protected var _lastContainer:String;
		
		//light Iterator
		protected var _lightIterator:Iterator;
		protected var _lightData:Array;
		//writer
		public var tags:Array;
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		public function getReportData():Vector.<Word>
		{
			return _reportData;
		}
		public function setReportData(data:Vector.<Word>):void
		{
			_reportData = data;
		}
		public function pushToReport(val:Word):void
		{
			if(! _reportData) _reportData = new Vector.<Word>();
			_reportData.push(val);
		}
		public function getLightList():Array
		{
			return _lightData;
		}
		public function setLighitList(vol:Array):void
		{
			_lightData = vol;
		}
		public function getWordsData():Vector.<Word>
		{
			return _words;
		}
		public function setWordsData(val:Vector.<Word>):void
		{
			if(! _words) _words = new Vector.<Word>();
			_words = val;
		}
		public function appendWord(word:Word):void
		{
			if(! _words) _words = new Vector.<Word>();
			_words.push(word);
		}
		public function removeWord(word:Word):void
		{
			_words[word] = null;	
		}
		public function hasWord(word:Word):Boolean
		{
			return _words[word];
		}
		
		public function getLastContainer():String
		{
			return _lastContainer;
		}
		public function setLastContainer(val:String):void
		{
			_lastContainer = val;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Get&Seter
		//
		//--------------------------------------------------------------------------
		public function get lightIterator():Iterator
		{
			return _lightIterator;
		}

		public function set lightIterator(val:Iterator):void
		{
			_lightIterator = val;
		}
	
		
	}
}