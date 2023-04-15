package objects;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite {

	var charge:Float;
	var wasHolding:Bool;
	var holding:Bool;
	var compressionIndex:Int;
	var maxCharge:Float;
	var normalImages:Array<String>;
	var fallingImages:Array<String>;
	public var grounded:Bool;

	var xPlus:Float;
	var yPlus:Float;

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(32, 32, FlxColor.LIME);
		loadGraphic("assets/images/playerSprites/player.png", true);

		animation.add("normal0", [0]);
		animation.add("normal1", [1]);
		animation.add("normal2", [2]);
		animation.add("normal3", [3]);

		animation.add("falling0", [4]);
		animation.add("falling1", [5]);
		animation.add("falling2", [6]);
		animation.add("falling3", [7]);

		charge = 0;
		wasHolding = false;
		holding = false;

		grounded = false;

		maxCharge = 2;
		compressionIndex = 0;

		normalImages = ["normal0", "normal1", "normal2", "normal3"];
		fallingImages = ["falling", "falling", "falling", "falling"];
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		holding = FlxG.keys.pressed.SPACE;
		grounded = (acceleration.y == 0);

		charge += elapsed * (cast holding ? 1 : 0);

		acceleration.x *= (cast FlxG.keys.pressed.PAGEUP ? 0 : 1);
		acceleration.y *= (cast FlxG.keys.pressed.PAGEUP ? 0 : 1);

		velocity.x *= (cast FlxG.keys.pressed.PAGEDOWN ? 0 : 1);
		velocity.y *= (cast FlxG.keys.pressed.PAGEDOWN ? 0 : 1);

		if (!holding) {
			xPlus = 20 * charge * FlxMath.fastCos(angle) * (cast grounded ? 1 : 0);
			yPlus = 20 * charge * FlxMath.fastSin(angle) * (cast grounded ? 1 : 0);

			velocity.x += xPlus;
			velocity.y += yPlus;

			x -= xPlus;
			y -= yPlus;



			charge = 0;
		}
		wasHolding = holding;

		charge = Math.max(0,charge);
		charge = Math.min(maxCharge,charge);

		compressionIndex = Math.floor(4 * charge / maxCharge);
		if (compressionIndex == 4) compressionIndex--;

		if (grounded || velocity.y >= 0) animation.play(normalImages[compressionIndex]);
		else animation.play(fallingImages[compressionIndex]);
	}
}
