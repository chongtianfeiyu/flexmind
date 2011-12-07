package com.mindLighting.view.mediators
{	
	
	import com.mindLighting.model.MainModel;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	import com.mindLighting.view.components.containers.SettingContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SettingMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		[Inject]
		public var view:SettingContainer;
		protected var keys:Dictionary;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, ActorEvent.SETTINGS_RETURN, onReturnSettings);
			dispatch(new ControlEvent(ControlEvent.GET_SETTINGS));
			trace("SettingContainerMediator.onRegister()");
			view.btnAutoStart.addEventListener(MouseEvent.CLICK,btnAutoStartClick);
			view.btnRandomSection.addEventListener(MouseEvent.CLICK,btnRandomSectionClick);
			view.btnSave.addEventListener(MouseEvent.CLICK,btnSaveClick);
			view.btnLogDay.addEventListener(MouseEvent.CLICK,btnLogDayClick);
			view.btnLogWeekend.addEventListener(MouseEvent.CLICK,btnLogWeekendsClick);
			view.btnLogMonth.addEventListener(MouseEvent.CLICK,btnLogMonthClick);
			eventMap.mapListener(view.btnNormal, MouseEvent.CLICK, btnNormalClick);
			eventMap.mapListener(view.btnLog, MouseEvent.CLICK, btnLogClick);
		}
		
		override public function onRemove():void
		{
			trace("SettingContainerMediator.onRemove()");
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function updateViewValue():void
		{
			// global
			view.btnAutoStart.selected = keys['autoLaunch'];
			view.btnRandomSection.selected = keys['randomSection'];
			// setings 
			view.btnLogDay.selected = keys['showDaysLogs'];
			view.btnLogWeekend.selected = keys['showWeeksLogs'];
			view.btnLogMonth.selected = keys['showMonthLogs'];
			if(keys['showLogTime'])
			{
				var timeString:String = keys['showLogTime'];
				(Number(timeString.substring(0,1)) == 0) ? view.numHour.value = Number(timeString.substring(2,1)) :
					view.numHour.value = Number(timeString.substring(0,2));
				
				(Number(timeString.substring(3,1)) == 0) ? view.numHour.value = Number(timeString.substring(5,1)) :
					view.numMinute.value = Number(timeString.substring(3));
			}			
			btnAutoStartClick(null);
			btnRandomSectionClick(null);
			btnLogDayClick(null);
			btnLogWeekendsClick(null);
			btnLogMonthClick(null);
		}
		
		protected function SaveSettings():void
		{
			// global section
			var autoLaunch:Setting = new  Setting('autoLaunch');
			view.btnAutoStart.selected ? autoLaunch.value = true : autoLaunch.value = false;
			var randomSection:Setting = new Setting('randomSection');
			view.btnRandomSection.selected ? randomSection.value = true : randomSection.value = false;
			// log section
			var showDaysLogs:Setting = new Setting('showDaysLogs');
			var showWeeksLogs:Setting = new Setting('showWeeksLogs');
			var showMonthLogs:Setting = new Setting('showMonthLogs');
			view.btnLogDay.selected ? showDaysLogs.value = true : showDaysLogs.value = false;
			view.btnLogWeekend.selected ? showWeeksLogs.value = true : showWeeksLogs.value = false;
			view.btnLogMonth.selected ? showMonthLogs.value = true : showMonthLogs.value = false;
			
			var showLogTime:Setting = new Setting('showLogTime');
			var hour:String = view.numHour.value.toString();
			(hour.length == 1) ? (hour = ("0" + hour)) : hour;			
			var minute:String  = view.numMinute.value.toString();
			(minute.length == 1) ? (minute = ("0" + minute)) : minute;
			showLogTime.value = (hour + ":" + minute);
			//save settings
			dispatch(new ControlEvent(ControlEvent.ADD_SETTINGS,
				[autoLaunch, randomSection, showDaysLogs, showWeeksLogs, showMonthLogs, showLogTime]));
			// go home
			dispatch(new ControlEvent(ControlEvent.CHANGE_STATE,MainModel.STATE_MENU));	
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnSettings(e:ActorEvent):void
		{
			keys = (e.body as Settings).getSettings();
			updateViewValue();
		}
	
		protected function btnSaveClick(e:MouseEvent):void
		{
			SaveSettings();
		}
		protected function btnAutoStartClick(e:MouseEvent):void
		{
			view.btnAutoStart.label = view.btnAutoStart.selected ? "Yes" : "No";
		}
		protected function btnRandomSectionClick(e:MouseEvent):void
		{
			view.btnRandomSection.label = view.btnRandomSection.selected ? "Yes" : "No";		
		}
		protected function btnLogDayClick(e:MouseEvent):void
		{
			view.btnLogDay.label = view.btnLogDay.selected  ? "Yes" : "No";		
		}
		protected function btnLogWeekendsClick(e:MouseEvent):void
		{
			view.btnLogWeekend.label = view.btnLogWeekend.selected ? "Yes" : "No";		
		}
		protected function btnLogMonthClick(e:MouseEvent):void
		{
			view.btnLogMonth.label = view.btnLogMonth.selected ? "Yes" : "No";		
		}
		
		protected function btnNormalClick(e:Event):void
		{
			view.viewStack.selectedChild = view.normal;
		}
		protected function btnLogClick(e:Event):void
		{
			view.viewStack.selectedChild = view.log;
		}

		
	}
}