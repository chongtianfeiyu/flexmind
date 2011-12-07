package com.mindLighting.control.commands.system
{
	import com.mindLighting.view.components.bars.Headbar;
	import com.mindLighting.view.components.containers.FeedbackContainer;
	import com.mindLighting.view.components.containers.LightingContainer;
	import com.mindLighting.view.components.containers.LoaderContainer;
	import com.mindLighting.view.components.containers.ManContainer;
	import com.mindLighting.view.components.containers.MenuContainer;
	import com.mindLighting.view.components.containers.QuickContainer;
	import com.mindLighting.view.components.containers.ReaderContainer;
	import com.mindLighting.view.components.containers.ReportContainer;
	import com.mindLighting.view.components.containers.SettingContainer;
	import com.mindLighting.view.components.containers.WriterContainer;
	import com.mindLighting.view.components.windows.LogWindow;
	import com.mindLighting.view.mediators.FeedbackMediator;
	import com.mindLighting.view.mediators.HeadbarMediator;
	import com.mindLighting.view.mediators.LightingMediator;
	import com.mindLighting.view.mediators.LoaderMediator;
	import com.mindLighting.view.mediators.LogWindowMediator;
	import com.mindLighting.view.mediators.ManMediator;
	import com.mindLighting.view.mediators.MenuMediator;
	import com.mindLighting.view.mediators.QuickMediator;
	import com.mindLighting.view.mediators.ReaderMediator;
	import com.mindLighting.view.mediators.ReportMediator;
	import com.mindLighting.view.mediators.SettingMediator;
	import com.mindLighting.view.mediators.WriterMediator;
	
	import org.robotlegs.mvcs.Command;
	
	public class PrepViewCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			//TODO
			trace("PrepViewCommand.execute()");
			mediatorMap.mapView(Headbar, HeadbarMediator);
			mediatorMap.mapView(ReportContainer, ReportMediator);
			mediatorMap.mapView(MenuContainer, MenuMediator);
			mediatorMap.mapView(SettingContainer, SettingMediator);
			mediatorMap.mapView(LoaderContainer, LoaderMediator);
			mediatorMap.mapView(FeedbackContainer, FeedbackMediator);
			mediatorMap.mapView(ManContainer, ManMediator);
			mediatorMap.mapView(ReaderContainer, ReaderMediator);
			mediatorMap.mapView(LightingContainer, LightingMediator);
			mediatorMap.mapView(WriterContainer, WriterMediator);
			mediatorMap.mapView(LogWindow, LogWindowMediator);
			mediatorMap.mapView(QuickContainer, QuickMediator);
			//mediatorMap.mapView(GoalContainer, GoalContainerMediator);
		}
		
	}
}