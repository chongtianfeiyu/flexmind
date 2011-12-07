package com.mindLighting.model.vo
{
	import flash.utils.Dictionary;
	
	
	public class Settings 
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		private var _settings:Dictionary;
		
		//--------------------------------------------------------------------------
		//
		// Initialization
		//
		//--------------------------------------------------------------------------
		public function Settings()
		{
				_settings = new Dictionary();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public function addSetting(key:*,value:*):void
		{
			_settings[key] = value;
		}
		public function getSettings():Dictionary
		{
			return _settings;
		}
		public function hasKey(key:*):Boolean
		{
			return _settings[key] != null;
		}
		public function getSetting(key:*):*
		{
			return _settings[key];
		}
	}
}