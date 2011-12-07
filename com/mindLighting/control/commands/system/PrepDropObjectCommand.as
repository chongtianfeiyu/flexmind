package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Drop;
	
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Parse drop in data.
	 * 1 remove the same title
	 * 2 remove the if no a title
	 * 3 if file open it and with the same action.
	 * 4 change container by the file type
	 * @author AlanHero
	 * 
	 */	
	public class PrepDropObjectCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var controlEvent:ControlEvent;
		[Inject]
		public var mainModel:MainModel;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("ApplyDropObjectCommand.execute()");
			
			eventDispatcher.addEventListener(ActorEvent.FILE_READ, onReadFile);
			
			(controlEvent.body as Drop).files  ? progressFile() : progressText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 * to light cotainer 
		 * @param text
		 * 
		 */		
		protected function getText(text:String):void
		{
			mainModel.setLighitList(ControlUtil.parseText(text));
			dispatch(new ControlEvent(ControlEvent.CHANGE_STATE, MainModel.STATE_LIGHT));
		}
		
		/**
		 * Determine if not reader container . prep to lights 
		 * 
		 */		
		protected function progressText():void
		{
			if( ! ((contextView as Main).currentState == MainModel.STATE_READ))
			{
				getText((controlEvent.body as Drop).text);
			}
		}
		protected function progressFile():void
		{
			switch((controlEvent.body as Drop).files[0].extension)
			{
				//TODO apply more extenstion or move logic to utils 
				case 'mp3':
				{
					break;
				}
				case 'flv':
				{
					break;
				}
				case 'txt':
				{
					dispatch(new ControlEvent(ControlEvent.READ_FILE, (controlEvent.body as Drop).files[0]));
					break;
				}
				case 'lnk':
				{
					//Humanize
					Alert.show('can not open the link file,plese drap in a ready file','Error');
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReadFile(e:ActorEvent):void
		{
			getText(e.body as String);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}