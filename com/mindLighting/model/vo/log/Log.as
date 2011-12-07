package com.mindLighting.model.vo.log
{
	import org.robotlegs.mvcs.Actor;
	
	public class Log extends Actor
	{
		
		public var id:Number
		public var title:String;
		public var cDate:Date;
		public var uDate:Date;
		public var parentID:Number;
		
		public function Log(id:Number=-1,title:String=null,cDate:Date=null,uDate:Date=null,parentID:Number=-1)
		{
			this.id = id;
			this.title = title;
			this.cDate = cDate;
			this.uDate = uDate;
			this.parentID = parentID;
		}
	}
}