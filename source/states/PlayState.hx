package states;

import flixel.FlxState;

class PlayState extends GameState
{
	override public function create()
	{
		var tile = new LetterTile(0, 0, 'A');
		add(tile);
		tile.screenCenter();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
