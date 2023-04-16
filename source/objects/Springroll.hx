package objects;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;

class Springroll extends FlxSprite {
	public var value:Int;

	private var collectSound:FlxSound;

	public function new(x:Float, y:Float, value:Int) {
		super(x, y);
		collectSound = FlxG.sound.load("assets/sounds/blip.wav", 0.5);
		this.value = value;
		if (value < 40) {
			loadGraphic("assets/images/misc/springRoll.png", true, 48, 48);
		}
		else {
			loadGraphic("assets/images/misc/superRoll.png", true, 48, 48);
		}
		animation.add("spin", [0, 1, 2, 3, 4], 10, true);
		animation.play("spin");
	}

	override function kill() {
		collectSound.play(true);
		super.kill();
	}
}
