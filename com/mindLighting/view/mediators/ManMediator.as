package com.mindLighting.view.mediators
{

	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Word;
	import com.mindLighting.model.vo.WordType;
	import com.mindLighting.view.components.containers.ManContainer;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	import mx.events.ValidationResultEvent;
	import mx.utils.StringUtil;
	import mx.validators.RegExpValidator;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * manual manager word class
	 * list,add,modify,and remove word
	 * 
	 */ 
	public class ManMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected static const MODIFY:String = "Modify";
		protected static const SEARCH:String = "Search";
		protected static const ADD:String = "Add";
		
		protected static const NOSEARCHRESULT:String = "No Search Result, Add it?";
		protected static const SEARCHMSG:String = "Search...";
		
		[Inject]
		public var view:ManContainer;
		
		[Inject]
		public var windowUtl:MainModel;
		
		protected var regValidator:RegExpValidator;
		protected var regexp:RegExp;

		protected var wordExist:Boolean = false;
		protected var wordList:ArrayList = new ArrayList();		
		protected var compareIndex:int = 0;
		protected var searchWordList:ArrayList = new ArrayList();
		protected var searchIndex:int = 0;
		protected var wordSelectedItem:Object;
		protected var wordSelectedIndex:int;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("ManContainerMediator.onRegister()");
			eventMap.mapListener(eventDispatcher,ActorEvent.WORD_MODIFY,onModfiy);
			eventMap.mapListener(eventDispatcher,ActorEvent.WORD_EXIST_CHECK,onCheckWord);
			eventMap.mapListener(eventDispatcher,ActorEvent.WORD_REMOVE,onDBRemove);

			if(! windowUtl.getWordsData())
			{
				windowUtl.setLastContainer(MainModel.STATE_MAN);
				dispatch(new ControlEvent(ControlEvent.GET_WORDS_ONE_BY_ONE));
				return;
			}
			
			wordList = new ArrayList(windowUtl.getWordsData() as Array);			
			view.lsWord.dataProvider = wordList;
			
			view.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,vStateChange);
			view.txtTitle.addEventListener(FocusEvent.FOCUS_IN,txtTitleFocus);
			view.txtTitle.addEventListener(Event.CHANGE,txtTitleChange);
			view.lsWord.addEventListener(MouseEvent.CLICK, lsWordsClick);
		}
		
		override public function onRemove():void
		{
			trace("ManContainerMediator.onRemove()");
		}
		
		protected function onCheckWord(e:ActorEvent):void
		{
			var token:String ='';
			if(e.body.data[0])
			{	
				backToSearchState();
				token = e.body.data[0].title;
			}
			else
			{				
				if((token !='') && (token ==searchText))
				{
					backToSearchState();
				}
				else
				{
					//! if not exist
					view.currentState = ADD;
					token = '';
				}
			}
		}
		
		protected function addWordItem():void
		{
			if(isToken()) return;
			var word:Word  =  new Word();
			word.title =  searchText;
			word.type = getWordType();
			eventMap.mapListener(eventDispatcher,ActorEvent.WORD_RETURN, onGetWord);
			dispatch(new ControlEvent(ControlEvent.ADD_WORD,word));
		}
		
		protected function modifyType(type:String):void
		{
			if(isToken()) return;				
			wordSelectedItem =view.lsWord.selectedItem;
			var item:Object = view.lsWord.selectedItem;
			item.mType = type;
			wordList.setItemAt(item,wordSelectedIndex);
			dispatch(new ControlEvent(ControlEvent.UPDATE_WORD_TYPE, [wordSelectedItem.id, type]));
		}

		protected function validInputText(source_:Object,callBack:Function):void
		{
			regValidator = new RegExpValidator();
			regValidator.addEventListener(ValidationResultEvent.VALID,callBack);
			regValidator.addEventListener(ValidationResultEvent.INVALID,onTypeInValid);

			regValidator.required = false;
			regValidator.source = source_;
			regValidator.noMatchError = '';
			regValidator.property = "text";
			regValidator.expression = "^[A-Za-z.-]+$";
			regValidator.validate();
		}
		
		protected function responseMessage(message:String):void
		{
			var word:Word = new Word();
			word.title = message;
			word.type =  WordType.TOKEN;
			view.lsWord.dataProvider =  new ArrayList(new Array(word));
		}
		
		protected function getWordType():String
		{
			if(view.btnYes.visible)	return WordType.MIND;
			else if(view.btnNo.visible)	return WordType.UNMIND;
			else if(view.btnOther.visible) return WordType.OTHER;
			else  return 'has not set yet ';
			
		}
		
		protected function setWordType(type:String):void
		{
			if(type == WordType.MIND)
			{
				view.btnYes.visible = true;
				view.btnNo.visible = false;
				view.btnOther.visible = false;
			}
			else if(type == WordType.UNMIND)
			{			
				view.btnYes.visible = false;
				view.btnNo.visible = true;
				view.btnOther.visible = false;
			}
			else if(type == WordType.OTHER)
			{	
				view.btnYes.visible = false;
				view.btnNo.visible = false;
				view.btnOther.visible = true;
			}
			else
			{
				view.btnYes.visible = false;
				view.btnNo.visible = false;
				view.btnOther.visible = false;
			
			}
		}
		
		protected function isToken():Boolean
		{
			if((view.lsWord.selectedItem !=null) || (view.lsWord.selectedIndex == 0))
			{			
				if(view.lsWord.selectedItem.mType == WordType.TOKEN)
				{				
					return true;
				}			
			}						
			return false;
		}
		
		protected function modifyEntry():void
		{
			if(isToken()) return;			
			var word:Object = wordSelectedItem;
			word.title = StringUtil.trim(view.txtModify.text);
			word.type = getWordType();
			
			dispatch(new ControlEvent(ControlEvent.UPDATE_WORD, word));
			//TODO
			//windowUtl.getWordsData()[m.existWords.indexOf(wordSelectedItem)] = word ;
			
			updateWordList(word);
		}

		protected function updateWordList(item:Object):void
		{
			wordList.setItemAt(item,wordSelectedIndex);
			if(searchWordList.length >0)
			{
				searchWordList.setItemAt(item,wordSelectedIndex);
			}			
		}
		
		protected function onGetWord(e:ActorEvent):void
		{
			//! here cost me 4 hours...stupid so did you got it?
			eventMap.unmapListener(eventDispatcher,ActorEvent.WORD_RETURN, onGetWord);
			trace('get word');
			view.currentState = SEARCH;
			if(e.body)
			{	
				addNewItemToList(e.body);
			}
		}
		
		protected function addNewItemToList(item:Object):void
		{
			wordList.addItemAt(item,0);
			if(searchWordList.length >0)
			{
				searchWordList.addItemAt(item,0);
			}
		}

		protected function removeItemInList(item:Object):void
		{
			wordList.removeItem(item);
			
			if(searchWordList.length >0)
			{
				searchWordList.removeItem(item);
			}
			
			dispatch(new ControlEvent(ControlEvent.REMOVE_WORD, wordSelectedItem.id));
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function compareText():void
		{
			nestCompareText();
			
			if(wordExist)
			{
				view.currentState = SEARCH;					
			}
			else
			{					
				view.currentState = ADD;					
			}
		}
		
		protected function backToSearchState():void
		{
			view.currentState = SEARCH;
			setWordType('no');
		}
		
		protected function showSearchTips():void
		{
			nestSearch();
			
			if(searchWordList.length >0)
			{
				view.lsWord.dataProvider = searchWordList;
			}
			else
			{
				searchWordList =  new ArrayList();
				view.lsWord.dataProvider = wordList;
			}
			
		}
		
		protected function nestCompareText():void
		{
			//compare next session 
			if(compareIndex <  (wordList.length - 900))
			{		
				wordExist = ControlUtil.isExist(searchText,wordList.source.slice(compareIndex,900));
				compareIndex +=900;
			}
				//compare last session
			else
			{					
				wordExist = ControlUtil.isExist(searchText,wordList.source.slice(compareIndex,wordList.length));
				compareIndex = 0;
			}
			//search til finds recorde
			if(wordExist == true || compareIndex == 0)
			{
				compareIndex = 0;
				return ;
			}
			else
			{
				nestCompareText();
			}
			
		}
		protected function nestSearch():void
		{
			//search next session 
			if(searchIndex <  (wordList.length - 900))
			{		
				searchWordList = new ArrayList(wordList.source.slice(searchIndex,900).filter(filterTitle));
				searchIndex += 900;
			}
			
			//search last session
			else
			{					
				searchWordList = new ArrayList(wordList.source.slice(searchIndex,wordList.length).filter(filterTitle));
				searchIndex = 0;
			}
			
			//if find out return;
			if(searchWordList.length > 0 || searchIndex == 0)
			{
				searchIndex = 0;
				return;
			}
			//search til find out recorde
			else
			{
				nestSearch();
			}
			
		}
		
		protected function filterTitle(element:*,index:int,arr:Array):Boolean
		{
//			regexp = new RegExp("$" + searchText,'igm');
			regexp = new RegExp(searchText,'ig');
			return (regexp.test(element.mTitle));
		}
		

		protected function makeSureSelectItem(e:Event):void
		{
			wordSelectedIndex = parseInt(e.target.label);
			view.lsWord.selectedIndex = wordSelectedIndex;	
			wordSelectedItem = view.lsWord.selectedItem;
		}
		
		protected function removeSelectedItem():void
		{
			wordSelectedIndex = -1;
			view.lsWord.selectedIndex = -1;
			wordSelectedItem = 0;
		}
		
		protected function selectWordToModify():void
		{
			if(isToken()) return;
			
			view.currentState = MODIFY;
			view.txtModify.text = view.lsWord.selectedItem.mTitle;
			
			if(view.lsWord.selectedItem.mType == WordType.MIND)
				setWordType(WordType.MIND);
				
			else if(view.lsWord.selectedItem.mType == WordType.UNMIND)
				setWordType(WordType.UNMIND);
				
			else if(view.lsWord.selectedItem.mType == WordType.OTHER)
				setWordType(WordType.OTHER);
			else
				setWordType('Disable all');
		}
		
		protected function removeWord():void
		{
			if(isToken()) return;
			
			removeItemInList(wordSelectedItem);
		}
		
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onModfiy(e:ActorEvent):void
		{
			trace('modify word ');
			view.currentState = SEARCH;
		}	
		protected function onDBRemove(e:ActorEvent):void
		{
			trace('remove word ');
			view.currentState = SEARCH;
		}	
		
		protected function onAddValid(e:ValidationResultEvent):void
		{
			trace('valid add title input.');
			regValidator.removeEventListener(ValidationResultEvent.VALID,onAddValid);
			
			addWordItem();
		}
		protected function onModifyValid(e:ValidationResultEvent):void
		{
			trace('valid modify title input.');
			regValidator.removeEventListener(ValidationResultEvent.VALID,onModifyValid);
			
			modifyEntry();
		}
		
		protected function onTypeInValid(e:ValidationResultEvent):void
		{
			trace('in valid search title input.');
			regValidator.removeEventListener(ValidationResultEvent.INVALID,onTypeInValid);
			
			if(view.currentState != MODIFY )
				responseMessage('plese check out.');
			view.currentState = SEARCH;
			
		}
		
		protected function btnSaveClick(e:Event):void
		{
			validInputText(view.txtModify,onModifyValid);
		}
		
		protected function modifyTextEnter(e:Event):void
		{
			if(view.currentState == MODIFY)
			{
				validInputText(view.txtModify,onModifyValid);
			}
		}
		
		protected function btnAddClick(e:Event):void
		{
			validInputText(view.txtTitle,onAddValid);
		}
		
		protected function txtTitleEnter(e:Event):void
		{
			if(view.currentState == ADD)
			{			
				validInputText(view.txtTitle,onAddValid);
			}
		}
		
		protected function txtTitleFocus(e:FocusEvent):void
		{	
			if(searchText == SEARCHMSG) searchText = "";	
		}
		
		protected function isEmptyText():Boolean
		{
			return (searchText =='') || (searchText == SEARCHMSG);
		}
		
		protected function btnYesClick(e:Event):void
		{
			setWordType(WordType.UNMIND);
		}
		
		protected function btnNoClick(e:Event):void
		{
			setWordType(WordType.OTHER);
		}
		
		protected function btnOtherClick(e:Event):void
		{
			setWordType(WordType.MIND);
		}
		
		protected function txtTitleChange(e:Event):void
		{
			if (isEmptyText()) 
			{
				backToSearchState();
			}
			else
			{
				//! done to things in a time
				compareText();
				showSearchTips();
			}
		}
		
		protected function lsWordsClick(e:Event):void
		{
			if(e.target.id == 'btnEdit')
			{
				makeSureSelectItem(e);
				selectWordToModify();
			}
			else if(e.target.id == 'btnDelete')
			{			
				makeSureSelectItem(e);
				removeWord();	
			}
			else if(e.target.id == 'btnYes')
			{
				makeSureSelectItem(e);
				modifyType(WordType.UNMIND);
			}
			else if(e.target.id == 'btnNo')
			{
				makeSureSelectItem(e);
				modifyType(WordType.OTHER);
			}
			else if(e.target.id == 'btnOther')
			{
				makeSureSelectItem(e);
				modifyType(WordType.MIND);
			}
			else
			{
				removeSelectedItem();
				backToSearchState();
			}
		}
		
		protected function vStateChange(e:StateChangeEvent=null):void
		{
			if(view.currentState == MODIFY )
			{				
				view.btnSave.addEventListener(MouseEvent.CLICK,btnSaveClick);
				view.txtModify.addEventListener(FlexEvent.ENTER,modifyTextEnter);
			}
			if((view.currentState == MODIFY) || (view.currentState == ADD))
			{
				view.btnYes.addEventListener(MouseEvent.CLICK,btnYesClick);
				view.btnNo.addEventListener(MouseEvent.CLICK,btnNoClick);
				view.btnOther.addEventListener(MouseEvent.CLICK,btnOtherClick);
			}
			if(view.currentState == ADD)
			{
				view.btnAdd.addEventListener(MouseEvent.CLICK,btnAddClick);
				view.txtTitle.addEventListener(FlexEvent.ENTER,txtTitleEnter);
				view.btnYes.visible = true;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Get&Seter
		//
		//--------------------------------------------------------------------------
		protected function get searchText():String
		{
			return StringUtil.trim(view.txtTitle.text);
		}
		protected function set searchText(vol:String):void
		{
			view.txtTitle.text = StringUtil.trim(vol);
		}
	}
}