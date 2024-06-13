package objects;

class UIText extends FlxText {
    override public function new(?position:{x:Float, y:Float}, fieldWidth:Float, text:String, size:Int) {
		setFormat(Paths.font('LeagueSpartan-Bold.otf'), size, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        borderSize = 2;

        super(position.x, position.y, fieldWidth, text);
    }
}