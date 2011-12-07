package com.mindLighting.model.services
{
	import com.mindLighting.control.events.ControlEvent;
	import com.mindLighting.model.events.ActorEvent;
	import com.mindLighting.model.services.base.DataBase;
	import com.mindLighting.model.vo.Setting;
	import com.mindLighting.model.vo.Settings;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;

	public class SettingSrv extends DataBase
	{
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------	
		public function SettingSrv()
		{
			super();
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		protected override function onConnectionOpen(evt:SQLEvent):void
		{
			createSettingTable();
		}
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public function getSettings():void
		{
			if(! _connection) init(getSettings);
			var q:String = "SELECT * FROM settings";
			executeStatement( q, [], [], onSettingsReturn );
		}
		public function removeSetting(key:String):void
		{
			if(! _connection) init( removeSetting, key );	
			var q:String = "DELETE FROM settings  WHERE  key = '" + key + "' ;";
			executeStatement( q, [], [], onSettingRemove );
		}
		public function getSetting(keyName:String):void
		{
			if(! _connection) init( getSetting, keyName );	
			var q:String = "SELECT  s.key, s.value FROM  settings s where" +
				" s.key =='"+keyName+"';";			
			executeStatement( q, [], [], onSettingReturn );
		}
		public function modifySetting(vol:Setting):void
		{
			if(! _connection) init( modifySetting, vol);	
			var q:String = "update settings set [value] = '"+ vol.value + "' where  " +
				"[key] = '" + vol.key + "' ;";
			executeStatement( q, [], [], onSettingModify );
		}
		public function addSetting(vol:Setting):void
		{
			if(! _connection) init( addSetting, vol );	
			var q:String = "insert into settings ('id','key','value') " +
				"values(null, '" + vol.key + "','" + vol.value +"');";	
			executeStatement( q, [], [], onSettingAdd );
		}
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		private function onSettingReturn( e:SQLEvent ):void
		{
			//TODO
		}
		private function onSettingsReturn( e:SQLEvent ):void
		{
			var statement:SQLStatement = e.target as SQLStatement;
			var result:SQLResult = statement.getResult();
			var settings:Settings = new Settings();
			if(result.data)
			{
				for each (var obj:Object in result.data) {
					settings.addSetting(obj.key, obj.value);	
				}
			}
			dispatch(new ActorEvent(ActorEvent.SETTINGS_RETURN,settings));
		}
		private function onSettingRemove( e:SQLEvent ):void
		{
			//TODO	
			trace("SettingSrv.onSettingRemove(e)");
		}
		private function onSettingModify( e:SQLEvent ):void
		{
			//TODO	
		}
		private function onSettingAdd( e:SQLEvent ):void
		{
			//TODO
		}
		private function onCreateSettingTable( e:SQLEvent ):void
		{
			callBack();
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *Call back while create. 
		 * 
		 */
		private function createSettingTable():void
		{
			var q:String = "CREATE TABLE If NOT Exists " +
				"[settings](" +
				"id    INTEGER    PRIMARY KEY," +
				"[key] varchar(255),[value] text);";
			executeStatement( q, [], [], onCreateSettingTable );
		}

	}
}