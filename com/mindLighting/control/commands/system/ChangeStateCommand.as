package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class ChangeStateCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var controlEvent:ControlEvent;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("ChangeStateCommand.execute()");
			(contextView as Main).currentState = controlEvent.body as String;
		}
	}
}