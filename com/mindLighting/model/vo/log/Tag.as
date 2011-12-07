package com.mindLighting.model.vo.log
{
	import org.robotlegs.mvcs.Actor;
	
	public class Tag extends Actor
	{
		
		
		private var _id:Number
		private var _type:String;
		
		public function Tag(id:Number= -1, type:String=null)
		{
			this.id = id;
			this.type = type;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get id():Number
		{
			return _id;
		}

		public function set id(value:Number):void
		{
			_id = value;
		}


	}
}