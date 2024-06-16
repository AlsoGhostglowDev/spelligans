package objects;

import flixel.addons.text.FlxTextTyper;

enum PromptType
{
	BOOL;
}

class OptionText {
	public var promptType:PromptType;
	
    public function new(?position:{x:Float, y:Float}, ?promptType:PromptType = BOOL) {
        super();
		
		this.promptType = promptType;
    }
}