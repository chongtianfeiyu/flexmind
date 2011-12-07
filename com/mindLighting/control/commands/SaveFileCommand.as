package com.mindLighting.control.commands
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.vo.SaveFile;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Command;
	
	public class SaveFileCommand extends Command
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
			trace("SaveFileCommand.execute()");
			var saveFile:SaveFile = (controlEvent.body as SaveFile);
			var temp:File = File.applicationStorageDirectory.resolvePath(saveFile.name);
			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.CLOSE,onFileSave);
			stream.openAsync(temp,FileMode.WRITE);
			stream.writeUTFBytes(saveFile.data);
			stream.close();
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onFileSave(e:Event):void
		{
			trace("SaveFileCommand.onFileSave(e)");	
		}
	}
}