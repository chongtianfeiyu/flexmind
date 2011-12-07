package com.mindLighting.view.mediators
{
	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Drop;
	import com.mindLighting.model.vo.ReaderReport;
	import com.mindLighting.model.vo.SaveFile;
	import com.mindLighting.view.components.containers.ReaderContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Mediator;

	public class ReaderMediator extends Mediator
	{	
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected static const COLORFILE_PATH:String = 'formater.html';
		protected static const STATE_START:String = 'Start';
		protected static const STATE_PROGRESS:String = 'Progress';
	
		[Inject]
		public var view:ReaderContainer;

		protected var token:String;
		protected var srceenSize:Boolean = false;
		protected var orgWidth:Number = 0;
		protected var orgHeight:Number = 0;
		
		protected var _htmlText:String;
		protected var _text:String;
		protected var drop:Drop;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("ReaderMediator.onRegister()");
			eventMap.mapListener(eventDispatcher, ActorEvent.DROP_IN, onDropInObject);
			eventMap.mapListener(eventDispatcher, ActorEvent.READER_FORMATUP, onFormated);
			
			view.btnFormat.addEventListener(MouseEvent.CLICK,btnFormatClick);
			view.btnLight.addEventListener(MouseEvent.CLICK,btnLightClick);
			view.addEventListener(MouseEvent.DOUBLE_CLICK,htmlControlClick);
		}
		
		override public function onRemove():void
		{
			trace("ReaderMediator.onRemove()");
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function enableSimpleView():void
		{
			//TODO	
			srceenSize = true;
		}
		
		protected function desableSimpleView():void
		{
			//TODO
			srceenSize = false;
		}
		
		protected function setReportState(report:ReaderReport):void
		{			
			//humanize
			view.lblPersentNumber.text = report.presentNumber.toString().slice(0,3)+"/1" + " mind";
			if(report.presentNumber >= 0.1)
			{
				//TODO if 80% words being minds 
				// show the smile icon
				// meaning is easy to read it
				// how about play a 'ding' sound:)
				view.lblPersentNumber.styleName = 'mind';
			}
			view.lblToalNumber.text = "Total:" + report.totalNumber.toString();
			view.lblUnmindNumber.text  = "and " + report.unmindNumber.toString() +"(No)" ;
		}

		protected function returnInit():void
		{
			view.currentState = STATE_START;
			clearViewData();
		}
		
		protected function clearViewData():void
		{			
			token = '';			
			view.lblPersentNumber.text = '';
			view.lblToalNumber.text = '';
			view.lblUnmindNumber.text = '';
		}
		
		protected function startFomat():void
		{
			dispatch(new ControlEvent(ControlEvent.START_FORMART,drop));
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onFormatFileSave(e:Event):void
		{	
			view.html.location = File.applicationStorageDirectory.resolvePath(COLORFILE_PATH).url;
		}
		
		protected function onFormated(e:ActorEvent):void
		{
			CursorManager.removeBusyCursor();
			var result:ReaderReport = ReaderReport(e.body as ReaderReport);			
			setReportState(result);
			//TODO is okay?
			dispatch(new ControlEvent(ControlEvent.SAVE_XML_FILE, new SaveFile(COLORFILE_PATH,result.formaterText)));
			token = 'formated';
		}
		protected function onDropInObject(e:ActorEvent):void
		{
			drop = (e.body as Drop);
			if(drop.htmlText)
			{
				dispatch(new ControlEvent(ControlEvent.SAVE_XML_FILE,new SaveFile(COLORFILE_PATH,drop.htmlText)));
			}
		}
		protected function htmlControlClick(e:MouseEvent):void
		{
			(srceenSize) ? desableSimpleView() : enableSimpleView();
		}
		protected function btnFormatClick(evt:Event):void
		{
			(token !='formated') ? startFomat() : returnInit();
		}
		protected function btnLightClick(evt:Event):void
		{	
			dispatch(new ControlEvent(ControlEvent.CHANGE_STATE,MainModel.STATE_LIGHT));
		}
		
	}
}