package objects;

import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;

class Player extends FlxNapeSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(32, 32, FlxColor.LIME);
		this.createRectangularBody(32, 32);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
