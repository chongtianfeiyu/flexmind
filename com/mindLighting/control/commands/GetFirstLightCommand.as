package com.mindLighting.control.commands
{
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Light;
	
	import designpattern.Iterator.StrangeDataStructure;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetFirstLightCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var mainModel:MainModel;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("GetFirstLightCommand.execute()");
			//setup global iterator.
			var lightsData:StrangeDataStructure = new StrangeDataStructure(mainModel.getLightList());
			mainModel.lightIterator = lightsData.getIterator();
			mainModel.lightIterator.first();

			//return first view data.
			var light:Light = new Light();
			light.currentTitle = mainModel.lightIterator.getElement().toString();
			light.perviouTitle = mainModel.lightIterator.getPreviousElement().toString();
			light.length =mainModel.getLightList().length;
			light.currentLength = mainModel.getLightList().length;
			// i get it!
			dispatch(new ActorEvent(ActorEvent.LIGHT_RETURN,light));
		}
	}
}