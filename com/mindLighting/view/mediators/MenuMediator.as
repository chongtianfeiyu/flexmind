package  com.mindLighting.view.mediators
{	
	import com.mindLighting.model.MainModel;
	import com.mindLighting.view.components.containers.MenuContainer;
	
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Mediator;

	public class MenuMediator extends  Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var view:MenuContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("MenuContainerMediator.onRegister()");
			eventMap.mapListener(view.btnFeelback, MouseEvent.CLICK, btnFeelbackClick);
			eventMap.mapListener(view.btnSettings, MouseEvent.CLICK, btnSettingsClick);
			eventMap.mapListener(view.btnManager, MouseEvent.CLICK, btnManagerClick);
			eventMap.mapListener(view.btnQuickAdd, MouseEvent.CLICK, btnQuickClick);
			eventMap.mapListener(view.btnReport, MouseEvent.CLICK, btnReportClick);
			eventMap.mapListener(view.btnReader, MouseEvent.CLICK, btnReaderClick);
			eventMap.mapListener(view.btnGoal, MouseEvent.CLICK, btnGoalClick);
			eventMap.mapListener(view.btnWriter, MouseEvent.CLICK, btnWriteClick);
			
		}
		override public function onRemove():void
		{
			trace("MenuContainerMediator.onRemove()");
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 * Change the Main Application state 
		 * @param state name
		 * 
		 */
		protected function changeState(state:String):void
		{
//			(contextView as Main).currentState = state;
			FlexGlobals.topLevelApplication.currentState = state;
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function btnGoalClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_GOAL);
		}
		protected function btnFeelbackClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_FEEDBACK);
		}
		protected function btnSettingsClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_SETTING);
		}
		
		protected function btnManagerClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_MAN);
		}
		protected function btnQuickClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_QUICK);
		}
		protected function btnReportClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_REPORT);			
		}
		protected function btnReaderClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_READ);			
		}
		protected function btnWriteClick(e:MouseEvent):void
		{
			changeState(MainModel.STATE_WRITE);			
		}

		
	}
}