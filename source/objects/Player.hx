package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite {
	private static inline var MAX_CHARGE = 2.0;

	private var charge = 0.0;
	private var wasHolding = false;
	private var holding = false;
	private var compressionIndex = 0;
	private var normalImages = ["normal0", "normal1", "normal2", "normal3"];
	private var fallingImages = ["falling0", "falling1", "falling2", "falling3"];

	private var xPlus:Float;
	private var yPlus:Float;
	private var boingSound:FlxSound;
	private var loudBoingSound:FlxSound;

	public var grounded = false;
	public var jumpAddVector:FlxPoint = null;
	public var falling = true;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/playerSprites/player.png", true);
		boingSound = FlxG.sound.load("assets/sounds/boing.wav", 0.5);
		loudBoingSound = FlxG.sound.load("assets/sounds/boing.wav", 1);
		antialiasing = true;

		animation.add("normal0", [0]);
		animation.add("normal1", [1]);
		animation.add("normal2", [2]);
		animation.add("normal3", [3]);

		animation.add("falling0", [4]);
		animation.add("falling1", [5]);
		animation.add("falling2", [6]);
		animation.add("falling3", [7]);
	}

	override public function update(elapsed:Float):Void {
		holding = FlxG.keys.pressed.SPACE;

		if (holding) {
			charge += elapsed;
		}

		if (!holding && wasHolding) {
			if (grounded) {
				jumpAddVector = FlxPoint.weak(0, -charge * 500).rotateByDegrees(angle);
				if (charge > MAX_CHARGE / 2) {
					loudBoingSound.play(true);
				}
				else {
					boingSound.play(true);
				}
			}

			charge = 0;
		}
		wasHolding = holding;

		charge = Math.max(0, charge);
		charge = Math.min(MAX_CHARGE, charge);

		compressionIndex = Math.floor(4 * charge / MAX_CHARGE);
		if (compressionIndex == 4) {
			compressionIndex--;
		}

		if (grounded || !falling) {
			animation.play(normalImages[compressionIndex]);
		}
		else {
			animation.play(fallingImages[compressionIndex]);
		}

		super.update(elapsed);
	}
}
