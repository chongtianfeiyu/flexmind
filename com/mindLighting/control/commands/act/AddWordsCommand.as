package com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.WordSrv;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.Words;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddWordsCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var controlEvent:ControlEvent;
		[Inject]
		public var wordSrv:WordSrv;
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			eventDispatcher.addEventListener(ActorEvent.WORDS_RETURN, onReturnWords);
			trace("SaveWordsCommand.execute()");
			
		}
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		/**
		 * if new word add
		 * otherwise  append view times
		 * @param e
		 * 
		 */		
		protected function onReturnWords(e:ActorEvent):void
		{
			var existWords:Vector.<Word> = (e.body as Words).getWords();
			var newWords:Vector.<Word> = new  Vector.<Word>();
			var inComeWords:Vector.<Word> = new  Vector.<Word>();
			
			for each (var item:Word in existWords) 
			{
				if(! isRepeatWords(item.title, existWords) )
				{
					newWords.push(item);
				}
				else
				{
					inComeWords.push(item);
				}
			}
			wordSrv.addWords(newWords);
			wordSrv.addCountByTitles(inComeWords);
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function isRepeatWords(title:String,words:Vector.<Word>):Boolean
		{	
			if(words.length <=0 ) return false;
			for each (var word:Word in words) {
				if( (word.title.toLowerCase() ) == (title.toLowerCase())  )
				{
					return true;
				}
			}
			
			return false;
		}
	}
}