package com.mindLighting.view.bases
{
	import spark.components.BorderContainer;
	import spark.layouts.VerticalLayout;
	
	public class SubContainerBase extends BorderContainer
	{
		
		//--------------------------------------------------------------------------
		//
		// Initialization
		//
		//--------------------------------------------------------------------------
		public function SubContainerBase()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		protected override function commitProperties():void
		{
			this.styleName = "SubBorderContainer";
			var verticalLO:VerticalLayout = new VerticalLayout();
			verticalLO.paddingTop = 8;
			verticalLO.paddingBottom = 8;
			verticalLO.paddingLeft = 8;
			verticalLO.paddingRight = 8;
			this.layout = verticalLO;
			super.commitProperties();
			
		}
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.width = 502;
			this.height = 360;
		}
	}
}