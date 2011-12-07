package com.mindLighting.model.vo
{
	public class SaveFile
	{
		public var name:String;
		public var data:*;
		public var path:String;
		public function SaveFile(name:String=null, data:String=null, path:String=null)
		{
			this.name = name;
			this.data = data;
			this.path = path;
		}
	}
}