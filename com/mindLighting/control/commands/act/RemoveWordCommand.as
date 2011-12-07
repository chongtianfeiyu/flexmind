package com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.services.WordSrv;
	
	import org.robotlegs.mvcs.Command;
	
	public class RemoveWordCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var wordSrc:WordSrv;
		[Inject]
		public var e:ControlEvent;
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("RemoveWordCommand.execute()");
			wordSrc.removeWord(e.body as int);
		}
	}
}