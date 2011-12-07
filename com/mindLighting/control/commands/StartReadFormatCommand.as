package com.mindLighting.control.commands
{
	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.MainModel;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.vo.Drop;
	import com.mindLighting.model.vo.ReaderReport;
	
	import org.robotlegs.mvcs.Command;
	
	public class StartReadFormatCommand extends Command
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

		public var beforeStyle:String = "<span style='background-color: #FCFF19'>";
		public var afterStyle:String = "</span>";
		
		private var _text:String;
		private var _html:String;
		private var _inComeTitleList:Array;
		
		
		private var e:RegExp;
		private var formaterItem:String = '';
		private var titleList:Array = [];
		// report
		private var _length:Number;
		private var _unmindNumber:Number  = 0;

		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function execute():void
		{
			trace("StartReadFormatCommand.execute()");
			var drop:Drop = (controlEvent.body as Drop);
			_text = drop.text;
			_inComeTitleList =  ControlUtil.parseText(_text);
			_html =  drop.htmlText;
			start();
		}		
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public function start():void
		{	
			_length = Number(_inComeTitleList.length);
			if(_length <= 0) return;
			next(_inComeTitleList.shift());
		}
		private function next(title:String):void
		{
			e = new RegExp("\\b" + title + "+\\b","gi");
			titleList.push(title);
			formaterItem = beforeStyle + title + afterStyle;
			_unmindNumber++;
			
			//make sure not replace style text
			if((beforeStyle.indexOf(title.toLowerCase())) == -1)
			{				
				_text = _text.replace(e,formaterItem);
			}
			(_inComeTitleList.length >0) ? next(_inComeTitleList.shift()) : complete();
		}
		
		protected function complete():void
		{
			if(_html)
			{
				_html = ControlUtil.filterHtml(_html,titleList,beforeStyle,afterStyle);
			}
			var result:ReaderReport = new ReaderReport();
			result.formaterText  = _html ? _html 	: _text;
			result.totalNumber = _length;
			result.unmindNumber = _unmindNumber;
			result.mindNumber = _length  - _unmindNumber;
			result.presentNumber = (_length  - _unmindNumber) / _length;
			dispatch(new ActorEvent(ActorEvent.READER_FORMATUP, result));
		}
		
	}
}