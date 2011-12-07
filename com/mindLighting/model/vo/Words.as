package com.mindLighting.model.vo
{
	public class Words
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		private var _words:Vector.<Word>;

		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------	
		public function Words()
		{
			_words = new  Vector.<Word>();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public function addWord(word:Word):void
		{
			_words.push(word);
		}
		
		public function getWords():Vector.<Word>
		{
			return _words;
		}
	}
}