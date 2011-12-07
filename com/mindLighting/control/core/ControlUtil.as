package  com.mindLighting.control.core
{
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.osmf.utils.URL;
	
	import spark.components.mediaClasses.VolumeBar;
	
	/**
	 * The Appliction Utils 
	 * @author AlanHero
	 * 
	 */	
	public class ControlUtil
	{
		
		private static var instance:ControlUtil;
		
		public static function getInstance():ControlUtil
		{
			if(!instance)
				instance = new ControlUtil();
			
			return instance;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		public static function formatDate(d:Date, fmt:String):String
		{
			var format:DateFormatter = new DateFormatter();
			format.formatString = fmt;
			return format.format(d);
		}
		
		public static function getDateString(d:Date):String
		{
			var dateString:String;
			var now:Date = new Date();
			var interval:Number = now.getFullYear() - d.getFullYear();
			if (interval != 0)
			{
				dateString = formatDate(d, "YYYY.MM.DD HH:NN");
			}
			else
			{
				interval = now.getMonth() - d.getMonth();
				if (interval != 0)
				{
					dateString = formatDate(d, "MM月DD日HH:NN");
				}
				else
				{
					interval = now.getDate() - d.getDate();
					if (interval != 0)
					{
						dateString = formatDate(d, "MM月DD日HH:NN");
					}
					else
					{
						interval = now.getHours() - d.getHours();
						if (interval != 0)
						{
							dateString = formatDate(d, "HH:NN");
						}
						else
						{
							interval = now.getMinutes() - d.getMinutes();
							if (interval < 0)
							{
								dateString = formatDate(d, "HH:NN");
							}
							else if (interval > 0)
							{
								dateString = interval + "分钟";
							}
							else if (interval == 0)
							{
								dateString = "1分钟";
							}
						}
					}
				}
			}
			return dateString;
		}
		
		
		public static function trimStr(str:String):String
		{
			return str.replace(/(^\s*)|(\s*$)/g, '');
		}
		
		public static function replaceSpace(str:String):String
		{
			return str.replace(/[\s*]+/g, ' ');
		}
		
		public static function transformStr(str:String):String
		{
			str = str.replace(/&quot;/g, "\"");
			str = str.replace(/&amp;/g, "&");
			str = str.replace(/>/g, "&gt;");
			str = str.replace(/</g, "&lt;");
			return str;
		}
		
		
		public static function getStatusHtmlText(str:String):String
		{
			str = replaceSpace(str);
			str = transformStr(str);
			var atRegx:RegExp = /@([A-Za-z0-9\u4e00-\u9fa5]+)/gi;
			var keywordRegx:RegExp = /(?<![color='])#([^#]+)#/gi;
			var shortUrlRegx:RegExp = /((http[s]?|ftp)?:\/\/(([\w-]+:)?[\w-]+@)?([\w-]+\.)+[\w-]+(:[\d]+)?(\/[\w-.\/?%&=]*)?(#[\w,]+)?)/gi;
			str = str.replace(shortUrlRegx, "<a click='handleClickEvent(event)' href='$1' target='_blank'>$1</a>");
			str = str.replace(atRegx, "<a href='http://t.sina.com.cn/n/$1' target='_blank'>@$1</a>");
			str = str.replace(keywordRegx, "<a href='http://t.sina.com.cn/k/$1' target='_blank'>#$1#</a>");
			
			return str;
		}
		
		
		public static function getSourceHtmlText(str:String):String
		{
			var aRegx:RegExp = /<a[\s]+[^>]*?href[\s]?=[\s\"\']+(.*?)[\"\']+.*?>([^<]+|.*?)?<\/a>/gi;
			str = str.replace(aRegx, "$2");
			return str;
		}
		
		public static function trunckStr(str:String, length:int):String
		{
			if ( length <= str.length )
			{
				return str;
			}
			return str.slice(0, length);
		}
		
		
		public static function screenHeight():Number
		{
			return Screen.mainScreen.visibleBounds.height;
		}
		
		
		public static function screenWidth():Number
		{
			return Screen.mainScreen.visibleBounds.width;
		}
		
		
		public static function TaskBarHeight():Number
		{
			return Screen.mainScreen.bounds.height - Screen.mainScreen.visibleBounds.height;
		}
		
		
		public static function getCenterX():Number
		{
			return Screen.mainScreen.visibleBounds.width / 2;
		}
		
		public static function getCenterY():Number
		{
			return Screen.mainScreen.visibleBounds.height / 2;
		}
		public static function parseText(text:String):Array
		{
			//			var tempTitles:Array = text.match(/\b\w+\b/gi);
			//			var tempTitles:Array = text.match(/\b[A-Za-z.-]+\b/gi);
			var tempTitles:Array = text.match(/\b[A-Za-z]+\b/gi);
			var newTitles:Array = [];
			for each (var title:String in tempTitles)
			{	
				title = StringUtil.trim(title);
				if(!isRepeat(title,newTitles) )
				{
					//if(TextUtil.isEnglish(title))
					newTitles.push(title);
				}
			}
			
			
			return newTitles;
		}
		public static function praseTitle(xml:XML):Array
		{
			var arr:Array = [];
			for( var i:int = 0; i < xml.children().length(); i++ )
			{
				var item:XMLList =  new XMLList(xml.children()[i]);
				arr.push( item.child("title").text());
			}
			return arr;
		}
		
		public static function filterHtml(orgSource:String,texts:Array,beforeStyle:String,afterStyle:String):String
		{
			// 1 find out all  html tages
			var htmlTags:Array = orgSource.match(/\<.*?\>/gi);
			
			// 2 mark each html tags as  [[{0}]] [[{1}]] ...
			for (var i:int = 0; i < htmlTags.length; i++) 
			{
				orgSource = orgSource.replace(htmlTags[i],"[[{" + i + "}]]");
			}
			
			// 3 high light(replace) each match item 
			
			for each (var text:String in texts)
			{	//make sure not replace style text
				if((beforeStyle.indexOf(text)) == -1)
					orgSource = orgSource.replace(text,beforeStyle + text + afterStyle);
			}			
			// 4 restore each html tags form mark 
			for (var j:int = 0; j < htmlTags.length; j++) 
			{
				orgSource = orgSource.replace("[[{" + j + "}]]",htmlTags[j]);
			}
			
			return orgSource;
		}
		
		
		public static function isRepeat(title:String,titles:Array=null):Boolean
		{	
			if(titles.length <=0 ) return false;
			for each (var existTitle:String in titles) {
				
				
				if( (existTitle.toLowerCase() ) == (title.toLowerCase())  )
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function isRepeatWords(title:String,words:Array=null):Boolean
		{	
			if(words.length <=0 ) return false;
			for each (var word:Object in words) {
				if( (word.mTitle.toLowerCase() ) == (title.toLowerCase())  )
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function getNewItems(news:Array,store:Array):Array
		{
			var newItems:Array = [];
			for each (var item:Object in news) {
				
				if(! isRepeatWords(item.mTitle,store) )
				{
					newItems.push(item);
				}
				
			}
			return newItems;
		} 
		public static function getRepeatItems(news:Array,store:Array):Array
		{
			var repeatItems:Array = [];
			for each (var item:Object in news) {
				
				if(isRepeatWords(item.mTitle,store) )
				{
					repeatItems.push(item);
				}
				
			}
			return repeatItems;
		} 
		
		public static function getWordsByType(arr:Array,wordType:String):Array
		{
			var matchs:Array = [];
			for each (var item:Object in arr) {
				if(item.mType == wordType )
				{
					matchs.push(item);
				}
				
			}
			return matchs;
		}
		
		/**
		 * //TODO better logic 
		 * @param title
		 * @param words
		 * @return 
		 * 
		 */		
		public static function isExist(title:String,words:*):Boolean
		{
			for each( var item:Object in words)
			{
				var wordTitle:String = item.title.toLowerCase();
				title = title.toLowerCase();
				if(wordTitle == title )
				{
					return true;		
				}	
			}
			return false;
		}
		public  function changeA4Size():void
		{
			FlexGlobals.topLevelApplication.stage.nativeWindow.y = 0
			FlexGlobals.topLevelApplication.nativeWindow.width = getScreenSize().width;
			FlexGlobals.topLevelApplication.nativeWindow.height = getScreenSize().height;
		}
		public static function getScreenSize():Rectangle
		{
			return Screen.mainScreen.bounds;
		}
		
	}
}