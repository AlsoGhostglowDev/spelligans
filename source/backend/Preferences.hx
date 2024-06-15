package backend;

@:structInit class PreferenceVars {
    public var antialiasing:Bool = true; 
    public var flashingLights:Bool = true;
    public var framerate:Int = 60;

    public var keyBinds:Map<String, Array<flixel.input.keyboard.FlxKey>> = [
        "exit" => [ESCAPE, ESCAPE]
    ];
}

class Preferences {
    public static var prefs:PreferenceVars = {};
	public static var defaultPrefs:PreferenceVars = {};

    public function savePrefs() {
		for (key in Reflect.fields(prefs))
			Reflect.setField(FlxG.save.data, key, Reflect.field(prefs, key));

		FlxG.save.flush();
    }

    public function loadPrefs() {
		for (key in Reflect.fields(prefs))
			if (Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(prefs, key, Reflect.field(FlxG.save.data, key));
    }

    public function resetPrefs() {
        prefs = defaultPrefs;
    }
}