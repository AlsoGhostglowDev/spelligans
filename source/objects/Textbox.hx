package objects;

import flixel.addons.text.FlxTextTyper;

class Textbox extends flixel.group.FlxGroup {
    public var text:UIText;
	public var box:FlxSprite;
    public var boxDimensions(default, set):{width:Float, height:Float};

    public var typer:FlxTextTyper;

    public function new(?position:{x:Float, y:Float}, ?dimensions:{width:Float, height:Float}, ?Text:String = '', ?size:Int = 8) {
        super();
		
		if(dimensions == null) dimensions = {width: 240, height: 120};
		
        box = new FlxSprite(position.x, position.y).makeGraphic(1, 1, FlxColor.WHITE);
        boxDimensions = dimensions;
        add(box);

		typer = new FlxTextTyper();
		add(typer);
		typer.onChange.add(() ->
		{
			text.text = typer.text;
		});

		text = new UIText({x: position.x + 5, y: position.y + 5}, 0, Text, size);
		add(text);
    }

	private function set_boxDimensions(newDimensions:{width:Float, height:Float}) {
		box.scale.set(newDimensions.width, newDimensions.height);
        box.updateHitbox();
		return boxDimensions = newDimensions;
    }
}