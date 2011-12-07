package com.mindLighting.view.mediators
{
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.view.components.containers.LoaderContainer;
	import com.mindLighting.view.components.containers.ReportContainer;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LoaderMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var view:LoaderContainer;
		[Inject]
		public var mainModel:MainModel;
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("LoaderContainerMediator.onRegister()");
			eventMap.mapListener(eventDispatcher, ActorEvent.WORDS_RETURN_ONE_BY_ONE, onReturnSessionWords);
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function updateViewState(
			currentValue:Number,totalValue:Number,minimum:Number,maximum:Number):void
		{
			view.loadBar.mode = "manual";
			view.loadBar.setProgress(currentValue,totalValue);
			view.loadBar.minimum = minimum;
			view.loadBar.maximum = maximum;
			//view.loadBar.label= currentValue.toString() + " / " + totalValue.toString();
		}

		protected function clearup():void
		{
			eventMap.unmapListener(eventDispatcher, ActorEvent.WORDS_RETURN_ONE_BY_ONE, onReturnSessionWords);
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnSessionWords(e:ActorEvent):void
		{
			var result:Array = (e.body as Array);
			updateViewState(result[0], result[1], 0, result[1]);
		}
		
		override public function onRemove():void
		{
			trace("LoaderContainerMediator.onRemove()");
			clearup();
		}	
	}
}