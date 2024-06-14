package states;

import flixel.FlxState;

class PlayState extends GameState
{
	override public function create()
	{
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GREEN);
		add(bg);

		var tile = new LetterTile(0, 0, 'A');
		add(tile);
		tile.screenCenter();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.R) switchState(new states.MainMenuState()); 
		super.update(elapsed);
	}
}
