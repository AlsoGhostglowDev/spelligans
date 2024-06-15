package states;

import flixel.input.keyboard.FlxKey;

class MainMenuState extends GameState {
    var camFollow:flixel.FlxObject;
    var firstOpened:Bool = true;

    override function create() {
        GameState.skipTrans = false;

        var bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
        bg.velocity.set(100, 100);
        add(bg);

        var grad = flixel.util.FlxGradient.createGradientFlxSprite(1, Std.int(FlxG.height / 3), [0x0, 0xFFFFB93F]);
        grad.setPosition(0, (FlxG.width/3) + 50);
        grad.scrollFactor.set();
        grad.scale.set(FlxG.width, 1);
        grad.updateHitbox();
        add(grad);

		var logo = new FlxSprite(30, 30).loadGraphic(Paths.image('logo'));
		logo.scale.set(0.6, 0.6);
        logo.antialiasing = Preferences.prefs.antialiasing;
        logo.updateHitbox();
		logo.scrollFactor.set(0.3, 0.3);
		logo.angle = -3;
		add(logo);

		var haxeJam = new FlxSprite(40, FlxG.height - 240).loadGraphic(Paths.image('haxejam'));
		haxeJam.scale.set(0.3, 0.3);
		haxeJam.antialiasing = Preferences.prefs.antialiasing;
		haxeJam.updateHitbox();
		haxeJam.scrollFactor.set(0.3, 0.3);
		add(haxeJam);

		var infoTxt = new UIText({x: 30, y: FlxG.height - 30}, 0, "", 13);
		infoTxt.applyMarkup("Made by <TBar>T-<TBar><Ghost>Ghost<Ghost> / <haxe>2024 Summer Haxe Gamejam<haxe>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<haxe>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>"),
		]);
		add(infoTxt);

		var infoTxt = new UIText({x: 30, y: FlxG.height - 46}, 0, "Spelligans v0.1.0", 13);
        add(infoTxt);

        camFollow = new flixel.FlxObject();
        add(camFollow);
        FlxG.camera.follow(camFollow, LOCKON, 0.5);

        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.sound.music == null && !transitioning) {
			FlxG.sound.playMusic(Paths.music('titlescreen'), 0); // This music is not original I just took it from Paper Mario -Tbar

			if (firstOpened) FlxG.sound.music.fadeIn(1, 0, 0.7);
            firstOpened = false;
        }

        camFollow.screenCenter();
        camFollow.x += ((FlxG.mouse.x - (FlxG.width/2)) / 16);
		camFollow.y += ((FlxG.mouse.y - (FlxG.height/2)) / 16);

        if (subState == null) {
			if (FlxG.keys.justPressed.R) {
				FlxG.sound.music.fadeOut(1, 0, (_) -> FlxG.sound.music = null);
				switchState(new states.PlayState());
			}

		    if (FlxG.keys.justPressed.ZERO) openSubState(new substates.Prompt('do you like ghost', YESNO, null, (answer) -> {
                if (answer == 'YES') trace('gay');
                else trace('no you do lmao lmaol maoasls');
            }));

		    if (FlxG.keys.justPressed.ONE)
		    	openSubState(new substates.Prompt('setting keybind for "jerk off"', KEYBIND, null, (answer) ->
		    	{
		    		trace('set keybind to: ${cast (answer, FlxKey).toString()}');
		    	})
            );

		    if (FlxG.keys.justPressed.TWO)
				openSubState(new substates.Prompt('how do you want ghost to react', OPTIONS, ["options" => ('horny shocked pent-up').split(' ')], (answer) ->
		        {
		        	trace('ghost wants his sandwich $answer');
		        })
            );

			if (FlxG.keys.justPressed.THREE)
			openSubState(new substates.Prompt('what do you think of ghost', INPUT, null, (answer) -> {
				trace(answer);
			}));
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