package com.mindLighting.control.commands
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.XMLFileSrv;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoadXMLFileCommand extends Command
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var controlEvent:ControlEvent;
		[Inject]
		public var fileSrv:XMLFileSrv;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("LoadFileCommand.execute()");
			eventDispatcher.addEventListener(ActorEvent.XML_FILE_NOT_FOUND, onNoFound);
			eventDispatcher.addEventListener(ActorEvent.XML_FILE_COPIED, onCopyFile);
			loadFile(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		protected function loadFile(e:ActorEvent):void
		{
			fileSrv.loadXMLFileFromStorage(controlEvent.body as String);
		}

		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//-------------------------------------------------------------------------
		/**
		 * If not found try to copy from appliction store.
		 * 
		 */		
		protected function onNoFound(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.XML_FILE_NOT_FOUND, onNoFound);
			fileSrv.copyXMLFileFromApplicationDirectoryToStorage(controlEvent.body as String);
		}
		protected function onCopyFile(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.XML_FILE_COPIED, onCopyFile);
			loadFile(null);
		}
	}
}