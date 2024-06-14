package states;

class MainMenuState extends GameState {
    var camFollow:flixel.FlxObject;

    override function create() {
		FlxG.sound.playMusic(Paths.music('titlescreen'), 0.7, true); //This music is not original I just took it from Paper Mario
		
        var bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
        bg.velocity.set(100, 100);
        add(bg);
		
		var gradient = new flixel.FlxSprite().loadGraphic(Paths.image('title_gradient'));
        gradient.scrollFactor.set();
		gradient.setGraphicSize(flixel.FlxG.width, flixel.FlxG.height);
		gradient.updateHitbox();
		gradient.screenCenter();
        add(gradient);
		
		var logo = new flixel.FlxSprite(200, 164).loadGraphic(Paths.image('logo'));
        logo.scale.set(0.6, 0.6);
		logo.scrollFactor.set(0.2, 0.2);
		logo.angle = -3;
        add(logo);
		
		var haxejamthing = new flixel.FlxSprite(-110, -180).loadGraphic(Paths.image('haxejam'));
		haxejamthing.scale.set(0.3, 0.3);
		haxejamthing.scrollFactor.set();
		add(haxejamthing);
		
		flixel.tweens.FlxTween.tween(logo, {y: logo.y - 200}, flixel.FlxG.random.float(1, 3), {ease: flixel.tweens.FlxEase.sineInOut, type: 4});
		flixel.tweens.FlxTween.tween(logo, {angle: 3}, flixel.FlxG.random.float(1, 2), {ease: flixel.tweens.FlxEase.sineInOut, type: 4});
		
		var dataTxt = new flixel.text.FlxText(0, FlxG.height - 14, 0, "", 10);
		dataTxt.setFormat(Paths.font('LeagueSpartan-Bold.otf'), 10, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		//var dataTxt = new objects.UIText({x: 0, y: FlxG.height - 14}, 0, "", 10);
		dataTxt.applyMarkup("Made by <TBar>T<TBar>-<Ghost>Ghost<Ghost> / <haxe>2024 Summer Haxe Gamejam<haxe>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<haxe>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00487C, false, false, 0xFF002B49), "<TBar>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF09BF91, false, false, 0xFF068966), "<Ghost>"),
		]);
		dataTxt.scrollFactor.set();
        add(dataTxt);
		
        camFollow = new flixel.FlxObject();
        add(camFollow);

        FlxG.camera.follow(camFollow, LOCKON, 0.5);

        super.create();
    }

    override function update(elapsed:Float) {
        camFollow.screenCenter();
        camFollow.x += ((FlxG.mouse.x - (FlxG.width/2)) / 16);
		camFollow.y += ((FlxG.mouse.y - (FlxG.height/2)) / 16);
		
		if(flixel.FlxG.keys.justPressed.TAB) switchState();

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