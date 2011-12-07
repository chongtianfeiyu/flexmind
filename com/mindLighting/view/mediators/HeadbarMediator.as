package com.mindLighting.view.mediators
{
	import com.mindLighting.view.components.bars.Headbar;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class HeadbarMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var v:Headbar;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("HeadbarMediator.onRegister()");
			eventMap.mapListener(v.btnHome,MouseEvent.CLICK,btnHomeClick);
			eventMap.mapListener(v,MouseEvent.MOUSE_DOWN,vDown);
			eventMap.mapListener(v.btnMin,MouseEvent.CLICK,btnMinClick);
			eventMap.mapListener(v.btnClose,MouseEvent.CLICK,btnCloseClick);
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function btnHomeClick(e:MouseEvent):void
		{
			trace("HeadbarMediator.btnHomeClick()");
			v.parentApplication.currentState = 'Menu';
		}

		protected function vDown(e:MouseEvent):void
		{
			v.stage.nativeWindow.startMove();			
		}
		
		protected function btnMinClick(e:MouseEvent):void
		{
			v.stage.nativeWindow.minimize();		
		}

		protected function btnCloseClick(e:MouseEvent):void
		{
			v.stage.nativeWindow.visible = false;
		}
	}
}