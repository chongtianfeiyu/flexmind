package  com.mindLighting.model.vo.utils
{
	import com.mindLighting.model.vo.Word;
	
	import mx.utils.StringUtil;
	
	/**
	 *WordUtils Check type. etc 
	 * @author AlanHero
	 * 
	 */	
	public class SystemUtil
	{
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public static function parseText(text:String):Array
		{
			// var tempTitles:Array = text.match(/\b\w+\b/gi);
			// var tempTitles:Array = text.match(/\b[A-Za-z.-]+\b/gi);
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
		
		public static function getWordsByType(words:Vector.<Word>, type:String):Vector.<Word>
		{
			var matchs:Vector.<Word> = new Vector.<Word>();
			for each (var word:Word in words) {
				if(word.type == type)
				{
					matchs.push(word);
				}
			}
			return matchs;
		}
		
		public static function isExist(title:String,words:Array):Boolean
		{
			for each( var item:Object in words)
			{
				var wordTitle:String = item.mTitle.toLowerCase();
				title = title.toLowerCase();
				if(wordTitle == title )
				{
					return true;		
				}	
			}
			return false;
		}
		
		public static function isType(title:String, words:Array, type:Boolean):Boolean
		{
			for each( var item:Object in words)
			{
				title = title.toLowerCase();
				var wordTitle:String = item.mTitle.toLowerCase();
				
				//match
				if(item.type == type)
				{
					if(wordTitle == title)
					{
						return true;
					}
				}
				
			}
			return false;
		}
		

	}
}