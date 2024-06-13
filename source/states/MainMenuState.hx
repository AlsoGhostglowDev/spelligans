package states;

class MainMenuState extends GameState {
    var camFollow:flixel.FlxObject;

    override function create() {
        var bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
        bg.velocity.set(100, 100);
        add(bg);

        camFollow = new flixel.FlxObject();
        add(camFollow);

        FlxG.camera.follow(camFollow, LOCKON, 0.5);

        super.create();
    }

    override function update(elapsed:Float) {
        camFollow.screenCenter();
        camFollow.x += ((FlxG.mouse.x - (FlxG.width/2)) / 16);
		camFollow.y += ((FlxG.mouse.y - (FlxG.height/2)) / 16);

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