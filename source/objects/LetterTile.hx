package objects;

class LetterTile extends flixel.group.FlxSpriteGroup
{
	public var tile:FlxSprite;
	public var letter:FlxText;

	override public function new(?x:Float = 0, ?y:Float = 0, ?daLetter:String = '?', ?color:Int = FlxColor.WHITE)
	{
		super();

		tile = new FlxSprite(x, y, Paths.image('letter_tile'));
		tile.scale.set(0.5, 0.5);
		tile.updateHitbox();
		tile.antialiasing = Preferences.prefs.antialiasing;
		tile.color = color;

		letter = new FlxText(0, 0, 128, daLetter);
		letter.setFormat(Paths.font(Paths.fonts.game), 54, FlxColor.WHITE, CENTER, OUTLINE, 0xFF000737);
		letter.borderSize = 4;
		letter.antialiasing = Preferences.prefs.antialiasing;

		add(tile);
		add(letter);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (letter.text.length > 1)
		{
			letter.text.substr(0, 0);
		}

		// center it
		letter.updateHitbox();
		letter.setPosition((tile.x + ((tile.width - letter.width) / 2)) - (16 * tile.scale.x),
			(tile.y + ((tile.height - letter.height) / 2)) - (16 * tile.scale.y));
		letter.centerOffsets();
	}
}
