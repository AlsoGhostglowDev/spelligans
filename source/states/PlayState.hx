package states;

import flixel.system.FlxSound;
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

	var difficulty = Preferences.prefs.difficulty;
	
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
		
		if(difficulty != null) Word.parseWords(difficulty.toString().toLowerCase(), "word-mode");
		else Word.parseWords("normal", "word-mode");
		
		var col = [
			"easy" => [0xFF00FF1A, 0xFF076C00],
			"normal" => [0xFFFFFB00, 0xFF6C6A00],
			"hard" => [0xFFFF0000, 0xFF6C0000],
			"impossible" => [0xFFAE00FF, 0xFF350067]
		];
		infoTxt = new UIText({x: 15, y: 15}, 0, "", 24);
		infoTxt.applyMarkup("Game Score: <score>" + gameScore + "<score>\nGame Misses: <miss>" + gameMisses + "<miss>\n\nDifficulty: <diff>" + difficulty.toUpperCase() + "<diff>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<score>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF404040, false, false, 0xFF0F0F0F), "<miss>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(col[difficulty][0], false, false, col[difficulty][1]), "<diff>")
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
		if (gameMisses >= 10) {
			gameIsRunning = false;
			youLost();
		}

		if (gameIsRunning)
		{
			coolSwag = new flixel.util.FlxTimer().start(0.2, (tmr:FlxTimer) -> {
				if(coolSwag.loopsLeft == 0)
				{
					getReadyTxt.visible = false;
					wordToType = Word.wordJson.words[FlxG.random.int(0, Word.wordJson.words.length-1)];
					
					FlxG.sound.playMusic(Paths.music('quiztime'), 1);
					var time = (difficulty == 'impossible' ?
						flixel.math.FlxMath.bound(wordToType.length * 1.25, 0, 20) : Std.int(wordToType.length * (difficulty == 'easy' ? 2 : 2.5))
					);

					openSubState(new substates.Prompt('Type the word:\n$wordToType', INPUT, null, (answer) -> {

						final isCorrect = (answer.toLowerCase() == wordToType.toLowerCase());
						(isCorrect ? correctWord : missWord)();
						addScore((isCorrect ? 100 : -100) * wordToType.length);

						curRound++;
						coolSwag = null;

						FlxG.sound.playMusic(Paths.music("rrr"), 0);
						
						if(curRound >= gameRounds) {
							gameIsRunning = false;
							endGame();
						} else if (gameIsRunning) 
							makeWordSection();
						
					}, time, false, false, () -> {
						missWord();
						addScore(-100 * wordToType.length);

						curRound++;
						coolSwag = null;

						FlxG.sound.playMusic(Paths.music("rrr"), 0);

						if(curRound >= gameRounds) endGame(); else makeWordSection();
					}));
				} else {
					if (coolSwag.elapsedLoops > 10) {
						getReadyTxt.visible = true;
						getReadyTxt.text = "GO!";

						if (coolSwag.elapsedLoops == 11) {
							var sfx:flixel.system.FlxSound = new FlxSound().loadEmbedded(ClickSfx);
							sfx.pitch = 1.5;
							add(sfx); sfx.play();
						}
					} else {
						getReadyTxt.visible = !getReadyTxt.visible;
						getReadyTxt.text = "READY?!";

						if (coolSwag.elapsedLoops % 2 != 0)
							FlxG.sound.play(Paths.sound('click'), 0.7);
					}

					getReadyTxt.screenCenter();
				}
			}, 13);
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
		var col = [
			"easy" => [0xFF00FF1A, 0xFF076C00],
			"normal" => [0xFFFFFB00, 0xFF6C6A00],
			"hard" => [0xFFFF0000, 0xFF6C0000],
			"impossible" => [0xFFAE00FF, 0xFF350067]
		];
		infoTxt.applyMarkup("Game Score: <score>" + gameScore + "<score>\nGame Misses: <miss>" + gameMisses + "<miss>\n\nDifficulty: <diff>" + difficulty.toUpperCase() + "<diff>", [
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFFEBB53D, false, false, 0xFFDA6A3D), "<score>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(0xFF404040, false, false, 0xFF0F0F0F), "<miss>"),
			new flixel.text.FlxTextFormatMarkerPair(new FlxTextFormat(col[difficulty][0], false, false, col[difficulty][1]), "<diff>")
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

@:sound("assets/sounds/click.ogg")
private class ClickSfx extends openfl.media.Sound {}