package backend;

import flixel.tweens.*;

class GameState extends flixel.addons.ui.FlxUIState {
    public function new() {
        FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.expoOut});
		FlxG.camera.fade(FlxColor.BLACK, 1.1, true);

        super();
    }

    public function switchState(state:GameState) {
        FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
		FlxG.camera.fade(FlxColor.BLACK, 1.1, false, () -> {
            FlxG.switchState(state);
        });
    }
}