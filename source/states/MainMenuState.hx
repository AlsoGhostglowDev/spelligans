package states;

import flixel.input.keyboard.FlxKey;

class MainMenuState extends GameState {
    var camFollow:flixel.FlxObject;
    var firstOpened:Bool = true;
	var canSelect:Bool = true;

    override function create() {
        GameState.skipTrans = false;
		
        var bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
        bg.velocity.set(100, 100);
		bg.antialiasing = Preferences.prefs.antialiasingGlobal;
        add(bg);

        var grad = flixel.util.FlxGradient.createGradientFlxSprite(1, Std.int(FlxG.height / 3), [0x0, 0xFFFFB93F]);
        grad.setPosition(0, (FlxG.width/3) + 50);
        grad.scrollFactor.set();
        grad.scale.set(FlxG.width, 1);
        grad.updateHitbox();
        add(grad);

		var logo = new FlxSprite(30, 30).loadGraphic(Paths.image('logo'));
		logo.scale.set(0.6, 0.6);
        logo.antialiasing = Preferences.prefs.antialiasingGlobal;
        logo.updateHitbox();
		logo.scrollFactor.set(0.3, 0.3);
		logo.angle = -3;
		add(logo);

		var haxeJam = new FlxSprite(40, FlxG.height - 240).loadGraphic(Paths.image('haxejam'));
		haxeJam.scale.set(0.3, 0.3);
		haxeJam.antialiasing = Preferences.prefs.antialiasingGlobal;
		haxeJam.updateHitbox();
		haxeJam.scrollFactor.set(0.3, 0.3);
		add(haxeJam);

		var infoTxt = new UIText({x: 30, y: FlxG.height - 30}, 0, "", 13);
		infoTxt.applyMarkup("Made by <TBar>T-<TBar><Ghost>Ghost<Ghost> / <haxe>2024 Summer Haxe Gamejam<haxe>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<haxe>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>")
		]);
		add(infoTxt);

		var infoTxt = new UIText({x: 30, y: FlxG.height - 46}, 0, "Spelligans v0.1.0", 13);
        add(infoTxt);
		
		if(Preferences.prefs.gameHighscore != 0)
		{
			var highScoreTxt = new UIText({x: 30, y: FlxG.height / 2}, 0, "", 13);
			highScoreTxt.applyMarkup("Current Highscore: <Ghost>" + backend.Preferences.prefs.gameHighscore + "<Ghost>", [
				new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>")
			]);
			add(highScoreTxt);
		}
		
		var woah = new UIText({x: (FlxG.width / 2) + 50, y: FlxG.height / 2}, 0, "", 20);
		woah.applyMarkup("Press <TBar>A<TBar> to Start the game!\n Press <Ghost>P<Ghost> to enter the Preferences menu.\n  Press <haxe>B<haxe> to exit the game.\n   Press <Ghost>?<Ghost> to get info on this game.", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<haxe>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>")
		]);
		add(woah);
		
        camFollow = new flixel.FlxObject();
        add(camFollow);
        FlxG.camera.follow(camFollow, LOCKON, 0.5);

        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.sound.music == null && !transitioning) {
			FlxG.sound.playMusic(Paths.music('titlescreen'), 0); // Paper Mario TTYD Music is placeholder.

			if (firstOpened) FlxG.sound.music.fadeIn(1, 0, 0.7);
            firstOpened = false;
        }

        camFollow.screenCenter();
        camFollow.x += ((FlxG.mouse.x - (FlxG.width/2)) / 16);
		camFollow.y += ((FlxG.mouse.y - (FlxG.height/2)) / 16);
		
		if (FlxG.keys.justPressed.A) {
			//FlxG.sound.music.fadeOut(1, 0, (_) -> FlxG.sound.music = null);
			if(!backend.Preferences.prefs.instructionsExplained) {
				openSubState(new substates.Prompt('Instructions:\nWhen the timer hits 0, you will be given a random word/words.\nType the word/words when they appear to earn points.\n\nIf you fail to type the word or run out of time, points will be deducted.\nEarn as many points as you can before all of the rounds are done to get a highscore!\n\nHave Fun! 2024 Summer Haxejam!', OK, null, (answer) -> {
					backend.Preferences.prefs.instructionsExplained = true;
					backend.Preferences.savePrefs();
					switchState(new states.PlayState());
				}));
			} else {
				switchState(new states.PlayState());
			}
		} else if (FlxG.keys.justPressed.P) {
			//FlxG.sound.music.fadeOut(1, 0, (_) -> FlxG.sound.music = null);
			switchState(new states.PreferenceState());
		} else if (FlxG.keys.justPressed.B) {
			#if !web Sys.exit(1); #end
		} else if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.SLASH && canSelect){
			canSelect = false;
			var cppString = "";
			#if cpp
			cppString = '\n\n(Your not on a windows platform. Online mode needs C++ to run its code, thus, Online mode cannot be enabled)';
			#end
			openSubState(new substates.Prompt('-Game was made on June 13th and completed on June 16th in the middle of the night.\n\n-Game uses music and sfx from Paper Mario: The Thousand Year Door.\n\n-Logo was meant to be a placeholder.\n\n-Game has words and letters that change consistantly. To enable this, turn on "Online mode" in Preferences.' + cppString + '\n\n-Press CTRL + R in Preferences to reset all data.\n\n-Game was made for the 2024 Summer Haxe Gamejam and was made by T-Ghost (T-Bar and Ghostglowdev).', OK, null, (answer) -> {
				canSelect = true;
			}));
			canSelect = true;
		}
        super.update(elapsed);
    }
}

private class MenuItem extends flixel.group.FlxSpriteGroup {
    public var itemBg:FlxSprite;
    public var itemTxt:FlxText;

    override public function new(x:Float, y:Float, itemText:String) {
        super(x, y);
    }
}