package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.events.FileSrvEvent;
	import com.mindLighting.model.services.XMLFileSrv;
	import com.mindLighting.model.services.LogSrc;
	import com.mindLighting.model.services.SettingSrv;
	import com.mindLighting.model.services.WordSrv;
	import com.mindLighting.model.vo.Settings;
	import com.mindLighting.model.vo.Words;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 
	 * @author AlanHero
	 * 
	 */	
	public class PrepModelCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		/**
		 * Note: for the Word/Words/Setting/Settings etc. value object
		 * need to map dependance weather need inject
		 * Here is no need to map now.
		 * 
		 */		
		override public function execute():void
		{
			trace("PrepModelCommand.execute()");
			injector.mapSingleton(WordSrv);
			injector.mapSingleton(SettingSrv);
			injector.mapSingleton(LogSrc);
			injector.mapSingleton(XMLFileSrv);
			injector.mapSingleton(MainModel);
			
		}
		
	}
}