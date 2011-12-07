package  com.mindLighting.view.mediators
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.log.Log;
	import com.mindLighting.model.vo.log.LogTags;
	import com.mindLighting.view.components.containers.WriterContainer;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class WriterMediator extends Mediator
	{
		
		[Inject]
		public var view:WriterContainer;
		
		public override function onRegister():void
		{
			trace('MindLog view create.');
			
			//TODO
			// add google auto word service
			// add speak check
			// add mind type title super
			// add sns super eg. the sina miniblog
			// add type /super
					// 'todo' , 'question' , 'techPoint' ,''
			// add weekend /dage/due pop a window list log (for call back)
			eventMap.mapListener(eventDispatcher, ActorEvent.LOGS_RETRUN, onReturnLogs);
			eventMap.mapListener(view.btnAdd,MouseEvent.CLICK,btnAddClick);
			
			dispatch(new  ControlEvent(ControlEvent.GET_LOGS));
			dispatch(new  ControlEvent(ControlEvent.GET_TAGS));
			
		}
		
		protected function onReturnLogs(e:ActorEvent):void
		{
			view.lsLogs.dataProvider = e.body as ArrayList;
		}
		
		protected function btnAddClick(e:MouseEvent):void
		{
			var log:Log= new Log(-1,view.txtALag.text);
			var tags:Array = view.txtType.text.split(",");
			var item:LogTags = new LogTags(log,tags);
			dispatch(new ControlEvent(ControlEvent.ADD_LOG, item))
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}