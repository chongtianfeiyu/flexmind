package com.mindLighting.model.vo
{
	/**
	 * Settings value object's item.
	 * @author AlanHero
	 * 
	 */	
	public class Setting
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		public var key:*;
		public var value:*;
		
		//--------------------------------------------------------------------------
		//
		// Initialization
		//
		//--------------------------------------------------------------------------
		public function Setting(key:*=null, value:*=null)
		{
			this.key = key;
			this.value = value;
		}
	}
}