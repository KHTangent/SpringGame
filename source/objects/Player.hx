package objects;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

class Player extends FlxNapeSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(32, 32, FlxColor.LIME);
		loadGraphic("assets/images/playerSprites/player.png", true);
		this.createRectangularBody(32, 32);

		animation.add("normal0", [0]);
		animation.add("normal1", [1]);
		animation.add("normal2", [2]);
		animation.add("normal3", [3]);

		animation.add("falling0", [4]);
		animation.add("falling1", [5]);
		animation.add("falling2", [6]);
		animation.add("falling3", [7]);

		var frame = 0;
		new FlxRandom();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (FlxG.keys.pressed.SPACE) {
			animation.play("falling3", true);
		}
		else {
			animation.play("normal0", true);
		}
	}
}
