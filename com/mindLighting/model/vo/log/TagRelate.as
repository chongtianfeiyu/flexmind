package com.mindLighting.model.vo.log
{
	import org.robotlegs.mvcs.Actor;
	
	public class TagRelate extends Actor
	{

		public var id:Number;
		public var logID:Number;
		public var tagID:Number;
		
		public function TagRelate(id:Number=0, logID:Number=0 ,tagID:Number=0)
		{
			this.id = id;
			this.logID = logID;
			this.tagID = tagID;
		}
	}
}