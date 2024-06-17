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
	public var timeUpCallback:() -> Void;
	public var optionTexts:flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>;
	public var timer:Float;
	public var isTimed:Bool = false;
	
	var duperTimer:Float = 1;
    var canProceed:Bool = false;
	

	public function new(text:String, ?promptType:PromptType = YESNO, ?extraData:Map<String, Dynamic>, ?callback:(answer:Dynamic) -> Void, ?timer:Float = 0, ?canLeave:Bool = true, ?isMute:Bool = false, ?timeUpCallback:() -> Void)
	{
		super();
		prompt = new UIText({x: 0, y: 0}, 0, text, if(promptType == OK) 17 else 34);
		prompt.alignment = CENTER;
		optionTexts = new flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxText>();
		add(optionTexts);

		this.promptType = promptType;
		this.extraData = extraData;
		this.callback = callback;
		this.timeUpCallback = timeUpCallback;
		this.mute = isMute;
		this.canLeaveSubstate = (!canLeave);
		
		if(timer != 0)
		{
			this.timer = timer;
			this.isTimed = true;
		}
		else {
			this.isTimed = false;
		}
		
		if(!mute) FlxG.sound.play(Paths.sound('menu/substate_notif_jingle'));
	}
	
	var timerTxt:UIText;
	override function create()
	{
		prompt.screenCenter();
		prompt.y -= 180;
		add(prompt);

		var pressEnter = new UIText({x: 0, y: 0}, 0, 'Press ENTER to confirm.', 20);
		pressEnter.screenCenter();
		pressEnter.y = FlxG.height - prompt.height;
		if(promptType == OK) {
			pressEnter.x = FlxG.width - pressEnter.width;
			pressEnter.y = FlxG.height - pressEnter.height;
		}
		add(pressEnter);
		
		if(isTimed)
		{
			timerTxt = new UIText({x: 0, y: 0}, 0, '', 25);
			timerTxt.screenCenter();
			timerTxt.y += 100;
			timerTxt.text = "" + timer;
			add(timerTxt);
		}

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

		promptAnswer = new UIText({x: 0, y: 0}, FlxG.width * 0.8, answerData, 24);

		if (promptType != YESNO && promptType != OPTIONS) {
			add(promptAnswer);
			promptAnswer.alignment = CENTER;
		}

		new flixel.util.FlxTimer().start(0.1, (_) -> canProceed = true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(isTimed)
		{
			timer -= elapsed;
			timerTxt.text = '${floorDecimal(timer, 1)}'; // showing the decimals makes the situation more intense

			if(timer <= 0) {
				if (timeUpCallback != null) timeUpCallback();
				close();
			}
		}

		if (FlxG.keys.justPressed.ENTER && answerData != null && canProceed)
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
				if (key != BACKSPACE) answerData += InputFormatter.getKeyName(key, true);
				else if(key == BACKSPACE && answerData.length > 0 && answerData != "") answerData = answerData.substr(0, answerData.length-1);
				
				promptAnswer.text = answerData;
			}
		}

		promptAnswer.screenCenter();
		if (timerTxt != null) timerTxt.screenCenter(X);
	}

	public function createOptTexts(texts:Array<String>)
	{
		var i = 0;
		for (string in texts)
		{
			i++;
			var text = new FlxText(0, 0, 0, string);
			text.x = (FlxG.width / (texts.length+2)) * i;

			if (texts.length == 2) {
				text.x = (i == 1 ? FlxG.width * 0.25 : FlxG.width * 0.75);
			}

			text.antialiasing = Preferences.prefs.antialiasingGlobal;
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

		if(isTimed) timerTxt.kill();
		close();
	}

	function floorDecimal(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}
}
