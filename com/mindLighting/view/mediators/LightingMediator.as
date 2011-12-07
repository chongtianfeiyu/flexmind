package com.mindLighting.view.mediators
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Light;
	import com.mindLighting.model.vo.WordType;
	import com.mindLighting.view.components.containers.LightingContainer;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.robotlegs.mvcs.Mediator;

	/**
	 * Apply Iterator Lights incomming (normally drop in text)
	 * @author AlanHero
	 * 
	 */	
	public class  LightingMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var view:LightingContainer;
			
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("LightingMediator.onRegister()");
			eventMap.mapListener(eventDispatcher, ActorEvent.LIGHT_RETURN , onRetrunNextTitle ,ActorEvent);
			
			// init first			
			dispatch(new ControlEvent(ControlEvent.GET_FIRST_LIGHT));
			
			eventMap.mapListener(view.btnYes,MouseEvent.CLICK,btnYesClick);
			eventMap.mapListener(view.btnNo, MouseEvent.CLICK,btnNoClick);
			eventMap.mapListener(view.btnOther, MouseEvent.CLICK, btnOtherClick);
			eventMap.mapListener(view,KeyboardEvent.KEY_UP,vKeyUp);
			view.setFocus();
		}
		override public function preRemove():void
		{
			trace("LightingMediator.preRemove()");
			eventMap.unmapListener(eventDispatcher, ActorEvent.LIGHT_RETURN , onRetrunNextTitle);
			eventMap.unmapListener(view.btnYes,MouseEvent.CLICK,btnYesClick);
			eventMap.unmapListener(view.btnNo, MouseEvent.CLICK,btnNoClick);
			eventMap.unmapListener(view.btnOther, MouseEvent.CLICK, btnOtherClick);
			eventMap.unmapListener(view,KeyboardEvent.KEY_UP,vKeyUp);
		}

		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function next(type:String):void
		{
			dispatch(new ControlEvent(ControlEvent.GET_NEXT_LIGHT, type));
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onRetrunNextTitle(e:ActorEvent):void
		{
			var light:Light = (e.body as Light);
			//steel total number while start
			if(light.length !=0 )
			{
				view.newTitlesLength.text = light.length.toString();					
			}
			
			view.lblCurrentTitle.text = light.currentTitle;
			view.lblCurrentLength.text = light.currentLength.toString();
			view.lblProvousTitle.text = light.perviouTitle;
			view.btnYes.setFocus();
		}

		protected function btnYesClick(evt:Event):void
		{
			next(WordType.MIND);
		}
		protected function btnNoClick(evt:Event):void
		{
			next(WordType.UNMIND);
		}
		protected function btnOtherClick(evt:Event):void
		{
			next(WordType.OTHER);
		}
		
		protected function vKeyUp(evt:KeyboardEvent):void
		{
			if(evt.keyCode ==  Keyboard.LEFT )
			{
				next(WordType.MIND);
			}
			else if(evt.keyCode ==  Keyboard.RIGHT)
			{
				next(WordType.UNMIND);
			}
			else if(evt.keyCode ==  Keyboard.DOWN)
			{
				next(WordType.OTHER);
			}
		}
	}
}