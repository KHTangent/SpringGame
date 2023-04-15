package objects;

import flixel.FlxSprite;

class Bomb extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/misc/bomb.png", false, 48, 48);
	}
}
