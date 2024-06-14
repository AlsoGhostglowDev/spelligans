package objects;

class UIText extends FlxText
{
	override public function new(?position:{x:Float, y:Float}, fieldWidth:Float, text:String, size:Int)
	{
		super(position.x, position.y, fieldWidth, text);

		setFormat(Paths.font(Paths.fonts.ui), size, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		antialiasing = Preferences.prefs.antialiasing;
		scrollFactor.set(0.3, 0.3);
		borderSize = 2;
	}
}
