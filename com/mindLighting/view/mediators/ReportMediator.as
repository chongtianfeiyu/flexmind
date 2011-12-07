package com.mindLighting.view.mediators
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.WordType;
	import com.mindLighting.model.vo.Words;
	import com.mindLighting.view.components.containers.ReportContainer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ReportMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var mainModel:MainModel;
		[Inject]
		public var v:ReportContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		/**
		 * determine if session report
		 * else if report all data.
		 * if has not init model just get it.
		 */
		override public function onRegister():void
		{
			trace("ReportContainerMediator.onRegister()");
			
			if(mainModel.getReportData())
			{
				setChartData(mainModel.getReportData());
				//clear session report data.
				mainModel.setReportData(null);
			}
			
			else if(mainModel.getWordsData())
			{
				setChartData(mainModel.getWordsData());
			}
			
			else
			{
				mainModel.setLastContainer(MainModel.STATE_REPORT);
				dispatch(new ControlEvent(ControlEvent.CHANGE_STATE, MainModel.STATE_LOAD));
				dispatch(new ControlEvent(ControlEvent.GET_WORDS_ONE_BY_ONE));
			}
				
		}
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function setChartData(words:Vector.<Word>):void
		{
			// empty session report data
			//mainModel.setReportData(null);
			var mindWords:uint = 0;
			var unmindWords:uint = 0;
			var otherWords:uint = 0;
			for each (var item:Word in words)
			{
				switch(item.type)
				{
					case WordType.MIND:
						mindWords++;
						break;
					case WordType.UNMIND:
						unmindWords++;
						break;
					default :
						otherWords++;
				}
			}
			
			v.pcWords.dataProvider = new ArrayCollection( [
				{ Type: "Yes", words: mindWords },
				{ Type: "No", words: unmindWords },
				{ Type: "other", words: otherWords }]);
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnWords(e:ActorEvent):void
		{
			eventMap.unmapListener(eventDispatcher, ActorEvent.WORDS_RETURN, onReturnWords, ActorEvent);
			setChartData((e.body as Words).getWords());
		}
	}
}