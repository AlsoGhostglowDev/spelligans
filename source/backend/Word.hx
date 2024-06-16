package backend;

import haxe.Json;
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
		if(backend.Preferences.prefs.onlineMode) wordJson = cast Json.parse(OnlineData.getDifficultyFromOnline(filePath));
		else
		#end
			wordJson = cast Json.parse(Paths.json(filePath, directory));
	}
}