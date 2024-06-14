package substates;

enum PromptType {
    YESNO;
    INPUT;
    OPTIONS;
	KEYBIND;
}

class Prompt extends GameSubState {
    public var prompt:FlxText;
    public var promptAnswer:FlxText;

    public var promptType:PromptType;
    public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();
    public var answerData:Any;
	public var callbacks:Map<String, Void->Void> = new Map<String, Void->Void>();
	public var optionTexts:flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>;

	public function new(text:String, ?promptType:PromptType = YESNO, ?extraData:Map<String, Dynamic>, ?callbacks:Map<String, Void->Void>) {
        super();
		prompt = new FlxText(0, 0, 0, text);
        optionTexts = new flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>();
        add(optionTexts);

        this.promptType = promptType;
        this.extraData = extraData;
        this.callbacks = callbacks;
    }

    override function create() {
        prompt.setFormat(Paths.font('LeagueSpartan-Bold.otf'), 34);
		prompt.screenCenter();
		prompt.y -= 180;
        prompt.antialiasing = Preferences.prefs.antialiasing;
		add(prompt);

		switch (promptType) {
			case YESNO: 
                answerData = 'YES';
                createOptTexts(['YES', 'NO']);
			case INPUT: '';
			case KEYBIND: '[Press Key to Bind]';
			case OPTIONS: extraData.get('options');
		}

		promptAnswer = new FlxText(0, 0, FlxG.width * 0.8, answerData);
		promptAnswer.setFormat(Paths.font('LeagueSpartan-Bold.otf'), 24);
		promptAnswer.screenCenter();
		if (promptType != YESNO) add(promptAnswer);
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ENTER) proceed(answerData);
		super.update(elapsed);

        for (text in optionTexts) {
			text.color = ((answerData == text.text) ? 0xFF0DFF00 : FlxColor.WHITE);
            if (FlxG.mouse.overlaps(text)) {
				text.color = 0xFF00F7FF;
                if (FlxG.mouse.justPressed) {
                    answerData = text.text;
                }
            }
        }
    }

    public function createOptTexts(texts:Array<String>) {
        var i = -1;
        for (string in texts) {
            i++;
            var x = (FlxG.width/texts.length+1) * i;
			var text = new FlxText(x, 0, 0, string);
			text.antialiasing = Preferences.prefs.antialiasing;
            text.screenCenter(Y);
            text.setFormat(Paths.font(Paths.fonts.ui), 24);
            add(text);

            optionTexts.add(text);
        }
    }

    public function proceed(answer:String) {
        if (callbacks != null) {
            for (key in callbacks.keys()) {
                if (key == answerData)
					callbacks.get(key)();
            }
        }
        close();
    }
}