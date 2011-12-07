package com.mindLighting.view.bases
{
	import com.mindLighting.view.components.bars.Headbar;
	
	import spark.components.BorderContainer;
	import spark.layouts.VerticalLayout;
	
	public class MainContainerBase extends BorderContainer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected var headbar:Headbar;
		
		//--------------------------------------------------------------------------
		//
		// Initialization
		//
		//--------------------------------------------------------------------------
		public function MainContainerBase()
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
			trace("MainContainerBase.commitProperties()");
			this.styleName = "MainBorderContainer";
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
			trace("num Children: " + this.numChildren);

			trace("MainContainerBase.updateDisplayList(unscaledWidth, unscaledHeight)");
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.width = 520;
			this.height = 410;
			//Q Why need to check otherway will loop never ending?
			if(!headbar)
			{
				headbar = new Headbar();
				addElementAt(headbar,0);
			}

		}
	}
}