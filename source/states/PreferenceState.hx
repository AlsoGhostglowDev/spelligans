package states;

import flixel.input.keyboard.FlxKey;
import backend.Preferences;

using StringTools;
class PreferenceState extends GameState {
	var currentVarTxt:UIText;
    override function create() {
		var bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
        bg.velocity.set(100, 100);
        add(bg);

        var grad = flixel.util.FlxGradient.createGradientFlxSprite(1, Std.int(FlxG.height / 3), [0x0, 0xFFFFB93F]);
        grad.setPosition(0, (FlxG.width/3) + 50);
        grad.scrollFactor.set();
        grad.scale.set(FlxG.width, 1);
        grad.updateHitbox();
        add(grad);
		
		var infoTxt = new UIText({x: 10, y: 0}, 0, "", 13);
		infoTxt.applyMarkup("Press <TBar>ONE [1]<TBar> to change the difficulty.\nPress <Ghost>TWO [2]<Ghost> to change the antialiasing.\nPress <TBar>THREE [3]<TBar> to change the game rounds." #if cpp + "\nPress <Ghost>FOUR [4]<Ghost> to change Online Mode." #end, [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>")
		]);
		add(infoTxt);
		
		currentVarTxt = new UIText({x: 10, y: 0}, 0, "", 13);
		currentVarTxt.applyMarkup("Difficulty: <TBar>" + Preferences.prefs.difficulty.toUpperCase() + "<TBar>\n\nAntialiasing: <Ghost>" + Preferences.prefs.antialiasingGlobal + "<Ghost>\n\nGame Rounds: <TBar>" + Preferences.prefs.gameRounds + "<TBar>" #if cpp + "\n\nOnline Mode: <Ghost>" + Preferences.prefs.onlineMode + "<Ghost>" #end, [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>")
		]);
		currentVarTxt.screenCenter();
		add(currentVarTxt);
	
        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
		
		//For the love of god we need to optimize this
		if (subState == null) {
			if (FlxG.keys.justPressed.ONE) {
				openSubState(new substates.Prompt('What is the new difficulty?', OPTIONS, ["options" => ('easy normal hard impossible').split(' ')], (answer) ->
				{
					Preferences.prefs.difficulty = answer.toLowerCase();
					updateText();
				}));
			}
			else if (FlxG.keys.justPressed.TWO) {
				openSubState(new substates.Prompt('Do you want to toggle antialiasing?', YESNO, null, (answer) ->
				{
					if(answer.toUpperCase() == "YES") Preferences.prefs.antialiasingGlobal = (!Preferences.prefs.antialiasingGlobal);
					
					updateText();
				}));
			}
			else if (FlxG.keys.justPressed.THREE) {
				openSubState(new substates.Prompt('How many rounds are in each game?', OPTIONS, ["options" => ('20 50 80 100 150 200').split(' ')], (answer) ->
				{
					switch(answer) {
						case "20":
							Preferences.prefs.gameRounds = 20;
						case "50":
							Preferences.prefs.gameRounds = 50;
						case "80":
							Preferences.prefs.gameRounds = 80;
						case "100":
							Preferences.prefs.gameRounds = 100;
						case "150":
							Preferences.prefs.gameRounds = 150;
						case "200":
							Preferences.prefs.gameRounds = 200;
					}					
					updateText();
				}));
			}
			#if cpp
			else if (FlxG.keys.justPressed.FOUR) {
				openSubState(new substates.Prompt('Do you want to toggle Online mode?', YESNO, null, (answer) ->
				{
					if(answer.toUpperCase() == "YES") Preferences.prefs.onlineMode = (!Preferences.prefs.onlineMode);
					updateText();
				}));
			}
			#end
			else if (FlxG.keys.pressed.R && FlxG.keys.pressed.CONTROL) {
				openSubState(new substates.Prompt('Are you sure you want to reset the Preferences?', YESNO, null, (answer) ->
				{
					if(answer.toUpperCase() == "YES") Preferences.resetPrefs();
					updateText();
				}));
			}
			else if (FlxG.keys.pressed.ESCAPE) {
				//FlxG.sound.music.fadeOut(1, 0, (_) -> FlxG.sound.music = null);
				switchState(new states.MainMenuState());
			}
		}
    }
	
	override function destroy() {
		Preferences.savePrefs();
	}
	
	function updateText()
	{
		currentVarTxt.applyMarkup("Difficulty: <TBar>" + Preferences.prefs.difficulty.toUpperCase() + "<TBar>\n\nAntialiasing: <Ghost>" + Preferences.prefs.antialiasingGlobal + "<Ghost>\n\nGame Rounds: <TBar>" + Preferences.prefs.gameRounds + "<TBar>" #if cpp + "\n\nOnline Mode: <Ghost>" + Preferences.prefs.onlineMode + "<Ghost>" #end, [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>")
		]);
	}
}