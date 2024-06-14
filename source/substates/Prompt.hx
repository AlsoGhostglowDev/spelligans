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
	public var prompt:FlxText;
	public var promptAnswer:FlxText;

	public var promptType:PromptType;
	public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var answerData:Any;
	public var callback:(answer:Any) -> Void;
	public var optionTexts:flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>;
	public var mute:Bool = false;

    var canProceed:Bool = false;

	public function new(text:String, ?promptType:PromptType = YESNO, ?extraData:Map<String, Dynamic>, ?callback:(answer:Any) -> Void)
	{
		super();
		prompt = new FlxText(0, 0, 0, text);
		optionTexts = new flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>();
		add(optionTexts);

		this.promptType = promptType;
		this.extraData = extraData;
		this.callback = callback;
	}

	override function create()
	{
		prompt.setFormat(Paths.font(Paths.fonts.ui), 34);
		prompt.screenCenter();
		prompt.y -= 180;
		prompt.antialiasing = Preferences.prefs.antialiasing;
		add(prompt);
		
		if(!mute) FlxG.sound.play(Paths.sound('menu/substate_notif_jingle'));
		
		switch (promptType)
		{
			case YESNO:
				answerData = 'YES';
				createOptTexts(['YES', 'NO']);
			case INPUT:
				'';
			case KEYBIND:
				'[Press Key to Bind]';
			case OPTIONS:
				answerData = extraData.get('options')[0];
				createOptTexts(extraData.get('options'));
            case OK:
                answerData = 'OK';
		}

		promptAnswer = new FlxText(0, 0, FlxG.width * 0.8, answerData);
		promptAnswer.setFormat(Paths.font(Paths.fonts.ui), 24);
		promptAnswer.screenCenter();
		if (promptType != YESNO && promptType != OPTIONS)
			add(promptAnswer);

		new flixel.util.FlxTimer().start(0.5, (_) -> canProceed = true);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
			proceed(answerData);

		super.update(elapsed);

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
                proceed(key);
            }
        }
	}

	public function createOptTexts(texts:Array<String>)
	{
		var i = -1;
		for (string in texts)
		{
			i++;
			var x = (FlxG.width / texts.length + 1) * i;
			var text = new FlxText(x, 0, 0, string);
			text.antialiasing = Preferences.prefs.antialiasing;
			text.screenCenter(Y);
			text.setFormat(Paths.font(Paths.fonts.ui), 24);
			add(text);

			optionTexts.add(text);
		}
	}

	public function proceed(answer:Any)
	{
		if (callback != null)
		{
			callback(answer);
		}
		if(!mute) FlxG.sound.play(Paths.sound('menu/substate_notif_jingle_end'));
		close();
	}
}
