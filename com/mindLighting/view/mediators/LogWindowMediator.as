package com.mindLighting.view.mediators 
{
	import org.robotlegs.mvcs.Mediator;
	
	public class LogWindowMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		public override function  onRegister():void
		{
			trace("LogWindowMediator.onRegister()");		
		}
	}
}