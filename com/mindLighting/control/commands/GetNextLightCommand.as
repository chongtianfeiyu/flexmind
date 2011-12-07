package com.mindLighting.control.commands
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Light;
	import com.mindLighting.model.vo.Word;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetNextLightCommand extends Command
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
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
		 *push to report 
		 * and store new title or add exist title view times
		 */
		override public function execute():void
		{
			trace("GetNextLightCommand.execute()");
			(mainModel.lightIterator.hasNext()) ? setNextLight() : complete();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 * save session report data.
		 * Save session work to database.
		 * TODO version 1.2 report exist titles 
		 * 
		 */		
		protected function saveToReport():void
		{
			var word:Word = new Word();
			word.title  = (mainModel.lightIterator.getElement() as String);
			word.type = (controlEvent.body as String);
			mainModel.pushToReport(word);
			dispatch(new ControlEvent(ControlEvent.ADD_WORD, word));
		}
		
		/**
		 * show session report while finished. 
		 */			
		protected function complete():void
		{
			dispatch(new ControlEvent(ControlEvent.CHANGE_STATE,MainModel.STATE_REPORT));			
		}

		/**
		 * make sure the base logic in  getElement() && getPreviousElement()
		 * 
		 */		
		protected function setNextLight():void
		{
			var light:Light = new Light();
			light.currentTitle = mainModel.lightIterator.getPreviousElement().toString();
			light.perviouTitle = mainModel.lightIterator.getElement().toString();
			light.length =mainModel.getLightList().length;
			light.currentLength = mainModel.lightIterator.getCurrentIndex();
			dispatch(new ActorEvent(ActorEvent.LIGHT_RETURN,light));
			
			saveToReport();

			mainModel.lightIterator.next();
		}
	}
}