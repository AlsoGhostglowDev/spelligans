package states;

import flixel.group.FlxSpriteGroup;
import backend.Preferences.PreferenceVars;

class PreferenceState extends GameState {
    public static var instance:PreferenceState;
	public var grpOptions:flixel.group.FlxSpriteGroup;
    public var curSelected:Int = 0;

    var clientPrefs = Preferences.prefs;

	var bg:flixel.addons.display.FlxBackdrop;
    override function create() {
		instance = this;

		bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
		bg.velocity.set(100, 100);
		bg.antialiasing = Preferences.prefs.antialiasingGlobal;
		add(bg);

		grpOptions = new FlxSpriteGroup();
        add(grpOptions);

        var option = new OptionText(0, 'Difficulty', OPTIONS, clientPrefs.difficulty, ['options' => ('easy/normal/hard/impossible').split('/')]);
        grpOptions.add(option);
		var option = new OptionText(1, 'Game Rounds', OPTIONS, clientPrefs.framerate, ['options' => ('20/50/80/100/200').split('/')], 'Int');
		grpOptions.add(option);
		var option = new OptionText(2, 'Antialiasing', YESNO, clientPrefs.antialiasingGlobal);
		grpOptions.add(option);

        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.anyJustPressed(clientPrefs.keyBinds.get('exit')))
            switchState(new states.MainMenuState());

        if (FlxG.keys.justPressed.UP)
            curSelected--;

		if (FlxG.keys.justPressed.DOWN) 
			curSelected++;

        if (curSelected < 0) curSelected = grpOptions.length-1;
		if (curSelected > grpOptions.length-1) curSelected = 0;

		super.update(elapsed);
    }

    function updateObjects() {
        if (bg.antialiasing != clientPrefs.antialiasingGlobal)
			bg.antialiasing = clientPrefs.antialiasingGlobal;

        if (FlxG.drawFramerate != clientPrefs.framerate)
            FlxG.drawFramerate = clientPrefs.framerate;
    }
}

class OptionText extends UIText {
    public var _text:String;
    public var type:substates.Prompt.PromptType;
    public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var castType:String;
	public var prefVar:Dynamic;
    public var iteration:Int;

	public function new(iteration:Int, text:String, type:substates.Prompt.PromptType, pref:Dynamic, ?extraData:Map<String, Dynamic>, ?castType:String = 'String') {
        super({x: 40, y: 50 + (26 * PreferenceState.instance.grpOptions.length)}, 0, text, 22);

        _text = text;
        prefVar = pref;
        this.type = type;
        this.iteration = iteration;
        this.extraData = extraData;
		this.castType = castType;
    }

    override function update(elapsed:Float) {
		text = _text + ' : [' + Std.string(prefVar) + ']';

		var isSelected = iteration == PreferenceState.instance.curSelected;

        if (FlxG.keys.justPressed.ENTER && isSelected) {
            if (PreferenceState.instance.subState == null) {
                PreferenceState.instance.openSubState(new substates.Prompt('Setting a new value for $_text:', type, extraData, (answer:Dynamic) -> {
                    if (type == YESNO) {
                        prefVar = (answer == 'YES');
                        return;
                    }

					if (castType == null)
                        prefVar = answer;
                    else {
                        prefVar = switch(castType) {
							case 'Int': if (answer is String) Std.parseInt(answer); else Std.int(answer);
							default: Std.string(answer);
                        }
                    } 
						

                    Preferences.savePrefs();
                }));
            }
        }

        color = (isSelected ? 0xFF00FFF7 : FlxColor.WHITE);

		super.update(elapsed);
    }
}