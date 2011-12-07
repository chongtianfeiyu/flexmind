package com.mindLighting.view.bases
{
	import com.mindLighting.control.core.ControlUtil;
	import com.mindLighting.control.core.alan;
	
	import spark.components.Window;
	
	
	use namespace alan;
	
	/**
	 * Main Window templete.
	 * Need customization? Do it here.
	 * @author AlanHero
	 * 
	 */	
	public class MainWindowBase extends Window
	{
		
		
		//--------------------------------------------------------------------------
		//
		// Initialization
		//
		//--------------------------------------------------------------------------
		public function MainWindowBase()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		/**
		 * step 1 add public header 
		 * step 2 apply Style form style file
		 * step 3 setup layout
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			moveToCeneter();
			this.width = 520;
			this.height = 420;
	
		}

		protected override function commitProperties():void
		{	
			this.showStatusBar = false;
			this.systemChrome = 'none';
			this.transparent = true;
			super.commitProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 *  move to center of screen
		 *
		 */
		alan function moveToCeneter():void
		{
			move(ControlUtil.getCenterX() - width / 2, ControlUtil.getCenterY() - height / 2);
		}
	}
}