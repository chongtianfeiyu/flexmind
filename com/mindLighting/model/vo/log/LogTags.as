package com.mindLighting.model.vo.log
{
	import org.robotlegs.mvcs.Actor;
	
	public class LogTags extends Actor
	{
		private var _logVO:Log;
		private var _tags:Array;
		
		public function LogTags(logVO:Log,tags:Array)
		{
			_logVO = logVO;
			_tags = tags;
		}

		public function get tags():Array
		{
			return _tags;
		}

		public function set tags(value:Array):void
		{
			_tags = value;
		}

		public function get log():Log
		{
			return _logVO;
		}

		public function set log(value:Log):void
		{
			_logVO = value;
		}


	}
}