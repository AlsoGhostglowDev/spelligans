package substates;

enum PromptType
{
	YESNO;
	INPUT;
	OK;
	OPTIONS;
	KEYBIND;
}

class Prompt extends GameSubState
{
	public var prompt:UIText;
	public var promptAnswer:UIText;

	public var promptType:PromptType;
	public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var answerData:Dynamic;
	public var callback:(answer:Dynamic) -> Void;
	public var optionTexts:flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>;

    var canProceed:Bool = false;

	public function new(text:String, ?promptType:PromptType = YESNO, ?extraData:Map<String, Dynamic>, ?callback:(answer:Dynamic) -> Void)
	{
		super();
		prompt = new UIText({x: 0, y: 0}, 0, text, 34);
		optionTexts = new flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>();
		add(optionTexts);

		this.promptType = promptType;
		this.extraData = extraData;
		this.callback = callback;
	}

	override function create()
	{
		prompt.screenCenter();
		prompt.y -= 180;
		add(prompt);

		var pressEnter = new UIText({x: 0, y: 0}, 0, 'Press ENTER to confirm.', 20);
		pressEnter.screenCenter();
		pressEnter.y -= 145;
		add(pressEnter);

		switch (promptType)
		{
			case YESNO:
				answerData = 'YES';
				createOptTexts(['YES', 'NO']);
			case INPUT:
				answerData = '';
			case KEYBIND:
				answerData = '[Press Key to Bind]';
			case OPTIONS:
				answerData = extraData.get('options')[0];
				createOptTexts(extraData.get('options'));
            case OK:
                answerData = 'OK';
		}

		promptAnswer = new UIText({x: 0, y: 0}, 0, answerData, 24);

		if (promptType != YESNO && promptType != OPTIONS)
			add(promptAnswer);

		new flixel.util.FlxTimer().start(0.5, (_) -> canProceed = true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && answerData != null)
			proceed(answerData);

		for (text in optionTexts)
		{
			text.color = ((answerData == text.text) ? 0xFF0DFF00 : FlxColor.WHITE);
			if (FlxG.mouse.overlaps(text))
			{
				text.color = 0xFF00F7FF;
				if (FlxG.mouse.justPressed)
				{
					answerData = text.text;
				}
			}
		}

        if (promptType == KEYBIND) {
			var key = FlxG.keys.firstPressed();
            if (key != -1 && canProceed) {
                answerData = key;
				promptAnswer.text = '[${cast(answerData, flixel.input.keyboard.FlxKey).toString()}]';
            }
        }

		if (promptType == INPUT) {
			var key = cast(FlxG.keys.firstJustPressed(), flixel.input.keyboard.FlxKey);
			if (key != NONE && canProceed) {
				if (key != BACKSPACE)
					answerData += InputFormatter.getKeyName(key, true);
				else
					answerData = answerData.substr(0, answerData.length-1);

				promptAnswer.text = answerData;
			}
		}

		promptAnswer.screenCenter();
	}

	public function createOptTexts(texts:Array<String>)
	{
		var i = 0;
		for (string in texts)
		{
			i++;
			var text = new FlxText(0, 0, 0, string);
			text.x = (((FlxG.width / (texts.length - 1)) * (i)) / 2) - (text.width / 2);

			text.antialiasing = Preferences.prefs.antialiasing;
			text.screenCenter(Y);
			text.setFormat(Paths.font(Paths.fonts.ui), 24);
			add(text);

			optionTexts.add(text);
		}
	}

	public function proceed(answer:Dynamic)
	{
		if (callback != null)
		{
			callback(answer);
		}
		close();
	}
}
