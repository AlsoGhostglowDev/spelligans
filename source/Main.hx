package;

import flixel.FlxGame;
import openfl.display.Sprite;

// Thanks Sqirra-rng
#if SHOW_CRASHDUMP
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
#end

using StringTools;
class Main extends Sprite
{
	public function new()
	{
		super();
		backend.Preferences.loadPrefs();
		addChild(new FlxGame(0, 0, states.MainMenuState));
		#if SHOW_CRASHDUMP
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	#if SHOW_CRASHDUMP
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "Flixel_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\nWhoops! Looks like Spelling Shenanigans has crashed!\n(Crash Handler written by T-Bar)";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "ERM");
		Sys.exit(1);
	}
	#end
}
