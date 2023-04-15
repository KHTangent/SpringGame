package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite {
	var charge:Float;
	var wasHolding:Bool;
	var holding:Bool;
	var compressionIndex:Int;
	var maxCharge:Float;
	var normalImages:Array<String>;
	var fallingImages:Array<String>;

	public var grounded:Bool;
	public var jumpAddVector:FlxPoint = null;
	public var falling:Bool;

	var xPlus:Float;
	var yPlus:Float;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/playerSprites/player.png", true);
		antialiasing = true;

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
		
		falling = true;
		grounded = false;

		maxCharge = 2;
		compressionIndex = 0;

		normalImages = ["normal0", "normal1", "normal2", "normal3"];
		fallingImages = ["falling0", "falling1", "falling2", "falling3"];
	}

	override public function update(elapsed:Float):Void {
		holding = FlxG.keys.pressed.SPACE;

		charge += elapsed * (cast holding ? 1 : 0);

		if (!holding && wasHolding) {
			jumpAddVector = FlxPoint.weak(0, -charge * 500 * (cast grounded ? 1 : 0)).rotateByDegrees(angle);

			charge = 0;
		}
		wasHolding = holding;

		charge = Math.max(0, charge);
		charge = Math.min(maxCharge, charge);

		compressionIndex = Math.floor(4 * charge / maxCharge);
		if (compressionIndex == 4)
			compressionIndex--;

		if (grounded || !falling)
			animation.play(normalImages[compressionIndex]);
		else
			animation.play(fallingImages[compressionIndex]);

		super.update(elapsed);
	}
}
