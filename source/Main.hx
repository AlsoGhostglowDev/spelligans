package;

import flixel.FlxGame;
import openfl.display.Sprite;

//Thanks Sqirra-rng
#if SHOW_CRASHDUMP
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
#end
class Main extends Sprite
{
	public function new()
	{
		super();
		GameState.skipTrans = true;
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

		errMsg += "\nUncaught Error: " + e.error;

		Sys.println(errMsg);

		Application.current.window.alert(errMsg, "Erm.");
		Sys.exit(1);
	}
	#end
}
