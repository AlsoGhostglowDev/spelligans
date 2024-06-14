package backend;

import objects.Transition;
import flixel.FlxCamera;

class GameState extends flixel.addons.ui.FlxUIState {
    public var transitionCam:flixel.FlxCamera;
	public var canSwitchState:Bool = true;
    public static var skipTrans:Bool = false; 

    override function create() {
		super.create();

        if (!skipTrans) {
			canSwitchState = false;

            transitionCam = new flixel.FlxCamera();
            transitionCam.bgColor = 0x0;
            FlxG.cameras.add(transitionCam, false);

            FlxG.camera.zoom = 3;
			for (camera in FlxG.cameras.list) {
				if (camera == transitionCam) continue;
		        FlxTween.tween(camera, {zoom: 1}, 1, {ease: FlxEase.expoOut});
            }
			var transition = new Transition(false, () -> canSwitchState = true);
			transition.camera = transitionCam;
			add(transition);
        }
    }

    override public function openSubState(substate:flixel.FlxSubState) {
        if (subState != null) return;
        super.openSubState(substate);

        if (FlxG.sound.music != null) {
			FlxG.sound.music.fadeIn(0.6, FlxG.sound.music.volume, FlxG.sound.music.volume-0.5);
        }

		persistentUpdate = true;
    }

    public function switchState(state:GameState) {
        if (canSwitchState) {
            if (!skipTrans) {
		    	canSwitchState = false;

                for (camera in FlxG.cameras.list) {
                    if (camera == transitionCam) continue;
                    FlxTween.tween(camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
                }

		    	var transition = new Transition(true, () -> {
		    		FlxG.switchState(state);
		    	});
		    	transition.camera = transitionCam;
		    	add(transition);
            } else {
		    	FlxG.switchState(state);
            }
        }
    }
}