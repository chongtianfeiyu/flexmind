package com.mindLighting.control.commands
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class ReadFileCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var controlEvent:ControlEvent;
		protected var _fileStream:FileStream;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("ReadFileCommand.execute()");
			_fileStream = new FileStream();
			_fileStream.addEventListener(Event.COMPLETE,onFileOpen);
			_fileStream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_fileStream.openAsync(controlEvent.body, FileMode.READ);	
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onFileOpen(e:Event):void
		{
			var text:String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
			_fileStream.close();
			dispatch(new ActorEvent(ActorEvent.FILE_READ, text));
		}
		protected function ioErrorHandler(evt:IOErrorEvent):void
		{
			//TODO 
		}	
	}
}