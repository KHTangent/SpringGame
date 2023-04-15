package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

using StringTools;

class HUD extends FlxSpriteGroup {
	static inline var OFFSET = 32;
	static inline var FONT_SIZE = 32;

	private var scoreText:FlxText;

	public function new() {
		super(OFFSET, OFFSET);
		scrollFactor.set(0, 0);
		scoreText = new FlxText(0, 0, 0, "Score: 00000", FONT_SIZE);
		add(scoreText);
	}

	public function setScore(score:Int) {
		scoreText.text = "Score: " + ("" + score).lpad("0", 5);
	}
}
