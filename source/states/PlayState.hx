package states;

import flixel.FlxState;
import backend.Word;
import flixel.FlxCamera;
import flixel.util.FlxTimer;

using StringTools;
class PlayState extends GameState
{
	//var tiles:LetterList;
	var textBox:Textbox;
	var wordToType:String;
	
	var camGame:FlxCamera;
	var camHud:FlxCamera;
	
	var gameScore:Int = 0;
	var gameMisses:Int = 0;
	
	var curRound:Int = 0;
	public static var gameRounds:Int = 20;
	var gameIsRunning:Bool = true;
	
	//objects
	var getReadyTxt:UIText;
	var infoTxt:UIText;
	
	override public function create()
	{
		camGame = new FlxCamera();
		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHud, false);
		
		initializeGameRules();
		
		FlxG.sound.playMusic(Paths.music("rrr"), 0);
		
		var bg = new flixel.addons.display.FlxBackdrop(Paths.image('cheese'), XY);
		bg.scale.set(0.5, 0.5);
        bg.velocity.set(100, 100);
		bg.antialiasing = Preferences.prefs.antialiasingGlobal;
        add(bg);
		
		//so sorry for the long vars
		if(backend.Preferences.prefs.difficulty != null) Word.parseWords(backend.Preferences.prefs.difficulty.toString().toLowerCase(), "word-mode");
		else Word.parseWords("normal", "word-mode");
		
		infoTxt = new UIText({x: 0, y: 0}, 0, "", 24);
		infoTxt.applyMarkup("Game Score: <score>" + gameScore + "<score>\nGame Misses: <miss>" + gameMisses + "<miss>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<score>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF404040, false, false, 0xFF0F0F0F), "<miss>"),
		]);
		add(infoTxt);
		
		getReadyTxt = new UIText({x: 0, y: 0}, 0, "GET READY...", 54);
		getReadyTxt.alignment = CENTER;
		getReadyTxt.screenCenter();
		getReadyTxt.y -= 50;
		getReadyTxt.visible = false;
		add(getReadyTxt);
		
		trace(Word.wordJson.words);
		
		makeWordSection();

		super.create();
	}
	
	var coolSwag:FlxTimer;
	function makeWordSection()
	{
		if (gameMisses >= 10)
		{
			gameIsRunning = false;
			youLost();
		}
		if(gameIsRunning && gameMisses < 10)
		{
			coolSwag = new flixel.util.FlxTimer().start(0.6, function(tmr:FlxTimer) {
				if(coolSwag.loopsLeft == 0)
				{
					//FlxG.sound.music.volume = 1;
					getReadyTxt.visible = false;
					wordToType = Word.wordJson.words[FlxG.random.int(0, Word.wordJson.words.length-1)];
					
					FlxG.sound.playMusic(Paths.music('quiztime'), 1);
					openSubState(new substates.Prompt('Type the word:\n' + wordToType, INPUT, null, (answer) -> {
						if(answer.toLowerCase() != wordToType.toLowerCase())
						{
							missWord();
							addScore(-100 * wordToType.length);
							
						} else {
							correctWord();
							addScore(100 * wordToType.length);
						}
						curRound++;
						coolSwag = null;
						FlxG.sound.playMusic(Paths.music("rrr"), 0);
						//FlxG.sound.music.volume = 0;
						
						if(curRound >= gameRounds) {
							gameIsRunning = false;
							endGame();
						}
						else if(gameIsRunning) makeWordSection();
						
					}, if(backend.Preferences.prefs.difficulty == "easy") Std.int(wordToType.length) else Std.int(wordToType.length / .5), false, () -> {
						missWord();
						addScore(-100 * wordToType.length);
						curRound++;
						coolSwag = null;
						FlxG.sound.playMusic(Paths.music("rrr"), 0);
						//FlxG.sound.music.volume = 0;
						if(curRound >= gameRounds) endGame();
						else makeWordSection();
					}));
				} else {
					getReadyTxt.visible = true;
					getReadyTxt.text = "GET READY...\n" + coolSwag.loopsLeft;
					
					FlxG.sound.play(Paths.sound('click'));
					getReadyTxt.scale.set(getReadyTxt.scale.x + 0.1, getReadyTxt.scale.y + 0.1);		
					flixel.tweens.FlxTween.tween(getReadyTxt.scale, {x: getReadyTxt.scale.x - 0.1, y: getReadyTxt.scale.y - 0.1}, 0.5, {ease: flixel.tweens.FlxEase.sineIn});
				}
			}, 4);
		}
	}
	
	function youLost() {
		FlxG.sound.playMusic(Paths.music("rrr"), 0);
		//FlxG.sound.music.volume = 0;
		
		var infoTxt = new UIText({x: 0, y: 0}, 0, "", 24);
		infoTxt.applyMarkup("<loser>You lost...<loser>\n\nGame Score: <score>" + gameScore + "<score>\nGame Misses: <score>" + gameMisses + "<score>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<score>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF404040, false, false, 0xFF0F0F0F), "<loser>")
		]);
		infoTxt.screenCenter();
		add(infoTxt);
		
		new flixel.util.FlxTimer().start(3, function(tmr:FlxTimer) {
			FlxG.sound.music.fadeOut(1, 0, (_) -> FlxG.sound.music = null);
			switchState(new states.MainMenuState());
		});
	}
	
	function addScore(scoreToAdd:Int) {
		gameScore += scoreToAdd;
		infoTxt.applyMarkup("Game Score: <score>" + gameScore + "<score>\nGame Misses: <miss>" + gameMisses + "<miss>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<score>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF404040, false, false, 0xFF0F0F0F), "<miss>"),
		]);
	}
	
	function missWord() {
		FlxG.sound.play(Paths.sound('letter_wrong_jingle'));
		gameMisses++;
	}
	
	function correctWord() {
		FlxG.sound.play(Paths.sound('letter_right_jingle'));
	}
	
	function endGame() {
		var infoTxt = new UIText({x: 0, y: 0}, 0, "", 24);
		infoTxt.applyMarkup("ROUND COMPLETED!\n\nGame Score: <score>" + gameScore + "<score>\nGame Misses: <score>" + gameMisses + "<score>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<score>")
		]);
		infoTxt.screenCenter();
		add(infoTxt);
		
		backend.Preferences.calculateHighscore(gameScore);
		
		new flixel.util.FlxTimer().start(3, function(tmr:FlxTimer) {
			FlxG.sound.music.fadeOut(1, 0, (_) -> FlxG.sound.music = null);
			switchState(new states.MainMenuState());
		});
	}
	
	function initializeGameRules() {
		gameRounds = Preferences.prefs.gameRounds;
		curRound = 0;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}