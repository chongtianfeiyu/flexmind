package com.mindLighting.control.commands.system
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.events.ErrorEvent;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;

	public class UpdateCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		public static const UPDATEURL:String = "http://localhost/mindlighting/media/air/update.xml";
		public  var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI(); 		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("UpdateCommand.execute()");
			// set the URL for the update.xml file
			appUpdater.updateURL = UPDATEURL;
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.addEventListener(ErrorEvent.ERROR, onUpdaterError);
			// Hide the dialog asking for permission for checking for a new update.
			// If you want to see it just leave the default value (or set true).
			appUpdater.isCheckForUpdateVisible = false;
			appUpdater.isDownloadProgressVisible = false;
			trace("current version: " + appUpdater.currentVersion);
			//appUpdater.initialize();
		}

		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		public  function onUpdate(event:UpdateEvent):void 
		{
			appUpdater.checkNow();
		}
		
		public  function onUpdaterError(event:ErrorEvent):void
		{
			//TODO
		}
		
		//--------------------------------------------------------------------------
		//
		//  Method
		//
		//--------------------------------------------------------------------------
		public function versionHelper():void
		{
			var appXML:XML =   FlexGlobals.topLevelApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			trace('current Version is: ' + appXML.ns::version );
		}

	}
}