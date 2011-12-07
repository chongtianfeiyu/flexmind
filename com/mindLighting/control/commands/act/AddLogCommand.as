package  com.mindLighting.control.commands.act
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.LogSrc;
	import com.mindLighting.model.vo.log.Log;
	import com.mindLighting.model.vo.log.LogTags;
	import com.mindLighting.model.vo.log.Tag;
	import com.mindLighting.model.vo.log.TagRelate;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddLogCommand extends Command
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
		[Inject]
		public var logSrv:LogSrc;		
		
		protected var _tagID:Number
		protected var _SessionTags:Array;
		protected var _lastLogID:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		public override function execute():void
		{
			if(! mainModel.tags)
			{
				eventDispatcher.addEventListener(ActorEvent.TAGS_RETURN,onReturnTags);
				dispatch(new ControlEvent(ControlEvent.GET_TAGS));
				return;
			}
			else
			{
				onReturnTags(null);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function isExist(typeString:String, tags:Array):Boolean
		{
			var obj:Object
			for (var i:int=0; i < tags.length ;i++)
			{
				obj = tags[i];
				if(obj.type.toLowerCase() == typeString.toLowerCase())
				{
					_tagID = obj.id;
					return true;
				}
			}
			return false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		
		protected function onReturnTags(e:ActorEvent):void
		{
			if(e)
			{				
				mainModel.tags = [];
				mainModel.tags = e.body as Array;
			}
			
			eventDispatcher.addEventListener(ActorEvent.LOG_ADDED,onLogAdd)
			eventDispatcher.addEventListener(ActorEvent.TAG_ADDED,onTagAdd);
			
			_SessionTags = (controlEvent.body as LogTags).tags;
			var log:Log = (controlEvent.body as LogTags).log;
			logSrv.addLog(log);
		}
		
		protected function onLogAdd(e:ActorEvent):void
		{
			eventDispatcher.removeEventListener(ActorEvent.LOG_ADDED,onLogAdd);
			// get logID and TagID 
			// save relate 
			_lastLogID = e.body.lastInsertRowID;
			for(var i:int=0; i<_SessionTags.length;i++)
			{
				(isExist(_SessionTags[i] , mainModel.tags)) ? logSrv.addRelate(new TagRelate(-1,_lastLogID,_tagID)) :
					logSrv.addTag(new Tag(-1,_SessionTags[i]));
			}
		}
		
		protected function onTagAdd(e:ActorEvent):void
		{			
			eventDispatcher.removeEventListener(ActorEvent.TAG_ADDED,onTagAdd);
			logSrv.addRelate(new TagRelate(-1,_lastLogID,e.body.lastInsertRowID));
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}