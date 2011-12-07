package  com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.WordSrv;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.WordType;
	import com.mindLighting.model.vo.Words;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * for load huge data 
	 * @author AlanHero
	 * 
	 */	
	public class GetWordsOneByOneCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var wordSrv:WordSrv;
		[Inject]
		public var mainModel:MainModel;
		
		//TODO separate DBSerivce->DBService->WordService				
		//TODO match out the better offset
		//protected var sessionGetWordNumber:int = 10000;
		protected var sessionGetWordNumber:int = 100;
		protected var totalWords:Vector.<Word> = new Vector.<Word>();
		protected var sessionWords:Array;
		protected var wordOffset:int = 0;
		protected var wordRows:Number = 0;
		protected var sessionRowsNumber:Number = 0;
		
		protected var timer:Timer;		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("GetWordsOneByOneCommand.execute()");
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER,onTimesUp);
			eventDispatcher.addEventListener(ActorEvent.WORD_COUNT,onReturnWordRow);
			eventDispatcher.addEventListener(ActorEvent.WORDS_RETURN, onRetrunWords);
			wordSrv.getWordRows();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------

		protected function next():void
		{
			timer.reset();
			(sessionGetWordNumber > (wordRows - wordOffset)) ? 
			(wordOffset = wordRows - wordOffset) : (wordOffset +=sessionGetWordNumber);
			
			wordSrv.getWords(sessionGetWordNumber,null,wordOffset);
		}
		protected function complete():void
		{
			mainModel.setWordsData(totalWords);
			// determine if get back to last container
			if(mainModel.getLastContainer())
			dispatch(new ControlEvent(ControlEvent.CHANGE_STATE,mainModel.getLastContainer()));
			clearup();
		}
		
		protected function clearup():void
		{
			//TODO release relate members
			timer.removeEventListener(TimerEvent.TIMER,onTimesUp);
			timer = null;
			totalWords = null;
			sessionRowsNumber = 0;
			sessionGetWordNumber = 0;
			wordRows = 0;
			wordOffset = 0;
			eventDispatcher.removeEventListener(ActorEvent.WORD_COUNT,onReturnWordRow);
			eventDispatcher.removeEventListener(ActorEvent.WORDS_RETURN, onRetrunWords);
		}
		
		/**
		 * deter data set up sessionGetWordNumber
		 * 
		 */		
		protected function setUpSessionNumber():void
		{
			if(wordRows > 30000)
			{
				sessionGetWordNumber = 3000;
			}
			else if((wordRows > 2000) && (wordRows < 30000) )
			{
				sessionGetWordNumber = 1000;
			}
			wordSrv.getWords(sessionGetWordNumber);
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onRetrunWords(e:ActorEvent):void
		{
			timer.start();
			var tempWords:Vector.<Word> = new Vector.<Word>();
			for each (var word:Word in (e.body as Words).getWords()) {
				tempWords.push(word);
			}
			if(tempWords.length >0 )
			{
				sessionRowsNumber += tempWords.length;
				totalWords = totalWords.concat(tempWords);				
			}
			dispatch(new  ActorEvent(ActorEvent.WORDS_RETURN_ONE_BY_ONE,[sessionRowsNumber,wordRows]));
		}
		
		protected function onReturnWordRow(e:ActorEvent):void
		{
			wordRows = Number(e.body.rows as Number); 
			if(wordRows == 0)
			{
				var word:Word= new  Word();
				word.title = 'no new word Yet';
				word.type = WordType.UNMIND;
				totalWords.push(word);
				mainModel.setWordsData(totalWords);
				timer.stop();
				clearup();
				return;
			}
			setUpSessionNumber();
		}
		
		protected function onTimesUp(e:TimerEvent):void
		{	
			(wordOffset < wordRows - sessionGetWordNumber) ? next() : complete();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}