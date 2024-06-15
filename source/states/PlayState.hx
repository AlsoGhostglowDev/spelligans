package states;

import flixel.FlxState;

class PlayState extends GameState
{
	var tiles:LetterList;
	var textBox:Textbox;

	override public function create()
	{
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bg);

		tiles = new LetterList();
		add(tiles);
		tiles.makeLetters({x: 10, y: 10}, 'hello');

		textBox = new Textbox({x: 10, y: FlxG.width * 0.6}, {width: FlxG.width - 20, height: FlxG.width * 0.3}, 'sup broski', 24);
		textBox.typer.startTyping('hello hello hello hello hello hello hello', true);
		add(textBox);

		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.R) switchState(new states.MainMenuState());
	}
}

private class LetterList extends flixel.group.FlxGroup.FlxTypedGroup<LetterTile> {
	override public function new() super();

	public function makeLetters(position:{x:Float, y:Float}, ?word:String = 'hi') {
		var wordSplit = word.split('');

		var i:Int = 0;
		for (word in wordSplit) {
			i++;
			var tile = new LetterTile(position.x + (135 * i), position.y, word.toUpperCase());
			add(tile);
		}
	}
}