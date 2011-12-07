package  com.mindLighting.view.mediators
{
	import com.mindLighting.model.MainModel;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	import com.mindLighting.view.components.containers.GoalContainer;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import org.robotlegs.mvcs.Mediator;

	public class GoalMediator extends Mediator
	{
	
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		private static const STATE_START:String = 'Start';
		private static const STATE_SUCCESS:String = 'Success';
		private static const STATE_SETUPGOAL:String = 'SetupGoal';
		private static const SET_CURRENTGOAL:String = 'currentGoal';
		//TODO 
		private static const SET_SHAREURL:String = 'http://www.mindlight.net.com/share';
		private static const SET_SHARETITLE:String = 'Woo~~~';
		private static const SET_COMMENT:String = '这个软件';
		
		[Inject]
		public var view:GoalContainer;
		[Inject]
		public var mainModel:MainModel;
		protected var sets:Dictionary;
		protected var _nextGoal:String;
		protected var _change:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("GoalContainerMediator.onRegister()");
			eventMap.mapListener(eventDispatcher, ActorEvent.SETTINGS_RETURN, onReturnSettings);
			dispatch(new ControlEvent(ControlEvent.GET_SETTINGS));
			eventMap.mapListener(view.btnSave, MouseEvent.CLICK, onBtnSaveClick);
			eventMap.mapListener(view.txtGoal, FocusEvent.FOCUS_IN, onFocus);
			eventMap.mapListener(view.txtGoal, FlexEvent.ENTER, onTxtGoalEnter);
			eventMap.mapListener(view.txtGoal, Event.CHANGE, onTxtGoalChange);
			eventMap.mapListener(view.btnQuickAdd, MouseEvent.CLICK, onBtnQuickAddClick);
		}

		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function getGoal():void
		{
			//if setup goal before
			if(_nextGoal && (_change == false))
			{
				saveGoal(_nextGoal);_change=true;return;
			}
			
			var goal:String = StringUtil.trim(view.txtGoal.text);
			if( (goal == '') || (Number(goal) <=0) )
			{
				view.txtGoal.text="请输入一个正确的目标";return;
			}
			
			if(sets[SET_CURRENTGOAL])
			{	
				(Number(goal) > Number(sets[SET_CURRENTGOAL])) ? saveGoal(goal) : 
					view.txtGoal.text = '当前目标要大于先前目标: ' + sets[SET_CURRENTGOAL].toString() + ' 个';
			}
			else
			{
				saveGoal(view.txtGoal.text);
			}
		}
		protected function saveGoal(val:String):void
		{
			var currentGoal:Setting = new Setting(SET_CURRENTGOAL,val);
			var goalOK:Setting = new Setting('goalOK',false);
			dispatch(new ControlEvent(ControlEvent.ADD_SETTINGS,[currentGoal,goalOK]));
			dispatch(new ControlEvent(ControlEvent.REMOVE_SETTING,'showSuccess'));
				
			//v.currentState = STATE_SETUPGOAL;
			//TODO gohome
			(contextView as Main).currentState = "Menu";
		}
		
		protected function generateGoalNumber():void
		{
			_nextGoal = (sets[SET_CURRENTGOAL] + 500);
			if(sets['showSucess'])
			{				
				view.txtGoal.text = "下一个目标..." + _nextGoal + " 个？";
			}
			else
			{	
				view.txtGoal.text = "写下你的目标单词量,如:" + _nextGoal;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onReturnSettings(e:ActorEvent):void
		{
			sets = (e.body as Settings).getSettings();
			if(sets['showSuccess'] == true)
			{
				view.currentState = STATE_START;
			}
			else if(sets['goalOk'] == true)
			{
				dispatch(new ControlEvent(ControlEvent.ADD_SETTING,new Setting('showSucess',true)));
				//TODO Save goal history version2.0
				view.currentState = STATE_SUCCESS;
			}			
			if(! sets[SET_CURRENTGOAL])
			{
				//set first goal equre 0;
				sets[SET_CURRENTGOAL] = 0;
			}
			generateGoalNumber();
			view.lblGoal.text = "目标:" + sets[SET_CURRENTGOAL].toString() + " 个达到了！";	
				
		}
		
		override public function onRemove():void
		{
			trace("GoalContainerMediator.onRemove()");
		}
		
		protected function onTxtGoalChange(e:Event):void
		{
			_change = true;
		}
		protected function onBtnBarChange(e:Event):void
		{
			view.txtGoal.text = e.target.selectedItem.toString();
		}
		protected function onBtnSaveClick(e:Event):void
		{
			getGoal();
		}
		
		protected function onTxtGoalEnter(e:FlexEvent):void
		{
			getGoal();
		}
		
		protected function onFocus(e:FocusEvent):void
		{	
			_nextGoal ? view.txtGoal.text = _nextGoal : view.txtGoal.text = "";	
		}
		
		protected function onBtnQuickAddClick(e:Event):void
		{
			(contextView as Main).currentState = MainModel.STATE_QUICK;
		}	
	}
}