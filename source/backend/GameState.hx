package backend;

import flixel.tweens.*;

class GameState extends flixel.addons.ui.FlxUIState {
    public function new() {
        //FlxG.camera.zoom = 3;
		//FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.expoOut});
		//FlxG.camera.fade(FlxColor.BLACK, 1.1, true);
		
		//FlxTween.tween(FlxG.camera, {width: 1}, 0.4, {ease: FlxEase.expoOut});
        super();
    }
	
	override function create() {
		FlxG.camera.width = 1;
		super.create();
		FlxTween.tween(FlxG.camera, {width: FlxG.width}, 0.4, {ease: FlxEase.expoOut});
	}

    public function switchState(?state:GameState) {
        //FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
		//FlxG.camera.fade(FlxColor.BLACK, 1.1, false, () -> {
        //    FlxG.switchState(state);
        //});
		FlxTween.tween(FlxG.camera, {width: 0}, 0.4, {ease: FlxEase.expoOut, 
			onComplete: function(twn:FlxTween) {
				if(state == flixel.FlxG.state || state == null) FlxG.resetState(); else FlxG.switchState(state);
			}
        });
    }
}