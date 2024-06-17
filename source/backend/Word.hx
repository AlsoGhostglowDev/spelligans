package backend;

import tjson.TJSON;
import haxe.format.JsonParser;

#if sys 
import sys.FileSystem;
#else
import openfl.utils.Assets as OpenFlAssets;
#end

using StringTools;
typedef WordFile = {
	var words:Array<String>;
}

class Word {
	public static var wordJson:WordFile;
    public static function parseWords(filePath:String, directory:String) {
		#if cpp
		if (backend.Preferences.prefs.onlineMode) wordJson = cast TJSON.parse(OnlineData.getDifficultyFromOnline(filePath));
		else
		#end

		wordJson = cast TJSON.parse(Paths.json(filePath, directory));
		
		if (wordJson == null) 
			wordJson.words = ['unavailable'];
	}
}