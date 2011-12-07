package com.mindLighting.control.commands.system
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.vo.Drop;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.NativeDragEvent;
	
	import mx.core.IUIComponent;
	import mx.managers.DragManager;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Setup drop in data  and Redirect section by the data
	 */	
	public class PrepDropCommand extends Command
	{
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("PrepDropCommand.execute()");
			contextView.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			contextView.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDragDrop);
			contextView.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,onDragExit);
		}

		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onDragEnter(evt:NativeDragEvent):void
		{
			if(evt.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var files:Array = evt.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;					
				DragManager.acceptDragDrop(evt.currentTarget as IUIComponent);	
			}
			if((evt.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) || 
			(evt.clipboard.hasFormat(ClipboardFormats.HTML_FORMAT)) )
			{
				DragManager.acceptDragDrop(evt.currentTarget as IUIComponent);
			}
			// TODO if file is url
			if(evt.clipboard.hasFormat(ClipboardFormats.URL_FORMAT)){}
		}
		protected function onDragDrop(e:NativeDragEvent):void
		{
			var dropObj:Drop = new Drop();
			
			if(e.clipboard.hasFormat(ClipboardFormats.HTML_FORMAT))
			{
				dropObj.htmlText = e.clipboard.getData(ClipboardFormats.HTML_FORMAT) as String;
			}
			if(e.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT))
			{
				dropObj.text = e.clipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
			}
			
			if(e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				if (files.length ==0) return;
				dropObj.files = files;
			}
			dispatch(new ControlEvent(ControlEvent.DROP_IN_OBJECT, dropObj));
		}
		protected function onDragExit(event:NativeDragEvent):void
		{
			//TODO
		}
		
		
	}
}