package com.mindLighting.view.mediators
{
	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.WordType;
	import com.mindLighting.view.components.containers.QuickContainer;
	import com.mindLighting.view.components.items.QuickItem;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	import mx.events.StateChangeEvent;
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Mediator;
	
	
	public class QuickMediator extends Mediator
	{		

		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected static const STATE_SETTING:String = 'Setting';
		public static const PATH:String = 'assets/dic/';
		[Inject]
		public var view:QuickContainer;
		protected var sets:Dictionary;
		protected var _dicTitles:Array = [];
		protected var _chooseWords:Array = [];
		protected var _sessionTitles:Array;
		protected var _dicQuickLength:Number = 100;
		protected var _dicLastIndex:Number;
		protected var _defaultDic:String = 'basic';		
		protected static const EXT:String = '.dic';
		/**
		 * keyboard press limit. 
		 */		
		protected var rightBottomIndex:int;
		protected var leftTopIndex:int;
		protected var currentElementIndex:int;
		protected var sessionFirstChoose:Boolean = false;
		protected var _tabIndex:int =0;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		/**
		 * Step 1 Get settings 
		 * Step 2 load dic file
		 * 
		 */		
		override public function onRegister():void
		{
			trace("QuickAddContainerMediator.onRegister()");
			CursorManager.setBusyCursor();
			eventMap.mapListener(eventDispatcher, ActorEvent.XML_FILE_LOADED, onLoadedFile);
			eventMap.mapListener(eventDispatcher, ActorEvent.SETTINGS_RETURN, onReturnSettings);
			eventMap.mapListener(view, KeyboardEvent.KEY_UP, vKeyup);
			eventMap.mapListener(view.btnNext, MouseEvent.CLICK, btnNextClick);
			dispatch(new ControlEvent(ControlEvent.GET_SETTINGS));	
		}
		
		override public function preRemove():void
		{
			trace("QuickAddContainerMediator.onRemove()");
			clearup();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function complete():void
		{	
			saveKeys();
			dispatch(new ControlEvent(ControlEvent.ADD_WORDS,_chooseWords));
			
			//SAVE return data
			//change to report container
			dispatch(new ControlEvent(ControlEvent.CHANGE_STATE,_chooseWords));
		}
		
		protected function next():void
		{
			var initWord:Word
			var mindItem:QuickItem
			_tabIndex = 0;
			view.wordGroup.removeAllElements();
			for each (var title:String in _sessionTitles.splice(0,20))
			{
				initWord = new Word();
				initWord.title = title;
				initWord.type = WordType.UNMIND;
						
				mindItem= new QuickItem();
				mindItem.addEventListener(MouseEvent.CLICK,quickItemSelect);
				mindItem.tabIndex = _tabIndex;
				mindItem.title = initWord.title;
				_tabIndex ++;
		
				//save initWords
				_chooseWords.push(initWord);
				// bind to next ui
				view.wordGroup.addElement(mindItem);
				trace( view.wordGroup.numChildren.toString());
			}
			//fill it if no enouth 20 item
			fillItem();
		}
		
		protected function fillItem():void
		{
			var mindItem:QuickItem;
			if(_tabIndex < 20)
			{
				var fillLength:int = 20 -_tabIndex;
				for (var i:int = 0; i < fillLength; i++) 
				{					
					mindItem= new QuickItem();
					_tabIndex ++;
					mindItem.tabIndex = _tabIndex;
					view.wordGroup.addElement(mindItem);
				}
			}
		}
		
		protected function saveKeys():void
		{		
			var defaultDic:Setting = new Setting('defaultDic');
			var dicQuickLength:Setting = new Setting('dicQuickLength');
			var defaultDicLastIndex:Setting = new Setting(_defaultDic + 'LastIndex');
			defaultDic.value = _defaultDic;
			dicQuickLength.value = _dicQuickLength;
			defaultDicLastIndex.value = (sets[_defaultDic + 'LastIndex'] + _dicQuickLength);
			dispatch(new ControlEvent(ControlEvent.ADD_SETTINGS, [defaultDic, dicQuickLength, 
			defaultDicLastIndex]));

			if(_dicLastIndex > _dicTitles.length - 1 )
			{	
				var dicComplete:Setting = new Setting(sets[sets['defaultDic'] + 'DicComplete'],true);
				dispatch(new ControlEvent(ControlEvent.ADD_SETTING,dicComplete));
			}
		}
		
		protected function clearup():void
		{
			view.removeEventListener(KeyboardEvent.KEY_UP,vKeyup);_chooseWords = null;
			_sessionTitles = null;
			_dicTitles = null;
		}
		
		/**
		 * determine if last secction
		 * determine if has last index. 			
		 * 	sets current dic is complete
		 */		
		protected function initQuick():void
		{
			_defaultDic = sets['defaultDic'] ? sets['defaultDic'] : _defaultDic;
			_dicQuickLength = sets['dicQuickLength'] ? sets['dicQuickLength'] : _dicQuickLength;
			_dicLastIndex = sets[_defaultDic +'LastIndex'] ? sets[_defaultDic +'LastIndex'] : 0;
			if(_dicLastIndex < _dicTitles.length - 1 )
			{
				_sessionTitles = _dicTitles.splice(_dicLastIndex,_dicQuickLength);	
				btnNextClick();
			}
			else
			{
				dispatch(new ControlEvent(ControlEvent.ADD_SETTING,new Setting(_defaultDic+"DicComplete",true)));
				//TODO version 1.2 add online dic
				dispatch(new ControlEvent(ControlEvent.CHANGE_STATE, MainModel.STATE_MENU));
				Alert.show("Finished 2000+ words.","Nice!");
			}
		}
		

		protected function changeFocusElementIndex(index:int):void
		{
			view.focusManager.setFocus(view.wordGroup.getElementAt(index) as QuickItem);
		}
		
		protected function getNextElementIndex(back:Boolean):int
		{
			var index:int
			if(back)
			{				
				index = view.wordGroup.getElementIndex(view.focusManager.getNextFocusManagerComponent(true) as QuickItem);
				//make the right cp
				index +=1;
			}
			else
			{
				index = view.wordGroup.getElementIndex(view.focusManager.getNextFocusManagerComponent() as QuickItem);
				//roll back make the right cp
				index -=1;
			}
			return index;
		}
		
		protected function inBound(index:int):Boolean
		{
			return ( (index >=0 ) && (index <= _tabIndex));
		}
		
		protected function getFocusElementIndex(back:Boolean,set:int):int
		{
			if(back)
			{
				if(currentElementIndex >= 1)
				{
					currentElementIndex = getNextElementIndex(true);	
					currentElementIndex -=set;
				}
				else
				{
					changeFocusElementIndex(_tabIndex-1);
					currentElementIndex = _tabIndex-1;
				}
			}
			else
			{
				if(currentElementIndex <= _tabIndex - 2)
				{
					currentElementIndex = getNextElementIndex(false);
					currentElementIndex +=set;
				}
					
				else
				{
					changeFocusElementIndex(0);
					currentElementIndex = 0;
				}
			}
			//roll back get the right elementIndex
			return currentElementIndex;
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
	
		protected function onLoadedFile(e:ActorEvent):void
		{
			CursorManager.removeBusyCursor();
			eventMap.unmapListener(eventDispatcher, ActorEvent.XML_FILE_LOADED ,onLoadedFile);
		 	_dicTitles = ControlUtil.praseTitle(e.body as XML);
			initQuick();
		}
		
		protected function onReturnSettings(e:ActorEvent):void
		{
			eventMap.unmapListener(eventDispatcher, ActorEvent.SETTINGS_RETURN, onReturnSettings);
			sets = (e.body as Settings).getSettings();
			//get dic
			dispatch(new ControlEvent(ControlEvent.GET_XML_FILE, PATH + _defaultDic + EXT));	
		}
		
		protected function btnNextClick(evt:Event=null):void
		{
			(_sessionTitles.length > 0 ) ? next() : complete();
			mx.managers.CursorManager.removeBusyCursor();
		}
		
		protected function pressRight():void
		{
			// get
			// if element index <0 && index < 19
			// set next
			var nextElementIndex:int = getFocusElementIndex(false,1);
			if(inBound(nextElementIndex))
			{
				changeFocusElementIndex(nextElementIndex);	
			}
			
		}
		
		protected function pressLift():void
		{
			// get
			// if element index <0 && index >19
			// set next
			var prevousElementIndex:int = getFocusElementIndex(true,1);
			if(inBound(prevousElementIndex) )
			{
				changeFocusElementIndex(prevousElementIndex);	
			}
			
		}
		protected function pressUp():void
		{
			if((currentElementIndex >= 0) && (currentElementIndex <=3))
				return;
			
			var nextElementIndex:int = getFocusElementIndex(true,4);
			if(inBound(nextElementIndex))
			{
				changeFocusElementIndex(nextElementIndex);	
			}
		}
		
		protected function pressDown():void
		{
			if((currentElementIndex >= 16) && (currentElementIndex <=19)) return;
			
			var nextElementIndex:int = getFocusElementIndex(false,4);
			if(inBound(nextElementIndex))
			{
				changeFocusElementIndex(nextElementIndex);	
			}
			
		}
		protected function vKeyup(e:KeyboardEvent):void
		{
			// default choose first 
			if(! sessionFirstChoose)
			{
				trace('first item focus.');
				currentElementIndex = 0;
				changeFocusElementIndex(0);
				sessionFirstChoose = true;
			}
			else if(e.keyCode == Keyboard.LEFT)
			{
				pressLift();
			}
			else if(e.keyCode == Keyboard.RIGHT)
			{
				pressRight();
			}
			else if(e.keyCode == Keyboard.DOWN)
			{
				pressDown();
			}
			else if(e.keyCode == Keyboard.UP)
			{
				pressUp();
			}
			else if(e.keyCode == Keyboard.ENTER)
			{
				btnNextClick();
				currentElementIndex = 0;
				sessionFirstChoose = false;
			}
			
		}
		
		protected function quickItemSelect(e:Event):void
		{
			sessionFirstChoose = true;
			for (var i:int = 0; i < _chooseWords.length; i++) 
			{
				if(_chooseWords[i].title == e.target.label)
				{
					_chooseWords[i].type = WordType.MIND;
					trace(e.target.label + ' is mind.')
				}
			}
			e.target.label = ""; 
		}
	}
}