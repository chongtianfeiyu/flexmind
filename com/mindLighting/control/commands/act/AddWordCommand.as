package com.mindLighting.control.commands.act
{
	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.WordSrv;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.Words;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddWordCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var wordSrc:WordSrv;
		[Inject]
		public var controlEvent:ControlEvent;
		[Inject]
		public var mainModel:MainModel;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 *if has exist words .just append its view times 
		 *else store it!
		 *
		 */
		override public function execute():void
		{
			trace("AddWordCommand.execute()");
			if(! mainModel.getWordsData())
			{
				eventDispatcher.addEventListener(ActorEvent.WORDS_RETURN, onReturnWords);
				dispatch(new ControlEvent(ControlEvent.GET_WORDS));
			}
			else
			{
				onReturnWords(null);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnWords(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.WORDS_RETURN, onReturnWords);
			if(e)
			{
				mainModel.setWordsData((e.body as Words).getWords());
			}
			var word:Word = (controlEvent.body as Word);
			if(! ControlUtil.isExist(word.title,mainModel.getWordsData()))
			{
				//append to model for current check (think about else title)
				mainModel.appendWord(word);
				//save it.
				wordSrc.addWord(word);
				
			}
			else
			{
				//just append view times for report
				wordSrc.addCountbyTitle(word);
			}
			
		}
	}
}