package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.SyncEvent;
	import flash.system.System;
	
	import org.robotlegs.mvcs.Command;
	
	public class SetAutoLounchCommand extends Command
	{
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("SetAutoLounchCommand.execute()");
			eventDispatcher.addEventListener(ActorEvent.SETTINGS_RETURN, onReturnSettings);
			dispatch(new ControlEvent(ControlEvent.GET_SETTINGS));
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------	
		protected function onReturnSettings(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.SETTINGS_RETURN, onReturnSettings);
			var autoRun:Boolean = (e.body as Settings).getSetting('autoRun');
			(autoRun) ? NativeApplication.nativeApplication.startAtLogin = true :
			NativeApplication.nativeApplication.startAtLogin = false;
		}
	}
}