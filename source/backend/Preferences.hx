package backend;

@:structInit class PreferenceVars {
    public var antialiasingGlobal:Bool = true; 
    public var flashingLights:Bool = true;
    public var framerate:Int = 60;
	public var instructionsExplained:Bool = false;
	public var difficulty:String = "normal";
	#if cpp public var onlineMode:Bool = false; #end
	public var gameRounds:Int = 20;
	public var gameHighscore:Int = 0;

    public var keyBinds:Map<String, Array<flixel.input.keyboard.FlxKey>> = [
        "exit" => [ESCAPE, ESCAPE]
    ];
}

class Preferences {
    public static var prefs:PreferenceVars = {};
	public static var defaultPrefs:PreferenceVars = {};

    static public function savePrefs() {
		for (key in Reflect.fields(prefs))
			Reflect.setField(FlxG.save.data, key, Reflect.field(prefs, key));

		FlxG.save.flush();
    }

    static public function loadPrefs() {
		FlxG.save.bind('spelligans', "SpellingShenanigans");
		
		for (key in Reflect.fields(prefs))
			if (Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(prefs, key, Reflect.field(FlxG.save.data, key));
    }

    static public function resetPrefs() {
        prefs = defaultPrefs;
    }
	
	static public function calculateHighscore(gameScore:Int) {
        if(gameScore > prefs.gameHighscore) {
			prefs.gameHighscore = gameScore;
			savePrefs();
		}
    }
}